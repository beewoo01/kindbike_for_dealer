
import 'package:flutter/material.dart';


class FailLoginPopup extends StatelessWidget {
  const FailLoginPopup({Key? key}) : super(key: key);

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
            margin: const EdgeInsets.only(top: 10),
            child: const Image(image: AssetImage('assets/icon_popup.png')),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            child: const Text('로그인 계정이\n일치하지 않습니다.', style: TextStyle(fontSize: 15, color: Colors.black),textAlign: TextAlign.center),
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
