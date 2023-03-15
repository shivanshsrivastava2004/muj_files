import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class Outbox extends StatefulWidget {
  Outbox({Key? key, required this.department}) : super(key: key);
  final String department;

  @override
  State<Outbox> createState() => _OutboxState();
}

class _OutboxState extends State<Outbox> {
  final firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: firestore.collection("outbox_${widget.department}").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return !snapshot.hasData
              ? Text("Loading...")
              : ListView(children: getOutboxItems(snapshot));
        });
  }

  getOutboxItems(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data!.docs
        .map(
          (doc) => ListTile(
            title: Text(doc['fileTitle']),
            subtitle: Text('Forwarded to : ${doc['toDepartment'].toString()}'),
          ),
        )
        .toList();
  }
}
