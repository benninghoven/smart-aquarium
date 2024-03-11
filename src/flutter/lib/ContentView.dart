import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


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
  const ContentView({super.key});

  @override
  _ContentViewState createState() => _ContentViewState();
}

class _ContentViewState extends State<ContentView> {
  AuthManager authManager = AuthManager();
  String name = '';
  String password = '';
  bool showPassword = false;
  bool navigateToPagesView = false;
  bool navigateToSignUpView = false;

  bool get isSignInButtonDisabled => name.isEmpty || password.isEmpty;

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
                  decoration: InputDecoration(
                    hintText: 'Name',
                    labelText: 'Login',
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
                    IconButton( // Added IconButton
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
          setState(() {
            navigateToPagesView = true;
          });
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const PagesView(selectedTab: Tab.house,),
          ));
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
  const SignUpView({super.key});

  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  String email = '';
  String password = '';
  String confirmPassword = '';

  bool get isSignUpButtonDisabled =>
      email.isEmpty || password.isEmpty || confirmPassword.isEmpty || password != confirmPassword;

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
                  setState(() {
                    email = value;
                  });
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
                  setState(() {
                    password = value;
                  });
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
                  setState(() {
                    confirmPassword = value;
                  });
                },
              ),
              const SizedBox(height: 15.0),
              ElevatedButton(
                onPressed: isSignUpButtonDisabled
                    ? null
                    : () {
                        // Perform sign-up action here
                        print("do sign-up action");

                        // Show a toast message
                        Fluttertoast.showToast(
                          msg: 'Sign up successful!',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );

                        // Navigate back to the login page
                        Navigator.pop(context);
                      },
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

  const PagesView({super.key, required this.selectedTab});

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
              selectedTab: widget.selectedTab,
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
  const FirstScreen({super.key});

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
  const SecondScreen({super.key});

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
  const ThirdScreen({super.key});

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
  const FourthScreen({super.key});

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
  const FifthScreen({super.key});

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

  const MyTabBar({super.key, required this.selectedTab, required this.onTabChanged});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () => onTabChanged(Tab.house),
            color: selectedTab == Tab.house ? Colors.blue : Colors.grey,
          ),
          IconButton(
            icon: const Icon(Icons.message),
            onPressed: () => onTabChanged(Tab.message),
            color: selectedTab == Tab.message ? Colors.blue : Colors.grey,
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => onTabChanged(Tab.person),
            color: selectedTab == Tab.person ? Colors.blue : Colors.grey,
          ),
          IconButton(
            icon: const Icon(Icons.directions_car),
            onPressed: () => onTabChanged(Tab.car),
            color: selectedTab == Tab.car ? Colors.blue : Colors.grey,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => onTabChanged(Tab.trash),
            color: selectedTab == Tab.trash ? Colors.blue : Colors.grey,
          ),
        ],
      ),
    );
  }
}
