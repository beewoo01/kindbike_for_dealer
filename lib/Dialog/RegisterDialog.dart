import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:kindbike_for_dealer/Singleton/singleton.dart';

import '../API/rest_client.dart';

class RegisterPurchase extends StatelessWidget {
  final int idx;
  const RegisterPurchase({Key? key, required this.idx}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Singleton singleton = Singleton();
    final tec = TextEditingController();
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
            alignment: const Alignment(-1.0,0.0),
            child: const Text('매입 견적 등록', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 22),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 5),
            alignment: const Alignment(-1.0,0.0),
            child: const Text('매입 금액을 입력하세요.', style: TextStyle(color: Colors.black)),
          ),
          Container(
            margin: const EdgeInsets.only(top: 7),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.black,
                  width: 1.0
                )
              )
            ),
            child: Row(children: [
              Expanded(child: TextField(
                maxLines: 1,
                controller: tec,
                keyboardType: TextInputType.number,
                style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w800, color: Colors.black),
                decoration: null,
                onChanged: (value){
                  final formatter = NumberFormat('#,###');
                  final newText = formatter.format(int.parse(value.replaceAll(',', '')));
                  tec.value = TextEditingValue(
                    text: newText,
                    selection: TextSelection.fromPosition(
                      TextPosition(offset: newText.length),
                    ),
                  );
                },
              )),
              const Text('원', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.black))
            ]),
          ),
          Container(
            margin: const EdgeInsets.only(top: 5, bottom: 20),
            child: const Text('찔러보기식 견적, 허위견적은 이용에 제한을 당할 수 있습니다.',
                style: TextStyle(fontSize: 10, color: Colors.red, overflow: TextOverflow.ellipsis)),
          ),
          Row(children: [
            Expanded(child: Container(
              height: 50,
              margin: const EdgeInsets.only(right: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: HexColor('DDDDDD')
              ),
              child: TextButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: const Text('취소', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),),
              ),
            ),),
            Expanded(child: Container(
              height: 50,
              margin: const EdgeInsets.only(left: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black
              ),
              child: TextButton(
                onPressed: (){
                  api.registEstimate(idx, singleton.idx, tec.text.replaceAll(',', '')).then((value) => {
                    if(value == 1){
                      Navigator.pop(context)
                    }
                  });
                },
                child: const Text('확인', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
              ),
            ),)
          ])
        ]),
      ),
    );
  }
}
