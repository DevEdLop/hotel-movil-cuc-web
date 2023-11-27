import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hotel_movil_cuc/config/config.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class CreateRooms extends StatefulWidget {
  const CreateRooms({super.key});

  @override
  State<CreateRooms> createState() => _CreateRoomsState();
}

class _CreateRoomsState extends State<CreateRooms> {
  final TextEditingController _roomNumberController = TextEditingController();
  final TextEditingController _imageRoomController = TextEditingController();
  final TextEditingController _descriptionRoomController =
      TextEditingController();
  final TextEditingController _typeRoomController = TextEditingController();
  final TextEditingController _capacityRoomController = TextEditingController();
  final TextEditingController _priceRoomController = TextEditingController();

  Future<void> addRoom() async {
    String roomNumber = _roomNumberController.text.trim();
    String imageRoom = _imageRoomController.text.trim();
    String descriptionRoom = _descriptionRoomController.text.trim();
    String typeRoom = _typeRoomController.text.trim();
    String capacityRoom = _capacityRoomController.text.trim();
    String priceRoom = _priceRoomController.text.trim();

    final Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded'
    };

    print("${Config.API_BASE}/rooms/create_room");
    final url = Uri.parse("${Config.API_BASE}/rooms/create_room");
    print('GG => room creada');
    final body = {
      'room_number': roomNumber,
      'room_type': typeRoom,
      'room_description': descriptionRoom,
      'capacity': capacityRoom,
      'price': priceRoom,
      'is_available': "true"
    };
    print('=>> body');
    print(body);
    final response = await http.post(
      url,
      headers: headers,
      body: body,
    );
    print(response.statusCode);

    if (roomNumber.isEmpty ||
        typeRoom.isEmpty ||
        descriptionRoom.isEmpty ||
        capacityRoom.isEmpty ||
        priceRoom.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Datos sin diligenciar'),
          content: const Text('todos los campos son obligatorios'),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else if (response.statusCode == 201) {
      print('call me negra');
      print(response.statusCode == 201);
      Navigator.pushNamed(context, '/list_rooms_adm');
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error servidor'),
          content: const Text('comuniquese con el administrador'),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  XFile? _image;
  Future<void> _getImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _image = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(255, 44, 44, 45), Colors.blue],
            ),
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Color.fromARGB(255, 252, 252, 252),
                      size: 35,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
              const Text(
                "Room Now",
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 254, 253),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),
                      const Text(
                        "Room number:",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      TextFormField(
                        controller: _roomNumberController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Enter Room number",
                        ),
                      ),
                      const Text(
                        "Image:",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton(
                        onPressed: _getImage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: Text("Select"),
                        ),
                      ),
                      if (_image != null)
                        Image.file(
                          File(_image!.path),
                          height: 150,
                        ),
                      const SizedBox(height: 10),
                      const Text(
                        "Room description:",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      TextField(
                        controller: _descriptionRoomController,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Enter room description",
                        ),
                      ),
                      const Text(
                        "Room type:",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      TextFormField(
                        controller: _typeRoomController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Enter Room type",
                        ),
                      ),
                      const Text(
                        "Capacity:",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      TextFormField(
                        controller: _capacityRoomController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Enter capacity",
                        ),
                      ),
                      const Text(
                        "Price:",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      TextFormField(
                        controller: _priceRoomController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Enter Price",
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: Container(
                            height: 50,
                            width: 300,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: const LinearGradient(
                                colors: [
                                  Colors.blue,
                                  Color.fromARGB(255, 54, 53, 53)
                                ],
                              ),
                            ),
                            child: TextButton(
                              onPressed: () {
                                addRoom();
                              },
                              child: const Center(
                                child: Text(
                                  "Room Now",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
