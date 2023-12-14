import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mini_projet/SignInPage.dart'; // Ensure the import statement is correct
import 'package:mini_projet/signup_page.dart';

import 'main.dart';

class AddMealForm extends StatefulWidget {
  final VoidCallback onAddMeal;

  const AddMealForm({Key? key, required this.onAddMeal}) : super(key: key);

  @override
  _AddMealFormState createState() => _AddMealFormState();
}

class _AddMealFormState extends State<AddMealForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();
  final TextEditingController instructionsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add New Meal'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Meal Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a meal name';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: imageUrlController,
              decoration: InputDecoration(labelText: 'Image URL'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an image URL';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: instructionsController,
              maxLines: 3,
              decoration: InputDecoration(labelText: 'Instructions'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter instructions';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  await addMeal(
                    nameController.text,
                    imageUrlController.text,
                    instructionsController.text,
                  );
                }
              },
              child: Text('Add Meal'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addMeal(
      String name, String imageUrl, String instructions) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/meals'),
        body: json.encode({
          'strMeal': name,
          'strMealThumb': imageUrl,
          'strInstructions': instructions,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        widget.onAddMeal(); // Trigger callback on success
        Navigator.of(context).pop();
      } else {
        print('Failed to add meal. Status code: ${response.statusCode}');
        setState(() {
          'Failed to add meal. Status code: ${response.statusCode}';
        });
      }
    } catch (error) {
      print('Error adding meal: $error');
      setState(() {});
    }
  }

  void handleSignUp() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SignUpPage(
          onSignUp: () {
            // Handle signup success
            print('Sign-up successful');
          },
        );
      },
    );
  }

  void handleSignIn() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SignInPage(onSignIn: () {
          // Handle sign-in success
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => NavigationBarApp()),
          );
        });
      },
    );
  }
}
