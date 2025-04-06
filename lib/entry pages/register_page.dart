import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plant_app/entry%20pages/sign_in_page.dart';

class RegisterPage extends StatefulWidget
{
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

final TextEditingController givenEmail = TextEditingController();
final TextEditingController givenPassword = TextEditingController();
final TextEditingController repeatedPassword = TextEditingController();

Future<void> createAccount(String email, String password) async {
  try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  } catch (e) {
    print('Error creating account: $e');
    rethrow; // Important for handling it in UI
  }
}

class _RegisterPageState extends State<RegisterPage>
{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 226, 242, 203),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 100),

            const Text("Email", style: TextStyle(fontWeight: FontWeight.bold)),
            Padding(
              padding: EdgeInsets.all(5),
              child: TextField(
                controller: givenEmail,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              )
            ),
            const SizedBox(height: 15),

            const Text("Password", style: TextStyle(fontWeight: FontWeight.bold)),
            Padding(
              padding: EdgeInsets.all(5),
              child: TextField(
                controller: givenPassword,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              )
            ),
            const SizedBox(height: 15),

            const Text("Repeat Password", style: TextStyle(fontWeight: FontWeight.bold)),
            Padding(
              padding: EdgeInsets.all(5),
              child: TextField(
                controller: repeatedPassword,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              )
            ),
            const SizedBox(height: 15),

            Padding(
              padding: EdgeInsets.all(5),
              child: ElevatedButton(
                onPressed: () async {
                  final email = givenEmail.text;
                  final password = givenPassword.text;
                  final confirmedPassword = repeatedPassword.text;

                  if (password != confirmedPassword) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Password is not correctly confirmed!")),
                    );
                    return;
                  }

                  try {
                    await createAccount(email, password);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Account created!")),
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignInPage()),
                    );
                  } catch (e) {
                    String errorMessage = 'Unknown error';

                    if (e is FirebaseAuthException) {
                      switch (e.code) {
                        case 'email-already-in-use':
                          errorMessage = 'This email is already in use.';
                          break;
                        case 'invalid-email':
                          errorMessage = 'Invalid email address.';
                          break;
                        case 'weak-password':
                          errorMessage = 'Password should be at least 6 characters.';
                          break;
                      }
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(errorMessage)),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 43, 184, 134),
                  foregroundColor: Colors.black,
                ),
                child: Text('Register', 
                  style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, fontSize: 15),
                )
              )
            )

          ],
        ),
      ),
    );
  }
}