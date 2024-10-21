import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final mechanicsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  // Fetch mechanics from Firestore
  QuerySnapshot mechanicsSnapshot = await FirebaseFirestore.instance.collection('mechanics').get();

  // Convert snapshot data into a list of maps
  return mechanicsSnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
});
