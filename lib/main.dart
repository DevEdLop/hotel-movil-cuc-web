import 'package:flutter/material.dart';
import 'package:hotel_movil_cuc/app/users/widgets/list_users.dart';
import 'package:hotel_movil_cuc/app/users/widgets/login.dart';
import 'package:hotel_movil_cuc/app/users/widgets/register.dart';
import 'package:hotel_movil_cuc/app/rooms/widgets/CreateRooms.dart';
import 'package:hotel_movil_cuc/app/bookings/widgets/createBook.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => const Login(),
        "/create_book": (context) => const BookNow(),
        "/create_rooms": (context) => const CreateRooms(),
        "/Register": (context) => const Register(),
      },
    );
  }
}
