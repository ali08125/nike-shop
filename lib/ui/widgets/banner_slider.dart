import 'package:flutter/material.dart';
import 'package:nike/common/utils.dart';
import 'package:nike/ui/widgets/image.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../data/banner.dart';

class BannerSlider extends StatelessWidget {
  final PageController _controller = PageController(initialPage: 0);
  final List<BannerEntity> banners;
  BannerSlider({
    super.key,
    required this.banners,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2,
      child: Stack(
        children: [
          PageView.builder(
            physics: defaultScroll,
            controller: _controller,
            itemCount: banners.length,
            itemBuilder: (context, index) => CashedImage(
              imageUrl: banners[index].imageUrl,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          Positioned(
            bottom: 8,
            left: 0,
            right: 0,
            child: Center(
              child: SmoothPageIndicator(
                controller: _controller,
                count: banners.length,
                axisDirection: Axis.horizontal,
                effect: WormEffect(
                    spacing: 8.0,
                    radius: 4.0,
                    dotWidth: 24.0,
                    dotHeight: 6.0,
                    paintStyle: PaintingStyle.fill,
                    strokeWidth: 1.5,
                    dotColor: Colors.grey.shade400,
                    activeDotColor: Theme.of(context).colorScheme.onBackground),
              ),
            ),
          )
        ],
      ),
    );
  }
}
