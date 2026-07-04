import 'package:oncare/features/schedule/domain/entities/schedule_event.dart';

abstract class ScheduleRepository {
  /// Events whose `date` matches the given `YYYY-MM-DD` string.
  Future<List<ScheduleEvent>> fetchByDate(String date);

  /// POST /schedule/events — create a calendar event. The server derives
  /// the emoji/color from [category] and returns the stored event.
  Future<ScheduleEvent> createEvent({
    required String date,
    required String title,
    String time = '',
    ScheduleCategory category = ScheduleCategory.other,
  });
}
