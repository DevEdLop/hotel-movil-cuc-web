import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hotel_movil_cuc/config/config.dart';
import 'package:hotel_movil_cuc/config/myAppState.dart';
import 'package:hotel_movil_cuc/models/bookings.dart';
import 'package:provider/provider.dart';
import 'package:hotel_movil_cuc/models/rooms.dart';
import 'package:hotel_movil_cuc/models/users.dart';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;

class EditarBook extends StatefulWidget {
  const EditarBook({Key? key}) : super(key: key);

  @override
  State<EditarBook> createState() => _EditarBookState();
}

class _EditarBookState extends State<EditarBook> {
  Room? validateRoom;
  Booking? selectedBooking;
  User? currentUserLogin;
  DateTime? selectedDate;
  DateTime? selectedDateini;
  double totalPrice = 0.0;

  @override
  void initState() {
    super.initState();
    getRooms();
  }

  void cargarInfo(dynamic book) {
    final currentUser = Provider.of<MyAppStateUser>(context).currentUser;
    setState(() {
      selectedBooking = book;
      currentUserLogin = currentUser;
    });
  }

  Future<void> getRooms() async {
    final resp = await http.get(
      Uri.parse("${Config.API_BASE}/rooms"),
      headers: {'Content-Type': 'application/json; charset=utf-8'},
    );

    final decodedBody = utf8.decode(resp.bodyBytes);
    final items = json.decode(decodedBody).cast<Map<String, dynamic>>();

    print('VALUE ROOOOOMS');
    print(items);

    List<Room> pd = items.map<Room>((json) {
      return Room.fromJson(json);
    }).toList();

    validateRoom =
        pd.firstWhere((room) => room.roomId == selectedBooking!.ROOM);
    print(validateRoom!.typeRoom);

    // setState(() {});
  }

  Future<void> _selectDateOut(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        selectedDateini = picked;
      });
    }
  }

  Future<void> _selectDateIn(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  int calculateNights(DateTime checkIn, DateTime checkOut) {
    final difference = checkOut.difference(checkIn);
    return difference.inDays.abs();
  }

  String formatDate(DateTime date) {
    final formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(date);
  }

  double calculateTotalPrice() {
    if (selectedDate != null && selectedDateini != null) {
      final numberOfNights = calculateNights(selectedDateini!, selectedDate!);
      if (numberOfNights > 0) {
        final double price = double.parse(validateRoom!.priceRoom);
        totalPrice = numberOfNights * price;
        return totalPrice;
      }
    }
    return 0.0;
  }

  Future<void> editBook() async {
    print("${Config.API_BASE}/bookings/update_booking/${selectedBooking!.ID}");
    final url = Uri.parse(
        "${Config.API_BASE}/bookings/update_booking/${selectedBooking!.ID}");

    final body = {
      'check_in_date': formatDate(selectedDate ?? DateTime.now()),
      'check_out_date': formatDate(selectedDateini ?? DateTime.now()),
      'number_of_nights':
          calculateNights(selectedDateini!, selectedDate!).toString(),
      'total_price': totalPrice.toString()
    };
    print('GG => book editada');
    print(body);
    final response = await http.put(
      url,
      body: body,
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      print('call me negra');
      print(response.statusCode == 200);
      Navigator.pushNamed(context, '/list_rooms_user');
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

  Future<void> validateEditBooking() async {
    if (selectedDateini == null || selectedDate == null) {
      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Datos sin diligenciar'),
          content: const Text('seleccione un rango de fecha'),
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
    } else {
      editBook();
    }
  }

  @override
  Widget build(BuildContext context) {
    Booking? arg = ModalRoute.of(context)?.settings.arguments as Booking;
    cargarInfo(arg);

    return Scaffold(
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 40,
                ),
                Row(
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
                    ),
                    const Text(
                      "Edit Book",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Check in date:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () => _selectDateIn(context),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Select date',
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          selectedDate != null
                              ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
                              : 'Select date',
                        ),
                        const Icon(Icons.calendar_today),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Check out date:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () => _selectDateOut(context),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Select date',
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          selectedDateini != null
                              ? "${selectedDateini!.day}/${selectedDateini!.month}/${selectedDateini!.year}"
                              : 'Select date',
                        ),
                        const Icon(Icons.calendar_today),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Number of nights:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  enabled: false,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "0",
                  ),
                  controller: TextEditingController(
                      text: (selectedDate != null && selectedDateini != null)
                          ? calculateNights(selectedDateini!, selectedDate!)
                              .toString()
                          : '0'),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Total Price:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  enabled: false,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "0",
                  ),
                  controller: TextEditingController(
                      text: calculateTotalPrice().toString()),
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
                          validateEditBooking();
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
                ),
                const SizedBox(
                  height: 20,
                ),
                Image.network(
                  'https://st3.idealista.com/news/archivos/styles/fullwidth_xl/public/2018-08/suite-princesse-grace-3.jpg?VersionId=4GORgqRZX0hbzXsr3j7zn8Dn580DRqLn&itok=hoDo8M8x', // Reemplaza esto con la URL de la imagen del hotel
                  width: double.infinity,
                  height:
                      200, // Ajusta la altura de la imagen según tus necesidades
                  fit: BoxFit.cover,
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
