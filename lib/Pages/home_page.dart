import 'dart:io';
import 'dart:convert';
import 'package:apikey_manager/Pages/APICard.dart';
import 'package:apikey_manager/Pages/ApiMap.dart';
import 'package:apikey_manager/Pages/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  void storeKeysInFireStore(List<ApiMap> keys) async {
    try {
      // Get current User's ID
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Reference User to Document's Database
      DocumentReference userDocument =
          FirebaseFirestore.instance.collection("users").doc(userId);

      // Converts the Keys list to Map
      List<Map<String, dynamic>> keysData =
          keys.map((apiMap) => apiMap.toJson()).toList();

      // Update user document
      await userDocument.set(
          {"keys": FieldValue.arrayUnion(keysData)}, SetOptions(merge: true));
    } catch (e) {
      print("Error is " + e.toString());
    }
  }

  void readKeysData() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;

      DocumentReference userDocs =
          FirebaseFirestore.instance.collection("users").doc(userId);

      DocumentSnapshot dataSnapshot = await userDocs.get();

      if (dataSnapshot.exists) {
        Map<String, dynamic> apiData =
            dataSnapshot.data() as Map<String, dynamic>;

        List<Map<String, dynamic>> keysData = (apiData['keys'] as List<dynamic>)
            .map((item) => item as Map<String, dynamic>)
            .toList();

        print('API Data from Firestore: $apiData');
        print('Keys Data from Firestore: $keysData');

        setState(() {
          keys.clear(); // Clear the existing keys
          keys.addAll(keysData.map((map) => ApiMap.fromJson(map)));
        });

        print(
            'Keys List after updating: ${keys.map((apiMap) => apiMap.toJson()).toList()}');
      } else {
        print('Document does not exist for user: $userId');
      }
    } catch (e) {
      print("Error in readKeysData: $e");
    }
  }

// Modify initState to call the updated method
  @override
  void initState() {
    super.initState();
    readKeysData();
  }

  @override
  Widget build(BuildContext context) {
    // Debug statement

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
                return APICard(
                    apiName: keys[index].apiName, apiKey: keys[index].apiKey);
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
    Future<void> storeKey() async {
      if (FirebaseAuth.instance.currentUser != null) {
        // Proceed to store data
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

        // Call Firestore function to store data and wait for completion
        storeKeysInFireStore([apiMap]); // Pass only the newly added key
        Navigator.of(context).pop();
      } else {
        print('User is not authenticated.');
        // You may want to handle this case, e.g., show an error message.
      }
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
                      borderRadius: BorderRadius.circular(3),
                    ),
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
                      borderRadius: BorderRadius.circular(3),
                    ),
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
              onPressed: () async {
                await storeKey(); // Await the completion of storeKey
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
