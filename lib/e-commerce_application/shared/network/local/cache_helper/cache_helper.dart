import 'package:shared_preferences/shared_preferences.dart';

abstract class CacheHelper{

  static SharedPreferences? preferences;

  static Future<void> initializeCache()async{
    preferences = await SharedPreferences.getInstance();
  }

  static Future<void> storeInCache(String key,dynamic value)async{
    if(value is int){
      await preferences!.setInt(key, value);
    }
    else if(value is double){
      await preferences!.setDouble(key, value);
    }
    else if(value is bool){
      await preferences!.setBool(key, value);
    }
    else if(value is String){
      await preferences!.setString(key, value);
    }
    else if(value is List<String>){
      await preferences!.setStringList(key, value);
    }
    else{
      print("Invalid Value");
    }

  }

  static String? getStringFromCache(String key){
    return  preferences!.getString(key);
  }
  static Future<bool> removeData({required String key}) async {
    return await preferences!.remove(key);
  }
}