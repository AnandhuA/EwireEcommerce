import 'package:flutter/material.dart';

class PriceSummaryCard extends StatelessWidget {
  final double total;

  const PriceSummaryCard({super.key, required this.total});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Price Summary',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total'),
                Text('₹${total.toStringAsFixed(0)}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
