import 'package:http/http.dart' as http;


Future<http.Response> FetchAllReadings() {
  return http.get(Uri.parse('http://localhost:5000/get_all_readings'));
}
