import 'package:flutter/material.dart';

class ListRooms extends StatefulWidget {
  const ListRooms({Key? key}) : super(key: key);

  @override
  State<ListRooms> createState() => _ListRoomsState();
}

class _ListRoomsState extends State<ListRooms> {
  final List<Room> habitaciones = [
    Room(
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
        urlImage:
            'https://s3.amazonaws.com/static-webstudio-accorhotels-usa-1.wp-ha.fastbooking.com/wp-content/uploads/sites/19/2022/01/06233739/DUF_7039-v-ok-1170x780.jpg'),
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
  final String urlImage;

  Room({
    required this.title,
    required this.description,
    required this.rating,
    required this.urlImage,
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
          Navigator.pushNamed(context, '/detail', arguments: room);
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                room.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                ),
                textAlign: TextAlign.center,
              ),
              Hero(
                  tag: 'roomUrlImage${room.urlImage}',
                  child: Image.network(room.urlImage)),
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

class DetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Room room = ModalRoute.of(context)!.settings.arguments as Room;
    return Scaffold(
      appBar: AppBar(
        title: Text(room.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.pushNamed(context, '/editar_rooms', arguments: room);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Hero(
                tag: 'roomTitle${room.title}',
                child: Image.network(room.urlImage)),
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
