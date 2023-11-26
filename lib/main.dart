import 'package:flutter/material.dart';
import 'package:hotel_movil_cuc/app/users/widgets/login.dart';
import 'package:hotel_movil_cuc/app/users/widgets/register.dart';
import 'package:hotel_movil_cuc/app/rooms/widgets/CreateRooms.dart';
import 'package:hotel_movil_cuc/app/rooms/widgets/editarRooms.dart';
import 'package:hotel_movil_cuc/app/bookings/widgets/createBook.dart';
import 'package:hotel_movil_cuc/app/bookings/widgets/editarBook.dart';
import 'package:hotel_movil_cuc/app/rooms/widgets/list_rooms.dart';

import 'package:hotel_movil_cuc/app/rooms/widgets/list_room_usur.dart';

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
        "/list_rooms_adm": (context) => const ListRooms(),
        "/list_rooms_user": (context) => const ListRooms_usu(),
        "/create_book_adm": (context) => const BookNow(),
        "/editar_books": (context) => const EditarBook(),
        "/create_rooms_adm": (context) => const CreateRooms(),
        "/editar_rooms": (context) => const EditarRooms(),
        "/detail": (context) => DetailScreen(),
        "/detail_user": (context) => DetailScreen_user(),
        "/Register": (context) => const Register(),
      },
    );
  }
}
