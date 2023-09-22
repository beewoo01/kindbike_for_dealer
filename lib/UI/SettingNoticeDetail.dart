import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../API/rest_client.dart';
import '../Model/NoticeModel.dart';
import 'HomeContainer.dart';

class SettingNoticeDetail extends StatefulWidget {
  const SettingNoticeDetail({Key? key}) : super(key: key);

  @override
  State<SettingNoticeDetail> createState() => _SettingNoticeDetailState();
}

class _SettingNoticeDetailState extends State<SettingNoticeDetail> {
  @override
  Widget build(BuildContext context) {
    int idx = HomeContainerState.of(context)!.noticeIdx;
    final dio = Dio();
    dio.options.headers["Content-Type"] = "application/json";
    final api = RestClient(dio);

    return WillPopScope(
      onWillPop: (){
        HomeContainerState.of(context)?.bottomTapped(7);
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
                      HomeContainerState.of(context)?.bottomTapped(7);
                    },
                    icon: Image.asset("assets/ic_back.png")),
              ),
              const Text('공지사항', style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),textAlign: TextAlign.center),
              const SizedBox(width: 50)
            ]),
          ),
          Expanded(child: FutureBuilder(
            future: api.getNoticeDetail(idx),
            builder: (context, AsyncSnapshot snapshot){
              if(snapshot.hasData){
                NoticeModel model = snapshot.data as NoticeModel;
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(children: [
                    Container(
                      alignment: const Alignment(-1.0,0.0),
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text('${model.notice_title}', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black)),
                    ),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.fromLTRB(20, 15, 20, 30),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: HexColor('EEEEEE')
                      ),
                      child: Text('${model.notice_detail}', style: const TextStyle(fontSize: 15, color: Colors.black),),
                    )
                  ]),
                );
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
