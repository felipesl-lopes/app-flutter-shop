import 'package:appshop/shared/utils/constants.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

String get apiKey => dotenv.env['API_KEY'] ?? '';

String get SECURE_TOKEN_URL =>
    'https://securetoken.googleapis.com/v1/token?key=$apiKey';

String get SIGNIN_URL =>
    "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$apiKey";

String get SIGNUP_URL =>
    "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$apiKey";

const USERS_BASE_URL = Constants.USERS_URL;
