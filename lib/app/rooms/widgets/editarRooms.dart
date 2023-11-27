import 'package:flutter/material.dart';
import 'package:hotel_movil_cuc/config/config.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class EditarRooms extends StatefulWidget {
  const EditarRooms({Key? key}) : super(key: key);

  @override
  State<EditarRooms> createState() => _EditarRoomsState();
}

class _EditarRoomsState extends State<EditarRooms> {
  TextEditingController roomNumberController = TextEditingController();
  TextEditingController imageRoomController = TextEditingController();
  TextEditingController descriptionRoomController = TextEditingController();
  TextEditingController typeRoomController = TextEditingController();
  TextEditingController capacityRoomController = TextEditingController();
  TextEditingController priceRoomController = TextEditingController();

  String idRoom = "";
  void cargarInfo(String roomNumber, String description, String type,
      String capacity, String precio, String id) {
    setState(() {
      roomNumberController.text = roomNumber;
      descriptionRoomController.text = description;
      typeRoomController.text = type;
      capacityRoomController.text = capacity;
      priceRoomController.text = precio;
      idRoom = id;
    });
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

  Future<void> editRoom() async {
    String roomNumber = roomNumberController.text.trim();
    String imageRoom = imageRoomController.text.trim();
    String descriptionRoom = descriptionRoomController.text.trim();
    String typeRoom = typeRoomController.text.trim();
    String capacityRoom = capacityRoomController.text.trim();
    String priceRoom = priceRoomController.text.trim();

    final Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded'
    };

    print("${Config.API_BASE}/rooms/update_room/${idRoom}");
    final url = Uri.parse("${Config.API_BASE}/rooms/update_room/${idRoom}");
    print('GG => room editada');
    final body = {
      'room_number': roomNumber,
      'room_type': typeRoom,
      'room_description': descriptionRoom,
      'capacity': capacityRoom,
      'price': priceRoom,
    };
    print('=>> body');
    print(body);
    final response = await http.put(
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
    } else if (response.statusCode == 200) {
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

  @override
  Widget build(BuildContext context) {
    Map arg = ModalRoute.of(context)?.settings.arguments as Map;
    cargarInfo(arg["roomNumber"], arg["description"], arg["type"],
        arg["capacity"], arg["precio"], arg["id"]);
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
                "Edit Room",
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
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextFormField(
                        controller:
                            roomNumberController, // Coloca el valor actual aquí
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const Text(
                        "Image:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
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
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextField(
                        controller: descriptionRoomController,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Enter room description",
                        ),
                      ),
                      const Text(
                        "Room type:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextFormField(
                        controller: typeRoomController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const Text(
                        "Capacity:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextFormField(
                        controller: capacityRoomController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const Text(
                        "Price:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextFormField(
                        controller: priceRoomController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
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
                                  Color.fromARGB(255, 54, 53, 53),
                                ],
                              ),
                            ),
                            child: TextButton(
                              onPressed: () {
                                editRoom();
                              },
                              child: const Center(
                                child: Text(
                                  "Save Changes",
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
