import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kindbike_for_dealer/Singleton/singleton.dart';
import 'package:toast/toast.dart';

import '../API/rest_client.dart';
import 'HomeContainer.dart';

class SettingQuestionAdd extends StatefulWidget {
  const SettingQuestionAdd({Key? key}) : super(key: key);

  @override
  State<SettingQuestionAdd> createState() => _SettingQuestionAddState();
}

class _SettingQuestionAddState extends State<SettingQuestionAdd> {
  Singleton singleton = Singleton();

  late TextEditingController _titleText, _detailText;
  late FocusNode _titleFocus, _detailFocus;

  @override
  void initState() {
    super.initState();
    _titleText = TextEditingController();
    _detailText = TextEditingController();
    _titleFocus = FocusNode();
    _detailFocus = FocusNode();
  }
  void clearText(){
    setState(() {
      _titleText.clear();
      _detailText.clear();
      _titleFocus.unfocus();
      _detailFocus.unfocus();
    });
  }

  @override
  void dispose() {
    print('dispose');
    _titleText.dispose();
    _detailText.dispose();
    _titleFocus.dispose();
    _detailFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    final dio = Dio();
    dio.options.headers["Content-Type"] = "application/json";
    final api = RestClient(dio);

    return WillPopScope(
      onWillPop: (){
        clearText();
        HomeContainerState.of(context)?.bottomTapped(9);
        return Future(() => false);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            width: double.infinity,
            height: 100,
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              SizedBox(
                width: 50,
                height: 50,
                child: IconButton(
                    onPressed: (){
                      clearText();
                      HomeContainerState.of(context)?.bottomTapped(9);
                    },
                    icon: Image.asset("assets/ic_back.png")),
              ),
              const Text('문의하기', style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),textAlign: TextAlign.center),
              const SizedBox(width: 50)
            ],
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 5),
            child: const Text('문의 등록', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800, color: Colors.black)),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: const Text('문의사항을 작성해주세요.', style: TextStyle(color: Colors.black)),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(20, 15, 20, 0),
            child: TextField(
              controller: _titleText,
              focusNode: _titleFocus,
              decoration: const InputDecoration(hintText: '제목을 입력해 주세요.'),
            ),
          ),
          Expanded(child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: TextField(
              controller: _detailText,
              focusNode: _detailFocus,
              decoration: const InputDecoration(hintText: '내용을 입력해 주세요.'),
              maxLines: 20,
            ),
          )),
          Container(
              width: double.infinity,
              height: 45,
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 30),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black
              ),
              child: TextButton(
                  onPressed: (){
                    api.registQuestion(singleton.idx, _titleText.text, _detailText.text).then((value) => {
                      if(value == 1){
                        clearText(),
                        Toast.show('등록되었습니다.', duration: Toast.lengthShort, gravity: Toast.bottom),
                        HomeContainerState.of(context)?.bottomTapped(9),
                      }
                    });
                  },
                  child: const Text('제출', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),))
          )
        ]),
      ),
    );
  }
}
