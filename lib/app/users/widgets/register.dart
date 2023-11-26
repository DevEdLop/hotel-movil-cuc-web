import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
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
                      const TextField(
                        decoration: InputDecoration(
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
                      const TextField(
                        decoration: InputDecoration(
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
                      const TextField(
                        decoration: InputDecoration(
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
                      const TextField(
                        decoration: InputDecoration(
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
                      const TextField(
                        decoration: InputDecoration(
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
                            // Navegar a la ruta "register" cuando se toque "Create Account"
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
                              // Navegar a la ruta "CreateBook"
                              Navigator.pushNamed(context, '/create_book');
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
