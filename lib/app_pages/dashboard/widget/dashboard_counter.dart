import 'package:flutter/material.dart';

class DashboardCount extends StatelessWidget {
  final String title;
  final int count;
  final Color color;

  const DashboardCount({
    super.key,
    required this.count,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius:
            BorderRadius.circular(15), // Adjust the border radius as needed
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        elevation: 5, // Adjust the elevation as needed
        borderRadius:
            BorderRadius.circular(15), // Adjust the border radius as needed
        child: Padding(
          padding: const EdgeInsets.all(10), // Adjust the padding as needed
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: Colors.white),
              ),
              Text(
                count.toString(),
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
