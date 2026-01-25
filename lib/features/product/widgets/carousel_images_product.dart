import 'package:appshop/core/models/product_image_model.dart';
import 'package:appshop/shared/Widgets/image_fallback_icon.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CarouselImagesProduct extends StatefulWidget {
  List<ProductImageModel> imageUrls;

  CarouselImagesProduct(this.imageUrls);

  @override
  State<CarouselImagesProduct> createState() => _CarouselImagesProductState();
}

class _CarouselImagesProductState extends State<CarouselImagesProduct> {
  int _currentIndex = 0;
  final PageController _controller = PageController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              PageView.builder(
                itemCount: widget.imageUrls.length,
                controller: _controller,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index % widget.imageUrls.length;
                  });
                },
                itemBuilder: (context, index) {
                  final bannerIndex = index % widget.imageUrls.length;
                  return Image.network(
                    widget.imageUrls[bannerIndex].value,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return ImageFallbackIcon(size: 120);
                    },
                  );
                },
              ),
            ],
          ),
        ),
        if (widget.imageUrls.length > 1)
          Column(children: [
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.imageUrls.length,
                (index) => Container(
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  width: _currentIndex == index ? 10 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: _currentIndex == index
                        ? Colors.black87
                        : Colors.black38,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ]),
      ],
    );
  }
}
