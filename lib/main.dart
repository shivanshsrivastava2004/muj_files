import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:muj_files/Login.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:muj_files/SignUp.dart';
import 'package:muj_files/Home.dart';

const List<String> departmentList = <String>[
  'Purchase',
  'President',
  'Pro President',
  'Registrar',
  'Deputy Registrar',
  'HR',
  'Finance',
  'Admission',
  'Training & Placement',
  'Atal Incubation Center',
  'Outline Digital Learning',
  'Mechanical',
  'Automobiles',
  'Civil',
  'Electronics',
  'Electronics & Communications',
  'Mass Communication',
  'Arts',
  'Economics',
  'Maths',
  'Physics',
  'Bioscience',
  'Chemistry',
  'Mechatronics'
];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var empId = prefs.getString("empId");
  print(empId);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(primarySwatch: Colors.amber),
    home: empId == null || empId == ''
        ? MyApp()
        : Home(
            empId: empId,
          ),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => SignUp()));
                    },
                    child: Text('SignUp',
                        style: TextStyle(color: Colors.amber, fontSize: 20))),
                TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => Login()));
                    },
                    child: Text('Login',
                        style: TextStyle(color: Colors.amber, fontSize: 20)))
              ],
            )
          ],
        ),
      ),
    );
  }
}
