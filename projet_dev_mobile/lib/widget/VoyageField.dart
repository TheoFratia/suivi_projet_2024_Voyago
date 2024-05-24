import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TravelCard extends StatelessWidget {
  final String destination;
  final String budget;
  final String price;

  const TravelCard({super.key,
    required this.destination,
    required this.budget,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            destination,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text('Budget : $budget'),
          const SizedBox(height: 4),
          Text('prix total : $price'),
        ],
      ),
    );
  }
}