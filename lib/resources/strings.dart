// Define all the strings to be used in application in this file
// To use - import this file and call required string by:
//```dart
//      Strings.<name>
//```

class Strings {
  Strings._();

  // splash screen
  static const SPLASH_TEXT = 'Created with flutter-boilerplate';

  // intro screen
  static const INTRO_TITLE = 'BauLog';
  static const INTRO_LIST_TITLE = 'A new way of construction site management!';
  static const INTRO_LIST = [
    'Create an account',
    'Get to know the app',
    'Find more infos in the help center'
  ];

  static const noInternetAlert = 'No internet availble. Please check your connection';
  static const FORMAT_ALERT = 'Format exception happen. Please check';
  static const HTTP_ALERT = 'No service available. Please try again later';
  static const GET_STARTED = 'Get Started';

  // it will return the dynamic string
  static String demo(amount) {
    return 'Total amount: $amount';
  }

  static String yourCategoryGenerates(String category) {
    return 'Your $category typically generates';
  }
}
