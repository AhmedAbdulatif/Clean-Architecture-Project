// onBoarding models
class SliderObject {
  String title;
  String subTitle;
  String image;

  SliderObject(this.title, this.subTitle, this.image);
}

class SliderViewObject {
  SliderObject sliderObject;
  int numOfSliders;
  int currentIndex;
  SliderViewObject(this.sliderObject, this.numOfSliders, this.currentIndex);
}

// login and registeration models

class Customer {
  String id;
  String name;
  int numOfNotifications;

  Customer(this.id, this.name, this.numOfNotifications);
}

class Contact {
  String phone;
  String email;
  String link;

  Contact(this.phone, this.email, this.link);
}

class Authentication {
  // nullable because it is custom object not primitive type and this is the best parctise
  Customer? customer;
  Contact? contact;

  Authentication(this.customer, this.contact);
}

// home models

class Service {
  int id;
  String title;
  String image;
  Service(this.id, this.title, this.image);
}

class Store {
  int id;
  String title;
  String image;

  Store(this.id, this.title, this.image);
}

class BannerAd {
  int id;
  String title;
  String image;
  String link;

  BannerAd(this.id, this.title, this.image, this.link);
}

class HomeData {
  List<Service> services;
  List<BannerAd> banners;
  List<Store> stores;

  HomeData(this.services, this.banners, this.stores);
}

class HomeObject {
  HomeData? homeData;
  HomeObject(this.homeData);
}

class StoreDetails {
  String image;
  int id;
  String title;
  String details;
  String services;
  String about;
  StoreDetails(
      this.image, this.id, this.title, this.details, this.services, this.about);
}
