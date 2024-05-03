import 'dart:async';
import 'package:http/http.dart' as http;

class UrlManager {
  static UrlManager? _instance;
  String? baseUrl;

  UrlManager._internal();

  factory UrlManager() {
    return _instance ??= UrlManager._internal();
  }

  Future<String> getValidBaseUrl() async {
    if (baseUrl != null) return baseUrl!;

    List<String> urls = [
      'http://192.168.1.5:8000',
      'http://192.168.1.21:8000',
      'http://192.168.1.8:8000',
      'http://127.0.0.1:8000',
      'http://192.168.1.4:8000',
      'http://10.0.2.2:8000',
      'http://192.168.1.10:8000',
      'http://172.29.10.8:8000',
      'http://172.29.3.167:8000',
      'http://10.0.18.234:8000',
    ];

    for (var url in urls) {
      try {
        final response = await http
            .get(Uri.parse('$url/stations/'))
            .timeout(const Duration(seconds: 3));

        if (response.statusCode == 200) {
          baseUrl = url;
          break;
        }
      } on TimeoutException {
        print('Request to $url timed out');
      } catch (e) {
        print('Error when fetching stations from $url: $e');
      }
    }

    if (baseUrl == null) throw Exception('Failed to find a valid base URL');
    return baseUrl!;
  }
}
