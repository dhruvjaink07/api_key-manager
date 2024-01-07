import 'dart:io';
import 'dart:convert';
import 'package:apikey_manager/Pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController API_NAME = TextEditingController();
  TextEditingController API_KEY = TextEditingController();
  final List<ApiMap> keys = [];

  @override
  Widget build(BuildContext context) {
    // Debug statement
    print('Keys List: ${keys.map((apiMap) => apiMap.toJson()).toList()}');

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
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
                  _AddKeyDialog(context, API_NAME, API_KEY);
                },
                icon: const Icon(
                  Icons.add_circle_outline_rounded,
                  color: Color.fromARGB(255, 218, 27, 255),
                ),
              ),
              const SizedBox(width: 15),
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
                ),
              ),
            ],
            elevation: 5,
          ),
          body: Container(
            child: ListView.builder(
              itemCount: keys.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildCard(keys[index].apiName, keys[index].apiKey);
              },
            ),
          ),
        );
      },
    );
  }

  // Function to log out
  Future<void> logOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  // Function to build a card widget
  Widget _buildCard(String apiName, String apiKey) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple, Colors.purpleAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
      ),
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  apiName,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    shadows: [
                      Shadow(
                        color: Colors.grey,
                        offset: Offset(1, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  apiKey,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    shadows: [
                      Shadow(
                        color: Colors.grey,
                        offset: Offset(1, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 8),
            child: IconButton(
              onPressed: () {
                // Handle copy button action
                Clipboard.setData(ClipboardData(text: apiKey));
              },
              icon: const Icon(Icons.copy),
            ),
          ),
        ],
      ),
    );
  }

  // Function to show add key dialog
  Future<void> _AddKeyDialog(
    BuildContext context,
    TextEditingController ed1,
    TextEditingController ed2,
  ) async {
    void clearText() {
      ed1.clear();
      ed2.clear();
    }

    // Function to store the key
    void storeKey() {
      ApiMap apiMap = ApiMap(apiKey: ed2.text, apiName: ed1.text);
      String apiMapJson = jsonEncode(apiMap.toJson());
      setState(() {
        keys.insert(0, apiMap);
      });
      clearText();
      // Debug statement
      print('API Map JSON: $apiMapJson');
      print(
          'Keys List after adding: ${keys.map((apiMap) => apiMap.toJson()).toList()}');
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: ed1,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: "Github API",
                    hintStyle: const TextStyle(color: Colors.grey),
                    label: const Text(
                      "API Name",
                      style: TextStyle(fontSize: 15),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(3)),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: ed2,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: "bgx0......",
                    hintStyle: const TextStyle(color: Colors.grey),
                    label: const Text(
                      "API Key",
                      style: TextStyle(fontSize: 15),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(3)),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: clearText,
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text(
                'Clear',
                style: TextStyle(
                  color: Color.fromARGB(255, 218, 27, 252),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                storeKey();
              },
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text(
                'Add',
                style: TextStyle(
                  color: Color.fromARGB(255, 218, 27, 252),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class ApiMap {
  final String apiName;
  final String apiKey;

  ApiMap({
    required this.apiName,
    required this.apiKey,
  });

  // Method to convert instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'apiName': apiName,
      'apiKey': apiKey,
    };
  }
}
