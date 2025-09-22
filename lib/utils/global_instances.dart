import 'package:get/get.dart';
import 'package:heavek/models/user/user_model.dart';
import 'package:heavek/services/api_service.dart/api_service.dart';
import 'package:heavek/services/local_storage/local_storage_service.dart';
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

String? globalUsername;
String? globalUSecret;

final userTokenKey = "heavek_user_token";
final userAuthTokenKey = "heavek_user_auth_token";
