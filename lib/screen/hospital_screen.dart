import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:medi_tect_admin/screen/book_beds_screen.dart';
import 'package:medi_tect_admin/screen/edit_bed.dart';

class BookedBeds extends StatelessWidget {
  const BookedBeds({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('bookBed').snapshots(),
      builder: (_, snapshot) {
        if (snapshot.hasError) return Text('Error = ${snapshot.error}');

        if (snapshot.hasData) {
          final docs = snapshot.data!.docs;
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () => Navigator.pushNamed(context, "/addHospital"),
              child: Icon(CupertinoIcons.add),
            ),
            body: ListView.builder(
              itemCount: docs.length,
              itemBuilder: (_, i) {
                final data = docs[i].data();
                return Container(
                  margin: EdgeInsets.all(16.0),
                  child: Card(
                    child: ListTile(
                      leading: Text(data['totalBed'].toString()),
                      title: Text(data['ward']),
                      subtitle: Text(data['userId']),
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

class ViewAllBeds extends StatelessWidget {
  const ViewAllBeds({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('ward').snapshots(),
      builder: (_, snapshot) {
        if (snapshot.hasError) return Text('Error = ${snapshot.error}');

        if (snapshot.hasData) {
          final docs = snapshot.data!.docs;
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () => Navigator.pushNamed(context, "/addHospital"),
              child: Icon(CupertinoIcons.add),
            ),
            body: ListView.builder(
              itemCount: docs.length,
              itemBuilder: (_, i) {
                final data = docs[i].data();
                return GestureDetector(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => EditBeds(
                          docId: snapshot.data!.docs[i].id,
                          wardName: data['wardName'],
                          totalBeds: data['totalBeds'],
                          contact: data['contact'],
                          availableBeds: data['availableBeds']))),
                  child: Container(
                    margin: EdgeInsets.all(16.0),
                    child: Card(
                      child: ListTile(
                        leading: Image.asset("assets/icons/hospital.png"),
                        title: Text(data['wardName']),
                        subtitle:
                            Text(data['totalBeds'] + "  " + data['contact']),
                        trailing: IconButton(
                          icon: Icon(
                            CupertinoIcons.arrow_right_circle,
                          ),
                          onPressed: () =>
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => BookHospitalScreen(
                                        id: snapshot.data!.docs[i].id,
                                        hospitalName: data['wardName'],
                                        hospitalContact: data['contact'],
                                        hospitalRemainingBeds:
                                            data['availableBeds'],
                                        hospitalTotalBeds: data['totalBeds'],
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

// ignore: must_be_immutable
class HospitalScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Hospital"),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Booked'),
              Tab(text: 'ViewAll'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            BookedBeds(),
            ViewAllBeds(),
          ],
        ),
      ),
    );
  }
}
