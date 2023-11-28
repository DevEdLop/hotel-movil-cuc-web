import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hotel_movil_cuc/design/room_card.dart';
import 'package:hotel_movil_cuc/models/rooms.dart';
import 'package:hotel_movil_cuc/config/config.dart';
import 'package:http/http.dart' as http;

class ListRooms_usu extends StatefulWidget {
  const ListRooms_usu({Key? key}) : super(key: key);

  @override
  State<ListRooms_usu> createState() => _ListRooms_usuState();
}

class _ListRooms_usuState extends State<ListRooms_usu> {
  late Future<List<Room>> listaProductos;
  List<Room> filteredHabitaciones = [];
  late TextEditingController _searchController;
  final List<Room> habitaciones = [];

  @override
  void initState() {
    super.initState();
    listaProductos = getRooms();
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
                Navigator.pushNamed(context, '/list_bookings');
              },
              child: Icon(
                Icons.table_view_rounded,
                color: Colors.lightBlue[300],
                size: 35,
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
                        ruta: '/create_books',
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
