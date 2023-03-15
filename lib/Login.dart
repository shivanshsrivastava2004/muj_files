import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:muj_files/Home.dart';
import 'main.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => LoginState();
}

class LoginState extends State<Login> {
  var empIdController = TextEditingController();
  var passwordController = TextEditingController();

  var pwd = '';

  checkUserCredentials() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(empIdController.text)
        .get()
        .then((doc) {
      setState(() {
        pwd = doc['password'];
      });
    });

    if (pwd == passwordController.text) {
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString("empId", empIdController.text);
      return Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  Home(empId: empIdController.text)));
    } else {
      return showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: Text('Invalid Credentials !'),
                content: Text('Please enter valid credentials and Try again !'),
                actions: [
                  TextButton(
                      onPressed: () {
                        setState(() {
                          empIdController.text = '';
                          passwordController.text = '';
                          Navigator.pop(context);
                        });
                      },
                      child: Text(
                        'Ok',
                        style: TextStyle(color: Colors.amber),
                      ))
                ],
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('MUJ Files'),
          centerTitle: true,
          backgroundColor: Colors.amber,
        ),
        body: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Login',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 35,
                          color: Colors.amber)),
                  SizedBox(
                    height: 12,
                  ),
                  TextField(
                      controller: empIdController,
                      autofocus: true,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter your Employee ID ')),
                  SizedBox(
                    height: 12,
                  ),
                  TextField(
                      controller: passwordController,
                      autofocus: true,
                      obscureText: true,
                      autocorrect: false,
                      enableSuggestions: false,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter your password ')),
                  SizedBox(
                    height: 12,
                  ),
                  SizedBox(height: 20),
                  TextButton(
                      onPressed: () async {
                        if (empIdController.text != '' &&
                            passwordController.text != '') {
                          await checkUserCredentials();
                        }
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(
                            color: Colors.amber,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ))
                ],
              )),
        ));
  }
}
