import 'package:flutter/foundation.dart';

class Donation {
  String id;
  String name;
  String address;
  int amount;

  Donation({
    required this.id,
    required this.name,
    required this.address,
    required this.amount,
  });

  factory Donation.fromMap(Map<String, dynamic> data, String id) {
    return Donation(
      id: id,
      name: data['name'] ?? '',
      address: data['address'] ?? '',
      amount: data['amount'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'amount': amount,
    };
  }
}