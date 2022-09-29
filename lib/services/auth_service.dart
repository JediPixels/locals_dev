import 'package:http/http.dart' as http;
import '../models/auth_error_model.dart';
import '../models/auth_model.dart';
import 'api_values_service.dart';

class AuthServiceResponse {
  String ssAuthToken = '';
  int statusCode = 0;
  String error = '';
  String errorAdditionalDescription = '';
}

class AuthService {
  static Future<AuthServiceResponse> login() async {
    AuthServiceResponse authServiceResponse = AuthServiceResponse();
    Uri url = Uri.https(ApiServiceValues.authBaseUrl, ApiServiceValues.authBaseUrlPath);

    await http.post(
      url,
      body: {
        'device_id': ApiServiceValues.deviceId,
        'email': ApiServiceValues.email,
        'password': ApiServiceValues.password,
      },
    ).then((response) {
      authServiceResponse.statusCode = response.statusCode;

      if (response.statusCode == 200) {
        // Check body response for possible 'error' message like wrong credentials
        final String isErrorMessage = response.body;
        if (isErrorMessage.contains('error')) {
          authServiceResponse.ssAuthToken = '';
          authServiceResponse.error = 'Error Response';
          final authErrorModel = AuthErrorModel.fromRawJson(isErrorMessage);
          authServiceResponse.errorAdditionalDescription = '\n${authErrorModel.error}';
          return authServiceResponse;
        }
        final authModel = AuthModel.fromRawJson(response.body);
        authServiceResponse.ssAuthToken = authModel.result.ssAuthToken;
        return authServiceResponse;
      }

      if (response.statusCode == 404) {
        authServiceResponse.error = 'Failed to load feed:\n404 Not Found';
      } else {
        authServiceResponse.error = 'Failed to load feed:\nUnknown Error';
      }
      return authServiceResponse;
    }).onError((error, stackTrace) {
      authServiceResponse.error = 'Failed to authenticate:\n$error';
      return authServiceResponse;
    });
    return authServiceResponse;
  }
}