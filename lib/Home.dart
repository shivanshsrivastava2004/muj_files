import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:muj_files/Inbox.dart';
import 'package:muj_files/Outbox.dart';
import 'package:muj_files/CreatedFiles.dart';
import 'package:muj_files/main.dart';
import 'CreateFile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:muj_files/ShowAllFiles.dart';

class Home extends StatefulWidget {
  Home({Key? key, required this.empId}) : super(key: key);
  final String empId;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final firestore = FirebaseFirestore.instance;

  var department = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            actions: [
              IconButton(
                onPressed: () async {
                  SharedPreferences pref =
                      await SharedPreferences.getInstance();
                  pref.setString("empId", '');
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => MyApp()));
                },
                icon: Icon(Icons.logout_outlined),
                tooltip: 'Logout',
              )
            ],
            title: Text('Home'),
            centerTitle: true,
            backgroundColor: Colors.amber),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => CreateFile(
                          empId: widget.empId,
                          userDepartment: department,
                        )));
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          hoverColor: Colors.black,
          backgroundColor: Colors.amber,
        ),
        body: FutureBuilder<DocumentSnapshot>(
          future: firestore.collection('users').doc(widget.empId).get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong");
            }

            if (snapshot.hasData && !snapshot.data!.exists) {
              return Text("Document does not exist");
            }

            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;
              department = data['department'];
              return HomeScreen(
                department: department,
                empId: widget.empId,
              );
            }

            return Text("loading");
          },
        ));
  }
}

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key, required this.department, required this.empId})
      : super(key: key);
  final String department;
  final String empId;

  @override
  Widget build(BuildContext context) {
    return ContainedTabBarView(
      tabs: [
        Text('Created Files',
            style: TextStyle(color: Colors.amber, fontSize: 16)),
        Text('Inbox', style: TextStyle(color: Colors.amber, fontSize: 16)),
        Text('OutBox', style: TextStyle(color: Colors.amber, fontSize: 16)),
        Text('All Files', style: TextStyle(color: Colors.amber, fontSize: 16))
      ],
      views: [
        CreatedFiles(empId: empId),
        Inbox(
          department: department,
        ),
        Outbox(
          department: department,
        ),
        AllFiles()
      ],
    );
  }
}
