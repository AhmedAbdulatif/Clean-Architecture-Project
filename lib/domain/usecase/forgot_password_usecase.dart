import 'package:clean_arc_app/data/network/failure.dart';
import 'package:clean_arc_app/domain/model/models.dart';
import 'package:clean_arc_app/domain/repository/repository.dart';
import 'package:clean_arc_app/domain/usecase/base_usecase.dart';
import 'package:dartz/dartz.dart';

class ForgotPasswordUseCase implements BaseUseCase<String, String> {
  final Repository _repository;
  ForgotPasswordUseCase(this._repository);
  @override
  Future<Either<Failure, String>> execute(String email) async {
    return await _repository.resetPassword(email);
  }
}
