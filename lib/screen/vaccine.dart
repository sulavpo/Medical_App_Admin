import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:medi_tect_admin/screen/edit_vaccine.dart';
import 'package:medi_tect_admin/screen/vaccine_book.dart';

class ViewAllVaccine extends StatelessWidget {
  const ViewAllVaccine({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('vaccine').snapshots(),
      builder: (_, snapshot) {
        if (snapshot.hasError) return Text('Error = ${snapshot.error}');

        if (snapshot.hasData) {
          final docs = snapshot.data!.docs;
          return Scaffold(
            body: ListView.builder(
              itemCount: docs.length,
              itemBuilder: (_, i) {
                final data = docs[i].data();
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditVaccine(
                                  vName: data['name'],
                                  vTotal: data['total'],
                                  vDose: data['dose'],
                                  vContact: data['contact'],
                                  docId: snapshot.data!.docs[i].id,
                                )));
                  },
                  child: Container(
                    margin: EdgeInsets.all(16.0),
                    child: Card(
                      child: ListTile(
                        leading: Image.asset("assets/icons/vaccine.png"),
                        title: Text(data['name']),
                        subtitle: Text(
                          "Total: " + data['total'] + "  Dose: " + data['dose'],
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => VaccineBook(
                                          vName: data['name'],
                                          vContact: data['contact'],
                                          vDose: data['dose'],
                                          patientName: "Abishek Khanal",
                                        )));
                          },
                          icon: Icon(CupertinoIcons.arrow_right_circle),
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

class TodayVaccineScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DateTime _dateTime = DateTime.now();
    String date = "${_dateTime.year}/${_dateTime.month}/${_dateTime.day}";
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('bookVaccine')
          .where("booked_date", isEqualTo: date)
          .snapshots(),
      builder: (_, snapshot) {
        if (snapshot.hasError) return Text('Error = ${snapshot.error}');

        if (snapshot.hasData) {
          final docs = snapshot.data!.docs;
          return Scaffold(
            body: ListView.builder(
              itemCount: docs.length,
              itemBuilder: (_, i) {
                final data = docs[i].data();
                return GestureDetector(
                  child: Container(
                    margin: EdgeInsets.all(16.0),
                    child: Card(
                      child: ListTile(
                        leading: Image.asset("assets/icons/vaccine.png"),
                        title: Text(data['name']),
                        subtitle: Text(
                          "Total: " + FirebaseAuth.instance.currentUser!.uid,
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

class VaccineScreen extends StatelessWidget {
  const VaccineScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Vaccine"),
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Today\'s'),
              Tab(text: 'View All'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            TodayVaccineScreen(),
            ViewAllVaccine(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(CupertinoIcons.add),
          onPressed: () {
            Navigator.pushNamed(context, "/addVaccine");
          },
        ),
      ),
    );
  }
}
