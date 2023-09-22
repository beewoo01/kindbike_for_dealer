
import 'package:flutter/material.dart';


class AccountDialog extends StatelessWidget {
  final String content;
  final String keyStr;

  const AccountDialog({Key? key, required this.content, required this.keyStr}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.all(10),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 30),
            child: Text.rich(
              TextSpan(text: '$content\n', children: <TextSpan>[
                TextSpan(
                    text: keyStr,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const TextSpan(text: ' 입니다.')
              ]),
              style: const TextStyle(fontSize: 15, color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.black
            ),
            child: TextButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: const Text('확인', style: TextStyle(color: Colors.white, fontSize: 17)),
            ),
          )
        ]),
      ),
    );
  }
}
