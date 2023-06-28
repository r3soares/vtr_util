import 'package:http/http.dart' as http;

class BaseScrap {
  final headers = {
    'Access-Control-Allow-Origin': '*',
  };

  Future<String> loadPage(String url, Map data) async {
    try {
      final uri = Uri.parse(url);
      final response = await http.post(uri, body: data, headers: headers);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      throw Exception('Erro ao consultar página $url');
    }
  }
}
