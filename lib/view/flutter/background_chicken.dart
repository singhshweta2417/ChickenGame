import 'package:chicken_game/main.dart';
import 'package:chicken_game/view/flutter/chicken_run.dart';
import 'package:chicken_game/view/flutter/sprite_image_of_chicken.dart';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import '../../generated/assets.dart';
import '../../res/color_constant.dart';
import '../../res/primary_button.dart';
import '../../res/text_widget.dart';
import 'big_fire_const.dart';
import 'controller_chicken.dart';
import 'fire_const.dart';

class BackgroundChicken extends StatefulWidget {
  const BackgroundChicken({super.key});

  @override
  State<BackgroundChicken> createState() => _BackgroundChickenState();
}

class _BackgroundChickenState extends State<BackgroundChicken> with SingleTickerProviderStateMixin {
  late ChickenController _controller;
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _controller = ChickenController();
    _controller.addListener(() {
      if (mounted) setState(() {});
    });

    // Initialize animation controllers
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _bounceAnimation = Tween<double>(begin: 0, end: -20).animate(
      CurvedAnimation(
        parent: _bounceController,
        curve: Curves.easeInOut,
      ),
    );

    // Start the fire timer
    _controller.chickenControllerStart();
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onButtonPressed() {
    _controller.onButtonPressed(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: screenWidth,
          height: screenHeight * 0.5,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(Assets.backgroundBackgroundImage),
                  fit: BoxFit.cover)),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background scrolling area
              AnimatedPositioned(
                duration: const Duration(milliseconds: 600),
                left: _controller.backgroundOffset,
                child: Row(
                  children: [
                    Container(
                      width: _controller.blueContainerWidth,
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(Assets.backgroundBackgroundDoor),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(5, (index) {
                        bool isFlipped =
                            _controller.flippedRedIndices.contains(index);
                        return index == 4
                            ? Container(
                                height: screenHeight * 0.5,
                                width: screenWidth * 0.55,
                                padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.05),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image:
                                        AssetImage(Assets.imagesGoldenEggWall),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              )
                            : Container(
                                height: screenHeight * 0.5,
                                width: screenWidth * 0.4,
                                padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.05),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(Assets.imagesFrontJali),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Coin flip card
                                    SizedBox(height: screenHeight * 0.08),
                                    FlipCard(
                                      flipOnTouch: false,
                                      direction: FlipDirection.HORIZONTAL,
                                      front: AnimatedContainer(
                                        alignment: Alignment.center,
                                        duration:
                                            const Duration(milliseconds: 300),
                                        width: _controller.redContainerWidth,
                                        height: screenHeight * 0.15,
                                        margin: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(isFlipped
                                                ? Assets.imagesGreenCoin
                                                : Assets.imagesGreyCoin),
                                          ),
                                        ),
                                        child: textWidget(
                                            text: '${index + 1}',
                                            fontSize: 25,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      back: AnimatedContainer(
                                        alignment: Alignment.center,
                                        duration:
                                            const Duration(milliseconds: 300),
                                        width: _controller.redContainerWidth,
                                        height: screenHeight * 0.15,
                                        margin: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(
                                                Assets.imagesGreenCoin),
                                          ),
                                        ),
                                        child: textWidget(
                                            text: '${index + 1}',
                                            fontSize: 25,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    // Fire (GIF if active, else base)
                                  ],
                                ),
                              );
                      }),
                    ),
                  ],
                ),
              ),
              // Chicken with bounce
              AnimatedBuilder(
                animation: _bounceAnimation,
                builder: (context, child) {
                  return AnimatedPositioned(
                    duration: const Duration(seconds: 5),
                    left: _controller.blackPosition,
                    top: screenHeight * 0.365, //+ _bounceAnimation.value
                    child: child!,
                  );
                },
                child: SizedBox(
                  height: screenHeight * 0.15,
                  width: screenHeight * 0.12,
                  child: _controller.isScrolling
                      ? const ChickenRun()
                      : const StoppedChicken(),
                ),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 600),
                left: _controller.backgroundOffset + screenWidth * 0.37,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(5, (index) {
                    bool hasFire = _controller.fireIndices.contains(index);
                    return Container(
                      height: screenHeight * 0.5,
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Spacer(),
                          if (_controller.showBigFire &&
                              _controller.currentChickenIndex == index)
                            Container(
                              margin:
                                  EdgeInsets.only(right: screenWidth * 0.025),
                              height: screenHeight * 0.15,
                              width: screenWidth * 0.3,
                              child: BigFire(),
                            )
                          else if (hasFire &&
                              !(_controller.currentChickenIndex == index))
                            Container(
                              margin:
                                  EdgeInsets.only(right: screenWidth * 0.025),
                              height: screenHeight * 0.05,
                              width: screenWidth * 0.3,
                              child: FireGif(),
                            ),
                          Container(
                            height: screenHeight * 0.01,
                            width: screenWidth * 0.3,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(Assets.imagesBaseFireImage),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
        containerBuild()
      ],
    );
  }

  Widget containerBuild() {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: screenHeight * 0.015, horizontal: screenWidth * 0.03),
      margin: EdgeInsets.symmetric(
          vertical: screenHeight * 0.015, horizontal: screenWidth * 0.03),
      height: screenHeight * 0.3,
      decoration: BoxDecoration(
          color: ColorConstant.footerBg,
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.02, vertical: 5),
            decoration: BoxDecoration(
              color: ColorConstant.headerBg,
              borderRadius: BorderRadius.circular(5),
              border: Border(
                bottom: BorderSide(
                  color: ColorConstant.black
                      .withValues(alpha: 0.5), // Border color
                  width: 2.0, // Border width
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                  height: screenHeight * 0.04,
                  width: screenWidth * 0.15,
                  decoration: BoxDecoration(
                    color: ColorConstant.grey,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: textWidget(
                      text: 'MIN',
                      color: ColorConstant.white,
                      fontWeight: FontWeight.bold,
                      fontSize: Dimensions.ten),
                ),
                textWidget(
                    text: _controller.selectedCoin ?? 'Amount',
                    fontSize: Dimensions.fifteen,
                    fontWeight: FontWeight.w700,
                    color: ColorConstant.white),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                  height: screenHeight * 0.04,
                  width: screenWidth * 0.15,
                  decoration: BoxDecoration(
                    color: ColorConstant.grey,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: textWidget(
                      text: 'MAX',
                      color: ColorConstant.white,
                      fontWeight: FontWeight.bold,
                      fontSize: Dimensions.ten),
                ),
              ],
            ),
          ),
          Row(
            children: List.generate(_controller.coinList.length, (index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _controller.selectedCoin = _controller.coinList[index];
                  });
                },
                child: Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.01,
                      vertical: screenHeight * 0.015),
                  height: screenHeight * 0.05,
                  width: screenWidth * 0.2,
                  decoration: BoxDecoration(
                    color:
                        _controller.selectedCoin == _controller.coinList[index]
                            ? Colors.blue
                            : ColorConstant.headerBg,
                    borderRadius: BorderRadius.circular(5),
                    border: Border(
                      bottom: BorderSide(
                        color: ColorConstant.black.withValues(alpha: 0.5),
                        width: 2.0, // Border width
                      ),
                    ),
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        textWidget(
                            text: _controller.coinList[index],
                            color: ColorConstant.white,
                            fontWeight: FontWeight.bold,
                            fontSize: Dimensions.fifteen),
                        Icon(Icons.currency_rupee,
                            size: 15, color: ColorConstant.white)
                      ]),
                ),
              );
            }),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
            decoration: BoxDecoration(
              color: ColorConstant.headerBg,
              borderRadius: BorderRadius.circular(5),
              border: Border(
                bottom: BorderSide(
                  color: ColorConstant.black.withValues(alpha: 0.5),
                  width: 2.0, // Border width
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                textWidget(
                    text: 'Easy',
                    fontSize: Dimensions.fifteen,
                    fontWeight: FontWeight.w700,
                    color: ColorConstant.white),
                PopupMenuButton<String>(
                  color: ColorConstant.grey,
                  icon: Icon(Icons.keyboard_arrow_down,
                      color: ColorConstant.white),
                  onSelected: (String value) {
                    setState(() {
                      _controller.dropdownValue = value;
                    });
                  },
                  itemBuilder: (BuildContext context) {
                    return _controller.levelList.map((String value) {
                      return PopupMenuItem<String>(
                        value: value,
                        child: textWidget(
                            text: value,
                            color: ColorConstant.white,
                            fontWeight: FontWeight.bold,
                            fontSize: Dimensions.fifteen),
                      );
                    }).toList();
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: screenHeight * 0.02),
          PrimaryButton(
            onTap: _controller.selectedCoin != null ? _onButtonPressed : null,
            color:_controller.selectedCoin != null ? ColorConstant.green:ColorConstant.grey,
            height: screenHeight * 0.05,
            label: _controller.selectedCoin != null ? 'Go' : 'Please Select Amount',
          )
        ],
      ),
    );
  }

}
