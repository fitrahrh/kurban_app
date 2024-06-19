import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/donation.dart';

class DonationService with ChangeNotifier {
  final CollectionReference _donationCollection = FirebaseFirestore.instance.collection('donations');

  Future<void> addDonation(Donation donation) async {
    try {
      await _donationCollection.add(donation.toMap());
      print('Donation added successfully!');
    } catch (e) {
      print('Error adding donation: $e');
      // Handle error as needed
    }
  }

  Future<void> updateDonation(Donation donation) async {
    try {
      await _donationCollection.doc(donation.id).update(donation.toMap());
      print('Donation updated successfully!');
    } catch (e) {
      print('Error updating donation: $e');
      // Handle error as needed
    }
  }

  Future<void> deleteDonation(String donationId) async {
    try {
      await _donationCollection.doc(donationId).delete();
      print('Donation deleted successfully!');
    } catch (e) {
      print('Error deleting donation: $e');
      // Handle error as needed
    }
  }

  Stream<List<Donation>> getDonations() {
    return _donationCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Donation.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }
}
