import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kindbike_for_dealer/Dialog/WithdrawDialog.dart';
import 'package:kindbike_for_dealer/Singleton/singleton.dart';

import '../API/rest_client.dart';
import '../main.dart';
import 'HomeContainer.dart';

class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {


  @override
  Widget build(BuildContext context) {
    Singleton singleton = Singleton();
    final dio = Dio();
    dio.options.headers["Content-Type"] = "application/json";
    final api = RestClient(dio);

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(children: [
          Container(
            width: double.infinity,
            alignment: const Alignment(0.0,0.0),
            height: 100,
            child: const Text('설정', style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),textAlign: TextAlign.center),
          ),
          Expanded(flex: 3, child: FutureBuilder(
            future: api.selectAlarmState(singleton.idx),
            builder: (context, AsyncSnapshot snapshot){
              if(snapshot.hasData){
                bool alarm;
                if(snapshot.data == 1){
                  alarm = true;
                }else{
                  alarm = false;
                }
                return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xFFEEEEEE)
                  ),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    const Expanded(child: Text('알림 설정', style: TextStyle(fontSize: 15, color: Colors.black))),
                    FlutterSwitch(
                      width: 60.0,
                      height: 30.0,
                      toggleColor: Colors.white,
                      activeColor: Colors.black,
                      inactiveColor: Colors.grey,
                      value: alarm,
                      onToggle: (value) {
                        setState(() {
                          alarm = value;
                        });
                        if(alarm){
                          api.updateDealerAlarm(1, singleton.idx);
                        }else{
                          api.updateDealerAlarm(0, singleton.idx);
                        }
                      },
                    )
                  ],),
                );
              }else{
                return Container();
              }
            },
          )),
          Expanded(flex: 7, child: Container(
            margin: const EdgeInsets.fromLTRB(20, 20, 20, 5),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Expanded(child: GestureDetector(
                onTap: (){
                  HomeContainerState.of(context)?.bottomTapped(7);
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: const Color(0xffdddddd),
                          width: 1.0
                      ),
                      color: Colors.white
                  ),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const Image(image: AssetImage('assets/icon_notice.png')),
                    Container(margin: const EdgeInsets.only(top: 15), child: const Text('공지사항', style: TextStyle(fontSize: 15, color: Colors.black)),)
                  ],),
                ),
              )),
              Expanded(child: GestureDetector(
                onTap: (){
                  HomeContainerState.of(context)?.bottomTapped(5);
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: const Color(0xffdddddd),
                          width: 1.0
                      ),
                      color: Colors.white
                  ),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const Image(image: AssetImage('assets/icon_faq.png')),
                    Container(margin: const EdgeInsets.only(top: 15), child: const Text('FAQ', style: TextStyle(fontSize: 15, color: Colors.black)),)
                  ],),
                ),
              ))
            ],),
          )),
          Expanded(flex: 7, child: Container(
            margin: const EdgeInsets.fromLTRB(20, 5, 20, 20),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Expanded(child: GestureDetector(
                onTap: (){
                  HomeContainerState.of(context)?.bottomTapped(9);
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: const Color(0xffdddddd),
                          width: 1.0
                      ),
                      color: Colors.white
                  ),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const Image(image: AssetImage('assets/icon_inquiry.png')),
                    Container(margin: const EdgeInsets.only(top: 15), child: const Text('문의하기', style: TextStyle(fontSize: 15, color: Colors.black)),)
                  ],),
                ),
              )),
              Expanded(child: GestureDetector(
                onTap: (){
                  HomeContainerState.of(context)?.bottomTapped(6);
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: const Color(0xffdddddd),
                          width: 1.0
                      ),
                      color: Colors.white
                  ),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const Image(image: AssetImage('assets/icon_mystore.png')),
                    Container(margin: const EdgeInsets.only(top: 15), child: const Text('내 업체 정보', style: TextStyle(fontSize: 15, color: Colors.black)),)
                  ],),
                ),
              ))
            ],),
          )),
          Expanded(flex: 3, child: GestureDetector(
            onTap: (){
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) => const Login()),
                      (route) => false
              );
            },
            child: Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 5),
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: HexColor('EEEEEE')
              ),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const [
                Text('로그아웃', style: TextStyle(fontSize: 15, color: Colors.grey)),
                Image(image: AssetImage('assets/notice_go.png'))
              ]),
            ),
          )),
          Expanded(flex: 3, child: GestureDetector(
            onTap: (){
              showDialog(context: context, builder: ((context) => const SignOutPopup()));
            },
            child: Container(
              margin: const EdgeInsets.fromLTRB(20, 5, 20, 0),
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: HexColor('EEEEEE')
              ),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const [
                Text('회원탈퇴', style: TextStyle(fontSize: 15, color: Colors.red)),
                Image(image: AssetImage('assets/notice_go.png'))
              ]),
            ),
          )),
          Expanded(flex: 8, child: Container())
        ],)
    );
  }
}
