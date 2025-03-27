import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static saveData(String key, String data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, data);
  }

  static saveDataList(String key, List<String> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(key, data);
  }

  static saveMultiData(List<String> keys, List<String> datas) async {
    if (keys.length != datas.length) return;
    final prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < keys.length; i++) {
      await prefs.setString(keys[i], datas[i]);
    }
  }

  static readData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static readDataList(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key);
  }

  static Future<bool> removeEntry(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.remove(key);
  }
}
