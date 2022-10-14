import 'dart:async';

import 'package:animated_stepper_flutter/utils/responsive.dart';
import 'package:flutter/material.dart';



class HomePage extends StatefulWidget {


  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{

  late AnimationController _animationController;
  late Animation<double> _valueAnimation;

  late final PageController _pageController;

  Timer? timer;
  int _selectedNumber = 0;

  @override
  void initState() {
    _selectedNumber = 1;
    _pageController = PageController(initialPage: _selectedNumber, viewportFraction: 1 / 3);
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 250))
      ..addListener(() => setState(() {}));
    _valueAnimation = Tween<double>(begin: 1, end: 0.95).animate(
      CurvedAnimation(
        parent: _animationController, 
        curve: Curves.ease
      )
    );
    super.initState();
  }

  void onTapNewNumber(final int number) {
    _pageController.animateToPage(number, duration: const Duration(milliseconds: 500), curve: Curves.ease);
    setState(() {
      _selectedNumber = number;
    });
  }

  @override
  Widget build(BuildContext context) {

    final ResponsiveUtil resp = ResponsiveUtil.of(context);

    return Scaffold(
      backgroundColor: const Color(0xfff5f4f5),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: resp.hp(10),
              width: resp.wp(40),
              child: Center(
                child: Container(
                  height: resp.hp(10),
                  width: resp.wp(40),
                  transform: Matrix4.identity()..scale(_valueAnimation.value),
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(
                    horizontal: resp.wp(3)
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xff333232),
                    borderRadius: BorderRadius.circular(30)
                  ),
                  child: PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    controller: _pageController,
                    children: List.generate(
                      100,
                      (index) {
            
                        final bool isSelected = _selectedNumber == index;
                        final Color fontColor = isSelected ? Colors.white : Colors.grey[600]!;
                        final double scale = isSelected ? 1 : 0.5;
                        
                        return AnimatedScale(
                          scale: scale,
                          duration: const Duration(milliseconds: 250),
                          child: Center(
                            child: GestureDetector(
                              onTapDown: (details) {
                                if(timer == null || !timer!.isActive){
                                  timer = Timer.periodic(const Duration(milliseconds: 50), (timer) => _animationController.forward());
                                }
                              },
                              onTapUp: (details) {
                                if(timer != null){
                                  timer!.cancel();
                                }
                                _animationController.reset();
                              },
                              onTap: () => onTapNewNumber(index),
                              child: Text(
                                (index + 1).toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: fontColor, 
                                  fontSize: 60, 
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}