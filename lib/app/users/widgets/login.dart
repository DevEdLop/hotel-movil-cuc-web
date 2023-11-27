import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hotel_movil_cuc/config/config.dart';
import 'package:hotel_movil_cuc/models/users.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  List<User> userList = [];

  @override
  void initState() {
    super.initState();
    // Llamada a la API de Django para obtener la lista de usuarios
    fetchData();
  }

  Future<void> fetchData() async {
    print("${Config.API_BASE}/users");
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

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    print("${Config.API_BASE}/users/login");
    final url = Uri.parse("${Config.API_BASE}/users/login");
    print('GG');
    final response = await http.post(
      url,
      // headers: headers,
      body: {
        'email': email,
        'password': password,
      },
    );
    print(response.statusCode);

    User? currentUser = userList.firstWhere((user) => user.email == email);
    print('Is admin');
    print(currentUser.isAdmin);

    if (email.isEmpty || password.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Datos sin diligenciar'),
          content: const Text(
              'No se puede ingresar sin llenar los campos de email address y password.'),
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
    } else if (response.statusCode == 200) {
      if (currentUser.isAdmin) {
        Navigator.pushNamed(context, '/list_rooms_adm');
      } else {
        Navigator.pushNamed(context, '/list_rooms_user');
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error servidor'),
          content: const Text(
              'No se puede ingresar verifique las credenciales o cree una cuenta'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.blue, Color.fromARGB(255, 54, 53, 53)])),
              child: const Padding(
                padding: EdgeInsets.only(top: 60, left: 22),
                child: Text(
                  "Welcome\nBack",
                  style: TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 250),
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50)),
                  color: Colors.white,
                ),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.only(left: 18, right: 18, top: 50),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                            suffixIcon: Icon(
                              Icons.abc,
                            ),
                            label: Text(
                              "Email Address",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue),
                            )),
                      ),
                      TextField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                            suffixIcon: Icon(
                              Icons.visibility_off,
                            ),
                            label: Text(
                              "Password",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue),
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/Register');
                          },
                          child: const Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "Crear una cuenta",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      Padding(
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
                              login();
                            },
                            child: const Center(
                              child: Text(
                                "Sign in",
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
                    ],
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    ));
  }
}
