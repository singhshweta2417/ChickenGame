import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:chicken_game/main.dart';
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

class _BackgroundChickenState extends State<BackgroundChicken>
    with SingleTickerProviderStateMixin {
  late ChickenController _controller;
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _controller = ChickenController();
    _controller.addListener(_onControllerUpdate);

    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _bounceAnimation = Tween<double>(begin: 0, end: -10).animate(
      CurvedAnimation(
        parent: _bounceController,
        curve: Curves.easeInOut,
      ),
    );

    _controller.chickenControllerStart();
  }

  void _onControllerUpdate() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _controller.removeListener(_onControllerUpdate);
    _controller.dispose();
    super.dispose();
  }

  void _onButtonPressed() {
    _controller.onButtonPressed(context);
    _bounceController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildGameArea(context),
        _buildControlPanel(),
      ],
    );
  }

  Widget _buildGameArea(BuildContext context) {
    return Container(
      width: screenWidth,
      height: screenHeight * 0.5,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Assets.backgroundBackgroundImage),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          _buildScrollingBackground(),
          _buildChickenCharacter(),
          _buildFireEffects(),
        ],
      ),
    );
  }

  Widget _buildScrollingBackground() {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 1000),
      left: _controller.backgroundOffset,
      child: Row(
        children: [
          _buildBlueDoor(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(5, _buildRedContainer),
          ),
        ],
      ),
    );
  }

  Widget _buildBlueDoor() {
    return Container(
      width: _controller.blueContainerWidth,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Assets.backgroundBackgroundDoor),
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildRedContainer(int index) {
    final isFlipped = _controller.flippedRedIndices.contains(index);
    final isLast = index == 4;
    return Container(
      height: screenHeight * 0.5,
      width: isLast ? screenWidth * 0.55 : screenWidth * 0.4,
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
              isLast ? Assets.imagesGoldenEggWall : Assets.imagesFrontJali),
          fit: isLast ? BoxFit.fill : BoxFit.contain,
        ),
      ),
      alignment: Alignment.center,
      child: isLast ? null : _buildCoinFlipCard(index, isFlipped),
    );
  }

  Widget _buildCoinFlipCard(int index, bool isFlipped) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: screenHeight * 0.08),
        FlipCard(
          flipOnTouch: false,
          direction: FlipDirection.HORIZONTAL,
          front: _buildCoinFace(index,
              isFlipped ? Assets.imagesGreenCoin : Assets.imagesGreyCoin),
          back: _buildCoinFace(index, Assets.imagesGreenCoin),
        ),
      ],
    );
  }

  Widget _buildCoinFace(int index, String asset) {
    return AnimatedContainer(
      alignment: Alignment.center,
      duration: const Duration(milliseconds: 300),
      width: _controller.redContainerWidth,
      height: screenHeight * 0.15,
      margin: const EdgeInsets.all(4),
      decoration:
          BoxDecoration(image: DecorationImage(image: AssetImage(asset))),
      child: textWidget(
        text: '${index + 1}',
        fontSize: 25,
        color: Colors.white,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildChickenCharacter() {
    return AnimatedPositioned(
      duration: const Duration(seconds: 3),
      left: _controller.blackPosition + 0.05,
      top: screenHeight * 0.37 + _bounceAnimation.value,
      child: Container(
        height: screenHeight * 0.15,
        width: screenHeight * 0.13,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(_controller.isScrolling
                    ? 'assets/images/chicken_gif.gif'
                    : 'assets/images/chickens/shivering_chicken.gif'),
                fit: _controller.isScrolling ? BoxFit.contain : BoxFit.cover)),
      ),
    );
  }

  Widget _buildFireEffects() {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 1000),
      left: _controller.backgroundOffset + screenWidth * 0.37,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(4, _buildFireForIndex),
      ),
    );
  }

  Widget _buildFireForIndex(int index) {
    final hasFire = _controller.fireIndices.contains(index);
    final isCurrent = _controller.currentChickenIndex == index;
    return Container(
      height: screenHeight * 0.5,
      padding: EdgeInsets.only(left: screenWidth * 0.09),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          if (_controller.showBigFire && isCurrent)
            _buildBigFireEffect()
          else if (hasFire)
            _buildSmallFireEffect(),
          _buildFireBase(),
        ],
      ),
    );
  }

  Widget _buildBigFireEffect() {
    return Container(
      margin: EdgeInsets.only(right: screenWidth * 0.025),
      height: screenHeight * 0.15,
      width: screenWidth * 0.3,
      child: const BigFire(),
    );
  }

  Widget _buildSmallFireEffect() {
    return Container(
      margin: EdgeInsets.only(right: screenWidth * 0.025),
      height: screenHeight * 0.05,
      width: screenWidth * 0.25,
      child: const FireGif(),
    );
  }

  Widget _buildFireBase() {
    return Container(
      height: screenHeight * 0.015,
      width: screenWidth * 0.3,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Assets.imagesBaseFireImage),
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Widget _buildControlPanel() {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: screenHeight * 0.015, horizontal: screenWidth * 0.03),
      margin: EdgeInsets.symmetric(
          vertical: screenHeight * 0.015, horizontal: screenWidth * 0.03),
      height: screenHeight * 0.3,
      decoration: BoxDecoration(
        color: ColorConstant.footerBg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildAmountSelector(),
          _buildCoinButtons(),
          _buildDifficultySelector(),
          _buildGoButton(),
        ],
      ),
    );
  }

  Widget _buildAmountSelector() {
    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: screenWidth * 0.02, vertical: 5),
      decoration: BoxDecoration(
        color: ColorConstant.headerBg,
        borderRadius: BorderRadius.circular(5),
        border: Border(
          bottom: BorderSide(
            color: ColorConstant.black.withValues(alpha: 0.5),
            width: 2.0,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildMinButton(),
          _buildSelectedAmountDisplay(),
          _buildMaxButton(),
        ],
      ),
    );
  }

  Widget _buildMinButton() {
    return _buildControlButton('MIN');
  }

  Widget _buildMaxButton() {
    return _buildControlButton('MAX');
  }

  Widget _buildControlButton(String text) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
      height: screenHeight * 0.04,
      width: screenWidth * 0.15,
      decoration: BoxDecoration(
        color: ColorConstant.grey,
        borderRadius: BorderRadius.circular(5),
      ),
      child: textWidget(
        text: text,
        color: ColorConstant.white,
        fontWeight: FontWeight.bold,
        fontSize: Dimensions.ten,
      ),
    );
  }

  Widget _buildSelectedAmountDisplay() {
    return textWidget(
      text: _controller.selectedCoin ?? 'Amount',
      fontSize: Dimensions.fifteen,
      fontWeight: FontWeight.w700,
      color: ColorConstant.white,
    );
  }

  Widget _buildCoinButtons() {
    return Row(
      children: List.generate(
        _controller.coinList.length,
        (index) => _buildCoinButton(index),
      ),
    );
  }

  Widget _buildCoinButton(int index) {
    final isSelected = _controller.selectedCoin == _controller.coinList[index];

    return GestureDetector(
      onTap: () => _selectCoin(index),
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.01, vertical: screenHeight * 0.015),
        height: screenHeight * 0.05,
        width: screenWidth * 0.2,
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : ColorConstant.headerBg,
          borderRadius: BorderRadius.circular(5),
          border: Border(
            bottom: BorderSide(
              color: ColorConstant.black.withValues(alpha: 0.5),
              width: 2.0,
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
              fontSize: Dimensions.fifteen,
            ),
            Icon(
              Icons.currency_rupee,
              size: 15,
              color: ColorConstant.white,
            ),
          ],
        ),
      ),
    );
  }

  void _selectCoin(int index) {
    setState(() {
      _controller.selectedCoin = _controller.coinList[index];
    });
  }

  Widget _buildDifficultySelector() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
      decoration: BoxDecoration(
        color: ColorConstant.headerBg,
        borderRadius: BorderRadius.circular(5),
        border: Border(
          bottom: BorderSide(
            color: ColorConstant.black.withValues(alpha: 0.5),
            width: 2.0,
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
            color: ColorConstant.white,
          ),
          _buildDifficultyDropdown(),
        ],
      ),
    );
  }

  Widget _buildDifficultyDropdown() {
    return PopupMenuButton<String>(
      color: ColorConstant.grey,
      icon: Icon(
        Icons.keyboard_arrow_down,
        color: ColorConstant.white,
      ),
      onSelected: (value) {
        setState(() {
          _controller.dropdownValue = value;
        });
      },
      itemBuilder: (context) {
        return _controller.levelList.map((value) {
          return PopupMenuItem<String>(
            value: value,
            child: textWidget(
              text: value,
              color: ColorConstant.white,
              fontWeight: FontWeight.bold,
              fontSize: Dimensions.fifteen,
            ),
          );
        }).toList();
      },
    );
  }

  Widget _buildGoButton() {
    bool isDisabled = _controller.selectedCoin == null || _controller.isScrolling;
    return PrimaryButton(
      onTap: !isDisabled ? _onButtonPressed : null,
      color: !isDisabled ? ColorConstant.green : ColorConstant.grey,
      height: screenHeight * 0.05,
      label: _controller.selectedCoin != null
          ? (_controller.isScrolling ? 'Running...' : 'Go')
          : 'Please Select Amount',
    );
  }
}
