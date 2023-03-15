import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CreatedFiles extends StatefulWidget {
  CreatedFiles({Key? key, required this.empId}) : super(key: key);
  final String empId;

  @override
  State<CreatedFiles> createState() => _CreatedFilesState();
}

class _CreatedFilesState extends State<CreatedFiles> {
  final firestore = FirebaseFirestore.instance;
  List data = [];
  var currentDepartment = '';

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder<QuerySnapshot>(
        stream: firestore.collection("created_${widget.empId}").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return !snapshot.hasData
              ? Text("Loading ...")
              : ListView(children: getInboxItems(snapshot));
        });
  }

  getInboxItems(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data!.docs.map(
      (doc) {
        firestore
            .collection('files')
            .where('fileTitle', isEqualTo: doc['fileTitle'])
            .get()
            .then((value) {
          for (var docRef in value.docs) {
            currentDepartment = docRef['currentDepartment'];
          }
          setState(() {
            currentDepartment;
          });
        });

        return ListTile(
          trailing: Text('Current Department : ${currentDepartment}'),
          title: Text(doc['fileTitle']),
          subtitle: Text(doc['createdDate'].toString()),
        );
      },
    ).toList();
  }
}
