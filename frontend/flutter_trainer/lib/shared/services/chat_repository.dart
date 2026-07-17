import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:oncare_trainer/core/storage/app_database.dart';
import 'package:oncare_trainer/shared/models/client_chat_message.dart';

/// Reads and appends messages in a client's chat thread (drift-backed).
class ChatRepository {
  /// Creates the repository over [_db].
  const ChatRepository(this._db);

  final AppDatabase _db;

  /// Streams a client's messages in chronological order.
  Stream<List<ClientChatMessage>> watchThread(String clientId) {
    final query = _db.select(_db.clientChatMessages)
      ..where((t) => t.clientId.equals(clientId))
      ..orderBy(<OrderingTerm Function($ClientChatMessagesTable)>[
        (t) => OrderingTerm(expression: t.createdAt),
      ]);
    return query.watch().map((rows) => rows.map(_toEntity).toList());
  }

  /// Appends a trainer message and refreshes the client's list-card
  /// preview (`lastMessage`/`lastTime`) in one transaction. The `chat-`
  /// id (no `seed-` prefix) means it survives re-seeding, and `now()`
  /// sorts it after the seed thread.
  Future<void> sendTrainerMessage({
    required String clientId,
    required String text,
  }) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    final now = DateTime.now();
    await _db.transaction(() async {
      await _db
          .into(_db.clientChatMessages)
          .insert(
            ClientChatMessagesCompanion.insert(
              id: 'chat-$clientId-${now.microsecondsSinceEpoch}',
              clientId: clientId,
              sender: 'trainer',
              body: trimmed,
              timeLabel: _timeLabel(now),
              createdAt: now,
            ),
          );
      await (_db.update(
        _db.trainerClients,
      )..where((t) => t.id.equals(clientId))).write(
        TrainerClientsCompanion(
          lastMessage: Value(trimmed),
          lastTime: const Value('방금'),
        ),
      );
    });
  }

  /// Per-client unread counts — client-sent messages newer than the
  /// trainer's last-read marker (an `AppKeyValues` row per client, so
  /// no schema migration). Clients with zero unread are absent.
  Stream<Map<String, int>> watchUnreadCounts() {
    // drift stores DateTime columns as unix epoch seconds; the read
    // marker persists the same unit for a plain integer comparison.
    final query = _db.customSelect(
      'SELECT m.client_id AS cid, COUNT(*) AS cnt '
      'FROM client_chat_messages m '
      "LEFT JOIN app_key_values k ON k.\"key\" = '$_readKeyPrefix' || m.client_id "
      "WHERE m.sender = 'client' "
      'AND (k.value IS NULL OR m.created_at > CAST(k.value AS INTEGER)) '
      'GROUP BY m.client_id',
      readsFrom: <ResultSetImplementation<Object?, Object?>>{
        _db.clientChatMessages,
        _db.appKeyValues,
      },
    );
    return query.watch().map(
      (rows) => <String, int>{
        for (final row in rows) row.read<String>('cid'): row.read<int>('cnt'),
      },
    );
  }

  /// Marks a client's thread as read up to now.
  Future<void> markThreadRead(String clientId) {
    final nowSeconds = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return _db.putValue('$_readKeyPrefix$clientId', '$nowSeconds');
  }

  static const String _readKeyPrefix = 'chat_read_';

  ClientChatMessage _toEntity(ClientChatMessageRow row) {
    return ClientChatMessage(
      id: row.id,
      sender: row.sender == 'trainer' ? ChatSender.trainer : ChatSender.client,
      body: row.body,
      timeLabel: row.timeLabel,
      createdAt: row.createdAt,
    );
  }

  static String _timeLabel(DateTime t) =>
      '${t.hour.toString().padLeft(2, '0')}:'
      '${t.minute.toString().padLeft(2, '0')}';
}

/// Provides the [ChatRepository].
final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepository(ref.watch(appDatabaseProvider));
});

/// Streams per-client unread message counts for the 고객 list badges.
final unreadCountsProvider = StreamProvider<Map<String, int>>((ref) {
  return ref.watch(chatRepositoryProvider).watchUnreadCounts();
});

/// Streams a client's chat thread by client id.
final chatThreadProvider =
    StreamProvider.family<List<ClientChatMessage>, String>((ref, clientId) {
      return ref.watch(chatRepositoryProvider).watchThread(clientId);
    });
