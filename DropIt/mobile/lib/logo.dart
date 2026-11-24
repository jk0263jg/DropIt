import 'package:flutter/material.dart';

/// Logo widget that displays the app branding
/// Contains two text elements stacked vertically with Korean text "로고" and "Drop It"
class Logo extends StatelessWidget {
  const Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          // Main logo text in Korean
          constraints: const BoxConstraints(maxWidth: 43),
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(),
          child: AspectRatio(
            aspectRatio: 0.9,
            child: Image.network(
              'https://api.builder.io/api/v1/image/assets/TEMP/1786bb018ff9812399da806901f534fa7fcce30f?placeholderIfAbsent=true&apiKey=2e52a8c4d23d4dad82ddd51e30f98c94',
              fit: BoxFit.contain,
              width: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.error),
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
            ),
          ),
        ),
        // Small spacing between logo elements
        SizedBox(height: 4),
        // App name "Drop It"
        Text(
          'Drop It',
          style: TextStyle(
            fontSize: 32, // Matching size with logo text
            fontWeight: FontWeight.w800, // Consistent bold styling
            color: Color(0xFF7C3AED), // Same violet brand color
          ),
        ),
      ],
    );
  }
}
