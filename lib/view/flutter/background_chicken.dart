import 'package:chicken_game/res/view_model/bet_view_model.dart';
import 'package:chicken_game/res/view_model/cash_view_model.dart';
import 'package:chicken_game/res/view_model/multiplier_view_model.dart';
import 'package:flutter/material.dart';
import 'package:chicken_game/main.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
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
  late VideoPlayerController _videoController;
  // final AudioPlayer _audioPlayer = AudioPlayer();
  // Future<void> playBackgroundMusic() async {
  //   await _audioPlayer.setReleaseMode(ReleaseMode.loop); // Loop the music
  //   await _audioPlayer.play(AssetSource('music/bg_music.mp3'));
  // }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // playBackgroundMusic();
      final multiplier =
          Provider.of<MultiplierViewModel>(context, listen: false);
      multiplier.multiplierApi('1', context);
    });
    _videoController =
        VideoPlayerController.asset("assets/images/convert_colission.mp4")
          ..initialize().then((_) {
            setState(() {});
            _videoController.setLooping(true);
            _videoController.play();
          });
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
     print('yaha shuru ho ra h chicken');
    _controller.chickenControllerStart();
  }

  void _onControllerUpdate() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    // _audioPlayer.dispose();
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
    final multiplier =
        Provider.of<MultiplierViewModel>(context).multiplierModel;
    if (multiplier.data == null) {
      return SizedBox(); // or some placeholder widget
    }

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 1000),
      left: _controller.backgroundOffset,
      child: Row(
        children: [
          _buildBlueDoor(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: multiplier.data != null
                ? List.generate(
                    multiplier.data!.data!.length, _buildRedContainer)
                : [], // empty list if data is null
          ),
        ],
      ),
    );
  }

  Widget _buildBlueDoor() {
    return Container(
      width: screenWidth * 0.4,
      height: screenHeight,
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
    final multiplierModel =
        Provider.of<MultiplierViewModel>(context).multiplierModel;
    final multiplierData = multiplierModel.data?.data;

    // Safely get the multiplier length or default to 0
    final multiplierLength = multiplierData?.length ?? 0;

    // Determine if this is the last index
    final isLast = index == multiplierLength - 1;
    return isLast
        ? Container(
            height: screenHeight * 0.5,
            width: screenWidth * 0.5,
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Assets.imagesGoldenEggWall),
                fit: BoxFit.fill,
              ),
            ),
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: screenHeight * 0.07, right: screenWidth * 0.09),
              child: textWidget(
                  textAlign: TextAlign.center,
                  text: '${multiplierData?.last.multiplier.toString()} x',
                  fontSize: Dimensions.twenty,
                  color: Colors.white,
                  fontWeight: FontWeight.w700),
            ),
          )
        : _buildCoinFlipCard(index, isFlipped);
  }

  Widget _buildCoinFlipCard(int index, bool isFlipped) {
    return Container(
      height: screenHeight * 0.5,
      width: screenWidth * 0.4,
      padding: EdgeInsets.only(top: screenHeight * 0.12),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Assets.imagesFrontJali),
          fit: BoxFit.contain,
        ),
      ),
      alignment: Alignment.topCenter,
      child: _buildCoinFace(
          index, isFlipped ? Assets.imagesGreenCoin : Assets.imagesGreyCoin),
    );
  }

  Widget _buildCoinFace(int index, String asset) {
    final multiplier =
        Provider.of<MultiplierViewModel>(context).multiplierModel.data!;
    return AnimatedContainer(
      alignment: Alignment.center,
      duration: const Duration(milliseconds: 300),
      width: screenWidth * 0.25,
      height: screenHeight * 0.15,
      decoration:
          BoxDecoration(image: DecorationImage(image: AssetImage(asset))),
      child: textWidget(
        text: '${multiplier.data?[index].multiplier.toString()} x',
        fontSize: 25,
        color: Colors.white,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildChickenCharacter() {
    if (_controller.isGameOver) {
      return const SizedBox.shrink(); // Chicken hidden when game is over
    }

    return AnimatedPositioned(
      duration: Duration(milliseconds: 1500),
      left: screenWidth * 0.04,
      top: screenHeight * 0.33 + _bounceAnimation.value,
      child: Container(
        height: screenHeight * 0.2,
        width: screenHeight * 0.17,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(_controller.isScrolling
                ? 'assets/images/chicken_gif.gif'
                : 'assets/images/chickens/shivering_chicken.gif'),
            fit: _controller.isScrolling ? BoxFit.contain : BoxFit.cover,
          ),
        ),
      ),
    );

  }


  Widget _buildFireEffects() {
    final multiplier =
        Provider.of<MultiplierViewModel>(context).multiplierModel;

    if (multiplier.data == null) {
      return SizedBox();
    }

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 1000),
      left: _controller.backgroundOffset + screenWidth * 0.38,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children:
            List.generate(multiplier.data!.data!.length, _buildFireForIndex),
      ),
    );
  }

  Widget _buildFireForIndex(int index) {
    final hasFire = _controller.fireIndices.contains(index);
    final isCurrent = _controller.currentChickenIndex == index;
    final multiplierModel =
        Provider.of<MultiplierViewModel>(context).multiplierModel;
    final multiplierData = multiplierModel.data?.data;
    final multiplierLength = multiplierData?.length ?? 0;

    // Determine if this is the last index
    final isLast = index == multiplierLength - 1;
    print(multiplierLength);
    print(isLast);
    print('isLastdjbfkj');
    return Container(
      height: screenHeight * 0.5,
      padding: EdgeInsets.only(
          left: index == 0 ? screenWidth * 0.05 : screenWidth * 0.1),
      alignment: Alignment.center,
      child: isLast
          ? Container()
          : Column(
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
      height: screenHeight * 0.4,
      width: screenWidth * 0.3,
      alignment: Alignment.centerRight,
      // decoration: BoxDecoration(
      //     color: Colors.blue,
      //     image: DecorationImage(image: AssetImage("assets/images/collission_fire.gif"),fit: BoxFit.cover)),
      // child: const BigFire(),
      child: _videoController.value.isInitialized
          ? SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _videoController.value.size.width,
                  height: _videoController.value.size.height,
                  child: VideoPlayer(_videoController),
                ),
              ),
            )
          : SizedBox(),
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
      // height: screenHeight * 0.3,
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

  void _onMaxTap() {
    setState(() {
      int currentAmount = int.tryParse(_controller.selectedCoin ?? '') ?? 0;
      currentAmount += 1;
      _controller.selectedCoin = currentAmount.toString();
    });
  }

  void _onMinTap() {
    setState(() {
      int currentAmount = int.tryParse(_controller.selectedCoin ?? '') ?? 0;
      if (currentAmount > 0) {
        currentAmount -= 1;
        _controller.selectedCoin = currentAmount.toString();
      }
    });
  }

  Widget _buildMinButton() {
    return _buildControlButton('MIN', _onMinTap);
  }

  Widget _buildMaxButton() {
    return _buildControlButton('MAX', _onMaxTap);
  }

  Widget _buildControlButton(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
        height: screenHeight * 0.04,
        width: screenWidth * 0.15,
        decoration: BoxDecoration(
          color: ColorConstant.grey,
          borderRadius: BorderRadius.circular(5),
        ),
        child: textWidget(
          text: '$text ₹',
          color: ColorConstant.white,
          fontWeight: FontWeight.bold,
          fontSize: Dimensions.ten,
        ),
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
    final bet = Provider.of<BetViewModel>(context);
    final cashOut = Provider.of<CashOutViewModel>(context);
    int index = _controller.currentChickenIndex + 1;
    int? coin = int.tryParse(_controller.selectedCoin ?? '0');
    int? totalAmount = index * coin!.toInt();
    return Container(
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
          PrimaryButton(
            onTap: (_controller.selectedCoin != null &&
                    !_controller.hasUserPlacedBet)
                ? () {
                    _controller.placeBet();
                    bet.betApi(_controller.selectedCoin.toString(), context);
                  }
                : null,
            color: (_controller.selectedCoin != null &&
                    !_controller.hasUserPlacedBet)
                ? ColorConstant.green
                : ColorConstant.grey,
            height: screenHeight * 0.05,
            width: screenWidth * 0.2,
            label: 'Bet',
          ),
          PrimaryButton(
            onTap: () {
              if (index != 0) {
                cashOut.cashOutApi(index, context);
              }
            },
            color: index != 0 ? ColorConstant.blueColor : ColorConstant.grey,
            width: screenWidth * 0.25,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                textWidget(
                    text: 'Cash Out',
                    fontSize: Dimensions.fifteen,
                    color: Colors.white),
                textWidget(
                    text: '${totalAmount.toString()} x',
                    fontSize: Dimensions.fifteen,
                    color: Colors.white),
              ],
            ),
          ),
          _buildDifficultyDropdown(),
        ],
      ),
    );
  }

  Widget _buildDifficultyDropdown() {
    // Define the mapping
    final difficultyMap = {
      'Easy': '1',
      'Medium': '2',
      'Hard': '3',
    };

    return PopupMenuButton<String>(
      color: ColorConstant.grey,
      onSelected: (value) {
        setState(() {
          _controller.dropdownValue = value;

          final selectedApiValue = difficultyMap[value] ?? '1'; // default to '1' (Easy)

          final multiplier =
          Provider.of<MultiplierViewModel>(context, listen: false);
          multiplier.multiplierApi(selectedApiValue, context); // Send mapped value to API

          print('Selected difficulty: $value => API value: $selectedApiValue');
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
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: ColorConstant.grey,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            textWidget(
              text: _controller.dropdownValue ?? "Select",
              color: ColorConstant.white,
              fontWeight: FontWeight.bold,
              fontSize: Dimensions.fifteen,
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down,
              color: ColorConstant.white,
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildGoButton() {
    bool isDisabled = !_controller.hasUserPlacedBet ||
        _controller.selectedCoin == null ||
        _controller.isScrolling;
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
