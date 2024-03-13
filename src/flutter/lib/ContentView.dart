import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(const MaterialApp(
    home: ContentView(),
  ));
}

class AuthManager extends ChangeNotifier {
  // Implement your AuthManager class
  // ...
}

class ContentView extends StatefulWidget {
  const ContentView({Key? key}) : super(key: key);

  @override
  _ContentViewState createState() => _ContentViewState();
}

class _ContentViewState extends State<ContentView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  AuthManager authManager = AuthManager();
  String name = '';
  String password = '';
  bool showPassword = false;

  bool get isSignInButtonDisabled => _nameController.text.isEmpty || _passwordController.text.isEmpty;

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
                TextField(
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
                const SizedBox(height: 15.0),
                Row(
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
                      icon: Icon(showPassword ? Icons.visibility_off : Icons.visibility),
                      color: Colors.red,
                      onPressed: () {
                        setState(() {
                          showPassword = !showPassword;
                        });
                      },
                    ),
                  ],
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

                          // Navigate to the next screen
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const PagesView(selectedTab: Tab.house),
                          )).then((_) {
                            // Clear the text fields after successful login
                            _nameController.clear();
                            _passwordController.clear();

                            // Reset the state of the Sign In button
                            setState(() {});
                          });
                        },
                  child: const Text('Sign In'),
                ),
                const SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SignUpView()),
                        );
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SignUpView extends StatefulWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Username',
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onChanged: (value) {
                  setState(() {});
                },
              ),
              const SizedBox(height: 15.0),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onChanged: (value) {
                  setState(() {});
                },
              ),
              const SizedBox(height: 15.0),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Confirm Password',
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onChanged: (value) {
                  setState(() {});
                },
              ),
              const SizedBox(height: 15.0),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Sign Up'),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

enum Tab { house, message, person, car, trash }

class PagesView extends StatefulWidget {
  final Tab selectedTab;

  const PagesView({Key? key, required this.selectedTab}) : super(key: key);

  @override
  _PagesViewState createState() => _PagesViewState();
}

class _PagesViewState extends State<PagesView> with SingleTickerProviderStateMixin {
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
              FourthScreen(),
              FifthScreen(),
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

class FirstScreen extends StatelessWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('First Screen'),
      ),
      body: const Center(
        child: Text(
          'Welcome to the First Screen!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class SecondScreen extends StatelessWidget {
  const SecondScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Disable the back arrow
        title: const Text('Second Screen'),
      ),
      body: const Center(
        child: Text(
          'Welcome to the Second Screen!',
          style: TextStyle(fontSize: 24),
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

class FourthScreen extends StatelessWidget {
  const FourthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Disable the back arrow
        title: const Text('Fourth Screen'),
      ),
      body: const Center(
        child: Text(
          'Welcome to the Fourth Screen!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class FifthScreen extends StatelessWidget {
  const FifthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Disable the back arrow
        title: const Text('Fifth Screen'),
      ),
      body: const Center(
        child: Text(
          'Welcome to the Fifth Screen!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class MyTabBar extends StatelessWidget {
  final Tab selectedTab;
  final ValueChanged<Tab> onTabChanged;

  const MyTabBar({Key? key, required this.selectedTab, required this.onTabChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildTabIcon(Icons.home, Tab.house),
          buildTabIcon(FontAwesomeIcons.fish, Tab.message),
          buildTabIcon(Icons.person, Tab.person),
          buildTabIcon(Icons.directions_car, Tab.car),
          buildTabIcon(Icons.delete, Tab.trash),
        ],
      ),
    );
  }

  IconButton buildTabIcon(IconData icon, Tab tab) {
    return IconButton(
      icon: Icon(icon),
      onPressed: () => onTabChanged(tab),
      color: selectedTab == tab ? Colors.blue : Colors.grey,
    );
  }
}
