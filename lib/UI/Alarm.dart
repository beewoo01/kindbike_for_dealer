import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kindbike_for_dealer/Model/AlarmModel.dart';
import 'package:kindbike_for_dealer/Singleton/singleton.dart';

import '../API/rest_client.dart';
import 'HomeContainer.dart';

class Alarm extends StatefulWidget {
  const Alarm({Key? key}) : super(key: key);

  @override
  State<Alarm> createState() => _AlarmState();
}

class _AlarmState extends State<Alarm> {
  Singleton singleton = Singleton();

  @override
  Widget build(BuildContext context) {
    final dio = Dio();
    dio.options.headers["Content-Type"] = "application/json";
    final api = RestClient(dio);

    return WillPopScope(
      onWillPop: (){
        HomeContainerState.of(context)?.bottomTapped(1);
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
                      HomeContainerState.of(context)?.bottomTapped(1);
                    },
                    icon: Image.asset("assets/ic_back.png")),
              ),
              const Text('알림 목록', style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),textAlign: TextAlign.center),
              const SizedBox(width: 50)
            ],
            ),
          ),
          Expanded(child: FutureBuilder(
            future: api.selectDealerAlarmList(singleton.idx),
            builder: (context, AsyncSnapshot snapshot){
              if(snapshot.hasData){
                List<AlarmModel> list = snapshot.data;
                return ListView.builder(
                    padding: const EdgeInsets.only(top: 10),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: list.length,
                    itemBuilder: (BuildContext context, int index){
                      return Container(
                        margin: const EdgeInsets.fromLTRB(20, 0, 20, 15),
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey, width: 1.0),
                            color: Colors.white
                        ),
                        child: Text('${list[index].alarm_dealer_detail}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),),
                      );
                    }
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
