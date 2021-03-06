import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medi_tect_admin/screen/doctor_profile_screen.dart';

DateTime _dateTime = DateTime.now();
String date = "${_dateTime.year}/${_dateTime.month}/${_dateTime.day}";

class TodaysDoctorAppointment extends StatelessWidget {
  const TodaysDoctorAppointment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('bookAppointment')
          .where("booked_date", isEqualTo: date)
          .snapshots(),
      builder: (_, snapshot) {
        if (snapshot.hasError) return Text('Error = ${snapshot.error}');
        if (snapshot.hasData) {
          final docs = snapshot.data!.docs;
          return Scaffold(
            body: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (_, i) {
                final data = docs[i].data();
                return Container(
                  margin: EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 2.0,
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 30.0,
                          backgroundImage:
                              AssetImage("assets/images/doctor1.jpg"),
                        ),
                        title: Text(
                          data['doctor_id'],
                        ),
                        subtitle: Text(
                          data['booked_time'],
                        ),
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

class AllDoctorAppointment extends StatelessWidget {
  const AllDoctorAppointment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('user')
          .where("role", isEqualTo: "doctor")
          .snapshots(),
      builder: (_, snapshot) {
        if (snapshot.hasError) return Text('Error = ${snapshot.error}');
        if (snapshot.hasData) {
          final docs = snapshot.data!.docs;
          return Scaffold(
            body: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (_, i) {
                final data = docs[i].data();
                return Container(
                  margin: EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 2.0,
                    child: Container(
                      padding: EdgeInsets.all(8.0),
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
                                        docId: snapshot.data!.docs[i].id,
                                        fullName: data['fullName'],
                                        email: data['email'],
                                        rating: data['rating'],
                                        address: data['address'],
                                        contact: data['contact'],
                                        licensesNumber: data['licenses_number'],
                                        description: data['description'],
                                      ))),
                        ),
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

class DoctorScreen extends StatelessWidget {
  const DoctorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Doctor\'s"),
          bottom: TabBar(
            tabs: [
              Text("Today\'s"),
              Text("View All"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            TodaysDoctorAppointment(),
            AllDoctorAppointment(),
          ],
        ),
      ),
    );
  }
}
