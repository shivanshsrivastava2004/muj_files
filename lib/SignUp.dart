import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:muj_files/Home.dart';
import 'main.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => SignUpState();
}

class SignUpState extends State<SignUp> {
  var nameController = TextEditingController();
  var empIdController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  var department = '';

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    Future<void> addUser() {
      // Call the user's CollectionReference to add a new user
      return users.doc(empIdController.text).set({
        'name': nameController.text,
        'password': passwordController.text,
        'email': emailController.text,
        'department': department
      }).then((value) async {
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setString("empId", empIdController.text);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => Home(
                      empId: empIdController.text,
                    )));
      }).catchError((error) => print("Failed to add user: $error"));
    }

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
                  Text('Sign Up',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 35,
                          color: Colors.amber)),
                  SizedBox(
                    height: 12,
                  ),
                  TextField(
                      controller: nameController,
                      autofocus: true,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter your name ')),
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
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      autofocus: true,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter your password ')),
                  SizedBox(height: 12),
                  TextField(
                      controller: emailController,
                      autofocus: true,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter your email ')),
                  SizedBox(
                    height: 12,
                  ),
                  DropdownSearch<String>(
                    items: departmentList,
                    onChanged: (value) {
                      setState(() {
                        department = value.toString();
                        print(department);
                      });
                    },
                    popupProps: PopupProps.menu(
                      showSelectedItems: true,
                      disabledItemFn: (String s) => s.startsWith('I'),
                    ),
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: const InputDecoration(
                        labelText: "Department",
                        hintText: "Search Department",
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextButton(
                      onPressed: () {
                        if (nameController.text != '' &&
                            empIdController.text != '' &&
                            emailController.text != '' &&
                            department != '') {
                          addUser();
                        }
                      },
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ))
                ],
              )),
        ));
  }
}
