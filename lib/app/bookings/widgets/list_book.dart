import 'dart:convert';
import 'package:hotel_movil_cuc/config/myAppState.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:hotel_movil_cuc/models/bookings.dart';
import 'package:hotel_movil_cuc/config/config.dart';
import 'package:hotel_movil_cuc/models/users.dart';
import 'package:http/http.dart' as http;

class ListBookings extends StatefulWidget {
  const ListBookings({Key? key}) : super(key: key);

  @override
  State<ListBookings> createState() => _ListBookingsState();
}

class _ListBookingsState extends State<ListBookings> {
  User? currentUserLogin;
  List<Booking> filteredReservas = [];
  late TextEditingController _searchController;
  final List<Booking> reservas = [];

  @override
  void initState() {
    super.initState();
    getBookings();
    _searchController = TextEditingController();
  }

  void cargarInfo() {
    final currentUser = Provider.of<MyAppStateUser>(context).currentUser;
    if (currentUser != null) {
      setState(() {
        currentUserLogin = currentUser;
        print(currentUserLogin!.username);
      });
    }
  }

  Future<void> getBookings() async {
    final resp = await http.get(Uri.parse("${Config.API_BASE}/bookings"));
    final items = json.decode(resp.body).cast<Map<String, dynamic>>();

    List<Booking> pd = items.map<Booking>((json) {
      return Booking.fromJson(json);
    }).toList();
    setState(() {
      reservas.addAll(pd);
      filteredReservas = reservas;
    });
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
    cargarInfo();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Builder(
          builder: (BuildContext context) {
            return ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/list_rooms_user');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                elevation: 0,
              ),
              child: const Icon(
                Icons.subdirectory_arrow_left_sharp,
                color: Color.fromARGB(255, 0, 0, 0),
                size: 35,
              ),
            );
          },
        ),
        title: const Text(
          "Listado de Reservas",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
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
                    filteredReservas = reservas
                        .where((reservas) => reservas.ROOM
                            .toLowerCase()
                            .contains(value.toLowerCase()))
                        .toList();
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'Buscar reserva por numero de habitacion',
                  icon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: reservas.isEmpty
                ? const Center(
                    child: Text(
                      'No hay reservas creadas, aparte su habitacion.',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredReservas.length,
                    itemBuilder: (context, index) {
                      return BookingCard(
                        booking: filteredReservas[index],
                        userName: currentUserLogin?.username ?? 'Guest',
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class BookingCard extends StatelessWidget {
  final Booking booking;
  final String userName;

  const BookingCard({
    Key? key,
    required this.booking,
    required this.userName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      margin: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/detail_user', arguments: booking);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
              child: Image.network(
                'https://st3.idealista.com/news/archivos/styles/fullwidth_xl/public/2018-08/suite-princesse-grace-3.jpg?VersionId=4GORgqRZX0hbzXsr3j7zn8Dn580DRqLn&itok=hoDo8M8x', // Coloca aquí la URL de la imagen de la habitación si tienes una.
                height: 150.0,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Booking #${booking.ID}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Cliente: ${userName}',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    'Habitacion: ${booking.ROOM}',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    'Ingresa el: ${booking.CHECK_IN_DATE}',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    'Sale el: ${booking.CHECK_OUT_DATE}',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    'Numero de noches: ${booking.NUMBER_OF_NIGHTS}',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    'Total Precio: \$${booking.TOTAL_PRICE}',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailScreen_user extends StatefulWidget {
  const DetailScreen_user({super.key});

  @override
  State<DetailScreen_user> createState() => _DetailScreen_userState();
}

class _DetailScreen_userState extends State<DetailScreen_user> {
  Future<void> deleteBook(String id) async {
    final resp = await http
        .delete(Uri.parse("${Config.API_BASE}/bookings/delete_booking/${id}"));

    print('GG ==>> book  delete');
    print(resp.statusCode);
    if (resp.statusCode == 204) {
      Navigator.pushNamed(context, '/list_bookings');
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
                deleteBook(id);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Booking booking =
        ModalRoute.of(context)!.settings.arguments as Booking;
    return Scaffold(
      appBar: AppBar(
        title: Text("Booking # ${booking.ID}"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.pushNamed(context, '/editar_books', arguments: booking);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              dialogDeleteRoom(booking.ID);
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
              tag: 'roomID${booking.ID}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image.network(
                  'https://st3.idealista.com/news/archivos/styles/fullwidth_xl/public/2018-08/suite-princesse-grace-3.jpg?VersionId=4GORgqRZX0hbzXsr3j7zn8Dn580DRqLn&itok=hoDo8M8x',
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              "Habitacion: ${booking.ROOM}",
              style: const TextStyle(fontSize: 16.0),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10.0),
            Text(
              "Ingreso: ${booking.CHECK_IN_DATE}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                color: Colors.blue,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10.0),
            Text(
              "Salida: ${booking.CHECK_OUT_DATE}",
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
