import 'package:chicken_game/main.dart';
import 'package:chicken_game/res/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../helper/response/status.dart';
import '../../res/view_model/bet_history_view_model.dart';

class BetHistoryScreen extends StatefulWidget {
  const BetHistoryScreen({super.key});

  @override
  State<BetHistoryScreen> createState() => _BetHistoryScreenState();
}

class _BetHistoryScreenState extends State<BetHistoryScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final betHistory =
          Provider.of<BetHistoryViewModel>(context, listen: false);
      betHistory.betHistoryApi(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BetHistoryViewModel>(builder: (context, value, _) {
      switch (value.betHistoryModel.success) {
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
          if (value.betHistoryModel.data != null &&
              value.betHistoryModel.data!.data != null &&
              value.betHistoryModel.data!.data!.isNotEmpty) {
            final betHistory = value.betHistoryModel.data!.data!;
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
            text: text, fontSize: Dimensions.thirteen, color: Colors.white));
  }
}
