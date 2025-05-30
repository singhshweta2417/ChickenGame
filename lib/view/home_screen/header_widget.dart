import 'package:chicken_game/generated/assets.dart';
import 'package:chicken_game/main.dart';
import 'package:chicken_game/res/color_constant.dart';
import 'package:chicken_game/res/text_widget.dart';
import 'package:chicken_game/res/view_model/auth_view_model.dart';
import 'package:chicken_game/utils/routes/routes_name.dart';
import 'package:chicken_game/view/flutter/how_to_play.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../res/exit.dart';
import '../../res/view_model/user_view_model.dart';
import '../flutter/results_screen.dart';

class HeaderWidget extends StatefulWidget {
  const HeaderWidget({super.key});

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> with SingleTickerProviderStateMixin {
  late AnimationController _drawerController;
  bool _showMiniDrawer = false;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _drawerController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AuthViewModel>(context, listen: false).profileApi(context);
    });
  }

  @override
  void dispose() {
    _drawerController.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _toggleDrawer() {
    if (_showMiniDrawer) {
      _drawerController.reverse().then((_) {
        setState(() => _showMiniDrawer = false);
        _removeOverlay();
      });
    } else {
      setState(() => _showMiniDrawer = true);
      _showOverlay();
      _drawerController.forward();
    }
  }

  void _showOverlay() {
    final renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: position.dy + screenHeight * 0.07, // Below header
        right: 10,
        child: GestureDetector(
          onTap: _toggleDrawer,
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: _drawerController,
              curve: Curves.easeOut,
            ),
            alignment: Alignment.topRight,
            child: _buildMiniDrawer(),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  Widget _buildMiniDrawer() {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: screenWidth * 0.5,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: ColorConstant.headerBg,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDrawerItem(Icons.person, 'My Account', () {
              _toggleDrawer();
              Navigator.pushNamed(context, RoutesName.profileScreen);
            }),
            _buildDrawerItem(Icons.help, 'Results', () {
              _toggleDrawer();
              showDialog(
                  context: context, builder: (context) => ResultScreen());
            }),
            _buildDrawerItem(Icons.help, 'How to play', () {
              _toggleDrawer();
              showDialog(
                  context: context, builder: (context) => HowToPlayScreen());
            }),
            // _buildDrawerItem(Icons.info, 'About us', () {
            //   _toggleDrawer();
            //   // Navigator.pushNamed(context, RoutesName.aboutScreen);
            // }),
            _buildDrawerItem(Icons.logout, 'Logout', () {
              _toggleDrawer();
              showBackDialog(
                message: 'Are You Sure want to Logout?',
                context: context,
                yes: () {
                  final userPref =
                  Provider.of<UserViewModel>(context, listen: false);
                  userPref.remove();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    RoutesName.login,
                        (Route<dynamic> route) => false,
                  );
                  SystemNavigator.pop();
                  HapticFeedback.vibrate();
                },
              );
              // Add logout functionality
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(icon, color: ColorConstant.white, size: 20),
            const SizedBox(width: 10),
            textWidget(
              text: text,
              color: ColorConstant.white,
              fontSize: Dimensions.fifteen,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileView =
        Provider.of<AuthViewModel>(context).userDetailsResponse?.profile;
    return Container(
      height: screenHeight * 0.07,
      width: screenWidth,
      color: ColorConstant.headerBg,
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, RoutesName.profileScreen);
            },
            child: CircleAvatar(
              radius: 25,
              backgroundColor: ColorConstant.blueColor,
              child: CircleAvatar(
                radius: 23,
                backgroundImage: profileView?.profileImage != null
                    ? NetworkImage(profileView!.profileImage.toString())
                    : const AssetImage(Assets.imagesGoldenEgg) as ImageProvider,
              ),
            ),
          ),
          textWidget(
            text: '  CHICKEN\n   ROAD',
            fontSize: Dimensions.fifteen,
            color: ColorConstant.white,
            fontWeight: FontWeight.bold,
          ),
          const Spacer(),
          Container(
            margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
            width: screenWidth * 0.4,
            decoration: BoxDecoration(
              color: ColorConstant.grey.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                textWidget(
                  text: profileView?.amount.toString() ?? '',
                  fontWeight: FontWeight.bold,
                  color: ColorConstant.white,
                ),
                Icon(
                  Icons.currency_rupee,
                  size: 18,
                  color: ColorConstant.white,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: _toggleDrawer,
            icon: Icon(
              Icons.menu,
              color: ColorConstant.white,
            ),
          ),
        ],
      ),
    );
  }
}