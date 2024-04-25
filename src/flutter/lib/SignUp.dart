import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Home.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'login.dart'; // Import your LoginView widget


class SignUpView extends StatefulWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  String email = '';
  String password = '';
  String confirmPassword = '';
  String tankId = ''; // Declare tankId variable


  bool get isSignUpButtonDisabled =>
      email.isEmpty ||
      password.isEmpty ||
      confirmPassword.isEmpty ||
      password != confirmPassword ||
      tankId.isEmpty; 

  String generateSalt() {
  final Random random = Random.secure();
  final salt = List<int>.generate(16, (_) => random.nextInt(256));
  return base64UrlEncode(salt);
}


  String hashPassword(String password, String salt) {
  final String saltedPassword = password + salt;
  final codec = Utf8Codec(allowMalformed: true);
  final passwordBytes = codec.encode(saltedPassword);
  final hash = sha256.convert(passwordBytes);
  final hashedPassword = hash.toString();
  return hashedPassword.substring(0, 60); // Truncate to 60 characters
}
  String getApiUrl() {
    if (kIsWeb) {
      // Handle web platform
      return 'http://localhost:5000/register';
    } else if (Platform.isAndroid) {
      // Handle Android platform
      return 'http://10.0.2.2:5000/register';
    } else if (Platform.isIOS) {
      // Handle iOS platform
      return 'http://localhost:5000/register';
    } else {
      // Handle other platforms (if any)
      return 'http://localhost:5000/register';
    }
}
  Future<void> registerUser(String username, String password, String tankId) async {
  String apiUrl = getApiUrl();
  final String salt = generateSalt();
  final Map<String, String> headers = {
    'Content-Type': 'application/json',
  };
  final Map<String, dynamic> body = {
    'username': username,
    'hashedPassword': hashPassword(password, salt),
    'salt': salt,
    'tankId': tankId, // Add tankId to the body
  };

  try {
    final response = await http.post(Uri.parse(apiUrl), headers: headers, body: jsonEncode(body));

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
        msg: 'Sign up successful!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      // Navigate to login screen after successful registration
      Navigator.pop(context);
      
    } else if (response.statusCode == 400 && jsonDecode(response.body)['error'] == 'Username already exists') {
      Fluttertoast.showToast(
        msg: 'Username already exists. Please choose a different username.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } 
    else if (response.statusCode == 402 ) {
      Fluttertoast.showToast(
        msg: 'Invalid Tank ID',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
    
    else {

      print('Failed to register: ${response.body}');
      Fluttertoast.showToast(
        msg: 'Sign up failed. Please try again.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  } catch (e) {
    print('Error registering user: $e');
    Fluttertoast.showToast(
      msg: 'Error registering user. Please try again.',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20.0),
                FractionallySizedBox(
                  widthFactor: 0.8,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Username',
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        email = value;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 15.0),
                FractionallySizedBox(
                  widthFactor: 0.8,
                  child: TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        password = value;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 15.0),
                FractionallySizedBox(
                  widthFactor: 0.8,
                  child: TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Confirm Password',
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        confirmPassword = value;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 15.0),
                FractionallySizedBox(
                  widthFactor: 0.8,
                  child: TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Tank ID',
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        tankId = value;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 5.0),
                
                ElevatedButton(
                    onPressed: isSignUpButtonDisabled
                        ? null
                        : () {
                            registerUser(email, password, tankId); // Pass tankId to the function
                          },
                    child: const Text('Sign Up'),
),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
