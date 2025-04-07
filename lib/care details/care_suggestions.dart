import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'plant_service.dart';

class CareSuggestionsWidget extends StatefulWidget {
  const CareSuggestionsWidget({super.key});

  @override
  State<CareSuggestionsWidget> createState() => _CareSuggestionsWidgetState();
}

class _CareSuggestionsWidgetState extends State<CareSuggestionsWidget> {
  Future<String?>? _sunlightFuture;

  @override
  void initState() {
    super.initState();
    _loadCareData();
  }

  void _loadCareData() async {

    final userPlantsSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('plants')
        .get();

    if (userPlantsSnapshot.docs.isNotEmpty) {
      final firstPlant = userPlantsSnapshot.docs.first;
      final plantId = firstPlant['plant_id'];

      setState(() {
        _sunlightFuture = PlantService().fetchSunlightInfo(plantId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('plants')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 189, 221, 214),
              borderRadius: BorderRadius.circular(15),
            ),
            width: MediaQuery.of(context).size.width - 40,
            child: const Center(
              child: Text(
                "No plants yet",
                style: TextStyle(fontFamily: 'Modak', fontSize: 20),
              ),
            ),
          );
        }

        final plants = snapshot.data!.docs;
        final int rows = (plants.length / 5).ceil();
        final double containerHeight = (rows * 60) + 80;

        return Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width - 40,
              height: containerHeight,
              padding: const EdgeInsets.fromLTRB(15, 50, 15, 30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: const Color.fromARGB(255, 189, 221, 214),
              ),
              child: _sunlightFuture == null
                ? const Center(child: Text('Loading plant care...'))
                : FutureBuilder<String?>(
                  future: _sunlightFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting)
                      return const Center(child: CircularProgressIndicator());

                    if (snapshot.hasError)
                      return Center(child: Text('Error: ${snapshot.error}'));

                    final sunlight = snapshot.data ?? 'No sunlight info';

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('☀️ Sunlight: $sunlight', style: TextStyle(fontSize: 16)),
                      ],
                    );
                  },
                )
            ),
            const Positioned(
              top: 10,
              left: 10,
              child: Text(
                "Care suggestions",
                style: TextStyle(fontFamily: 'Modak', fontSize: 25),
              ),
            ),
          ],
        );
      },
    );
  }
}