import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'SignUp.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_application_1/Home.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

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


    String getApiUrl() {
        if (kIsWeb) {
          // Handle web platform
          return 'http://localhost:5000/login';
        } else if (Platform.isAndroid) {
          // Handle Android platform
          return 'http://10.0.2.2:5000/login';
        } else if (Platform.isIOS) {
          // Handle iOS platform
          return 'http://localhost:5000/login';
        }
         
        else {
          // Handle other platforms (if any)
          return 'http://localhost:5000/login';
        }
      return 'http://localhost:5000/login';
    }

    Future<void> loginUser(String username, String password) async {
        String apiUrl = getApiUrl();
        final Map<String, String> headers = {
            'Content-Type': 'application/json',
        };

        final Map<String, dynamic> body = {
            'username': username,
            'password': password,
        };

        try {
            final response = await http.post(Uri.parse(apiUrl), headers: headers, body: json.encode(body));

            if (response.statusCode == 200) {
              Fluttertoast.showToast(
                            msg: 'Sign in successful!',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const PagesView(selectedTab: Tab.house),
                ));
            } else {
              Fluttertoast.showToast(
                            msg: 'Sign in Unsuccessful, Invalid Credentials!',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                // Handle failed login
                print('DEVIN: Failed to login: ${response.statusCode}');
            }
        }
        catch (e) {
            print('Error: $e');
        }
    }

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
                          
                            loginUser(name, password);
                            _nameController.clear();
                        _passwordController.clear();
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
            children:  [
              FirstScreen(),
              SecondScreen(),
              ThirdScreen(toggleTheme: () {  }, isDarkTheme: false),
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


class SecondScreen extends StatefulWidget {
  const SecondScreen({Key? key}) : super(key: key);

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  List<String> dropdownItems = [];
  String selectedFish = '';
  Map<String, dynamic> fishData = {};
  late List<dynamic> jsonData; // Define jsonData as a class-level variable
  bool isDarkTheme = false; // New variable to track the theme

Future<void> fetchOurData() async {
  try {
    String apiUrlFishTolerances = kIsWeb
        ? 'http://localhost:5000/get_fish_tolerances'
        : Platform.isAndroid
            ? 'http://10.0.2.2:5000/get_fish_tolerances'
            : 'http://localhost:5000/get_fish_tolerances';

    final responseFishTolerances = await http.get(Uri.parse(apiUrlFishTolerances));
    if (responseFishTolerances.statusCode == 200) {
      List<dynamic> jsonDataFishTolerances = json.decode(responseFishTolerances.body);

      String apiUrlLatestReading = kIsWeb
          ? 'http://localhost:5000/get_latest_reading'
          : Platform.isAndroid
              ? 'http://10.0.2.2:5000/get_latest_reading'
              : 'http://localhost:5000/get_latest_reading';

      final responseLatestReading = await http.get(Uri.parse(apiUrlLatestReading));
      if (responseLatestReading.statusCode == 200) {
        Map<String, dynamic> jsonDataLatestReading = json.decode(responseLatestReading.body);

        // Extract latest readings
        int? latestPPM = jsonDataLatestReading['PPM'] as int?;
        double? latestPH = jsonDataLatestReading['pH'] as double?;
        double? latestTemp = jsonDataLatestReading['water_temp'] as double?;

        // Find selected fish data
        Map<String, dynamic> selectedFishData = jsonDataFishTolerances.firstWhere(
          (fish) => fish['fish_name'] == selectedFish,
          orElse: () => {},
        );

        if (selectedFishData.isNotEmpty) {
          // Compare latest reading with fish's tolerance range
          int minPPM = selectedFishData['min_ppm'] as int;
          int maxPPM = selectedFishData['max_ppm'] as int;
          double minPH = selectedFishData['min_ph'] as double;
          double maxPH = selectedFishData['max_ph'] as double;
          double minTemp = selectedFishData['min_temp'] as double;
          double maxTemp = selectedFishData['max_temp'] as double;

          print('Latest PPM: $latestPPM, Latest pH: $latestPH, Latest Temp: $latestTemp');
          print('Min PPM: $minPPM, Max PPM: $maxPPM, Min pH: $minPH, Max pH: $maxPH, Min Temp: $minTemp, Max Temp: $maxTemp');

          if (latestPPM != null && latestPH != null && latestTemp != null) {
            List<String> warnings = [];

            if (latestPPM < minPPM || latestPPM > maxPPM) {
              warnings.add('PPM: $latestPPM (Expected: $minPPM - $maxPPM)');
            }
            if (latestPH < minPH || latestPH > maxPH) {
              warnings.add('pH: $latestPH (Expected: $minPH - $maxPH)');
            }
            if (latestTemp < minTemp || latestTemp > maxTemp) {
              warnings.add('Temperature: $latestTemp (Expected: $minTemp - $maxTemp)');
            }

            if (warnings.isNotEmpty) {
              String warningMessage = 'Fish is out of tolerance range!\n\n';

              warningMessage += 'Your Values That Are Out Of Habitable Range:\n';
              warningMessage += warnings.join('\n');

              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Warning'),
                  content: Text(warningMessage),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            } else {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Hooray!'),
                  content: const Text('Fish is within tolerance range!'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            }
          }
        }
      } else {
        throw Exception('Failed to load latest reading data: ${responseLatestReading.statusCode}');
      }
    } else {
      throw Exception('Failed to load fish tolerances data: ${responseFishTolerances.statusCode}');
    }
  } catch (e) {
    print('Error fetching data: $e');
    // Handle error gracefully
  }
}




    Future<void> fetchData() async {
    try {
      String apiUrl = kIsWeb
          ? 'http://localhost:5000/get_fish_tolerances'
          : Platform.isAndroid
              ? 'http://10.0.2.2:5000/get_fish_tolerances'
              : 'http://localhost:5000/get_fish_tolerances';

      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        List<dynamic> fetchedData = jsonDecode(response.body);
        setState(() {
          jsonData = fetchedData;
          dropdownItems = fetchedData.map<String>((fish) => fish['fish_name'] as String).toList();
          selectedFish = dropdownItems.isNotEmpty ? dropdownItems[0] : '';
          fishData = fetchedData.firstWhere(
            (fish) => fish['fish_name'] == selectedFish,
            orElse: () => {},
          );
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
      // Handle error gracefully
    }
  }



  void onDropdownChanged(String? newValue) {
    print('Selected fish: $newValue'); // Add debug print
    setState(() {
      selectedFish = newValue ?? '';
      fishData = jsonData.firstWhere(
        (fish) => fish['fish_name'] == selectedFish,
        orElse: () => {},
      );
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData(); // Call fetchData in initState to fetch data when the screen is loaded
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Disable the back arrow
        title: const Text('Select Fish', textAlign: TextAlign.center,),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDarkTheme
                ? [Colors.blueGrey.shade900, Colors.blueGrey.shade700]
                : [Colors.blue.shade200, Colors.blue.shade400],
          ),
        ),
        child: Center(
          
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<String>(
              value: selectedFish,
              onChanged: dropdownItems.isNotEmpty ? onDropdownChanged : null,
              items: dropdownItems.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            ElevatedButton(
              onPressed: fetchOurData, // Call fetchData when the button is pressed
              child: const Text('Is It Compatible?'),
            ),
            const SizedBox(height: 20),
            if (fishData.isNotEmpty)
              Column(
                children: [
                  Text('Fish: ${fishData['fish_name']}'),
                  Text('PPM Range: ${fishData['min_ppm']} - ${fishData['max_ppm']}'),
                  Text('pH Range: ${fishData['min_ph']} - ${fishData['max_ph']}'),
                  Text('Temperature Range: ${fishData['min_temp']} - ${fishData['max_temp']}'),
                  const SizedBox(height: 20),
                ],
              ),
          ],
        ),
      ),
    )
    );
  }
}



class ThirdScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  
  final bool isDarkTheme;

  const ThirdScreen({Key? key, required this.isDarkTheme, required this.toggleTheme}) : super(key: key);

  @override
  _ThirdScreenState createState() => _ThirdScreenState(isDarkTheme: isDarkTheme);
}
class _ThirdScreenState extends State<ThirdScreen> {
  bool useSystemTheme = true; // Track if the system theme should be used
  bool isNotificationEnabled = true; // Track the state of the notification
  final bool isDarkTheme;
  _ThirdScreenState({required this.isDarkTheme});

  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Disable the back arrow
        title: const Text('Settings'), // Changed the title to "Settings"
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'General Settings',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            ListTile(
              title: Text('Dark Mode'),
              trailing: Checkbox(
                value: isDarkTheme,
                onChanged: (_) {
                  print('Checkbox onChanged triggered');
                  
                },
              ),
            ),
             // Track the state of the notification

            ListTile(
              title: Text('Notifications'),
              trailing: IconButton(
                icon: Icon(
                  isNotificationEnabled ? Icons.notifications : Icons.notifications_off,
                  color: isNotificationEnabled ? Colors.blue : Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    // Toggle the state of the notification
                    isNotificationEnabled = !isNotificationEnabled;
                  });
                },
              ),
            ),

            Divider(), // A divider for visual separation

            Text(
              'Account Settings',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            ListTile(
              title: Text('Change Password'),
              onTap: () {
                // Implement navigation to change password screen
              },
            ),
            ListTile(
              title: Text('Logout'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
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
