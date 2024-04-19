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

  Future<void> fetchOurData() async {
  try {
    // Fetch fish tolerances data
    var apiUrlFishTolerances = 'http://localhost:5000/get_fish_tolerances';
    var responseFishTolerances = await http.get(Uri.parse(apiUrlFishTolerances));

    if (responseFishTolerances.statusCode == 200) {
      var jsonDataFishTolerances = json.decode(responseFishTolerances.body) as List<dynamic>;

      // Fetch latest reading data
      var apiUrlLatestReading = 'http://localhost:5000/get_latest_reading';
      var responseLatestReading = await http.get(Uri.parse(apiUrlLatestReading));

      if (responseLatestReading.statusCode == 200) {
        var jsonDataLatestReading = json.decode(responseLatestReading.body) as Map<String, dynamic>;

        // Extract latest readings
        var latestPPM = jsonDataLatestReading['PPM'] as int?;
        var latestPH = jsonDataLatestReading['pH'] as double?;
        var latestTemp = jsonDataLatestReading['water_temp'] as double?;

        // Find selected fish data
        var selectedFishData = jsonDataFishTolerances.firstWhere(
          (fish) => fish['fish_name'] == selectedFish,
          orElse: () => {},
        );

        if (selectedFishData.isNotEmpty) {
          // Compare latest reading with fish's tolerance range
          var minPPM = selectedFishData['min_ppm'] as int;
          var maxPPM = selectedFishData['max_ppm'] as int;
          var minPH = selectedFishData['min_ph'] as double;
          var maxPH = selectedFishData['max_ph'] as double;
          var minTemp = selectedFishData['min_temp'] as double;
          var maxTemp = selectedFishData['max_temp'] as double;

          print('Latest PPM: $latestPPM, Latest pH: $latestPH, Latest Temp: $latestTemp');
          print('Min PPM: $minPPM, Max PPM: $maxPPM, Min pH: $minPH, Max pH: $maxPH, Min Temp: $minTemp, Max Temp: $maxTemp');

          if (latestPPM != null && latestPH != null && latestTemp != null) {
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
                    }
                    else{
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
        }
      } else {
        print('Failed to load latest reading data: ${responseLatestReading.statusCode}');
        throw Exception('Failed to load latest reading data');
      }
    } else {
      print('Failed to load fish tolerances data: ${responseFishTolerances.statusCode}');
      throw Exception('Failed to load fish tolerances data');
    }
  } catch (e) {
    print('Error fetching data: $e');
    // Handle error gracefully
  }
}



  Future<void> fetchData() async {
    try {
      var apiUrl = 'http://localhost:5000/get_fish_tolerances';
      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        jsonData = json.decode(response.body) as List<dynamic>;

        setState(() {
          dropdownItems = jsonData.map<String>((fish) => fish['fish_name'] as String).toList();
          selectedFish = dropdownItems.isNotEmpty ? dropdownItems[0] : '';
          fishData = jsonData.firstWhere(
            (fish) => fish['fish_name'] == selectedFish,
            orElse: () => {},
          );
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
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
        title: const Text('Select Fish'),
      ),
      body: Center(
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
