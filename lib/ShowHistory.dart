import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ShowHistory extends StatelessWidget {
  ShowHistory({Key? key, required this.fileTitle}) : super(key: key);
  final String fileTitle;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("outbox_${fileTitle}")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return !snapshot.hasData
              ? Text("Loading...")
              : ListView(children: getHistory(snapshot));
        });
  }

  getHistory(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data!.docs
        .map(
          (doc) => ListTile(
            title: Text(doc['department']),
            subtitle: Text('On :  ${doc['date'].toString()}'),
          ),
        )
        .toList();
  }
}
