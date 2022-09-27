import 'package:flutter/material.dart';

class BeaconItem extends StatelessWidget {
  const BeaconItem({
    Key? key,
    required this.color,
    required this.distance,
    this.radius = 25,
  }) : super(key: key);

  final Color color;
  final double distance;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      width: radius,
      height: radius,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: color.withOpacity(0.4),
      ),
      child: Container(
        width: radius - 10,
        height: radius - 10,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: color,
        ),
        // child: Text(distance.toString(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
      ),
    );
  }
}
