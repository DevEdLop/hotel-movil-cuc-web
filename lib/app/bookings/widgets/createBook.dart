import 'package:hotel_movil_cuc/config/my_app_state.dart';
import 'package:hotel_movil_cuc/models/users.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:hotel_movil_cuc/models/rooms.dart';
import 'package:http/http.dart' as http;

class BookNow extends StatefulWidget {
  const BookNow({Key? key}) : super(key: key);

  @override
  State<BookNow> createState() => _BookNowState();
}

class _BookNowState extends State<BookNow> {
  Room? selectedRoom;
  User? currentUserLogin;
  DateTime? selectedDate;
  DateTime? selectedDateini;
  int numberOfNights = 1;

  void cargarInfo(Room room) {
    print(room);
    print('runnebale');
    final currentUser = Provider.of<MyAppStateUser>(context).currentUser;
    setState(() {
      selectedRoom = room;
      currentUserLogin = currentUser;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
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

  Future<void> _selectDateEntra(BuildContext context) async {
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

  int calculateNights(DateTime checkIn, DateTime checkOut) {
    final difference = checkOut.difference(checkIn);
    return difference.inDays.abs();
  }

  double calculateTotalPrice() {
    if (selectedDate != null && selectedDateini != null) {
      final numberOfNights = calculateNights(selectedDateini!, selectedDate!);
      if (numberOfNights > 0) {
        final double price = double.parse(selectedRoom!.priceRoom);
        return numberOfNights * price;
      }
    }
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    Room? arg = ModalRoute.of(context)?.settings.arguments as Room?;
    if (arg != null) {
      cargarInfo(arg);
    } else {
      // Handle the case where arguments are null
    }
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
                    "Book Now",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                "Booking number:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter booking number",
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Check in date:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () => _selectDate(context),
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
                onPressed: () => _selectDateEntra(context),
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
                    text: calculateNights(selectedDateini!, selectedDate!)
                        .toString()),
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
                        colors: [Colors.blue, Color.fromARGB(255, 54, 53, 53)],
                      ),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/editar_books');
                      },
                      child: const Center(
                        child: Text(
                          "Book Now",
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
      ],
    ));
  }
}
