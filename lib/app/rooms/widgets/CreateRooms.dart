import 'package:flutter/material.dart';

class CreateRooms extends StatefulWidget {
  const CreateRooms({super.key});

  @override
  State<CreateRooms> createState() => _CreateRoomsState();
}

class _CreateRoomsState extends State<CreateRooms> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 255, 255, 255),
                    elevation: 0,
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Color.fromARGB(255, 0, 0, 0),
                    size: 35,
                  ),
                ),
                const SizedBox(
                  width: 10,
                )
              ],
            ),
          ),
          Container(
            height: 250,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color.fromARGB(255, 44, 44, 45), Colors.blue],
                ),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50))),
            child: const Column(
              children: [
                Text(
                  "Room Now",
                  style: TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
