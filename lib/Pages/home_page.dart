import 'dart:io';

import 'package:apikey_manager/Pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> logOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            if (Platform.isAndroid) {
              SystemNavigator.pop();
            } else if (Platform.isIOS) {
              exit(0);
            }
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color.fromARGB(
              255,
              218,
              27,
              252,
            ),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                _AddKeyDialog(context);
              },
              icon: const Icon(Icons.add_circle_outline_rounded,
                  color: Color.fromARGB(255, 218, 27, 255))),
          const SizedBox(
            width: 15,
          ),
          IconButton(
              onPressed: logOut,
              icon: const Icon(
                Icons.logout_rounded,
                color: Color.fromARGB(
                  255,
                  218,
                  27,
                  252,
                ),
              )),
        ],
        elevation: 5,
      ),
      body: Container(),
    );
  }
}

Future<void> _AddKeyDialog(BuildContext context) {
  TextEditingController API_NAME = TextEditingController();
  TextEditingController API_KEY = TextEditingController();
  void clearText() {
    API_KEY.clear();
    API_NAME.clear();
  }

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Add Your API Key'),
        content: Container(
          height: MediaQuery.of(context).size.height / 5.5,
          width: MediaQuery.of(context).size.width / 1.2,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: API_NAME,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    hintText: "Github API",
                    hintStyle: const TextStyle(color: Colors.grey),
                    label: const Text(
                      "API Name",
                      style: TextStyle(fontSize: 15),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(3))),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: API_KEY,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    hintText: "bgx0......",
                    hintStyle: const TextStyle(color: Colors.grey),
                    label: const Text(
                      "API Key",
                      style: TextStyle(fontSize: 15),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(3))),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text(
              'Clear',
              style: TextStyle(
                  color: Color.fromARGB(255, 218, 27, 252),
                  fontSize: 15,
                  fontWeight: FontWeight.w500),
            ),
            onPressed: clearText,
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text(
              'Add',
              style: TextStyle(
                  color: Color.fromARGB(255, 218, 27, 252),
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
