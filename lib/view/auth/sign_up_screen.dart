import 'package:chicken_game/main.dart';
import 'package:chicken_game/res/color_constant.dart';
import 'package:chicken_game/res/custom_text_field.dart';
import 'package:chicken_game/res/primary_button.dart';
import 'package:chicken_game/res/text_widget.dart';
import 'package:chicken_game/res/view_model/auth_view_model.dart';
import 'package:chicken_game/utils/utils.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailCont = TextEditingController();
  TextEditingController mobileCont = TextEditingController();
  TextEditingController passCont = TextEditingController();
  bool hidePassword = true;
  final FocusNode _focusNodePass = FocusNode();

  @override
  void dispose() {
    _focusNodePass.dispose();
    super.dispose();
  }

  String selectedCountryCode = "+91";
  bool isChecked = false;

  @override
  Widget build(context) {
    final register = Provider.of<AuthViewModel>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorConstant.regBlackBg.withValues(alpha: 0.5),
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.02, vertical: screenHeight * 0.05),
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
          decoration: BoxDecoration(
              color: ColorConstant.regBlackBg,
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.05),
              textWidget(
                  text: 'SIGN UP',
                  color: ColorConstant.white,
                  fontWeight: FontWeight.w900,
                  fontSize: Dimensions.twentyFour),
              SizedBox(height: screenHeight * 0.01),
              CustomTextField(
                  fillColor: ColorConstant.textFieldBg,
                  cursorColor: ColorConstant.white,
                  labelText: 'Email',
                  controller: emailCont,
                  borderSide: const BorderSide(color: Colors.transparent),
                  labelColor: ColorConstant.white),
              SizedBox(height: screenHeight * 0.02),
              Row(
                children: [
                  Flexible(
                    flex: 2,
                    child: CountryCodePicker(
                        onChanged: (country) {
                          setState(() {
                            selectedCountryCode = country.dialCode!;
                          });
                        },
                        initialSelection: 'IN',
                        favorite: ['+91', '+1', '+44'],
                        showFlag: true,
                        showDropDownButton: true,
                        searchStyle: TextStyle(color: Colors.white),
                        dialogTextStyle: TextStyle(color: Colors.white),
                        textStyle: TextStyle(color: Colors.white),
                        searchDecoration: InputDecoration(
                          iconColor: Colors.white,
                          prefixIconColor: Colors.white,
                        ),
                        dialogBackgroundColor: Colors.black,
                        margin: EdgeInsets.zero,
                        padding: EdgeInsets.zero,
                        headerTextStyle: TextStyle(
                            color: Colors.white, fontSize: Dimensions.fifteen)),
                  ),
                  Flexible(
                    flex: 4,
                    child: CustomTextField(
                      maxLength: 10,
                      keyboardType: TextInputType.phone,
                      fillColor: ColorConstant.textFieldBg,
                      cursorColor: ColorConstant.white,
                      labelText: 'Phone number',
                      controller: mobileCont,
                      borderSide: const BorderSide(color: Colors.transparent),
                      labelColor: ColorConstant.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),
              CustomTextField(
                  focusNode: _focusNodePass,
                  fillColor: ColorConstant.textFieldBg,
                  obscureText: hidePassword,
                  cursorColor: ColorConstant.white,
                  labelText: 'Password',
                  controller: passCont,
                  borderSide: const BorderSide(color: Colors.transparent),
                  labelColor: ColorConstant.white,
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          hidePassword = !hidePassword;
                        });
                      },
                      icon: Icon(
                        hidePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: ColorConstant.white,
                      ))),
              Spacer(),
              PrimaryButton(
                onTap: () {
                  if (!isChecked) {
                    print("Please agree to the terms and conditions.");
                    ShowMessage.show(context,
                        message: 'Please agree to the Terms an conditions',
                        boxColor: Colors.orange);
                    return;
                  }
                  if (mobileCont.text.isNotEmpty ||
                      mobileCont.text.length == 10 &&
                          passCont.text.isNotEmpty) {
                    register.registerApi(
                        emailCont.text.toString(),
                        mobileCont.text.toString(),
                        passCont.text.toString(),
                        context);
                  } else {
                    ShowMessage.show(context,
                        message:
                            'Please Fill the Fields and mobile digit should be 10',
                        boxColor: Colors.red);
                  }
                },
                label: 'SIGN UP',
                borderRadius: BorderRadius.circular(50),
              ),
              SizedBox(height: screenHeight * 0.05),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isChecked = !isChecked;
                      });
                    },
                    child: Container(
                        alignment: Alignment.center,
                        height: screenHeight * 0.025,
                        width: screenWidth * 0.05,
                        decoration: BoxDecoration(
                            color: isChecked
                                ? Colors.blue
                                : Colors.white.withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(2)),
                        child: isChecked
                            ? textWidget(
                                text: '✔️',
                                fontSize: Dimensions.twelve,
                                color: Colors.white)
                            : null),
                  ),
                  RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(children: [
                        TextSpan(
                          text: 'I confirm all the  ',
                          style: TextStyle(
                            color: ColorConstant.grey,
                          ).merge(GoogleFonts.sourceSerif4()),
                        ),
                        TextSpan(
                          text: 'Terms of user agreement\n',
                          style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: ColorConstant.white,
                                  decoration: TextDecoration.underline)
                              .merge(GoogleFonts.sourceSerif4()),
                        ),
                        TextSpan(
                          text: 'and that I am over 18 ',
                          style: TextStyle(
                            color: ColorConstant.grey,
                          ).merge(GoogleFonts.sourceSerif4()),
                        ),
                      ]))
                ],
              ),
              SizedBox(height: screenHeight * 0.02),
              RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(children: [
                    TextSpan(
                      text: 'Already Registered?  ',
                      style: TextStyle(
                        color: ColorConstant.grey,
                      ).merge(GoogleFonts.sourceSerif4()),
                    ),
                    TextSpan(
                      text: 'Sign in',
                      style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: ColorConstant.white,
                              decoration: TextDecoration.underline)
                          .merge(GoogleFonts.sourceSerif4()),
                    ),
                  ])),
              SizedBox(height: screenHeight * 0.02),
            ],
          ),
        ),
      ),
    );
  }
}
