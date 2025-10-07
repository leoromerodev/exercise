import 'package:get/get.dart';
import 'package:heavek/models/user/user_model.dart';
import 'package:heavek/services/api_service/api_service.dart';
import 'package:heavek/services/local_storage/local_storage_service.dart';
import 'package:heavek/services/user_service/user_service.dart';
import 'package:heavek/utils/custom_snackbars.dart';
import 'package:heavek/utils/dialogs.dart';
import 'package:heavek/utils/validators.dart';

// Remove circular dependency - don't import AuthController here
Rx<UserModel?> userModelGlobal = Rx<UserModel?>(null);


final apiService = APIService.instance;
final localStorageService = LocalStorageService.instance;
final dialogService = DialogService.instance;
final validationService = ValidationService.instance;
final customSnackBars = CustomSnackBars.instance;

// Set up the auth refresh service after all instances are created
void initializeServices() {
  print('Initializing services...');
  print('UserService.instance: ${UserService.instance}');
  print('apiService: $apiService');
  apiService.setAuthRefreshService(UserService.instance);
  print('Services initialized successfully');
}

String? globalUsername;
String? globalUSecret;

final userTokenKey = "heavek_user_token";
final userAuthTokenKey = "heavek_user_auth_token";
final userEmailKey = "heavek_user_email";
final userPasswordKey = "heavek_user_password";

// Global user login status based on token availability
Future<bool> get isUserLogged async {
  String? token = await localStorageService.readSecureString(key: userTokenKey);
  String? authToken = await localStorageService.readSecureString(key: userAuthTokenKey);
  
  return (token?.isNotEmpty ?? false) && (authToken?.isNotEmpty ?? false);
}
