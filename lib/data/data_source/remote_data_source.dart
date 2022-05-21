import 'package:clean_arc_app/data/network/requests.dart';
import 'package:clean_arc_app/data/response/responses.dart';

import '../network/app_api.dart';

abstract class RemoteDataSource {
  Future<AuthResponse> login(LoginRequest loginRequest);
  Future<ForgotPassResponse> resetPassword(String email);
  Future<AuthResponse> register(RegisterRequest registerRequest);
  Future<HomeResponse> getHomeData();
  Future<StoreDetailsResponse> getStoreDetails();
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final AppServiceClient _appServiceClient;
  RemoteDataSourceImpl(this._appServiceClient);
  @override
  Future<AuthResponse> login(LoginRequest loginRequest) async {
    return await _appServiceClient.login(
        loginRequest.email, loginRequest.password);
  }

  @override
  Future<ForgotPassResponse> resetPassword(String email) async {
    return await _appServiceClient.resetPassword(email);
  }

  @override
  Future<AuthResponse> register(RegisterRequest registerRequest) async {
    return await _appServiceClient.register(
        registerRequest.userName,
        registerRequest.countryCode,
        registerRequest.phoneNumber,
        registerRequest.email,
        registerRequest.password,
        "");
  }

  @override
  Future<HomeResponse> getHomeData() {
    return _appServiceClient.getHomeData();
  }

  @override
  Future<StoreDetailsResponse> getStoreDetails() {
    return _appServiceClient.getStoreDetails();
  }
}
