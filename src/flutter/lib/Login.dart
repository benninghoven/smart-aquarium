import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'SignUp.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_application_1/Home.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool useSystemTheme = true; // Track if the system theme should be used
  bool isDarkTheme = false; // New variable to track the theme

  void toggleTheme() {
    setState(() {
      if (useSystemTheme == isDarkTheme) {
        useSystemTheme = false;
        isDarkTheme = !isDarkTheme;
      } else if (useSystemTheme != isDarkTheme) {
        useSystemTheme = false;
        isDarkTheme = !isDarkTheme;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Brightness platformBrightness =
        MediaQuery.of(context).platformBrightness;
    final bool systemIsDark = platformBrightness == Brightness.dark;
    final themeData = useSystemTheme
        ? (systemIsDark ? ThemeData.dark() : ThemeData.light())
        : (isDarkTheme ? ThemeData.dark() : ThemeData.light());

    return MaterialApp(
      theme: themeData,
      home: Login(toggleTheme: toggleTheme),
    );
  }
}

class AuthManager extends ChangeNotifier {
  // Implement your AuthManager class
  // ...
}


class Login extends StatefulWidget {
  final VoidCallback toggleTheme;

  const Login({Key? key, required this.toggleTheme}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<Login> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  AuthManager authManager = AuthManager();
  String name = '';
  String password = '';
  bool showPassword = false;
  bool isDarkTheme = false; // New variable to track the theme

  bool get isSignInButtonDisabled =>
      _nameController.text.isEmpty || _passwordController.text.isEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Smart Aquarium',
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20.0), // Add spacing below the large text
                FractionallySizedBox(
                  widthFactor: 0.9, // Adjust this value as needed
                  child: TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'Username',
                      labelText: 'Username',
                      labelStyle: const TextStyle(color: Colors.blue),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        name = value;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 15.0),
                FractionallySizedBox(
                  widthFactor: 0.9, // Adjust this value as needed
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _passwordController,
                          obscureText: !showPassword,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            labelText: 'Password',
                            labelStyle: const TextStyle(color: Colors.red),
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
                      IconButton(
                        icon: Icon(showPassword
                            ? Icons.visibility_off
                            : Icons.visibility),
                        color: Colors.red,
                        onPressed: () {
                          setState(() {
                            showPassword = !showPassword;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15.0),
                ElevatedButton(
                  onPressed: isSignInButtonDisabled
                      ? null
                      : () {
                          Fluttertoast.showToast(
                            msg: 'Sign in successful!',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );

                          Navigator.of(context)
                              .push(MaterialPageRoute(
                            builder: (context) =>
                                const PagesView(selectedTab: Tab.house),
                          ))
                              .then((_) {
                            _nameController.clear();
                            _passwordController.clear();
                            setState(() {});
                          });
                        },
                  child: const Text('Sign In'),
                ),
                const SizedBox(height: 0.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        _nameController.clear();
                        _passwordController.clear();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUpView()),
                        );
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(widget.toggleTheme == null
                      ? Icons.lightbulb
                      : (isDarkTheme
                          ? Icons.lightbulb
                          : Icons.lightbulb_outline)),
                  color: Colors.yellow,
                  onPressed: widget.toggleTheme,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



enum Tab { house, message, person, }

class PagesView extends StatefulWidget {
  final Tab selectedTab;

  const PagesView({Key? key, required this.selectedTab}) : super(key: key);

  @override
  _PagesViewState createState() => _PagesViewState();
}

class _PagesViewState extends State<PagesView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: Tab.values.length, vsync: this);
    _tabController.index = Tab.values.indexOf(widget.selectedTab);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _tabController,
            children: const [
              FirstScreen(),
              SecondScreen(),
              ThirdScreen(),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: MyTabBar(
              selectedTab: Tab.values[_tabController.index],
              onTabChanged: (tab) {
                setState(() {
                  _tabController.index = Tab.values.indexOf(tab);
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}


class SecondScreen extends StatelessWidget {
  const SecondScreen({Key? key}) : super(key: key);


  Future fetchData() async {
    var apiUrl = 'http://localhost:5000/get_latest_reading'; // Replace with your API endpoint
    Map<String, String> header = {
    "Content-Type": "application/json",
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale"
    };
    var response = await http.get(Uri.parse(apiUrl), headers:header);

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON
      var jsonData = json.decode(response.body);

      print(jsonData); // You can process the data further here
      return jsonData;
    } else {
      // If the server did not return a 200 OK response, handle the error accordingly
      print('Failed to load data: ${response.statusCode}');
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Disable the back arrow
        title: const Text('Second Screen'),
      ),
      body: Center(
        child: FutureBuilder(
          future: fetchData(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // Show a loading indicator while fetching data
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              // Data has been fetched successfully
              var data = snapshot.data;
              return Text(
                data != null ? data.toString() : 'No data available',
                style: TextStyle(fontSize: 24),
              );
            }
          },
        ),
      ),
    );
  }
}


class ThirdScreen extends StatelessWidget {
  const ThirdScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Disable the back arrow
        title: const Text('Third Screen'),
      ),
      body: const Center(
        child: Text(
          'Welcome to the Third Screen!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}





class MyTabBar extends StatelessWidget {
  final Tab selectedTab;
  final ValueChanged<Tab> onTabChanged;
  final double tabBarHeightPercentage; // Added tabBarHeightPercentage parameter

  const MyTabBar({
    Key? key,
    required this.selectedTab,
    required this.onTabChanged,
    this.tabBarHeightPercentage = 0.1, // Default percentage set to 8%
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double tabBarHeight = screenHeight * tabBarHeightPercentage;

    return Container(
      height: tabBarHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        currentIndex: selectedTab.index,
        onTap: (index) => onTabChanged(Tab.values[index]),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.fish),
            label: 'Fish',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Person',
          ),
        ],
        type: BottomNavigationBarType.fixed,
        elevation: 0, // Remove the default elevation
      ),
    );
  }
}
