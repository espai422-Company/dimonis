import 'package:flutter/material.dart';

class PagePlantilla extends StatelessWidget {
  const PagePlantilla({
    super.key,
    required this.image,
    required this.title,
    required this.subTitle,
    required this.counterText,
    required this.bgColor,
    this.size,
  });

  final String image;
  final String title;
  final String subTitle;
  final String counterText;
  final Color bgColor;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(20),
      color: bgColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image(
            image: AssetImage(image),
            height: size.height * 0.45,
          ),
          Column(
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                subTitle,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          Text(
            counterText,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(
            height: 80.0,
          )
        ],
      ),
    );
  }
}
