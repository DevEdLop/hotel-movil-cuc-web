import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hotel_movil_cuc/models/rooms.dart';
import 'package:hotel_movil_cuc/config/config.dart';
import 'package:http/http.dart' as http;

class ListRooms extends StatefulWidget {
  const ListRooms({Key? key}) : super(key: key);

  @override
  State<ListRooms> createState() => _ListRoomsState();
}

class _ListRoomsState extends State<ListRooms> {
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
    final resp = await http.get(Uri.parse("${Config.API_BASE}/rooms"));
    final items = json.decode(resp.body).cast<Map<String, dynamic>>();

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

  /* Room(
        title: 'Suite de Lujo',
        description: 'Una suite elegante con vistas impresionantes.',
        rating: '5 estrellas',
        urlImage:
            'https://st3.idealista.com/news/archivos/styles/fullwidth_xl/public/2018-08/suite-princesse-grace-3.jpg?VersionId=4GORgqRZX0hbzXsr3j7zn8Dn580DRqLn&itok=hoDo8M8x'),
    Room(
        title: 'Habitación Familiar',
        description: 'Perfecta para una estancia en familia.',
        rating: '4 estrellas',
        urlImage:
            'https://media.istockphoto.com/id/1209743499/es/foto/sonrisa-padres-e-hija-con-batas-blancas-pasando-la-ma%C3%B1ana-juntos-pap%C3%A1-y-el-ni%C3%B1o-est%C3%A1n-posando.jpg?s=612x612&w=0&k=20&c=-LWLKlw3C3ZEFW3vXvMH3PiYcmSjzqHTsVoZU3RLypg='),
    Room(
        title: 'Habitación Temática',
        description: 'Una experiencia única con decoración temática.',
        rating: '4.5 estrellas',
        urlImage:
            'https://i.pinimg.com/736x/0b/57/cd/0b57cd8a9885c14cac1cf714e2771658.jpg'),
    Room(
        title: 'Habitación Ejecutiva',
        description:
            'Ideal para viajes de negocios con comodidades ejecutivas.',
        rating: '4 estrellas',
        urlImage:
            'https://www.windsortower.com/wp-content/uploads/2015/04/DSC_7859.jpg'),
    Room(
        title: 'Suite Presidencial',
        description: 'La mejor habitación con servicios exclusivos.',
        rating: '5 estrellas',
        urlImage: 'https://s3.amazonaws.com/stati c-webstudio-accorhotels-usa-1.wp-ha.fastbooking.com/wp-content/uploads/sites/19/2022/01/06233739/DUF_7039-v-ok-1170x780.jpg'),
 */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 22, left: 05, right: 10),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
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
                ),
                const Text(
                  "Listado de Habitaciones",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 05, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/create_rooms_adm');
                  },
                  icon: const Icon(Icons.add),
                  tooltip: 'Agregar',
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 05, right: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
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
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class RoomCard extends StatelessWidget {
  final Room room;

  const RoomCard({
    Key? key,
    required this.room,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      margin: const EdgeInsets.all(20.0),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/detail', arguments: room);
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                room.typeRoom,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                ),
                textAlign: TextAlign.center,
              ),
              Hero(
                  tag: 'roomUrlImage${room.imageRoom}',
                  child: Image.network(room.imageRoom)),
              const SizedBox(height: 10.0),
              Text(
                room.descriptionRoom,
                style: const TextStyle(fontSize: 16.0),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10.0),
              Text(
                "capacidad: ${room.capacityRoom} persona(s)",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  color: Colors.blue,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
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
                "roomNumber": room.roomNumber,
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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Hero(
                tag: 'roomTitle${room.typeRoom}',
                child: Image.network(room.imageRoom)),
            const SizedBox(height: 10.0),
            Text(
              room.descriptionRoom,
              style: const TextStyle(fontSize: 16.0),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10.0),
            Text(
              "capacidad: ${room.capacityRoom} persona(s)",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                color: Colors.blue,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10.0),
            Text(
              "Precio por noche: ${room.priceRoom}",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18.0,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
