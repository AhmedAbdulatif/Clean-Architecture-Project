import 'package:clean_arc_app/app/constants.dart';
import 'package:clean_arc_app/data/response/responses.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

part 'app_api.g.dart';

@RestApi(baseUrl: Constants.baseUrl)
abstract class AppServiceClient {
  factory AppServiceClient(Dio dio, {String baseUrl}) = _AppServiceClient;

  @POST("/customers/login")
  Future<AuthResponse> login(
      @Field("email") String email, @Field("password") String password);

  @POST("/customers/forgotPassword")
  Future<ForgotPassResponse> resetPassword(@Field("email") String email);

  @POST("/customers/register")
  Future<AuthResponse> register(
    @Field("user_name") String userName,
    @Field("country_code") String countryCode,
    @Field("phone_number") String phoneNumber,
    @Field("email") String email,
    @Field("password") String password,
    @Field("profile_picture") String profilePicture,
  );

  @GET("/home")
  Future<HomeResponse> getHomeData();

  @GET("/storeDetails/1")
  Future<StoreDetailsResponse> getStoreDetails();
}
