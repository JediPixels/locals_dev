// Current Note: Make sure you enter the keys in the api_keys.dart, they are removed for security
// Future Note: api_keys.dart is not uploaded to GitHub via .gitignore for Security
import 'api_keys.dart' as api;

class ApiServiceValues {
  static String authBaseUrl = api.authBaseUrl;
  static String authBaseUrlPath = api.authBaseUrlPath;
  static String deviceId = api.deviceId;
  static String email = api.email;
  static String password = api.password;
  static String feedBaseUrl = api.feedBaseUrl;
  static String feedBaseUrlPath = api.feedBaseUrlPath;
  static Map dataBody = api.dataBody;
}