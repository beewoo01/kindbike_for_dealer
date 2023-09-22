import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kindbike_for_dealer/Model/BiddingModel.dart';
import 'package:kindbike_for_dealer/Model/ProductModel.dart';

import '../API/rest_client.dart';
import '../Singleton/singleton.dart';
import 'HomeContainer.dart';

class Bidding extends StatefulWidget {
  const Bidding({Key? key}) : super(key: key);

  @override
  State<Bidding> createState() => _BiddingState();
}

class _BiddingState extends State<Bidding> {
  Singleton singleton = Singleton();
  final _stateList = ['전체', '낙찰대기', '거래중','거래완료', '거래취소'];
  var _selectedValue = '전체';

  Widget imageView(BuildContext context, String? str) {
    var thumbnail = str!.split(',');
    return Image(
      image: NetworkImage(
          'http://codebrosdev.cafe24.com:8080/media/kindbike/${thumbnail[0]}'),
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    );
  }

  @override
  Widget build(BuildContext context) {
    final dio = Dio();
    dio.options.headers["Content-Type"] = "application/json";
    final api = RestClient(dio);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(children: [
        Container(
          color: Colors.white,
          width: double.infinity,
          alignment: const Alignment(0.0,0.0),
          height: 100,
          child: const Text('내 입찰 목록', style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),textAlign: TextAlign.center),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          alignment: const Alignment(-1.0,0.0),
          child: const Text('입찰 내역', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black)),
        ),
        Expanded(child: FutureBuilder(
          future: api.getMyBiddingList(singleton.idx, _selectedValue),
          builder: (context, AsyncSnapshot snapshot){
            if(snapshot.hasData){
              List<BiddingModel> list = snapshot.data as List<BiddingModel>;
              return Column(children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Row(children: [
                    Expanded(child: Text('총 ${list.length}건', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black))),
                    Container(
                      width: 100,
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black
                      ),
                      child: DropdownButton(
                        underline: const SizedBox.shrink(),
                        isExpanded: true,
                        value: _selectedValue,
                        items: _stateList.map((value){
                          return DropdownMenuItem(
                            value: value,
                            child: Text(value, style: const TextStyle(color: Colors.grey, fontSize: 13),),
                          );
                        },).toList(),
                        onChanged: (value){
                          setState(() {
                            _selectedValue =  value.toString();
                          });
                        },
                      ),
                    )

                  ]),
                ),
                Container(
                  width: double.infinity,
                  height: 2.0,
                  color: HexColor('DDDDDD'),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                ),
                Expanded(child: ListView.builder(
                    padding: const EdgeInsets.only(top: 10),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: list.length,
                    itemBuilder: (BuildContext context, int index){
                      return GestureDetector(
                        onTap: (){
                          HomeContainerState.of(context)!.biddingIdx = list[index].product_idx!;
                          HomeContainerState.of(context)?.bottomTapped(4);
                        },
                        child: Container(
                          width: double.infinity,
                          height: 150,
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.fromLTRB(20, 7, 20, 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: const Color(0xffcccccc).withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 7,
                                  offset: const Offset(0,3)
                              )
                            ],
                          ),
                          child: Row(children: [
                            SizedBox(
                              width: 130,
                              height: double.infinity,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: imageView(context, list[index].product_image),
                              ),
                            ),
                            Expanded(child: Container(
                              margin: const EdgeInsets.only(left: 15),
                              child: Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Container(
                                  alignment: Alignment.centerRight,
                                  child: (){
                                    if(list[index].buy_state == 0){
                                      return Container(
                                        width: 70,
                                        height: 25,
                                        alignment: const Alignment(0.0,0.0),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(100),
                                            color: HexColor('66C5EF')
                                        ),
                                        child: const Text('낙찰대기',
                                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14)),
                                      );
                                    }else{
                                      if(list[index].product_state == 1){
                                        return Container(
                                          width: 70,
                                          height: 25,
                                          alignment: const Alignment(0.0,0.0),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(100),
                                              color: Colors.orangeAccent
                                          ),
                                          child: const Text('거래중',
                                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14)),
                                        );
                                      }else if(list[index].product_state == 2){
                                        return Container(
                                          width: 70,
                                          height: 25,
                                          alignment: const Alignment(0.0,0.0),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(100),
                                              color: Colors.green
                                          ),
                                          child: const Text('거래완료',
                                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14)),
                                        );
                                      }else if(list[index].product_state == 3){
                                        return Container(
                                          width: 70,
                                          height: 25,
                                          alignment: const Alignment(0.0,0.0),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(100),
                                              color: Colors.grey
                                          ),
                                          child: const Text('거래취소',
                                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14)),
                                        );
                                      }
                                    }
                                  }(),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  margin: const EdgeInsets.only(bottom: 5),
                                  child: Text('${list[index].product_model}',
                                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 17)),
                                ),
                                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                  Text('${list[index].product_year}년식', style: const TextStyle(fontSize: 14, color: Colors.black)),
                                  Container(width: 1, height: 10, color: Colors.black,),
                                  Text(int.parse(list[index].product_mileage!) >= 10000
                                      ? '${int.parse(list[index].product_mileage!) ~/ 10000}만km'
                                      : '${list[index].product_mileage}km', style: const TextStyle(fontSize: 14, color: Colors.black)),
                                  Container(width: 1, height: 10, color: Colors.black,),
                                  Text('${list[index].city_name}', style: const TextStyle(fontSize: 14, color: Colors.black))
                                ],),
                                Expanded(child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                    const Text('남은시간', style: TextStyle(fontSize: 15, color: Colors.black)),
                                    Text('${list[index].product_endtime}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.black))
                                  ],),
                                ))
                              ]),
                            ))
                          ]),
                        ),
                      );
                    }
                ))
              ]);
            }else{
              return Container();
            }
          },
        ))
      ]),
    );
  }
}
