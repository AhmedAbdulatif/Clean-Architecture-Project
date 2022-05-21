import 'package:clean_arc_app/data/network/failure.dart';
import 'package:clean_arc_app/data/network/requests.dart';
import 'package:clean_arc_app/domain/model/models.dart';
import 'package:clean_arc_app/domain/repository/repository.dart';
import 'package:clean_arc_app/domain/usecase/base_usecase.dart';
import 'package:dartz/dartz.dart';

// usecases are used to connect our viewmodels with domain layer
class LoginUseCase implements BaseUseCase<LoginUseCaseInput, Authentication> {
  final Repository _repository;
  LoginUseCase(this._repository);

  @override
  Future<Either<Failure, Authentication>> execute(
      LoginUseCaseInput input) async {
    return await _repository.login(LoginRequest(input.email, input.password));
  }
}

class LoginUseCaseInput {
  final String email;
  final String password;
  LoginUseCaseInput(this.email, this.password);
}
