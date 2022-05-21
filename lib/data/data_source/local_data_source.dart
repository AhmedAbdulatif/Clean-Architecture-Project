import 'dart:convert';

import 'package:clean_arc_app/app/di.dart';
import 'package:clean_arc_app/data/network/error_handler.dart';
import 'package:clean_arc_app/data/response/responses.dart';
import 'package:shared_preferences/shared_preferences.dart';

const CACHE_HOME_KEY = "CACHE_HOME_KEY";
const CACHE_STORE_DETAILS_KEY = "CACHE_STORE_DETAILS_KEY";
const CACHE_STORE_DETAILS_INTERVAL = 30 * 1000;
const CACHE_HOME_INTERVAL = 60 * 1000; // 1 minute cache in millis

abstract class LocalDataSource {
  Future<HomeResponse> getHomeData();
  Future<void> saveHomeToCache(HomeResponse homeResponse);
  Future<StoreDetailsResponse> getStoreDetails();
  Future<void> saveStoreDetailsToCache(
      StoreDetailsResponse storeDetailsResponse);
  void clearCache();
  void removeFromCache(String key);
}

class LocalDataSourceImpl implements LocalDataSource {
  final SharedPreferences _sharedPreferences = getIt<SharedPreferences>();
  @override
  Future<HomeResponse> getHomeData() async {
    String? savedItem = _sharedPreferences.getString(CACHE_HOME_KEY);
    try {
      if (savedItem != null) {
        Map<String, dynamic> cachedMap =
            jsonDecode(savedItem) as Map<String, dynamic>;
        HomeResponse homeResponse = HomeResponse.fromJson(cachedMap["data"]);
        int cacheTime = cachedMap.entries.last.value;
        if (isVal(CACHE_HOME_INTERVAL, cacheTime)) {
          return homeResponse;
        } else {
          throw ErrorHandler.handle(DataSource.CACHE_ERROR);
        }
      }
      throw ErrorHandler.handle(DataSource.CACHE_ERROR);
    } catch (e) {
      print(e.toString());
      throw ErrorHandler.handle(DataSource.CACHE_ERROR);
    }
  }

  @override
  Future<void> saveHomeToCache(HomeResponse homeResponse) async {
    try {
      Map<String, dynamic> item = {
        'data': homeResponse,
        'cacheTime': DateTime.now().millisecondsSinceEpoch
      };
      _sharedPreferences.setString(CACHE_HOME_KEY, jsonEncode(item));
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void clearCache() {
    _sharedPreferences.clear();
  }

  @override
  void removeFromCache(String key) {
    _sharedPreferences.remove(key);
  }

  @override
  Future<StoreDetailsResponse> getStoreDetails() async {
    String? savedItem = _sharedPreferences.getString(CACHE_STORE_DETAILS_KEY);
    try {
      if (savedItem != null) {
        Map<String, dynamic> cachedMap =
            jsonDecode(savedItem) as Map<String, dynamic>;
        StoreDetailsResponse storeDetailsResponse =
            StoreDetailsResponse.fromJson(cachedMap["data"]);
        int cacheTime = cachedMap.entries.last.value;
        if (isVal(CACHE_STORE_DETAILS_INTERVAL, cacheTime)) {
          return storeDetailsResponse;
        } else {
          throw ErrorHandler.handle(DataSource.CACHE_ERROR);
        }
      }
      throw ErrorHandler.handle(DataSource.CACHE_ERROR);
    } catch (e) {
      print(e.toString());
      throw ErrorHandler.handle(DataSource.CACHE_ERROR);
    }
  }

  @override
  Future<void> saveStoreDetailsToCache(
      StoreDetailsResponse storeDetailsResponse) async {
    try {
      Map<String, dynamic> item = {
        'data': storeDetailsResponse,
        'cacheTime': DateTime.now().millisecondsSinceEpoch
      };
      _sharedPreferences
          .setString(CACHE_STORE_DETAILS_KEY, jsonEncode(item))
          .then((value) => print("saved"))
          .catchError((error) => print(error.toString()));
    } catch (e) {
      print(e.toString());
    }
  }
}

class CachedItem {
  dynamic data;
  int cacheTime = DateTime.now().millisecondsSinceEpoch;

  CachedItem({required this.data, required this.cacheTime});

  factory CachedItem.fromJson(Map<String, dynamic> json) {
    return CachedItem(data: json["data"], cacheTime: json["cacheTime"]);
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map["data"] = data;
    map["cacheTime"] = cacheTime;
    return map;
  }
}

extension CachedItemExtension on CachedItem {
  bool isValid(int expirationTimeInMillis) {
    int currentTimeInMilliseconds = DateTime.now().millisecondsSinceEpoch;
    bool valid =
        currentTimeInMilliseconds - cacheTime <= expirationTimeInMillis;
    return valid;
  }
}

bool isVal(int expirationTimeInMillis, int cacheTime) {
  int currentTimeInMilliseconds = DateTime.now().millisecondsSinceEpoch;
  bool valid = currentTimeInMilliseconds - cacheTime <= expirationTimeInMillis;
  return valid;
}
