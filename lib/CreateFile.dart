import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

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

class CreateFile extends StatefulWidget {
  CreateFile({Key? key, required this.empId, required this.userDepartment})
      : super(key: key);
  final String empId;
  final String userDepartment;
  @override
  State<CreateFile> createState() => _CreateFileState();
}

class _CreateFileState extends State<CreateFile> {
  final firestore = FirebaseFirestore.instance;
  var department = '';

  var erpIdController = TextEditingController();

  var titleController = TextEditingController();

  late CollectionReference createdFile =
      firestore.collection('created_${widget.empId}');

  @override
  Widget build(BuildContext context) {
    late final docId =
        'MUJ${DateTime.now().year}${firestore.collection('files').snapshots().length}';
    return Scaffold(
      appBar: AppBar(title: Text('Create new File')),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Create File',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 35,
                        color: Colors.amber)),
                SizedBox(
                  height: 12,
                ),
                Text('File ID : ${docId}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.amber)),
                SizedBox(
                  height: 12,
                ),
                TextField(
                    controller: erpIdController,
                    autofocus: true,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter file ERP-PR number ')),
                SizedBox(
                  height: 12,
                ),
                TextField(
                    controller: titleController,
                    autofocus: true,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter file Title')),
                SizedBox(
                  height: 12,
                ),
                DropdownSearch<String>(
                  items: departmentList,
                  onChanged: (value) {
                    department = value.toString();
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
                      if (erpIdController.text != '' &&
                          titleController.text != '' &&
                          department != '') {
                        firestore.collection('files').doc().set({
                          'erpId': erpIdController.text,
                          'fileTitle': titleController.text,
                          'createdDate': DateTime.now(),
                          'status': 'under_process',
                          'currrentDepartment': widget.userDepartment
                        }).then((doc) {
                          Navigator.pop(context);
                        }).catchError((e) => print(e));

                        firestore
                            .collection('history_${titleController.text}')
                            .add({
                              'department': widget.userDepartment,
                              'date': DateTime.now()
                            })
                            .then((value) => {})
                            .catchError((error) => print(error));

                        firestore
                            .collection('inbox_${widget.userDepartment}')
                            .doc()
                            .set({
                              'fileTitle': titleController.text,
                              'createdDate': DateTime.now(),
                            })
                            .then((value) => {})
                            .catchError((e) => print(e));

                        firestore
                            .collection('created_${widget.empId}')
                            .doc()
                            .set({
                              'fileTitle': titleController.text,
                              'createdDate': DateTime.now(),
                            })
                            .then((value) => {})
                            .catchError((e) => print(e));
                      }
                    },
                    child: Text(
                      'Create File',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ))
              ],
            )),
      ),
    );
  }
}
