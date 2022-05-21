import 'package:clean_arc_app/data/network/failure.dart';
import 'package:clean_arc_app/data/network/requests.dart';
import 'package:clean_arc_app/domain/model/models.dart';
import 'package:clean_arc_app/domain/repository/repository.dart';
import 'package:clean_arc_app/domain/usecase/base_usecase.dart';
import 'package:dartz/dartz.dart';

// usecases are used to connect our viewmodels with domain layer
class RegisterUseCase
    implements BaseUseCase<RegisterUseCaseInput, Authentication> {
  final Repository _repository;
  RegisterUseCase(this._repository);

  @override
  Future<Either<Failure, Authentication>> execute(
      RegisterUseCaseInput input) async {
    return await _repository.register(RegisterRequest(
        input.userName,
        input.countryCode,
        input.phone,
        input.email,
        input.password,
        input.profilePicture));
  }
}

class RegisterUseCaseInput {
  final String userName;
  final String countryCode;
  final String phone;
  final String email;
  final String password;
  final String profilePicture;
  RegisterUseCaseInput(this.userName, this.countryCode, this.phone, this.email,
      this.password, this.profilePicture);
}
