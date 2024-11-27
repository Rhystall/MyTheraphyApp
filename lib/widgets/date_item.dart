import 'package:flutter/material.dart';
import 'package:my_theraphy/styles/color_collection.dart';

class DateItem extends StatelessWidget {
  final isSelected = false;
  const DateItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 35,
      height: 55,
      color: isSelected
          ? ColorCollections.primaryDarkBlue
          : ColorCollections.primaryGray,
      child: Column(
        children: [
          Text(
            'Mon',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 10,
              fontWeight: FontWeight.normal,
              color: isSelected
                  ? ColorCollections.primaryGray
                  : ColorCollections.primaryDarkBlue,
            ),
          ),
          Text(
            '12',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isSelected
                  ? ColorCollections.primaryGray
                  : ColorCollections.primaryDarkBlue,
            ),
          ),
        ],
      ),
    );
  }
}
