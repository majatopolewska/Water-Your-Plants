import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plant_app/calendar_widget.dart';
import 'package:plant_app/care%20details/care_suggestions.dart';

import '../your plants/add_plant.dart';
import '../your plants/plant_list_widget.dart';
import 'sign_in_page.dart';

class InHomePage extends StatefulWidget {
  const InHomePage({super.key});

  @override
  State<InHomePage> createState() => _InHomePageState();
}

class _InHomePageState extends State<InHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 226, 242, 203),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 50),

                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const SignInPage()),
                      );
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black,
                    ),
                    child: const Text(
                      "Sign Out",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                const PlantListWidget(), 

                const SizedBox(height: 20),
                const CalendarWidget(),
                
                const SizedBox(height: 20),
                const CareSuggestionsWidget(),

              ],
            ),
          ),
        ),
      ),
    );
  }
}