import 'package:nextgen_learners/constant/import_export.dart';

class ApiConfig {
  // Platform-aware host (always ends with a slash)
  static String get baseHost {
    if (kIsWeb) return 'https://nextgen-learners-backend.onrender.com/';
    if (defaultTargetPlatform == TargetPlatform.android)
      return 'https://nextgen-learners-backend.onrender.com/';
    // return 'http://localhost:5379/';
    return 'https://nextgen-learners-backend.onrender.com/';
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
