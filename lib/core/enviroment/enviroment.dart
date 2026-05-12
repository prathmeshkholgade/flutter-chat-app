import 'package:flutter_dotenv/flutter_dotenv.dart';

class Enviroment {
  static final baseUrl = dotenv.env["BASE_URL"] ?? "";
}
