import 'package:clean_arc_app/app/constants.dart';
import 'package:clean_arc_app/data/response/responses.dart';
import 'package:clean_arc_app/domain/model/models.dart';

import 'package:clean_arc_app/app/extensions.dart';

extension CustomerResponseMapper on CustomerResponse? {
  Customer toDomain() {
    return Customer(this!.id.orEmpty(), this!.name.orEmpty(),
        this!.numOfNotifications.orZero());
  }
}

extension ContactResponseMapper on ContactResponse? {
  Contact toDomain() {
    return Contact(
        this!.phone.orEmpty(), this!.email.orEmpty(), this!.link.orEmpty());
  }
}

extension AuthResponseMapper on AuthResponse? {
  Authentication toDomain() {
    return Authentication(this!.customer.toDomain(), this!.contact.toDomain());
  }
}

extension ForgotPasswordResponseMapper on ForgotPassResponse? {
  String toDomain() {
    return this!.support.orEmpty();
  }
}

extension ServicesResponseMapper on ServicesResponse? {
  Service toDomain() {
    return Service(
        this!.id.orZero(), this!.title.orEmpty(), this!.image.orEmpty());
  }
}

extension BannersResponseMapper on BannersResponse? {
  BannerAd toDomain() {
    return BannerAd(this!.id.orZero(), this!.title.orEmpty(),
        this!.image.orEmpty(), this!.link.orEmpty());
  }
}

extension StoresResponseMapper on StoresResponse? {
  Store toDomain() {
    return Store(
        this!.id.orZero(), this!.title.orEmpty(), this!.image.orEmpty());
  }
}

extension HomeDataResponseMapper on HomeDataResponse? {
  HomeData toDomain() {
    return HomeData(
        this!.services!.map((s) => s.toDomain()).cast<Service>().toList(),
        this!.banners!.map((b) => b.toDomain()).cast<BannerAd>().toList(),
        this!.stores!.map((s) => s.toDomain()).cast<Store>().toList());
  }
}

extension HomeResponseMapper on HomeResponse? {
  HomeObject toDomain() {
    return HomeObject(this!.homeDataResponse.toDomain());
  }
}

extension StoreDetailsResponseMapper on StoreDetailsResponse? {
  StoreDetails toDomain() {
    return StoreDetails(
      this!.image?.orEmpty() ?? Constants.empty,
      this!.id?.orZero() ?? Constants.zero,
      this!.title?.orEmpty() ?? Constants.empty,
      this!.details?.orEmpty() ?? Constants.empty,
      this!.services?.orEmpty() ?? Constants.empty,
      this!.about?.orEmpty() ?? Constants.empty,
    );
  }
}

/*
extension HomeResponseMappers on HomeResponse? {
  HomeObject toDomain() {
    List<Service> services = (this
                ?.homeDataResponse
                ?.services
                ?.map((serviceResponse) => serviceResponse.toDomain()) ??
            const Iterable.empty())
        .cast<Service>()
        .toList();

    List<BannerAd> banners = (this
                ?.homeDataResponse
                ?.banners
                ?.map((bannersResponse) => bannersResponse.toDomain()) ??
            const Iterable.empty())
        .cast<BannerAd>()
        .toList();

    List<Store> stores = (this
                ?.homeDataResponse
                ?.stores
                ?.map((storesResponse) => storesResponse.toDomain()) ??
            const Iterable.empty())
        .cast<Store>()
        .toList();

    var data = HomeData(services, banners, stores);
    return HomeObject(data);
  }
}
*/