import 'package:flutter/material.dart';

class LocationTag extends StatelessWidget {
  final String location;

  LocationTag(this.location);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      decoration: ShapeDecoration(
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
      child: Text(location),
    );
  }
}
