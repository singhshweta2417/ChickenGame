import 'package:chicken_game/generated/assets.dart';
import 'package:chicken_game/main.dart';
import 'package:chicken_game/res/primary_button.dart';
import 'package:chicken_game/res/text_widget.dart';
import 'package:chicken_game/res/view_model/today_result_view_model.dart';
import 'package:chicken_game/view/flutter/today_result_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../res/view_model/bet_history_view_model.dart';
import 'bet_history_screen.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final today = Provider.of<TodayResultViewModel>(context, listen: false);
      today.todayResultApi(context);
      final betHistory =
          Provider.of<BetHistoryViewModel>(context, listen: false);
      betHistory.betHistoryApi(context);
    });
  }

  bool selectedButton = true;
  @override
  Widget build(BuildContext context) {
    final today = Provider.of<TodayResultViewModel>(context);
    final betHistory = Provider.of<BetHistoryViewModel>(context);
    return Dialog(
      child: Container(
        height: screenHeight * 0.6,
        width: screenWidth,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(Assets.imagesDialogeBoxCont),
                fit: BoxFit.fill)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      selectedButton = !selectedButton;
                    });
                    betHistory.betHistoryApi(context);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: screenHeight * 0.05,
                    width: screenWidth * 0.3,
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color:
                                    selectedButton ? Colors.white : Colors.grey,
                                width: 2))),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedButton = !selectedButton;
                        });
                        today.todayResultApi(context);
                      },
                      child: textWidget(
                          text: "Today's Result",
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: selectedButton ? Colors.white : Colors.grey),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      selectedButton = !selectedButton;
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: screenHeight * 0.05,
                    width: screenWidth * 0.3,
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: !selectedButton
                                    ? Colors.white
                                    : Colors.grey,
                                width: 2))),
                    child: textWidget(
                        text: 'History Result',
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: !selectedButton ? Colors.white : Colors.grey),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: screenHeight * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                rowConst('S.No.', screenWidth * 0.1),
                rowConst('Bet Amount', screenWidth * 0.15),
                rowConst('Win Amount', screenWidth * 0.15),
                rowConst('CashOut', screenWidth * 0.2),
                rowConst('Date', screenWidth * 0.1),
              ],
            ),
            SizedBox(
              height: screenHeight * 0.02,
            ),
            !selectedButton ? BetHistoryScreen() : TodayResultScreen(),
            Spacer(),
            PrimaryButton(
              onTap: () {
                Navigator.pop(context);
              },
              width: screenWidth * 0.3,
              height: screenHeight * 0.05,
              color: Colors.grey,
              child: textWidget(text: 'Exit', color: Colors.white),
            ),
            SizedBox(
              height: screenHeight * 0.02,
            ),
          ],
        ),
      ),
    );
  }

  Widget rowConst(String text, screenWidth) {
    return Container(
        height: screenHeight * 0.05,
        width: screenWidth,
        alignment: Alignment.center,
        child: textWidget(
            textAlign: TextAlign.center,
            text: text,
            fontSize: Dimensions.thirteen,
            color: Colors.white,
            fontWeight: FontWeight.w700));
  }
}
