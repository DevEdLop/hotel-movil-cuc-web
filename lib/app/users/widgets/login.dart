import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
                      const TextField(
                        decoration: InputDecoration(
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
                              Navigator.pushNamed(context, '/create_book');
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
