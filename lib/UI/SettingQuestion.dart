import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kindbike_for_dealer/Singleton/singleton.dart';

import '../API/rest_client.dart';
import '../Model/QuestionModel.dart';
import 'HomeContainer.dart';

class SettingQuestion extends StatefulWidget {
  const SettingQuestion({Key? key}) : super(key: key);

  @override
  State<SettingQuestion> createState() => _SettingQuestionState();
}

class _SettingQuestionState extends State<SettingQuestion> {
  Singleton singleton = Singleton();

  @override
  Widget build(BuildContext context) {
    final dio = Dio();
    dio.options.headers["Content-Type"] = "application/json";
    final api = RestClient(dio);

    return WillPopScope(
      onWillPop: (){
        HomeContainerState.of(context)?.bottomTapped(2);
        return Future(() => false);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(children: [
          SizedBox(
            width: double.infinity,
            height: 100,
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              SizedBox(
                width: 50,
                height: 50,
                child: IconButton(
                    onPressed: (){
                      HomeContainerState.of(context)?.bottomTapped(2);
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
            future: api.getQuestion(singleton.idx),
            builder: (context, AsyncSnapshot snapshot){
              if(snapshot.hasData){
                List<QuestionModel> list = snapshot.data as List<QuestionModel>;
                return ListView.builder(
                    padding: const EdgeInsets.only(top: 10),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: list.length,
                    itemBuilder: (BuildContext context, int index){
                      return GestureDetector(
                        onTap: (){
                          HomeContainerState.of(context)!.questionIdx = list[index].question_idx!;
                          HomeContainerState.of(context)?.bottomTapped(11);
                        },
                        child: Container(
                          width: double.infinity,
                          height: 60,
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: HexColor('DDDDDD'),
                                  width: 1.0
                              ),
                              color: Colors.white
                          ),
                          child: Row(children: [
                            Expanded(child: Text('${list[index].question_title}', style:
                            const TextStyle(color: Colors.black, fontSize: 15, overflow: TextOverflow.ellipsis),)),
                            const Image(image: AssetImage('assets/notice_go.png'))
                          ]),
                        ),
                      );
                    }
                );
              }else{
                return Container();
              }
            },
          )),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.black
            ),
            child: TextButton(
              onPressed: (){
                HomeContainerState.of(context)?.bottomTapped(10);
              },
              child: const Text('문의 등록', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),),
            ),
          )
        ]),
      ),
    );
  }
}
