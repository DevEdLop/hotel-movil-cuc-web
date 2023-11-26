import 'package:flutter/material.dart';

class ListRooms_usu extends StatefulWidget {
  const ListRooms_usu({Key? key}) : super(key: key);

  @override
  State<ListRooms_usu> createState() => _ListRooms_usuState();
}

class _ListRooms_usuState extends State<ListRooms_usu> {
  final List<Room> habitaciones = [
    Room(
      title: 'Suite de Lujo',
      description: 'Una suite elegante con vistas impresionantes.',
      rating: '5 estrellas',
    ),
    Room(
      title: 'Habitación Familiar',
      description: 'Perfecta para una estancia en familia.',
      rating: '4 estrellas',
    ),
    Room(
      title: 'Habitación Temática',
      description: 'Una experiencia única con decoración temática.',
      rating: '4.5 estrellas',
    ),
    Room(
      title: 'Habitación Ejecutiva',
      description: 'Ideal para viajes de negocios con comodidades ejecutivas.',
      rating: '4 estrellas',
    ),
    Room(
      title: 'Suite Presidencial',
      description: 'La mejor habitación con servicios exclusivos.',
      rating: '5 estrellas',
    ),
  ];

  late TextEditingController _searchController;
  List<Room> filteredHabitaciones = [];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    filteredHabitaciones = habitaciones;
  }

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
                        .where((habitacion) => habitacion.title
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
            child: ListView.builder(
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

class Room {
  final String title;
  final String description;
  final String rating;

  Room({
    required this.title,
    required this.description,
    required this.rating,
  });
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
          Navigator.pushNamed(context, '/detail_user', arguments: room);
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Hero(
                tag: 'roomTitle${room.title}',
                child: Text(
                  room.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 10.0),
              Text(
                room.description,
                style: const TextStyle(fontSize: 16.0),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10.0),
              Text(
                room.rating,
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

class DetailScreen_user extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Room room = ModalRoute.of(context)!.settings.arguments as Room;
    return Scaffold(
      appBar: AppBar(
        title: Text(room.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Hero(
              tag: 'roomTitle${room.title}',
              child: Text(
                room.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              room.description,
              style: const TextStyle(fontSize: 16.0),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10.0),
            Text(
              room.rating,
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
    );
  }
}
