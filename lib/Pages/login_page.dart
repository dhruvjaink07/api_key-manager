import 'package:apikey_manager/Pages/home_page.dart';
import 'package:apikey_manager/Pages/registration_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  // Function to handle Login
  Future<void> loginUser(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      print(userCredential.user?.email);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
    } catch (e) {
      print('Error: $e');
      // Handle other errors
    }
  }

  bool _obscureText = true;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height / 16,
                ),
                Container(
                    padding: const EdgeInsets.all(15),
                    margin: const EdgeInsets.all(15),
                    width: MediaQuery.of(context).size.width / 1.5,
                    child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome Back",
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w700,
                                color: Color.fromARGB(255, 218, 27, 252)),
                          ),
                          Text(
                            "Let's see where you left",
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w700,
                                color: Color.fromARGB(255, 218, 27, 252)),
                          ),
                        ])),
                Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height / 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Login to Key Securer",
                        style: TextStyle(
                            color: Color.fromARGB(255, 218, 27, 252),
                            fontSize: 20.5,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.94,
                        height: MediaQuery.of(context).size.height * 0.09,
                        // color: Colors.yellow,
                        child: TextField(
                          controller: email,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(color: Colors.grey.shade700),
                          decoration: InputDecoration(
                              filled: true,
                              fillColor:
                                  const Color.fromARGB(255, 250, 195, 253),
                              prefixIcon: const Icon(
                                Icons.email,
                                color: Colors.grey,
                              ),
                              labelText: "Email",
                              hintText: "Enter Email",
                              hintStyle: const TextStyle(color: Colors.white),
                              labelStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade400,
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.025),
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: MediaQuery.of(context).size.height *
                                      0.025,
                                  horizontal:
                                      MediaQuery.of(context).size.width *
                                          0.025),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      MediaQuery.of(context).size.width * 0.84),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade800,
                                    width: 3,
                                  )),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      MediaQuery.of(context).size.width * 0.84),
                                  borderSide: BorderSide(
                                      color: Colors.grey.shade600, width: 3))),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.94,
                        height: MediaQuery.of(context).size.height * 0.09,
                        // color: Colors.yellow,
                        child: TextField(
                          controller: password,
                          obscureText: _obscureText,
                          style: TextStyle(color: Colors.grey.shade700),
                          decoration: InputDecoration(
                              filled: true,
                              fillColor:
                                  const Color.fromARGB(255, 250, 195, 253),
                              prefixIcon: Icon(
                                Icons.password,
                                color: Colors.grey,
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                                icon: Icon(
                                  _obscureText
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              labelText: "Password",
                              hintText: "Enter Password",
                              hintStyle: const TextStyle(color: Colors.white),
                              labelStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade400,
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.025),
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: MediaQuery.of(context).size.height *
                                      0.025,
                                  horizontal:
                                      MediaQuery.of(context).size.width *
                                          0.025),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      MediaQuery.of(context).size.width * 0.84),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade800,
                                    width: 3,
                                  )),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      MediaQuery.of(context).size.width * 0.84),
                                  borderSide: BorderSide(
                                      color: Colors.grey.shade600, width: 3))),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 1.5,
                        child: ElevatedButton(
                            onPressed: () {
                              loginUser(email.text.toString(),
                                  password.text.toString());
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              elevation: 7,
                              enableFeedback: true,
                              enabledMouseCursor: MouseCursor.defer,
                            ),
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 218, 27, 252),
                              ),
                            )),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          height: 70,
          child: Center(
            child: InkWell(
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RegisterationPage()));
              },
              child: Text("New Here? SignUp Now",
                  style: TextStyle(
                      color: Color.fromARGB(255, 218, 27, 252), fontSize: 18)),
            ),
          ),
        ));
  }
}
