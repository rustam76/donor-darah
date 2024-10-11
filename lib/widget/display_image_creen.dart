import 'package:flutter/material.dart';

class DisplayImageScreen extends StatelessWidget {
  final String imagePath;
  final double? width;
  final double? height;

  DisplayImageScreen({
    required this.imagePath,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.network(
        imagePath,
        height: height ?? 100,
        width: width ?? 150,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: progress.expectedTotalBytes != null
                  ? progress.cumulativeBytesLoaded /
                      progress.expectedTotalBytes!
                  : null,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Text('Failed to load image');
        },
      ),
    );
  }
}
