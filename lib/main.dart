import 'package:flutter/material.dart';
import 'package:hotel_movil_cuc/app/bookings/widgets/list_book.dart';
import 'package:hotel_movil_cuc/app/users/widgets/login.dart';
import 'package:hotel_movil_cuc/app/users/widgets/register.dart';
import 'package:hotel_movil_cuc/app/rooms/widgets/CreateRooms.dart';
import 'package:hotel_movil_cuc/app/rooms/widgets/editarRooms.dart';
import 'package:hotel_movil_cuc/app/bookings/widgets/createBook.dart';
import 'package:hotel_movil_cuc/app/bookings/widgets/editarBook.dart';
import 'package:hotel_movil_cuc/app/rooms/widgets/list_rooms.dart';

import 'package:hotel_movil_cuc/app/rooms/widgets/list_room_usur.dart';
import 'package:hotel_movil_cuc/config/my_app_state.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => MyAppStateUser()),
      // Otros Providers, si los tienes
    ], child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hotel movil CUC',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => const Login(),
        "/list_rooms_adm": (context) => const ListRooms(),
        "/list_rooms_user": (context) => const ListRooms_usu(),
        "/list_bookings": (context) => const ListBookings(),
        "/create_books": (context) => const BookNow(),
        "/editar_books": (context) => const EditarBook(),
        "/create_rooms_adm": (context) => const CreateRooms(),
        "/editar_rooms": (context) => const EditarRooms(),
        "/detail": (context) => const DetailScreen(),
        "/detail_user": (context) => const DetailScreen_user(),
        "/Register": (context) => const Register(),
      },
    );
  }
}
