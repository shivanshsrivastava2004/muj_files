import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:muj_files/ShowHistory.dart';

class AllFiles extends StatefulWidget {
  const AllFiles({super.key});

  @override
  State<AllFiles> createState() => _AllFilesState();
}

class _AllFilesState extends State<AllFiles> {
  final firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return ContainedTabBarView(tabs: [
      Text('Under Process',
          style: TextStyle(color: Colors.amber, fontSize: 16)),
      Text('Completed', style: TextStyle(color: Colors.amber, fontSize: 16)),
    ], views: [
      StreamBuilder<QuerySnapshot>(
          stream: firestore
              .collection("files")
              .where('status', isEqualTo: 'under_process')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            return !snapshot.hasData
                ? Text("Loading ...")
                : ListView(children: getAllFiles(snapshot));
          }),
      StreamBuilder<QuerySnapshot>(
          stream: firestore
              .collection("files")
              .where('status', isEqualTo: 'completed')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            return !snapshot.hasData
                ? Text("Loading ...")
                : ListView(children: getAllFiles(snapshot));
          }),
    ]);
  }

  getAllFiles(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data!.docs.map(
      (doc) {
        return ListTile(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        ShowHistory(fileTitle: doc['fileTitle'])));
          },
          trailing: Text('Status: ${doc['status']}'),
          title: Text(doc['fileTitle']),
          subtitle: Text(
              'Created Date :${doc['createdDate'].toDate().toString()} Department : ${doc['currentDepartment']}'),
        );
      },
    ).toList();
  }
}
