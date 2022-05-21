import 'package:clean_arc_app/data/network/failure.dart';
import 'package:clean_arc_app/domain/model/models.dart';
import 'package:clean_arc_app/domain/repository/repository.dart';
import 'package:clean_arc_app/domain/usecase/base_usecase.dart';
import 'package:dartz/dartz.dart';

// usecases are used to connect our viewmodels with domain layer
class StoreDetailsUseCase implements BaseUseCase<void, StoreDetails> {
  final Repository _repository;
  StoreDetailsUseCase(this._repository);

  @override
  Future<Either<Failure, StoreDetails>> execute(void input) async {
    return await _repository.getStoreDetails();
  }
}
