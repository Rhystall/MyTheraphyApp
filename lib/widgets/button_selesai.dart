import 'package:flutter/material.dart';
import 'package:my_theraphy/styles/color_collection.dart';
import 'package:my_theraphy/styles/typography_collection.dart';

class ButtonSelesai extends StatelessWidget {
  final VoidCallback onPressed;

  const ButtonSelesai({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 150,
        height: 50,
        decoration: BoxDecoration(
          color: ColorCollections.primaryGray,
          borderRadius: BorderRadius.circular(100),
        ),
        alignment: Alignment.center,
        child: Text("Selesai", style: TypographyCollection.h1),
      ),
    );
  }
}
