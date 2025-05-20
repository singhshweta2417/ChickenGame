import 'package:flutter/material.dart';

class SwitchToggleExample extends StatefulWidget {
  @override
  _SwitchToggleExampleState createState() => _SwitchToggleExampleState();
}

class _SwitchToggleExampleState extends State<SwitchToggleExample> {
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Switch Toggle Example')),
      body: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(isSwitched ? 'ON' : 'OFF'),
            Switch(
              splashRadius:30,
              value: isSwitched,
                padding:EdgeInsets.symmetric(vertical: 40),
              onChanged: (value) {
                setState(() {
                  isSwitched = value;
                });
              },
              activeColor: Colors.green,
              inactiveThumbColor: Colors.grey,
              inactiveTrackColor: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}
