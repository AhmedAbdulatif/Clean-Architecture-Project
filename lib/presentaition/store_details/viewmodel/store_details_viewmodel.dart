import 'dart:async';
import 'dart:ffi';

import 'package:clean_arc_app/domain/model/models.dart';
import 'package:clean_arc_app/domain/usecase/store_details_usecase.dart';
import 'package:clean_arc_app/presentaition/base/base_viewmodel.dart';
import 'package:clean_arc_app/presentaition/common/state_rendrer/state_rendrer.dart';
import 'package:clean_arc_app/presentaition/common/state_rendrer/state_rendrer_imp.dart';
import 'package:rxdart/rxdart.dart';

class StoreDetailsViewModel extends BaseViewModel
    with StoreDetailsViewModelInputs, StoreDetailsViewModelOutputs {
  final StoreDetailsUseCase _storeDetailsUseCase;
  StoreDetailsViewModel(this._storeDetailsUseCase);

  final StreamController _storeDetailsStreamController =
      BehaviorSubject<StoreDetails>();
  @override
  void start() {
    getStoreDetails();
  }

  @override
  void dispose() {
    _storeDetailsStreamController.close();
    super.dispose();
  }

  getStoreDetails() async {
    inputState.add(LoadingState(
        stateRendrerType: StateRendrerType.fullScreenLoadingState));
    (await _storeDetailsUseCase.execute(Void)).fold((failure) {
      inputState.add(ErrorState(
          stateRendrerType: StateRendrerType.fullScreenErrorState,
          message: failure.message));
    }, (storeDetails) {
      inputState.add(ContentState());
      inputStoreDetails.add(storeDetails);
    });
  }

  @override
  Sink get inputStoreDetails => _storeDetailsStreamController.sink;

  @override
  Stream<StoreDetails> get outPutStoreDetails =>
      _storeDetailsStreamController.stream.map((storeDetails) => storeDetails);
}

abstract class StoreDetailsViewModelInputs {
  Sink get inputStoreDetails;
}

abstract class StoreDetailsViewModelOutputs {
  Stream<StoreDetails> get outPutStoreDetails;
}
