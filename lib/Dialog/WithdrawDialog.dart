
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kindbike_for_dealer/Singleton/singleton.dart';

import '../API/rest_client.dart';
import '../main.dart';

class SignOutPopup extends StatelessWidget {
  const SignOutPopup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Singleton singleton = Singleton();
    final dio = Dio();
    dio.options.headers["Content-Type"] = "application/json";
    final api = RestClient(dio);

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
            margin: const EdgeInsets.symmetric(vertical: 25),
            child: const Text('회원을 탈퇴하시겠습니까?', style: TextStyle(fontSize: 15, color: Colors.black)),
          ),
          Row(children: [
            Expanded(child: Container(
              height: 50,
              margin: const EdgeInsets.only(right: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black
              ),
              child: TextButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: const Text('취소', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            )),
            Expanded(child: Container(
              height: 50,
              margin: const EdgeInsets.only(left: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: HexColor('EEEEEE')
              ),
              child: TextButton(
                onPressed: (){
                  api.withdrawDealer(singleton.idx).then((value) => {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (BuildContext context) => const Login()),
                            (route) => false
                    )
                  });
                },
                child: const Text('확인', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey)),
              ),
            ))
          ])
        ]),
      ),
    );
  }
}
