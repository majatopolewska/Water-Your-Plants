import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'register_page.dart';
import 'in_home_page.dart';


class SignInPage extends StatefulWidget
{
  const SignInPage({super.key});

  @override
  State<SignInPage> createState () => _SignInPageState();
}

final TextEditingController givenEmail = TextEditingController();
final TextEditingController givenPassword = TextEditingController();

class _SignInPageState extends State<SignInPage>
{
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 226, 242, 203),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 100),
              Text("Email"),
              Padding(
                padding: EdgeInsets.all(5),
                child: TextField(
                  controller: givenEmail,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              
              SizedBox(height: 15),

              Text("Password"),
              Padding(
                padding: EdgeInsets.all(5),
                child: TextField(
                  controller: givenPassword,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: 15,),

              ElevatedButton(
                onPressed: () async{
                  final email = givenEmail.text.trim();
                  final password = givenPassword.text.trim();

                  try{
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: email,
                      password: password,
                    );

                    Navigator.push(context, 
                    MaterialPageRoute(builder: (context) => const InHomePage())
                    );
                  }
                  catch(e)
                  {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Login failed: ${e.toString()}")),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 43, 184, 134),
                  foregroundColor: Colors.black,
                ),
                child: Text('Sign In', 
                  style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, fontSize: 15),
                )
              ),

              Row(
                children: [
                  Text("Don't have an account yet?",
                  style: TextStyle(fontSize: 17)),
                  
                  TextButton(
                    onPressed: (){
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => RegisterPage()),
                      );
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black,
                    ),
                    child: Text('Register')
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}