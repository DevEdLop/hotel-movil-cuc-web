import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hotel_movil_cuc/design/room_card.dart';
import 'package:hotel_movil_cuc/models/rooms.dart';
import 'package:hotel_movil_cuc/config/config.dart';
import 'package:http/http.dart' as http;

class ListRooms extends StatefulWidget {
  const ListRooms({Key? key}) : super(key: key);

  @override
  State<ListRooms> createState() => _ListRoomsState();
}

class _ListRoomsState extends State<ListRooms> {
  List<Room> filteredHabitaciones = [];
  late TextEditingController _searchController;
  final List<Room> habitaciones = [];

  @override
  void initState() {
    super.initState();
    getRooms();
    _searchController = TextEditingController();
  }

  Future<List<Room>> getRooms() async {
    final resp = await http.get(
      Uri.parse("${Config.API_BASE}/rooms"),
      headers: {'Content-Type': 'application/json; charset=utf-8'},
    );

    final decodedBody = utf8.decode(resp.bodyBytes);
    final items = json.decode(decodedBody).cast<Map<String, dynamic>>();

    List<Room> pd = items.map<Room>((json) {
      return Room.fromJson(json);
    }).toList();
    setState(() {
      habitaciones.addAll(pd);
      filteredHabitaciones = habitaciones;
    });

    print('GG ==>> rooms');
    print(pd);
    return pd;
  }

  Future<void> outApp() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Salir'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('¿Está seguro de que desea salir de la app?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Salir'),
              onPressed: () {
                Navigator.pushNamed(context, '/');
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.exit_to_app,
                color: Color.fromARGB(255, 0, 0, 0),
                size: 35,
              ),
              onPressed: () {
                outApp();
              },
            );
          },
        ),
        title: const Text(
          "Listado de Habitaciones",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 20.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/create_rooms_adm');
              },
              child: Icon(
                Icons.add_home_work_rounded,
                color: Colors.lightBlue[300],
                size: 30,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 05, right: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 58),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: const Color.fromARGB(255, 255, 255, 255),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    filteredHabitaciones = habitaciones
                        .where((habitacion) => habitacion.typeRoom
                            .toLowerCase()
                            .contains(value.toLowerCase()))
                        .toList();
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'Buscar habitación por título',
                  icon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: habitaciones.isEmpty
                ? const Center(
                    child: Text(
                      'No hay habitaciones creadas. Comuníquese con el administrador.',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredHabitaciones.length,
                    itemBuilder: (context, index) {
                      return RoomCard(
                        room: filteredHabitaciones[index],
                        ruta: '/detail',
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  Future<void> deleteRoom(String id) async {
    final resp = await http
        .delete(Uri.parse("${Config.API_BASE}/rooms/delete_room/${id}"));

    print('GG ==>> room  delete');
    print(resp.statusCode);
    if (resp.statusCode == 204) {
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

  Future<void> dialogDeleteRoom(String id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('¿Está seguro de que desea eliminar esta habitación?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Eliminar'),
              onPressed: () {
                deleteRoom(id);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Room room = ModalRoute.of(context)!.settings.arguments as Room;
    return Scaffold(
      appBar: AppBar(
        title: Text(room.typeRoom),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.pushNamed(context, '/editar_rooms', arguments: {
                "description": room.descriptionRoom,
                "type": room.typeRoom,
                "capacity": room.capacityRoom,
                "precio": room.priceRoom,
                "id": room.roomId,
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              dialogDeleteRoom(room.roomId);
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Hero(
            tag: 'roomUrlImage${room.imageRoom}',
            child: Image.network(
              room.imageRoom,
              height: 250.0,
              width: double.infinity,
              fit: BoxFit.fitHeight,
            ),
          ),
          const SizedBox(height: 16.0),
          Text(
            room.typeRoom,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24.0,
            ),
          ),
          const SizedBox(height: 10.0),
          Text(
            room.descriptionRoom,
            style: TextStyle(fontSize: 16.0),
          ),
          const SizedBox(height: 10.0),
          Text(
            "Capacidad: ${room.capacityRoom} persona(s)",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
              color: Colors.cyan[900],
            ),
          ),
          const SizedBox(height: 10.0),
          Text(
            room.isAvailable ? 'Disponible' : 'No Disponible',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
              color: room.isAvailable
                  ? Colors.greenAccent[400]
                  : Colors.redAccent[400],
            ),
          ),
        ],
      ),
    );
  }
}
