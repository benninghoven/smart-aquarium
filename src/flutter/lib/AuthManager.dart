import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthResponse {
  final bool success;
  // other properties you expect in the response

  AuthResponse({required this.success});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      success: json['success'],
      // parse other properties if needed
    );
  }
}

class AuthManager {
  // ... other properties

  Future<void> login(
      String name, String password, Function(bool) completion) async {
    const loginEndpoint =
        'https://yourapi.com/login'; // Replace with your actual API endpoint

    try {
      final response = await http.post(
        Uri.parse(loginEndpoint),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': name,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final authResponse = AuthResponse.fromJson(jsonResponse);
        completion(authResponse.success);
      } else {
        completion(false);
      }
    } catch (e) {
      completion(false);
    }
  }
}
