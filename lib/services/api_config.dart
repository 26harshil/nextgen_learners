import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform, TargetPlatform;

class ApiConfig {
  // Platform-aware host (always ends with a slash)
  static String get baseHost {
    if (kIsWeb) return 'http://localhost:5379/';
    if (defaultTargetPlatform == TargetPlatform.android) return 'http://10.0.2.2:5379/';
    return 'http://localhost:5379/';
  }

  // Full quiz endpoint builder: e.g. http://host:port/Quizz/colors
  static String quizUrl(String quizId) => '${baseHost}Quizz/$quizId';

  // Headers without API key
  static Map<String, String> headers({Map<String, String>? extra}) {
    return <String, String>{
      'Content-Type': 'application/json',
      if (extra != null) ...extra,
    };
  }
}









// import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform, TargetPlatform;

// class ApiConfig {
//   // Platform-aware host (always ends with a slash)
//   static String get baseHost {
//     if (kIsWeb) return 'http://localhost:5379/';
//     if (defaultTargetPlatform == TargetPlatform.android) return 'http://10.0.2.2:5379/';
//     return 'http://localhost:5379/';
//   }

//   // Full quiz endpoint builder: e.g. http://host:port/Quizz/colors
//   static String quizUrl(String quizId) => '${baseHost}Quizz/$quizId';

//   // Headers without API key
//   static Map<String, String> headers({Map<String, String>? extra}) {
//     return <String, String>{
//       'Content-Type': 'application/json',
//       if (extra != null) ...extra,
//     };
//   }
// }