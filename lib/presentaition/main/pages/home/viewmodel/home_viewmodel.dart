import 'dart:async';
import 'dart:ffi';

import 'package:clean_arc_app/domain/model/models.dart';
import 'package:clean_arc_app/domain/usecase/home_usecase.dart';
import 'package:clean_arc_app/presentaition/base/base_viewmodel.dart';
import 'package:rxdart/subjects.dart';

import '../../../../common/state_rendrer/state_rendrer.dart';
import '../../../../common/state_rendrer/state_rendrer_imp.dart';

class HomeViewModel extends BaseViewModel
    with HomeViewModelInputs, HomeViewModelOutputs {
  final HomeUseCase _homeUseCase;
  HomeViewModel(this._homeUseCase);

  final StreamController _homeDataStreamController =
      BehaviorSubject<HomeData>();
/*
  final StreamController _servicesStreamController =
      BehaviorSubject<List<Service>>();
  final StreamController _bannersStreamController =
      BehaviorSubject<List<BannerAd>>();
  final StreamController _storesStreamController =
      BehaviorSubject<List<Store>>();
      */
  @override
  void start() {
    _getHomeData();
  }

  @override
  void dispose() {
    /*_servicesStreamController.close();
    _bannersStreamController.close();
    _storesStreamController.close();*/
    _homeDataStreamController.close();
    super.dispose();
  }

  @override
  Sink get inputHomeData => _homeDataStreamController.sink;

  @override
  Stream<HomeData> get outputHomeData =>
      _homeDataStreamController.stream.map((homeData) => homeData);
/*
  // inputs
  @override
  Sink get inputBanners => _bannersStreamController.sink;

  @override
  Sink get inputServices => _servicesStreamController.sink;

  @override
  Sink get inputStores => _storesStreamController.sink;

  // outputs
  @override
  Stream<List<BannerAd>> get outputBanners =>
      _bannersStreamController.stream.map((banners) => banners);

  @override
  Stream<List<Service>> get outputServices =>
      _servicesStreamController.stream.map((services) => services);

  @override
  Stream<List<Store>> get outputStores =>
      _storesStreamController.stream.map((stores) => stores);
      */

  _getHomeData() async {
    inputState.add(LoadingState(
        stateRendrerType: StateRendrerType.fullScreenLoadingState));
    (await _homeUseCase.execute(Void)).fold((failure) {
      inputState.add(ErrorState(
          stateRendrerType: StateRendrerType.fullScreenErrorState,
          message: failure.message));
    }, (homeObject) {
      inputHomeData.add(homeObject.homeData);
      inputState.add(ContentState());

      /*inputServices.add(homeObject.homeData!.services);
      inputBanners.add(homeObject.homeData!.banners);
      inputStores.add(homeObject.homeData!.stores);*/
    });
  }
}

abstract class HomeViewModelInputs {
  Sink get inputHomeData;
  /*
  Sink get inputServices;
  Sink get inputBanners;
  Sink get inputStores;*/
}

abstract class HomeViewModelOutputs {
  Stream<HomeData> get outputHomeData;
  /*
  Stream<List<Service>> get outputServices;
  Stream<List<BannerAd>> get outputBanners;
  Stream<List<Store>> get outputStores;*/
}

class HomeDataObject {
  List<Service> services;
  List<BannerAd> banners;
  List<Store> stores;
  HomeDataObject(this.services, this.banners, this.stores);
}
