import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CashedImage extends StatelessWidget {
  final String imageUrl;
  final BorderRadius? borderRadius;
  const CashedImage({
    super.key,
    required this.imageUrl,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final Widget image = CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          errorWidget: (context, url, error) => const Icon(Icons.error),
        );
    if (borderRadius == null) {
      return image;
    } else
    {
      return ClipRRect(
          borderRadius: borderRadius,
          child: image,
        );

    }
  }
}
