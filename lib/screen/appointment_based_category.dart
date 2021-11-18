import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medi_tect_admin/widgets/custom_appbar.dart';
import 'package:medi_tect_admin/widgets/custom_drawer.dart';

import 'doctor_profile_screen.dart';

class AppointmentBasedCategory extends StatelessWidget {
  String category = "";
  AppointmentBasedCategory({required this.category});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('doctor')
          .where("speciality", isEqualTo: "$category")
          .snapshots(),
      builder: (_, snapshot) {
        if (snapshot.hasError) return Text('Error = ${snapshot.error}');
        if (snapshot.hasData) {
          final docs = snapshot.data!.docs;
          return Scaffold(
            appBar: myAppBar("$category"),
            drawer: MyDrawer(),
            body: ListView.builder(
              itemCount: docs.length,
              itemBuilder: (_, i) {
                final data = docs[i].data();
                return Container(
                  margin: EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 2.0,
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30.0,
                        backgroundImage:
                        AssetImage("assets/images/doctor1.jpg"),
                      ),
                      title: Text(
                        data['fullName'],
                      ),
                      subtitle: Text(
                        data['email'],
                      ),
                      trailing: IconButton(
                        icon: Icon(CupertinoIcons.arrow_right_circle),
                        onPressed: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => DoctorProfileScreen(
                                  fullName: data['fullName'],
                                  email: data['email'],
                                  likes: data['likes'],
                                  rating: data['rating'],
                                  address: data['address'],
                                  contact: data['contact'],
                                  licensesNumber: data['licenses_number'],
                                  description: data['description'],
                                ))),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }
}