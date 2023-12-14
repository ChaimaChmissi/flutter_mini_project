import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:mini_projet/SignInPage.dart'; // Ensure the import statement is correct
import 'firebase_options.dart';
import 'AddMealForm.dart';
import 'color_schemes.g.dart';
import 'MealsPage.dart';
import 'OrdersPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RootWidget(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
    );
  }
}

class RootWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Check if the user is already signed in
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      return NavigationExample();
    } else {
      return SignInPage(
        onSignIn: () {
          // This callback will be triggered when the user successfully signs in
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => NavigationExample()),
          );
        },
      );
    }
  }
}

class NavigationBarApp extends StatelessWidget {
  const NavigationBarApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NavigationExample(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class NavigationExample extends StatefulWidget {
  const NavigationExample({Key? key}) : super(key: key);

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  int currentPageIndex = 0;
  List<dynamic> meals = [];
  List<dynamic> orders = [];

  @override
  void initState() {
    super.initState();
    fetchMeals();
    fetchOrders(); // Add this line
  }

  Future<void> fetchMeals() async {
    final response = await http.get(Uri.parse('http://localhost:3000/meals'));

    if (response.statusCode == 200) {
      setState(() {
        meals = json.decode(response.body);
      });
    } else {
      print('Failed to load meals');
    }
  }

  Future<void> fetchOrders() async {
    final response = await http.get(Uri.parse('http://localhost:3000/orders'));

    if (response.statusCode == 200) {
      setState(() {
        orders = json.decode(response.body);
      });
    } else {
      print('Failed to load orders');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        destinations: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dining_sharp),
            label: 'Meals',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'My Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Profile',
          ),
        ],
      ),
      body: getPage(currentPageIndex),
      floatingActionButton: currentPageIndex == 0
          ? FloatingActionButton(
              onPressed: handleAddMeal,
              tooltip: 'Add Meal',
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  Widget getPage(int index) {
    switch (index) {
      case 0:
        return MealsPage(meals: meals);
      case 2:
        return Center(child: Text('Menu Page'));
      case 1:
        return OrdersPage(orders: orders);
      default:
        return Center(child: Container());
    }
  }

  void handleAddMeal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddMealForm(
          onAddMeal: () {
            print('Meal added successfully');
            fetchMeals(); // Refresh meals after adding a new one
          },
        );
      },
    );
  }
}

class NavigationBar extends StatelessWidget {
  const NavigationBar({
    Key? key,
    required this.labelBehavior,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
  }) : super(key: key);

  final NavigationDestinationLabelBehavior labelBehavior;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<BottomNavigationBarItem> destinations;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: destinations,
      currentIndex: selectedIndex,
      onTap: onDestinationSelected,
    );
  }
}

enum NavigationDestinationLabelBehavior {
  alwaysShow,
}
