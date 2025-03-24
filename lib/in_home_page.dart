import 'package:flutter/material.dart';
import 'add_plant.dart';

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
      body: Center(
        child: Column(
          children:[
            SizedBox(height: 150),
            Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width - 40, // 20 margin on each side
                  height: 130,
                  padding: EdgeInsets.all(50),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Color.fromARGB(255, 189, 221, 214),
                  ),
                ),
                
                const Positioned(
                  top: 10,
                  left: 10,
                  child: Text("Your Plants", style: TextStyle(fontFamily: 'Modak', fontSize: 20)),
                ),

                Positioned(
                  bottom: 2,
                  right: 5,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const AddPlantPage()),
                      );
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black,
                    ),
                    child: const Text(
                      'Add Your Plant',
                      style: TextStyle(fontSize: 12, decoration: TextDecoration.underline),
                    ),
                  ),
                ),
                
              ],
            ),
          ]
        ) 
      )
    );
  }
}