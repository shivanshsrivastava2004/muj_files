import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

class Inbox extends StatefulWidget {
  Inbox({Key? key, required this.department}) : super(key: key);
  final String department;

  @override
  State<Inbox> createState() => _InboxState();
}

class _InboxState extends State<Inbox> {
  final firestore = FirebaseFirestore.instance;
  var department = '';
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: firestore.collection("inbox_${widget.department}").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return !snapshot.hasData
              ? Text("Loading...")
              : ListView(children: getInboxItems(snapshot));
        });
  }

  getInboxItems(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data!.docs
        .map(
          (doc) => ListTile(
              onTap: () async {
                await Clipboard.setData(ClipboardData(text: doc.id));
              },
              title: Text(doc['fileTitle']),
              subtitle: Text('File Id : ${doc.id} '),
              trailing: ForwardBtn(doc),
              leading: IconButton(
                onPressed: () {
                  firestore
                      .collection('files')
                      .where('fileTitle', isEqualTo: doc['fileTitle'])
                      .get()
                      .then((querySnapshot) => {
                            for (var docSnapshot in querySnapshot.docs)
                              {
                                firestore
                                    .collection('files')
                                    .doc(docSnapshot.id)
                                    .update({
                                  'status': 'completed',
                                  'currentDepartment': 'shelf',
                                })
                              }
                          })
                      .catchError((error) => print(error));
                  firestore
                      .collection('inbox_${widget.department}')
                      .doc(doc.id)
                      .delete();
                },
                icon: Icon(
                  Icons.check,
                  color: Colors.green,
                ),
                tooltip: 'Shelf The file !',
              )),
        )
        .toList();
  }

  IconButton ForwardBtn(QueryDocumentSnapshot<Object?> doc) {
    return IconButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Enter Department name'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          firestore
                              .collection('inbox_${department}')
                              .doc()
                              .set({
                                'fileTitle': doc['fileTitle'],
                                'date': DateTime.now(),
                              })
                              .then((value) => {})
                              .catchError((error) => print(error));

                          firestore
                              .collection('outbox_${widget.department}')
                              .doc()
                              .set({
                                'fileTitle': doc['fileTitle'],
                                'date': DateTime.now(),
                                'toDepartment': department
                              })
                              .then((value) => {})
                              .catchError((error) => print(error));

                          firestore
                              .collection('history_${doc['fileTitle']}')
                              .add({
                            'department': department,
                            'date': DateTime.now()
                          });

                          firestore
                              .collection('files')
                              .where('fileTitle', isEqualTo: doc['fileTitle'])
                              .get()
                              .then((querySnapshot) => {
                                    for (var docSnapshot in querySnapshot.docs)
                                      {
                                        firestore
                                            .collection('files')
                                            .doc(docSnapshot.id)
                                            .update({
                                          'currentDepartment': department
                                        })
                                      }
                                  })
                              .catchError((error) => print(error));
                          firestore
                              .collection('inbox_${widget.department}')
                              .doc(doc.id)
                              .delete()
                              .then((value) => {})
                              .catchError((error) => print(error));

                          Navigator.pop(context);
                        },
                        child: Text('Forward'))
                  ],
                  content: DropdownSearch<String>(
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
                );
              });
        },
        tooltip: 'Forward to Other Department',
        icon: Icon(
          Icons.forward_outlined,
          color: Colors.amber,
        ));
  }
}
