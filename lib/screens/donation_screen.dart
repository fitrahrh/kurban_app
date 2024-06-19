import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/donation_service.dart';
import '../models/donation.dart';
import '../widgets/bottom_navbar.dart';
import 'add_donation_screen.dart'; // Import AddDonationScreen

class DonationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Donations'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => AddDonationScreen()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Donation>>(
        stream: context.read<DonationService>().getDonations(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No donations found'));
          }
          final donations = snapshot.data!;
          
          return ListView(
            padding: EdgeInsets.all(16.0), // Menambahkan padding untuk margin
            children: [
              DataTable(
                columns: [
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Address')),
                  DataColumn(label: Text('Amount')),
                  DataColumn(label: Text('Action')), // Kolom untuk tombol delete
                ],
                rows: donations.map((donation) {
                  return DataRow(cells: [
                    DataCell(Text(donation.name)),
                    DataCell(Text(donation.address)),
                    DataCell(Text(donation.amount.toString())),
                    DataCell(
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Delete Donation'),
                                content: Text('Are you sure you want to delete this donation?'),
                                actions: [
                                  TextButton(
                                    child: Text('Cancel'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text('Delete'),
                                    onPressed: () {
                                      // Delete donation logic
                                      context.read<DonationService>().deleteDonation(donation.id);
                                      Navigator.of(context).pop(); // Close dialog
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ]);
                }).toList(),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
