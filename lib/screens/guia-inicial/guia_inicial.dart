import 'package:app_dimonis/screens/guia-inicial/page_plantilla.dart';
import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class GuiaInicial extends StatefulWidget {
  const GuiaInicial({super.key});

  @override
  State<GuiaInicial> createState() => _GuiaInicialState();
}

class _GuiaInicialState extends State<GuiaInicial> {
  final LiquidController controller = LiquidController();

  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          LiquidSwipe(
            pages: [
              const PagePlantilla(
                image: 'assets/guia/foto1.png',
                title: 'Ves a la caça dels dimonis',
                subTitle:
                    'Descobreix i troba el major nombre de dimonis possibles.',
                counterText: '1/3',
                bgColor: Colors.white,
              ),
              const PagePlantilla(
                image: 'assets/guia/foto2.png',
                title: 'Compateix amb els teus amics',
                subTitle: 'Juga amb els teus amics i competeix en temps real.',
                counterText: '2/3',
                bgColor: Color.fromARGB(255, 255, 218, 218),
              ),
              const PagePlantilla(
                image: 'assets/guia/foto3.png',
                title: 'Vols crear gincanes?',
                subTitle:
                    'Uneix-te a la comunitat i crea les teves pròpies gincanes.',
                counterText: '3/3',
                bgColor: Color.fromARGB(255, 224, 255, 212),
              ),
              Container(color: Colors.white)
            ],
            enableSideReveal: true,
            liquidController: controller,
            onPageChangeCallback: onPageChangedCallback,
            slideIconWidget: const Icon(Icons.arrow_back_ios),
            waveType: WaveType.liquidReveal,
          ),
          Positioned(
            bottom: 60.0,
            child: OutlinedButton(
              onPressed: () => animateToNextSlide(),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.black26),
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(20),
              ),
              child: Container(
                padding: const EdgeInsets.all(20.0),
                decoration: const BoxDecoration(
                    color: Colors.black, shape: BoxShape.circle),
                child: const Icon(Icons.arrow_forward_ios),
              ),
            ),
          ),
          Positioned(
            top: 50,
            right: 20,
            child: TextButton(
              onPressed: () => skip(),
              child: const Text("Skip", style: TextStyle(color: Colors.grey)),
            ),
          ),
          Positioned(
            bottom: 10,
            child: AnimatedSmoothIndicator(
              count: 3,
              activeIndex: currentPage,
              effect: const ExpandingDotsEffect(
                activeDotColor: Color(0xff272727),
              ),
            ),
          ),
        ],
      ),
    );
  }

  skip() => controller.jumpToPage(page: 3);

  animateToNextSlide() {
    if (currentPage == 3) {
      Navigator.pushReplacementNamed(context, '/');
      return;
    }
    setState(() {
      int nextPage = controller.currentPage + 1;
      controller.animateToPage(page: nextPage);
    });
  }

  onPageChangedCallback(int activePageIndex) => {
        if (activePageIndex == 3)
          {
            Navigator.pushReplacementNamed(context, '/'),
          }
        else
          {
            setState(() {
              currentPage = activePageIndex;
            })
          }
      };
}
