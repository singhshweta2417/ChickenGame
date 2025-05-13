import 'package:chicken_game/generated/assets.dart';
import 'package:chicken_game/main.dart';
import 'package:chicken_game/res/color_constant.dart';
import 'package:chicken_game/res/custom_text_field.dart';
import 'package:chicken_game/res/primary_button.dart';
import 'package:chicken_game/res/text_widget.dart';
import 'package:chicken_game/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();
  bool _hidePassword = true;
  bool _isEmailSelected = true;

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.5),
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.02, vertical: screenHeight * 0.05),
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.05),
              _buildLoginTitle(),
              SizedBox(height: screenHeight * 0.01),
              _buildLoginMethodToggle(),
              SizedBox(height: screenHeight * 0.02),
              _isEmailSelected ? _buildEmailField() : _buildPhoneField(),
              SizedBox(height: screenHeight * 0.02),
              _buildPasswordField(),
              SizedBox(height: screenHeight * 0.02),
              _buildPasswordRecoveryText(),
              Spacer(),
              _buildSignUpText(),
              SizedBox(height: screenHeight * 0.02),
              _buildSignInButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginTitle() {
    return textWidget(
      text: 'Login',
      color: Colors.white,
      fontWeight: FontWeight.w900,
      fontSize: 24,
    );
  }

  Widget _buildLoginMethodToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildToggleButton(
          icon: Icons.mail,
          label: 'Email',
          isSelected: _isEmailSelected,
          onTap: () => setState(() => _isEmailSelected = true),
        ),
        _buildToggleButton(
          icon: Icons.phone_android,
          label: 'Phone',
          isSelected: !_isEmailSelected,
          onTap: () => setState(() => _isEmailSelected = false),
        ),
      ],
    );
  }

  Widget _buildToggleButton({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        height: screenHeight * 0.065,
        width: screenWidth * 0.45,
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : ColorConstant.textFieldBg,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                color: isSelected
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.3)),
            SizedBox(width: 8),
            textWidget(
              text: label,
              color: isSelected
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.5),
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return CustomTextField(
        controller: _emailController,
        fillColor: ColorConstant.textFieldBg,
        cursorColor: ColorConstant.white,
        labelText: 'Email',
        borderSide: const BorderSide(color: Colors.transparent),
        labelColor: ColorConstant.white);
  }

  Widget _buildPhoneField() {
    return CustomTextField(
        controller: _phoneController,
        keyboardType: TextInputType.phone,
        fillColor: ColorConstant.textFieldBg,
        cursorColor: ColorConstant.white,
        labelText: 'Phone Number',
        prefixIcon: Padding(
            padding: EdgeInsets.only(right: screenWidth * 0.02),
            child: SizedBox(
              width: screenWidth * 0.25,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image(
                    image: const AssetImage(Assets.iconsIndianIcon),
                    width: screenWidth * 0.06,
                  ),
                  textWidget(
                      text: '+91',
                      color: ColorConstant.white,
                      fontSize: Dimensions.fifteen),
                  const VerticalDivider(
                    color: ColorConstant.white,
                    indent: 7,
                    endIndent: 7,
                  )
                ],
              ),
            )),
        borderSide: const BorderSide(color: Colors.transparent),
        labelColor: ColorConstant.white);
  }

  Widget _buildPasswordField() {
    return CustomTextField(
        controller: _passwordController,
        focusNode: _passwordFocusNode,
        obscureText: _hidePassword,
        suffixIcon: IconButton(
          onPressed: () => setState(() => _hidePassword = !_hidePassword),
          icon: Icon(
            _hidePassword ? Icons.visibility_off : Icons.visibility,
            color: Colors.white,
          ),
        ),
        fillColor: ColorConstant.textFieldBg,
        cursorColor: ColorConstant.white,
        labelText: 'Password',
        borderSide: const BorderSide(color: Colors.transparent),
        labelColor: ColorConstant.white);
  }

  Widget _buildPasswordRecoveryText() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: "Don't remember?  ",
            style:
                TextStyle(color: Colors.grey).merge(GoogleFonts.sourceSerif4()),
          ),
          TextSpan(
            text: 'Recover a password',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Colors.white,
              decoration: TextDecoration.underline,
            ).merge(GoogleFonts.sourceSerif4()),
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpText() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: "Don't have an account?  \n",
            style:
                TextStyle(color: Colors.grey).merge(GoogleFonts.sourceSerif4()),
          ),
          TextSpan(
            text: 'Sign up',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Colors.white,
              decoration: TextDecoration.underline,
            ).merge(GoogleFonts.sourceSerif4()),
          ),
        ],
      ),
    );
  }

  Widget _buildSignInButton() {
    return PrimaryButton(
      label: 'SIGN IN',
      onTap: () {
        Navigator.pushNamed(context, RoutesName.homeScreen);
      },
      borderRadius: BorderRadius.circular(20),
    );
  }
}
