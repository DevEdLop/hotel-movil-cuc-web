import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hotel_movil_cuc/config/config.dart';
import 'package:hotel_movil_cuc/models/users.dart';
import 'package:http/http.dart' as http;

class ListUsers extends StatefulWidget {
  const ListUsers({Key? key}) : super(key: key);
  @override
  State<ListUsers> createState() => _ListUsersState();
}

class _ListUsersState extends State<ListUsers> {
  List<User> userList = [];

  @override
  void initState() {
    super.initState();
    // Llamada a la API de Django para obtener la lista de usuarios
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse("${Config.API_BASE}/users"));
    print(response.statusCode);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        userList = data.map((user) => User.fromJson(user)).toList();
      });
    } else {
      throw Exception('Error al cargar la lista de usuarios');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Usuarios'),
      ),
      body: userList.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: userList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(userList[index].username),
                  subtitle: Text(userList[index].email),
                  // Puedes agregar más detalles según tus necesidades
                );
              },
            ),
    );
  }
}
