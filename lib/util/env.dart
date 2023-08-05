import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static Future<void> load() async {
    await dotenv.load(fileName: '.env');
  }

  static String get apiUrl => dotenv.env['API_URL']!;

  static String get testEmail => dotenv.env['TEST_EMAIL'] ?? '';

  static String get testPassword => dotenv.env['TEST_PASSWORD'] ?? '';
}
