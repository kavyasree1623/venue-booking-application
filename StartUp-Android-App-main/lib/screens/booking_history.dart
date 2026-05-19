import 'package:flutter/material.dart';

class BookingHistoryPage extends StatelessWidget {
  final String userEmail;
  const BookingHistoryPage({super.key, required this.userEmail}); // FIXED

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Booking History")),
      body: Center(
        child: Text(
          "Bookings of $userEmail will display here soon",
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
