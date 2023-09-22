import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../API/rest_client.dart';
import '../Model/QuestionModel.dart';
import 'HomeContainer.dart';

class SettingQuestionDetail extends StatefulWidget {
  const SettingQuestionDetail({Key? key}) : super(key: key);

  @override
  State<SettingQuestionDetail> createState() => _SettingQuestionDetailState();
}

class _SettingQuestionDetailState extends State<SettingQuestionDetail> {
  @override
  Widget build(BuildContext context) {
    final dio = Dio();
    dio.options.headers["Content-Type"] = "application/json";
    final api = RestClient(dio);

    int idx = HomeContainerState.of(context)!.questionIdx;

    return WillPopScope(
      onWillPop: (){
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
          Expanded(child: FutureBuilder(
            future: api.getQuestionDetail(idx),
            builder: (context, AsyncSnapshot snapshot){
              if(snapshot.hasData){
                QuestionModel model = snapshot.data as QuestionModel;
                return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Row(children: [
                      const Image(image: AssetImage('assets/icon_q.png')),
                      Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: const Text('문의 내용', style: TextStyle(fontWeight: FontWeight.w800, color: Colors.black, fontSize: 25)),
                      )
                    ]),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Text('${model.question_title}', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black)),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    color: Colors.black,
                    width: double.infinity,
                    height: 1.5,
                  ),
                  Expanded(child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(10),
                      child: SingleChildScrollView(
                          child: Text('${model.question_detail}', style: const TextStyle(color: Colors.black),)
                      )
                  )),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Row(children: [
                      const Image(image: AssetImage('assets/icon_a.png')),
                      Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: const Text('문의 답변', style: TextStyle(fontWeight: FontWeight.w800, color: Colors.black, fontSize: 25)),
                      )
                    ]),
                  ),
                  Expanded(child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: HexColor('EEEEEE')
                      ),
                      child: SingleChildScrollView(
                          child: Text(model.question_answer_detail == null ? '' : model.question_answer_detail!, style: const TextStyle(color: Colors.black),)
                      )
                  )),
                ]);
              }else{
                return Container();
              }
            },
          ))
        ]),
      ),
    );
  }
}
