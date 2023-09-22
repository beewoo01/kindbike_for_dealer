import 'package:dio/dio.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:kindbike_for_dealer/Dialog/RegisterDialog.dart';
import 'package:kindbike_for_dealer/Model/ProductModel.dart';
import 'package:kindbike_for_dealer/Singleton/singleton.dart';
import 'package:toast/toast.dart';

import '../API/rest_client.dart';
import 'HomeContainer.dart';

class HomeDetail extends StatefulWidget {
  const HomeDetail({Key? key}) : super(key: key);

  @override
  State<HomeDetail> createState() => _HomeDetailState();
}

class _HomeDetailState extends State<HomeDetail> {
  int currentDots = 0;
  Singleton singleton = Singleton();

  @override
  Widget build(BuildContext context) {
    int idx =  HomeContainerState.of(context)!.homeIdx;
    ToastContext().init(context);
    final dio = Dio();
    dio.options.headers["Content-Type"] = "application/json";
    final api = RestClient(dio);

    return WillPopScope(
      onWillPop: (){
        HomeContainerState.of(context)?.bottomTapped(1);
        return Future(() => false);
      },
      child: Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(children: [
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
                const Text('매물 상세', style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),textAlign: TextAlign.center),
                const SizedBox(width: 50)
              ],
              ),
            ),
            FutureBuilder(
              future: api.getProductsDetail(idx),
              builder: (context, AsyncSnapshot snapshot){
                if(snapshot.hasData){
                  ProductModel model = snapshot.data as ProductModel;
                  List<String> image = model.product_image!.split(',');
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(children: [
                      Container(
                          margin: const EdgeInsets.symmetric(vertical: 15),
                          alignment: const Alignment(-1.0,0.0),
                          child:  const Text('매물 사진', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black))
                      ),
                      SizedBox(
                        height: 250,
                        child: PageView.builder(
                          itemCount: image.length,
                          controller: PageController(
                              initialPage: 0
                          ),
                          itemBuilder: (BuildContext context, int index){
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image(image: NetworkImage('http://codebrosdev.cafe24.com:8080/media/kindbike/${image[index]}')
                                ,fit: BoxFit.contain,width: double.infinity, height: double.infinity,),
                            );
                          },
                          onPageChanged: (index){
                            setState(() {
                              currentDots = index;
                            });
                          },
                        ),
                      ),
                      DotsIndicator(dotsCount: image.length, position: currentDots.toDouble(),
                        decorator: const DotsDecorator(color: Colors.grey, activeColor: Colors.black),),
                      Container(
                          margin: const EdgeInsets.symmetric(vertical: 15),
                          alignment: const Alignment(-1.0,0.0),
                          child:  const Text('기본 정보', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black))
                      ),
                      Row(children: [
                        const Expanded(child: Text('제조사', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.grey))),
                        Expanded(flex: 3, child: Text('${model.product_manufacturer}', style: const TextStyle(color: Colors.black, fontSize: 15),),)
                      ]),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child:  Row(children: [
                          const Expanded(child: Text('모델명', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.grey))),
                          Expanded(flex: 3, child: Text('${model.product_model}', style: const TextStyle(color: Colors.black, fontSize: 15),),)
                        ])
                      ),
                      Row(children: [
                        const Expanded(child: Text('주행거리', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.grey))),
                        Expanded(flex: 3, child: Text('${model.product_mileage} km', style: const TextStyle(color: Colors.black, fontSize: 15),),)
                      ]),
                      Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child:  Row(children: [
                            const Expanded(child: Text('연식', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.grey))),
                            Expanded(flex: 3, child: Text('${model.product_year}년식', style: const TextStyle(color: Colors.black, fontSize: 15),),)
                          ])
                      ),
                      Row(children: [
                        const Expanded(child: Text('거래지역', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.grey))),
                        Expanded(flex: 3, child: Text('${model.city_name} ${model.town_name}', style: const TextStyle(color: Colors.black, fontSize: 15),),)
                      ]),
                      Container(
                          margin: const EdgeInsets.symmetric(vertical: 15),
                          alignment: const Alignment(-1.0,0.0),
                          child:  const Text('상세 정보', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black))
                      ),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 25),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: HexColor('EEEEEE')
                        ),
                        child: Text('${model.product_detail}', style: const TextStyle(fontSize: 15, color: Colors.black)),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 30),
                        child: (){
                          if(model.product_state == 0){
                            return Column(children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: HexColor('FFFAE6')
                                ),
                                child: Row(children: [
                                  const Text('남은시간', style: TextStyle(fontSize: 14, color: Colors.black)),
                                  Expanded(child: Container(
                                    margin: const EdgeInsets.only(left: 15),
                                    child: Text('${model.product_endtime}',
                                        style: TextStyle(fontSize: 23, fontWeight: FontWeight.w900, color: HexColor('FEC700'))),
                                  )),
                                  Text('${model.count}명 참여중', style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold)),
                                ]),
                              ),
                              Container(
                                width: double.infinity,
                                margin: const EdgeInsets.only(top: 15),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: HexColor('E6EDFF')
                                ),
                                child: TextButton(
                                  onPressed: (){
                                    api.existsRegist(model.product_idx!, singleton.idx).then((value) => {
                                      if(value == 1){
                                        Toast.show('이미 등록하셨습니다.', duration: Toast.lengthShort, gravity: Toast.bottom)
                                      }else{
                                        showDialog(context: context, builder: (BuildContext context){
                                          return RegisterPurchase(idx: model.product_idx!,);
                                        })
                                      }
                                    });
                                  },
                                  child: const Text('매입 견적 등록', style: TextStyle(color: Colors.black, fontSize: 15),),
                                )
                              )
                            ]);
                          }else{
                            return Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: HexColor('FFFAE6')
                              ),
                              child: const Text('마감된 거래입니다.', style: TextStyle(fontSize: 15, color: Colors.black), textAlign: TextAlign.center,),
                            );
                          }
                        }(),
                      )
                    ]),
                  );
                }else{
                  return Container();
                }
              },
            )
          ]),
        ),
      ),
    );
  }
}
