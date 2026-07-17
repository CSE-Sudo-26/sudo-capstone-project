// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'On-Care';

  @override
  String get navDashboard => 'Home';

  @override
  String get navDiet => 'Diet';

  @override
  String get navExercise => 'Exercise';

  @override
  String get navMyHealth => 'MY';

  @override
  String get pageDashboardTitle => 'Home';

  @override
  String get pageDietTitle => 'Diet';

  @override
  String get pageExerciseTitle => 'Exercise';

  @override
  String get pageMyHealthTitle => 'My';

  @override
  String get pageAiCoachTitle => 'AI Coach';

  @override
  String get pageNotificationTitle => 'Notifications';

  @override
  String get pagePlaceTitle => 'Place';

  @override
  String get pageSignInTitle => 'Sign in';

  @override
  String get actionOpenAiCoach => 'Open AI Coach';

  @override
  String get actionFindPlace => 'Find a place';

  @override
  String get actionSignInPlaceholder => 'Sign in (placeholder)';

  @override
  String get actionRetry => 'Retry';

  @override
  String get placeholderDashboard => 'Dashboard (placeholder)';

  @override
  String get placeholderDiet => 'Diet Record (placeholder)';

  @override
  String get placeholderExercise => 'Exercise (placeholder)';

  @override
  String get placeholderMyHealth => 'My Health (placeholder)';

  @override
  String get placeholderAiCoach => 'AI Coach (placeholder, mock responses)';

  @override
  String get placeholderNotification => 'Notifications (placeholder)';

  @override
  String get placeholderPlace => 'Place (placeholder, Google Maps in Stage 4)';

  @override
  String get placeholderSignIn =>
      'Sign in (placeholder, social SDKs in Stage 4)';

  @override
  String get errorNetwork => 'Network problem';

  @override
  String get errorUnauthorized => 'Sign in required';

  @override
  String get errorNotFound => 'Not found';

  @override
  String get errorServer => 'Server error';

  @override
  String get errorCancelled => 'Cancelled';

  @override
  String get errorUnknown => 'Something went wrong';

  @override
  String get dashboardSectionToday => 'Today';

  @override
  String get dashboardMetricCalories => 'Calories';

  @override
  String get dashboardMetricExercise => 'Exercise';

  @override
  String get dashboardMetricWeight => 'Weight';

  @override
  String get dashboardChartWeightWeek => 'Weekly weight';

  @override
  String dashboardCaloriesProgress(int pct, int goal) {
    return '$pct% of $goal';
  }

  @override
  String dashboardWeightDelta(String sign, String delta) {
    return '$sign$delta vs last week';
  }

  @override
  String get homeGreeting => 'Minsu, let\'s ease into the day 👋';

  @override
  String get homeCoachingPill => '✦ AI Coaching';

  @override
  String get homeCoachingTitle => 'Today\'s tailored advice';

  @override
  String get homeCoachingBody =>
      'Cut back on sodium at dinner and\ntake about a 20-minute walk';

  @override
  String get homeCoachingReady => 'AI prepared 3 tailored tips for you today';

  @override
  String get homeDietSodiumAlert => 'Sodium over limit detected';

  @override
  String get homeMacroCarbs => 'Carbs';

  @override
  String get homeMacroProtein => 'Protein';

  @override
  String get homeMacroFat => 'Fat';

  @override
  String get homeDietRecBadge => '✦ AI dinner recommendation';

  @override
  String get homeMealChickenSalad => 'Chicken breast salad';

  @override
  String get homeDietRecRice => 'Half bowl of brown rice';

  @override
  String get homeDietLogButton => 'Log diet →';

  @override
  String get homeExerciseRoutineProgress => 'AI routine 1/3 done';

  @override
  String homeExerciseBurnGoal(String unit, int goal) {
    return '$unit burned · Goal $goal';
  }

  @override
  String get homeExerciseBrisk => 'Brisk walking';

  @override
  String get homeExerciseLegStretch => 'Lower-body stretch';

  @override
  String get homeExerciseRecBadge => '✦ AI remaining routine';

  @override
  String get homeExerciseRecStretch => 'Lower-body stretch 10 min';

  @override
  String get homeExerciseRecStrength => 'Low-intensity strength 15 min';

  @override
  String get homeExerciseLogButton => 'Log exercise →';

  @override
  String get homeSummaryToday => 'Today total';

  @override
  String get homeVsGoal => 'vs goal';

  @override
  String get homeNutritionTitle => 'Nutrition status';

  @override
  String get homeAiAnalysisPill => '✦ AI analysis';

  @override
  String get homeNutritionSubtitle => 'Weekly trend · vs last week';

  @override
  String get homeDetails => 'Details';

  @override
  String get homeThisWeekAvg => 'This week avg';

  @override
  String get homeLastWeekAvg => 'Last week avg';

  @override
  String get homeGoal => 'Goal';

  @override
  String get homeVsLastWeek => 'vs last week';

  @override
  String get homeSodiumInsightPre => 'Sodium intake has been ';

  @override
  String get homeSodiumInsightTrend => 'rising for 2 weeks';

  @override
  String get homeSodiumInsightMid => '. Cut back on salt and turn on ';

  @override
  String get homeSodiumInsightAlert => 'high-sodium meal alerts';

  @override
  String get homeSodiumInsightPost => '?';

  @override
  String get homeAiPill => '✦ AI';

  @override
  String get homeLegendThisWeek => 'This week';

  @override
  String get homeLegendLastWeek => 'Last week';

  @override
  String get homeLegendToday => 'Today';

  @override
  String get homeMealReasonSodium => 'Great for sodium control';

  @override
  String get homeMealTagLowSodium => 'Low sodium';

  @override
  String get homeMealBrownRiceBox => 'Brown rice lunchbox';

  @override
  String get homeMealReasonGlucose => 'Helps steady blood sugar';

  @override
  String get homeMealTagLowGi => 'Low GI';

  @override
  String get homeMealSalmon => 'Grilled salmon + greens';

  @override
  String get homeMealReasonOmega => 'Omega-3 + fiber';

  @override
  String get homeMealTagHighProtein => 'High protein';

  @override
  String get homeMealTofu => 'Stir-fried tofu & veggies';

  @override
  String get homeMealReasonLowCal => 'Low calorie, keeps you full';

  @override
  String get homeMealTagLowCal => 'Low calorie';

  @override
  String get homeRecMealsTitle => 'This week\'s AI meal picks';

  @override
  String get homeViewAll => 'View all';

  @override
  String homeScheduleDate(String weekday, int month, int day) {
    return '$weekday, $month/$day';
  }

  @override
  String get homeScheduleTitle => 'Today\'s schedule';

  @override
  String get homeScheduleEveningWalk => 'Evening walk';

  @override
  String get homeScheduleWalkDetail => 'Around home · 20 min';

  @override
  String get unitKcal => 'kcal';

  @override
  String get unitMinutes => 'min';

  @override
  String get unitKg => 'kg';

  @override
  String get dietTitle => 'Diet';

  @override
  String get dietToday => 'Today';

  @override
  String dietWeekLabel(int month, int week) {
    return 'Month $month, Week $week';
  }

  @override
  String get dietWeekdayMon => 'Mon';

  @override
  String get dietWeekdayTue => 'Tue';

  @override
  String get dietWeekdayWed => 'Wed';

  @override
  String get dietWeekdayThu => 'Thu';

  @override
  String get dietWeekdayFri => 'Fri';

  @override
  String get dietWeekdaySat => 'Sat';

  @override
  String get dietWeekdaySun => 'Sun';

  @override
  String get dietNutritionSummary => 'Today\'s Nutrition';

  @override
  String get dietCalories => 'Calories';

  @override
  String get dietSodium => 'Sodium';

  @override
  String get dietSugar => 'Sugar';

  @override
  String get dietUnitMg => 'mg';

  @override
  String get dietUnitG => 'g';

  @override
  String get dietAiFeedback => 'AI Feedback';

  @override
  String get dietTodayMeals => 'Today\'s Meals';

  @override
  String get dietAddMeal => 'Add Meal';

  @override
  String get dietEmptyLog =>
      'No meals logged yet.\nAdd your first meal with a photo!';

  @override
  String get dietPhotoAnalysis => 'Photo Analysis';

  @override
  String get dietLoadError => 'Couldn\'t load your diet.';

  @override
  String get dietOtherDateEmpty =>
      'Records for the selected date aren\'t available yet.\nPlease check your diet on today\'s date.';

  @override
  String dietTagSodium(int mg) {
    return 'Sodium ${mg}mg';
  }

  @override
  String dietTagSugar(int g) {
    return 'Sugar ${g}g';
  }

  @override
  String get dietMealBreakfast => 'Breakfast';

  @override
  String get dietMealLunch => 'Lunch';

  @override
  String get dietMealDinner => 'Dinner';

  @override
  String get dietMealSnack => 'Snack';

  @override
  String dietMealSheetTitle(String meal) {
    return '$meal';
  }

  @override
  String get dietAddSheetTitle => 'Add a Meal';

  @override
  String get dietAddSheetSubtitle => 'Analyze your food from a photo';

  @override
  String get dietPickPhoto => 'Choose a Photo';

  @override
  String get dietPickPhotoSub => 'Pick a food photo from your gallery';

  @override
  String get dietTakePhoto => 'Take a Photo';

  @override
  String get dietTakePhotoSub => 'Snap your food with the camera';

  @override
  String get dietPhotoLoadError =>
      'Couldn\'t load the photo. Please try again in a moment.';

  @override
  String get dietAnalyzing => 'Analyzing…';

  @override
  String get dietAnalysisFailed => 'Analysis failed';

  @override
  String get dietAnalysisDone => 'Analysis complete!';

  @override
  String get dietAiNutritionResult => 'AI Nutrition Result';

  @override
  String get dietAnalyzingBody => 'Analyzing the food in your photo';

  @override
  String get dietAnalysisFailedBody =>
      'Analysis failed. Please try again in a moment.';

  @override
  String get dietRecognizedFood => 'Recognized Food';

  @override
  String get dietNoRecognizedFood => 'No food recognized';

  @override
  String get dietNutritionResult => 'Nutrition Result';

  @override
  String get dietSaved => 'Meal saved';

  @override
  String get dietDone => 'Done';

  @override
  String get dietSaveFailed => 'Couldn\'t save. Please try again in a moment.';

  @override
  String get dietDeleteTitle => 'Delete Meal Record';

  @override
  String get dietDeleteConfirm => 'Delete this meal record?';

  @override
  String get dietCancel => 'Cancel';

  @override
  String get dietDelete => 'Delete';

  @override
  String get dietDeleted => 'Meal deleted';

  @override
  String get dietDeleteFailed =>
      'Couldn\'t delete. Please try again in a moment.';

  @override
  String get dietSave => 'Save';

  @override
  String get dietMealInfo => 'Meal Info';

  @override
  String get dietEatenTime => 'Time Eaten';

  @override
  String get dietEatenFood => 'Food Eaten';

  @override
  String get dietNewFood => 'New food';

  @override
  String get dietAddFood => '+ Add Food';

  @override
  String get dietEditFoodHint => 'You can edit the food name and calories';

  @override
  String get dietTotalCalories => 'Total Calories';

  @override
  String get dietNutritionInfo => 'Nutrition Info';

  @override
  String get dietEditNutritionHint =>
      'You can edit the analyzed values directly';

  @override
  String get dietSodiumHint => 'Recommended under 2,000mg/day';

  @override
  String get dietSugarHint => 'Recommended under 50g/day';

  @override
  String get dietDeleteMeal => 'Delete Meal';
}
