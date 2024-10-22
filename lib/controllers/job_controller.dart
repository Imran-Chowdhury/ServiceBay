

import 'package:cloud_firestore/cloud_firestore.dart';


//Fetching for mechanics
Stream<QuerySnapshot<Map<String, dynamic>>> getMechanicBookings(String mechanicUid) {
  return FirebaseFirestore.instance
      .collection('bookings')
      .doc(mechanicUid)
      .collection('jobs')
      .snapshots();
}

//Fetching for admins
Stream<QuerySnapshot<Map<String, dynamic>>> getAdminBookings() {
  return FirebaseFirestore.instance
      .collectionGroup('jobs')
      .snapshots(); // Fetches all jobs across all mechanics
}

