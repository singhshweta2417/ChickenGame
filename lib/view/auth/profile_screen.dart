import 'dart:convert';
import 'dart:io';
import 'package:chicken_game/generated/assets.dart';
import 'package:chicken_game/main.dart';
import 'package:chicken_game/res/color_constant.dart';
import 'package:chicken_game/res/custom_text_field.dart';
import 'package:chicken_game/res/primary_button.dart';
import 'package:chicken_game/res/text_widget.dart';
import 'package:chicken_game/res/view_model/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../utils/utils.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  File? _image;
  final picker = ImagePicker();
  String? base64Image;

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      base64Image = base64Encode(_image!.readAsBytesSync());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final chicken = Provider.of<AuthViewModel>(context, listen: false);
      chicken.profileApi(context);
      if (chicken.userDetailsResponse?.profile != null) {
        nameController.text =
            chicken.userDetailsResponse?.profile?.name.toString() ?? '';
        emailController.text =
            chicken.userDetailsResponse?.profile?.email.toString() ?? '';
        phoneController.text =
            chicken.userDetailsResponse?.profile?.mobile.toString() ?? '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: textWidget(text: 'Profile Screen'),
      ),
      resizeToAvoidBottomInset: false,
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
              SizedBox(height: screenHeight * 0.02),
              _buildNameField(),
              SizedBox(height: screenHeight * 0.02),
              _buildEmailField(),
              SizedBox(height: screenHeight * 0.02),
              _buildPhoneField(),
              SizedBox(height: screenHeight * 0.02),
              _buildSignInButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginTitle() {
    final viewProfile = Provider.of<AuthViewModel>(context);
    final profileImageUrl =
        viewProfile.userDetailsResponse?.profile?.profileImage;

    ImageProvider imageProvider;

    if (_image != null) {
      imageProvider = FileImage(_image!);
    } else if (profileImageUrl != null && profileImageUrl.isNotEmpty) {
      imageProvider = NetworkImage(profileImageUrl);
    } else {
      imageProvider = AssetImage(Assets.chickensChickenRoast);
    }

    return GestureDetector(
      onTap: () => _getImage(ImageSource.gallery),
      child: CircleAvatar(
        radius: 50,
        backgroundColor: Colors.blue,
        child: CircleAvatar(
          radius: 48,
          backgroundImage: imageProvider,
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return CustomTextField(
        controller: nameController,
        fillColor: ColorConstant.textFieldBg,
        cursorColor: ColorConstant.white,
        labelText: 'Name',
        borderSide: const BorderSide(color: Colors.transparent),
        labelColor: ColorConstant.white);
  }

  Widget _buildEmailField() {
    return CustomTextField(
        controller: emailController,
        fillColor: ColorConstant.textFieldBg,
        cursorColor: ColorConstant.white,
        labelText: 'Email',
        borderSide: const BorderSide(color: Colors.transparent),
        labelColor: ColorConstant.white);
  }

  Widget _buildPhoneField() {
    return CustomTextField(
        maxLength: 10,
        controller: phoneController,
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

  Widget _buildSignInButton() {
    final profileUpdate = Provider.of<AuthViewModel>(context);
    return PrimaryButton(
      label: 'Confirm',
      onTap: () {
        if (phoneController.text.isNotEmpty ||
            phoneController.text.length == 10) {
          profileUpdate.updateProfileApi(
              nameController.text.toString(),
              emailController.text.toString(),
              phoneController.text.toString(),
              base64Image.toString(),
              context);
        } else {
          ShowMessage.show(context,
              message: 'Please Fill the Fields and mobile digit should be 10',
              boxColor: Colors.red);
        }
        // Navigator.pushNamed(context, RoutesName.homeScreen);
      },
      borderRadius: BorderRadius.circular(20),
    );
  }
}
