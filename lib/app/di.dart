import 'package:clean_arc_app/app/app_prefs.dart';
import 'package:clean_arc_app/data/data_source/local_data_source.dart';
import 'package:clean_arc_app/data/data_source/remote_data_source.dart';
import 'package:clean_arc_app/data/network/app_api.dart';
import 'package:clean_arc_app/data/network/dio_factory.dart';
import 'package:clean_arc_app/data/network/network_info.dart';
import 'package:clean_arc_app/data/repository/repository_impl.dart';
import 'package:clean_arc_app/domain/repository/repository.dart';
import 'package:clean_arc_app/domain/usecase/forgot_password_usecase.dart';
import 'package:clean_arc_app/domain/usecase/home_usecase.dart';
import 'package:clean_arc_app/domain/usecase/login_usecase.dart';
import 'package:clean_arc_app/domain/usecase/store_details_usecase.dart';
import 'package:clean_arc_app/presentaition/forgot_password/viewmodel/forgot_password_viewmodel.dart';
import 'package:clean_arc_app/presentaition/login/viewmodel/login_viewmodel.dart';
import 'package:clean_arc_app/presentaition/main/pages/home/viewmodel/home_viewmodel.dart';
import 'package:clean_arc_app/presentaition/store_details/viewmodel/store_details_viewmodel.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/usecase/register_usecase.dart';
import '../presentaition/register/viewmodel/register_viewmodel.dart';

final getIt = GetIt.instance;
// app module we put in it generic dependencies that we will use in the entire app
Future<void> initAppModule() async {
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  getIt.registerLazySingleton<AppPrefrences>(
      () => AppPrefrences(getIt<SharedPreferences>()));

  // network info
  getIt.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(InternetConnectionChecker()));

  // dio factory
  getIt.registerLazySingleton<DioFactory>(() => DioFactory(getIt()));
  Dio dio = await getIt<DioFactory>().getDio();

  // app service client
  getIt.registerLazySingleton<AppServiceClient>(() => AppServiceClient(dio));

  //remote data source
  getIt.registerLazySingleton<LocalDataSource>(() => LocalDataSourceImpl());

  //remote data source
  getIt.registerLazySingleton<RemoteDataSource>(
      () => RemoteDataSourceImpl(getIt()));

  // repository
  getIt.registerLazySingleton<Repository>(
      () => RepositoryImp(getIt(), getIt(), getIt()));
}

initLoginModule() {
  if (!GetIt.I.isRegistered<LoginUseCase>()) {
    getIt.registerFactory<LoginUseCase>(() => LoginUseCase(getIt()));
    getIt.registerFactory<LoginViewModel>(() => LoginViewModel(getIt()));
  }
}

initForgotPasswordModule() {
  if (!GetIt.I.isRegistered<ForgotPasswordUseCase>()) {
    getIt.registerFactory<ForgotPasswordUseCase>(
        () => ForgotPasswordUseCase(getIt()));
    getIt.registerFactory<ForgotPasswordViewModel>(
        () => ForgotPasswordViewModel(getIt()));
  }
}

initRegisterModule() {
  if (!GetIt.I.isRegistered<RegisterUseCase>()) {
    getIt.registerFactory<RegisterUseCase>(() => RegisterUseCase(getIt()));
    getIt.registerFactory<RegisterViewModel>(() => RegisterViewModel(getIt()));
    getIt.registerFactory<ImagePicker>(() => ImagePicker());
  }
}

initHomeModule() {
  if (!GetIt.I.isRegistered<HomeUseCase>()) {
    getIt.registerFactory<HomeUseCase>(() => HomeUseCase(getIt()));
    getIt.registerFactory<HomeViewModel>(() => HomeViewModel(getIt()));
  }
}

initStoreDetailsModule() {
  if (!GetIt.I.isRegistered<StoreDetailsUseCase>()) {
    getIt.registerFactory<StoreDetailsUseCase>(
        () => StoreDetailsUseCase(getIt()));
    getIt.registerFactory<StoreDetailsViewModel>(
        () => StoreDetailsViewModel(getIt()));
  }
}
