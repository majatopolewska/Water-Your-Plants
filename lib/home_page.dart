import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'register_page.dart';
import 'sign_in_page.dart';
import 'in_home_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

final user = FirebaseAuth.instance.currentUser;

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 226, 242, 203),
      body: Center(
        child: Column(
          children:[
            SizedBox(height: 150),
            const Text('Do you often forget\nto water your plants?', 
              style: TextStyle(fontSize: 30, fontFamily: 'Modak')),

            SizedBox(height: 30),

            GestureDetector(
              onTap: () {
                if(user == null)
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignInPage()),
                  );
                }
                else{
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const InHomePage()),
                  );
                }
                
              },
              child: Image.asset('assets/images/home_plant.png', width: 300),
            ),

            SizedBox(height: 30),

            const Text('I am here to help you!', 
              style: TextStyle(fontSize: 30, fontFamily: 'Modak')),


            Row(
              mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account yet?", 
                    style: TextStyle(fontSize: 17)),

                  TextButton(
                    onPressed: () {
                      Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const RegisterPage()),
                      );
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black,
                    ),
                    child: const Text(
                      'Register',
                      style: TextStyle(fontSize: 17)
                    ),
                  ),
                ]
            ),

          ]
        ) 
      )
    );
  }
}