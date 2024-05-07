import 'package:flutter/material.dart';
import 'package:smart_key/utils/constants.dart';

class ProfileImage extends StatelessWidget {
  const ProfileImage({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Image.network(
        imageUrl,
        width: screenWidth(context) * 0.2,
        loadingBuilder: (context, child, loadingProgress) {
      if (loadingProgress == null) {
        return child;
      }
      return CircularProgressIndicator(
        value: loadingProgress.expectedTotalBytes != null
            ? loadingProgress.cumulativeBytesLoaded /
                loadingProgress.expectedTotalBytes!
            : null,
      );
    }, errorBuilder: (context, error, stackTrace) {
      return Icon(
        Icons.person_2,
        color: secondaryColor,
      );
    });
  }
}
