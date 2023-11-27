import 'package:flutter/material.dart';
import 'package:hotel_movil_cuc/config/config.dart';
import 'package:http/http.dart' as http;

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  Future<void> register() async {
    String username = _usernameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String firstName = _firstNameController.text.trim();
    String lastName = _lastNameController.text.trim();

    final Map<String, String> headers = {
      'authorization': Config.API_BASE,
      'Content-Type': 'application/x-www-form-urlencoded'
    };

    print("${Config.API_BASE}/users/register");
    final url = Uri.parse("${Config.API_BASE}/users/register");
    print('GG => register');
    final body = {
      'username': username,
      'email': email,
      'password': password,
      'first_name': firstName,
      'last_name': lastName
    };
    print('=>> body');
    print(body);
    final response = await http.post(
      url,
      headers: headers,
      body: body,
    );
    print(response.statusCode);

    if (email.isEmpty ||
        password.isEmpty ||
        username.isEmpty ||
        firstName.isEmpty ||
        lastName.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Datos sin diligenciar'),
          content: const Text('todos los campos son obligatorios'),
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
    } else if (response.statusCode == 201) {
      print('call me negra');
      print(response.statusCode == 201);
      Navigator.pushNamed(context, '/');
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
                padding: EdgeInsets.only(top: 120, left: 22),
                child: Text(
                  "Registrate",
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
                        controller: _usernameController,
                        decoration: const InputDecoration(
                            suffixIcon: Icon(
                              Icons.abc,
                            ),
                            label: Text(
                              "Username",
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
                      TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                            suffixIcon: Icon(
                              Icons.attach_email_outlined,
                            ),
                            label: Text(
                              "Email",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue),
                            )),
                      ),
                      TextField(
                        controller: _firstNameController,
                        decoration: const InputDecoration(
                            suffixIcon: Icon(
                              Icons.abc,
                            ),
                            label: Text(
                              "First name",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue),
                            )),
                      ),
                      TextField(
                        controller: _lastNameController,
                        decoration: const InputDecoration(
                            suffixIcon: Icon(
                              Icons.abc,
                            ),
                            label: Text(
                              "Last name",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue),
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: GestureDetector(
                          onTap: () {
                            // Navegar a la ruta "login" cuando se toque "Create Account"
                            Navigator.pushNamed(context, '/');
                          },
                          child: const Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "¿Ya tienes cuenta?",
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
                              register();
                            },
                            child: const Center(
                              child: Text(
                                "Sign up",
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
