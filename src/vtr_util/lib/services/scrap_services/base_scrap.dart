import 'package:http/http.dart' as http;

class BaseScrap {
  // final Map<String, String> header = {
  //   'Content-Type': 'application/x-www-form-urlencoded',
  // };
  Future<String> loadPage(String url, Map data) async {
    final uri = Uri.parse(url);
    final response = await http.post(uri, body: data);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return '';
    }
  }
}
