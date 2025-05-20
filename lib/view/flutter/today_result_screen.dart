import 'package:chicken_game/main.dart';
import 'package:chicken_game/res/text_widget.dart';
import 'package:chicken_game/res/view_model/today_result_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../helper/response/status.dart';

class TodayResultScreen extends StatefulWidget {
  const TodayResultScreen({super.key});

  @override
  State<TodayResultScreen> createState() => _TodayResultScreenState();
}

class _TodayResultScreenState extends State<TodayResultScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final betHistory =
          Provider.of<TodayResultViewModel>(context, listen: false);
      betHistory.todayResultApi(context);
    });
  }

  bool selectedButton = true;
  @override
  Widget build(BuildContext context) {
    return Consumer<TodayResultViewModel>(builder: (context, value, _) {
      switch (value.todayResultModel.success) {
        case Success.LOADING:
          return Container(
            height: screenHeight * 0.3,
            width: screenWidth,
            alignment: Alignment.center,
            child: const CircularProgressIndicator(),
          );
        case Success.ERROR:
          return Container();
        case Success.COMPLETED:
          if (value.todayResultModel.data != null &&
              value.todayResultModel.data!.data != null &&
              value.todayResultModel.data!.data!.isNotEmpty) {
            final betHistory = value.todayResultModel.data!.data!;
            return Column(
              children: List.generate(betHistory.length, (index) {
                DateTime parsedDate =
                    DateTime.parse(betHistory[index].createdAt.toString());
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    rowConst('${index + 1}', screenWidth * 0.08),
                    rowConst(
                        betHistory[index].amount.toString(), screenWidth * 0.2),
                    rowConst(betHistory[index].winAmount.toString(),
                        screenWidth * 0.15),
                    rowConst(betHistory[index].multiplier.toString(),
                        screenWidth * 0.15),
                    rowConst(DateFormat('dd-MM-yy').format(parsedDate),
                        screenWidth * 0.15),
                  ],
                );
              }),
            );
          } else {
            return Container();
          }
        case null:
          // TODO: Handle this case.
          throw UnimplementedError();
      }
    });
  }

  Widget rowConst(String text, screenWidth) {
    return Container(
        height: screenHeight * 0.04,
        width: screenWidth,
        alignment: Alignment.center,
        child: textWidget(
            text: text,
            fontSize: Dimensions.thirteen,
            color: Colors.white,
            fontWeight: FontWeight.w700));
  }
}
