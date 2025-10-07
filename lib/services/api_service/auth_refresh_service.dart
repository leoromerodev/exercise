// Abstract interface for auth refresh functionality
abstract class AuthRefreshService {
  Future<void> refreshAuthToken();
  Future<void> refreshAuthUserToken();
}
