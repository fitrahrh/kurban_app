import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/donation.dart';
import '../services/donation_service.dart';

class AddDonationScreen extends StatefulWidget {
  @override
  _AddDonationScreenState createState() => _AddDonationScreenState();
}

class _AddDonationScreenState extends State<AddDonationScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  void _clearControllers() {
    _nameController.clear();
    _addressController.clear();
    _amountController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Donation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(labelText: 'Address'),
            ),
            TextField(
              controller: _amountController,
              decoration: InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_amountController.text.isEmpty) {
                  // Handle case where amount is empty
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('Please enter the amount.'),
                        actions: [
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                  return;
                }

                final donation = Donation(
                  id: '',
                  name: _nameController.text,
                  address: _addressController.text,
                  amount: int.parse(_amountController.text),
                );
                context.read<DonationService>().addDonation(donation);
                _clearControllers();
                Navigator.of(context).pop(); // Close the screen
              },
              child: Text('Add Donation'),
            ),
          ],
        ),
      ),
    );
  }
}
