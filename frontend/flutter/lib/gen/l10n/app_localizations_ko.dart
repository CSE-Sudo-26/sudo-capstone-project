// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'On-Care';

  @override
  String get navDashboard => '홈';

  @override
  String get navDiet => '식단';

  @override
  String get navExercise => '운동';

  @override
  String get navMyHealth => 'MY';

  @override
  String get pageDashboardTitle => '홈';

  @override
  String get pageDietTitle => '식단';

  @override
  String get pageExerciseTitle => '운동';

  @override
  String get pageMyHealthTitle => 'My';

  @override
  String get pageAiCoachTitle => 'AI 코치';

  @override
  String get pageNotificationTitle => '알림';

  @override
  String get pagePlaceTitle => '장소';

  @override
  String get pageSignInTitle => '로그인';

  @override
  String get actionOpenAiCoach => 'AI 코치 열기';

  @override
  String get actionFindPlace => '장소 찾기';

  @override
  String get actionSignInPlaceholder => '로그인 (placeholder)';

  @override
  String get actionRetry => '다시 시도';

  @override
  String get placeholderDashboard => '대시보드 (placeholder)';

  @override
  String get placeholderDiet => '식단 기록 (placeholder)';

  @override
  String get placeholderExercise => '운동 (placeholder)';

  @override
  String get placeholderMyHealth => '내 건강 (placeholder)';

  @override
  String get placeholderAiCoach => 'AI 코치 (placeholder, mock 응답)';

  @override
  String get placeholderNotification => '알림 (placeholder)';

  @override
  String get placeholderPlace => '장소 (placeholder, Stage 4에서 Google Maps)';

  @override
  String get placeholderSignIn => '로그인 (placeholder, Stage 4에서 소셜 SDK)';

  @override
  String get errorNetwork => '네트워크 문제';

  @override
  String get errorUnauthorized => '로그인이 필요합니다';

  @override
  String get errorNotFound => '찾을 수 없습니다';

  @override
  String get errorServer => '서버 오류';

  @override
  String get errorCancelled => '취소됨';

  @override
  String get errorUnknown => '알 수 없는 오류';

  @override
  String get dashboardSectionToday => '오늘의 요약';

  @override
  String get dashboardMetricCalories => '칼로리';

  @override
  String get dashboardMetricExercise => '운동';

  @override
  String get dashboardMetricWeight => '체중';

  @override
  String get dashboardChartWeightWeek => '주간 체중';

  @override
  String dashboardCaloriesProgress(int pct, int goal) {
    return '$pct% / $goal';
  }

  @override
  String dashboardWeightDelta(String sign, String delta) {
    return '$sign$delta (지난주 대비)';
  }

  @override
  String get unitKcal => 'kcal';

  @override
  String get unitMinutes => '분';

  @override
  String get unitKg => 'kg';

  @override
  String get dietTitle => '식단';

  @override
  String get dietToday => '오늘로';

  @override
  String dietWeekLabel(int month, int week) {
    return '$month월 $week주차';
  }

  @override
  String get dietWeekdayMon => '월';

  @override
  String get dietWeekdayTue => '화';

  @override
  String get dietWeekdayWed => '수';

  @override
  String get dietWeekdayThu => '목';

  @override
  String get dietWeekdayFri => '금';

  @override
  String get dietWeekdaySat => '토';

  @override
  String get dietWeekdaySun => '일';

  @override
  String get dietNutritionSummary => '오늘의 영양 요약';

  @override
  String get dietCalories => '칼로리';

  @override
  String get dietSodium => '나트륨';

  @override
  String get dietSugar => '당류';

  @override
  String get dietUnitMg => 'mg';

  @override
  String get dietUnitG => 'g';

  @override
  String get dietAiFeedback => 'AI 피드백';

  @override
  String get dietTodayMeals => '오늘의 식단';

  @override
  String get dietAddMeal => '식단 추가';

  @override
  String get dietEmptyLog => '아직 기록된 식단이 없어요.\n사진으로 첫 끼니를 추가해 보세요!';

  @override
  String get dietPhotoAnalysis => '사진 분석';

  @override
  String get dietLoadError => '식단 정보를 불러오지 못했어요.';

  @override
  String get dietOtherDateEmpty =>
      '선택한 날짜의 기록은 아직 볼 수 없어요.\n오늘 날짜에서 식단을 확인해 주세요.';

  @override
  String dietTagSodium(int mg) {
    return '나트륨 ${mg}mg';
  }

  @override
  String dietTagSugar(int g) {
    return '당류 ${g}g';
  }

  @override
  String get dietMealBreakfast => '아침';

  @override
  String get dietMealLunch => '점심';

  @override
  String get dietMealDinner => '저녁';

  @override
  String get dietMealSnack => '간식';

  @override
  String dietMealSheetTitle(String meal) {
    return '$meal 식단';
  }

  @override
  String get dietAddSheetTitle => '식단 추가하기';

  @override
  String get dietAddSheetSubtitle => '사진으로 음식을 분석해요';

  @override
  String get dietPickPhoto => '사진 선택하기';

  @override
  String get dietPickPhotoSub => '갤러리에서 음식 사진 선택';

  @override
  String get dietTakePhoto => '사진 찍기';

  @override
  String get dietTakePhotoSub => '카메라로 음식 촬영';

  @override
  String get dietPhotoLoadError => '사진을 불러오지 못했어요. 잠시 후 다시 시도해 주세요';

  @override
  String get dietAnalyzing => '분석 중…';

  @override
  String get dietAnalysisFailed => '분석 실패';

  @override
  String get dietAnalysisDone => '분석 완료!';

  @override
  String get dietAiNutritionResult => 'AI 영양 분석 결과';

  @override
  String get dietAnalyzingBody => '사진 속 음식을 분석하고 있어요';

  @override
  String get dietAnalysisFailedBody => '분석에 실패했어요. 잠시 후 다시 시도해 주세요.';

  @override
  String get dietRecognizedFood => '인식된 음식';

  @override
  String get dietNoRecognizedFood => '인식된 음식이 없어요';

  @override
  String get dietNutritionResult => '영양 분석 결과';

  @override
  String get dietSaved => '식단이 저장되었어요';

  @override
  String get dietDone => '완료';

  @override
  String get dietSaveFailed => '저장에 실패했어요. 잠시 후 다시 시도해 주세요';

  @override
  String get dietDeleteTitle => '식단 기록 삭제';

  @override
  String get dietDeleteConfirm => '이 식단 기록을 삭제할까요?';

  @override
  String get dietCancel => '취소';

  @override
  String get dietDelete => '삭제';

  @override
  String get dietDeleted => '식단이 삭제되었어요';

  @override
  String get dietDeleteFailed => '삭제에 실패했어요. 잠시 후 다시 시도해 주세요';

  @override
  String get dietSave => '저장';

  @override
  String get dietMealInfo => '식사 정보';

  @override
  String get dietEatenTime => '먹은 시간';

  @override
  String get dietEatenFood => '먹은 음식';

  @override
  String get dietNewFood => '새 음식';

  @override
  String get dietAddFood => '+ 음식 추가';

  @override
  String get dietEditFoodHint => '음식명과 칼로리를 수정할 수 있어요';

  @override
  String get dietTotalCalories => '총 칼로리';

  @override
  String get dietNutritionInfo => '영양 정보';

  @override
  String get dietEditNutritionHint => '분석된 값을 직접 수정할 수 있어요';

  @override
  String get dietSodiumHint => '하루 권장 2,000mg 이하';

  @override
  String get dietSugarHint => '하루 권장 50g 이하';

  @override
  String get dietDeleteMeal => '식단 삭제';
}
