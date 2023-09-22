import 'dart:convert';

import 'package:bootpay/bootpay.dart';
import 'package:bootpay/model/extra.dart';
import 'package:bootpay/model/item.dart';
import 'package:bootpay/model/payload.dart';
import 'package:bootpay/model/user.dart';
import 'package:dio/dio.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:kindbike_for_dealer/Model/BiddingModel.dart';
import 'package:kindbike_for_dealer/Singleton/singleton.dart';
import 'package:toast/toast.dart';

import '../API/rest_client.dart';
import 'HomeContainer.dart';

class BiddingDetail extends StatefulWidget {
  const BiddingDetail({Key? key}) : super(key: key);

  @override
  State<BiddingDetail> createState() => _BiddingDetailState();
}

class _BiddingDetailState extends State<BiddingDetail> {
  Singleton singleton = Singleton();
  int currentDots = 0;

  String dataStr = '';
  String androidApplicationId = '64892a00e57a7e001cb92cc6';
  String iosApplicationId = '64892a00e57a7e001cb92cc7';

  final _payText = TextEditingController();
  final _detailText = TextEditingController();
  final _payFocus = FocusNode();
  final _detailFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    int idx = HomeContainerState.of(context)!.biddingIdx;
    ToastContext().init(context);
    final dio = Dio();
    dio.options.headers["Content-Type"] = "application/json";
    final api = RestClient(dio);

    return WillPopScope(
      onWillPop: (){
        HomeContainerState.of(context)?.bottomTapped(0);
        return Future(() => false);
      },
      child: Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
              width: double.infinity,
              height: 100,
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                SizedBox(
                  width: 50,
                  height: 50,
                  child: IconButton(
                      onPressed: (){
                        HomeContainerState.of(context)?.bottomTapped(0);
                      },
                      icon: Image.asset("assets/ic_back.png")),
                ),
                const Text('입찰 상세', style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),textAlign: TextAlign.center),
                const SizedBox(width: 50)
              ],
              ),
            ),
            FutureBuilder(
              future: api.getMyBiddingDetail(singleton.idx, idx),
              builder: (context, AsyncSnapshot snapshot){
                if(snapshot.hasData){
                  BiddingModel model = snapshot.data;
                  List<String> image = model.product_image!.split(',');
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(children: [
                      Container(
                        alignment: const Alignment(-1.0,0.0),
                        margin: const EdgeInsets.symmetric(vertical: 15),
                        child: const Text('진행상황', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black)),
                      ),
                      Container(
                        child: (){
                          if(model.buy_state == 0){
                            return Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 13),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: HexColor('66C5EF')
                              ),
                              alignment: const Alignment(0.0,0.0),
                              child: const Text('낙찰대기', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.white)),
                            );
                          }else{
                            if(model.product_state == 1){
                              return Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(vertical: 13),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Colors.orangeAccent
                                ),
                                alignment: const Alignment(0.0,0.0),
                                child: const Text('거래중', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.white)),
                              );
                            }else if(model.product_state == 2){
                              return Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(vertical: 13),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Colors.green
                                ),
                                alignment: const Alignment(0.0,0.0),
                                child: const Text('거래완료', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.white)),
                              );
                            }else if(model.product_state == 3){
                              return Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(vertical: 13),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Colors.grey
                                ),
                                alignment: const Alignment(0.0,0.0),
                                child: const Text('거래취소', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.white)),
                              );
                            }
                          }
                        }(),
                      ),
                      Container(
                        alignment: const Alignment(-1.0,0.0),
                        margin: const EdgeInsets.symmetric(vertical: 15),
                        child: const Text('매물 사진', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black)),
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
                        Expanded(flex: 3, child: Text('${model.product_mileage} km',
                          style: const TextStyle(color: Colors.black, fontSize: 15),),)
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
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: HexColor('EEEEEE')
                        ),
                        child: Text('${model.product_detail}', style: const TextStyle(fontSize: 15, color: Colors.black)),
                      ),
                      Container(
                        child: (){
                          if(model.buy_state == 0){
                            return Column(children: [
                              Container(
                                width: double.infinity,
                                margin: const EdgeInsets.symmetric(vertical: 30),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: HexColor('FFFAE6')
                                ),
                                child: Row(children: [
                                  const Text('내 견적 금액', style: TextStyle(fontSize: 17, color: Colors.black)),
                                  Expanded(child: Align(
                                    alignment: const Alignment(1.0,0.0),
                                    child: Text('${NumberFormat('###,###,###,###').format(model.buy_price)} 원',
                                        style: const TextStyle(color: Colors.black, fontSize: 23, fontWeight: FontWeight.bold)),
                                  ))
                                ]),
                              )
                            ]);
                          }else{
                            if(model.product_state == 1){
                              return Column(children: [
                                Container(
                                    margin: const EdgeInsets.symmetric(vertical: 15),
                                    alignment: const Alignment(-1.0,0.0),
                                    child:  const Text('판매자 정보', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black))
                                ),
                                Row(children: [
                                  const Expanded(child: Text('이름', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.grey))),
                                  Expanded(flex: 3, child: Text('${model.user_name}', style: const TextStyle(color: Colors.black, fontSize: 15),),)
                                ]),
                                Container(
                                    margin: const EdgeInsets.symmetric(vertical: 10),
                                    child:  Row(children: [
                                      const Expanded(child: Text('연락처', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.grey))),
                                      Expanded(flex: 3, child: Text('${model.user_phone}', style: const TextStyle(color: Colors.black, fontSize: 15),),)
                                    ])
                                ),
                                Row(children: [
                                  const Expanded(child: Text('이메일', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.grey))),
                                  Expanded(flex: 3, child: Text('${model.user_id}', style: const TextStyle(color: Colors.black, fontSize: 15),),)
                                ]),
                                Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.symmetric(vertical: 30),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: HexColor('FFFAE6')
                                  ),
                                  child: Row(children: [
                                    const Text('내 견적 금액', style: TextStyle(fontSize: 15, color: Colors.black)),
                                    Expanded(child: Align(
                                      alignment: const Alignment(1.0,0.0),
                                      child: Text('${NumberFormat('###,###,###,###').format(model.buy_price)} 원',
                                          style: const TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold)),
                                    ))
                                  ]),
                                )
                              ]);
                            }else if(model.product_state == 2){
                              return Column(children: [
                                Container(
                                    margin: const EdgeInsets.symmetric(vertical: 15),
                                    alignment: const Alignment(-1.0,0.0),
                                    child:  const Text('판매자 정보', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black))
                                ),
                                Row(children: [
                                  const Expanded(child: Text('이름', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.grey))),
                                  Expanded(flex: 3, child: Text('${model.user_name}', style: const TextStyle(color: Colors.black, fontSize: 15),),)
                                ]),
                                Container(
                                    margin: const EdgeInsets.symmetric(vertical: 10),
                                    child:  Row(children: [
                                      const Expanded(child: Text('연락처', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.grey))),
                                      Expanded(flex: 3, child: Text('${model.user_phone}', style: const TextStyle(color: Colors.black, fontSize: 15),),)
                                    ])
                                ),
                                Row(children: [
                                  const Expanded(child: Text('이메일', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.grey))),
                                  Expanded(flex: 3, child: Text('${model.user_id}', style: const TextStyle(color: Colors.black, fontSize: 15),),)
                                ]),
                                Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.only(top: 30, bottom: 15),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: HexColor('FFFAE6')
                                  ),
                                  child: Row(children: [
                                    const Text('내 견적 금액', style: TextStyle(fontSize: 15, color: Colors.black)),
                                    Expanded(child: Align(
                                      alignment: const Alignment(1.0,0.0),
                                      child: Text('${NumberFormat('###,###,###,###').format(model.buy_price)} 원',
                                          style: const TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold)),
                                    ))
                                  ]),
                                ),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: HexColor('DEF7EB')
                                  ),
                                  child: Row(children: [
                                    const Text('실 매입 금액', style: TextStyle(fontSize: 15, color: Colors.black)),
                                    Expanded(child: Container(
                                      child: (){
                                        if(model.pay_idx == 0){
                                          return TextField(
                                            controller: _payText,
                                            focusNode: _payFocus,
                                            decoration: InputDecoration(
                                                isDense: true,
                                                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: HexColor('DEF7EB'))),
                                                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: HexColor('DEF7EB'))),
                                                contentPadding: EdgeInsets.zero,
                                                hintText: '가격 입력',
                                                hintStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 22, color: Colors.grey)
                                            ),
                                            keyboardType: TextInputType.number,
                                            textAlign: TextAlign.end,
                                            style: const TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold,),
                                            onChanged: (value){
                                              final formatter = NumberFormat('#,###');
                                              final newText = formatter.format(int.parse(value.replaceAll(',', '')));
                                              _payText.value = TextEditingValue(
                                                text: newText,
                                                selection: TextSelection.fromPosition(
                                                  TextPosition(offset: newText.length),
                                                ),
                                              );
                                            },
                                          );
                                        }else{
                                          return Align(
                                            alignment: const Alignment(1.0,0.0),
                                            child: Text(NumberFormat('###,###,###,###').format(model.pay_price),
                                                style: const TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold)),
                                          );
                                        }
                                      }(),
                                    )),
                                    const Text(' 원', style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold,)),
                                  ]),
                                ),
                                Container(
                                    margin: const EdgeInsets.symmetric(vertical: 15),
                                    alignment: const Alignment(-1.0,0.0),
                                    child:  const Text('감가사항', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black))
                                ),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: HexColor('EEEEEE')
                                  ),
                                  child: (){
                                    if(model.pay_idx == 0){
                                      return TextField(
                                          decoration: InputDecoration(
                                              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: HexColor('EEEEEE'))),
                                              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: HexColor('EEEEEE'))),
                                              contentPadding: EdgeInsets.zero,
                                              hintText: '내용을 입력해 주세요.'
                                          ),
                                          controller: _detailText,
                                          focusNode: _detailFocus,
                                          maxLines: 10,
                                          style: const TextStyle(fontSize: 15, color: Colors.black)
                                      );
                                    }else{
                                      return Text('${model.pay_detail}', style: const TextStyle(fontSize: 15, color: Colors.black));
                                    }
                                  }(),
                                ),
                                Container(
                                    margin: const EdgeInsets.only(top: 20,bottom: 30),
                                    child: (){
                                      if(model.pay_idx == 0){
                                        return Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: Colors.black
                                          ),
                                          child: TextButton(
                                            onPressed: (){
                                              if(_payText.text != ''){
                                                int pay = int.parse(_payText.text.replaceAll(',', ''));
                                                api.insertPay(model.buy_idx!, pay, _detailText.text).then((value) => {
                                                  // 결제 연동 넣음됨
                                                  _payFocus.unfocus(),
                                                  _detailFocus.unfocus(),
                                                  _payText.clear(),
                                                  _detailText.clear(),
                                                  print('idx = $value'),
                                                  bootPay(context, value, model.dealer_id!, model.dealer_name!, model.dealer_phone!)
                                                });
                                              }else{
                                                Toast.show('가격을 입력해 주세요.', duration: Toast.lengthShort, gravity: Toast.bottom);
                                              }
                                            },
                                            child: const Text('등록', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 17),),
                                          ),
                                        );
                                      }else if(model.pay_idx! > 0 && model.pay_state == 0){
                                        return Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: Colors.black
                                          ),
                                          child: TextButton(
                                            onPressed: (){
                                              //결제연동
                                              bootPay(context, model.pay_idx!, model.dealer_id!, model.dealer_name!, model.dealer_phone!);

                                            },
                                            child: const Text('결제', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 17),),
                                          ),
                                        );
                                      }else{
                                        return Container();
                                      }
                                    }()
                                ),
                              ]);
                            }else if(model.product_state == 3){
                              return Column(children: [
                                Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.symmetric(vertical: 30),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: HexColor('FFFAE6')
                                  ),
                                  child: Row(children: [
                                    const Text('내 견적 금액', style: TextStyle(fontSize: 17, color: Colors.black)),
                                    Expanded(child: Align(
                                      alignment: const Alignment(1.0,0.0),
                                      child: Text('${NumberFormat('###,###,###,###').format(model.buy_price)} 원',
                                          style: const TextStyle(color: Colors.black, fontSize: 23, fontWeight: FontWeight.bold)),
                                    ))
                                  ]),
                                )
                              ]);
                            }
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


  void bootPay(BuildContext context, int idx, String email, String name, String phone) {
    Payload payload = getPayload(email, name, phone);

    Bootpay().requestPayment(
      context: context,
      payload: payload,
      showCloseButton: false,
      onCancel: (String data) {
        print('------- onCancel: $data');
      },
      onError: (String data) {
        print('------- onCancel: $data');
      },
      onClose: () {
        print('------- onClose');
        closeBootpay(context, idx);
      },
      onIssued: (String data) {
        dataStr = data;
        print('------- onIssued: $data');
      },
      onConfirm: (String data) {
        // *
        //     1. 바로 승인하고자 할 때
        //     return true;
        //  *
        // **
        //     2. 클라이언트 승인 하고자 할 때
        //     Bootpay().transactionConfirm();
        //     return false;
        //  **
        // **
        //     3. 서버승인을 하고자 하실 때 (클라이언트 승인 X)
        //     return false; 후에 서버에서 결제승인 수행

        // Bootpay().transactionConfirm();
        return true;
      },
      onDone: (String data) {
        print('------- onDone: $data');
      },
    );
  }

  Payload getPayload(String email, String name, String phone) {
    Payload payload = Payload();
    Item item1 = Item();
    item1.name = "거래 수수료"; // 주문정보에 담길 상품명
    item1.qty = 1; // 해당 상품의 주문 수량
    item1.id = "10539"; // 해당 상품의 고유 키
    item1.price = 1000; // 상품의 가격

    List<Item> itemList = [item1];

    payload.androidApplicationId = androidApplicationId; // android application id
    payload.iosApplicationId = iosApplicationId; // ios application id


    // payload.methods = ['card', 'phone', 'vbank', 'bank', 'kakao'];
    payload.pg = "페이앱";
    payload.method = "vbank";
    payload.orderName = "수수료"; //결제할 상품명
    payload.price = 1000.0; //정기결제시 0 혹은 주석
    payload.orderId = "0e137003-dc03-4380-9320-578eaaed2423";

    payload.orderId = DateTime.now().millisecondsSinceEpoch.toString(); //주문번호, 개발사에서 고유값으로 지정해야함
    payload.items = itemList; // 상품정보 배열

    User user = User(); // 구매자 정보
    user.id = singleton.idx.toString();
    user.username = name;
    user.email = email;
    user.area = "서울";
    user.phone = phone;


    Extra extra = Extra(); // 결제 옵션
    extra.appScheme = 'bootpayFlutterExample';
    extra.testDeposit = true;

    payload.user = user;
    payload.extra = extra;
    return payload;
  }

  Future<void> closeBootpay(BuildContext context, int idx) async {

    await Future.delayed(const Duration(seconds: 0)).then((value) {
      print('Bootpay().dismiss');

      Bootpay().dismiss(context);

      if(dataStr != ''){
        payDialog(context, dataStr, idx);
        HomeContainerState.of(context)?.bottomTapped(0);
      }
    });
  }

  void payDialog(BuildContext context, String str, int idx) {
    final dio = Dio();
    dio.options.headers["Content-Type"] = "application/json";
    final api = RestClient(dio);

    final jsonStr = json.decode(str);

    DateTime tempDate = DateTime.parse(jsonStr['data']['vbank_data']['expired_at']).add(const Duration(hours: 9));
    String expireDate = DateFormat("yyyy-MM-dd HH:mm").format(tempDate);

    api.updatePay(jsonStr['data']['receipt_id'], idx);


    showGeneralDialog(context: context,
        pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation){
          return Scaffold(
            body: Container(
              color: Colors.white,
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                  color: Colors.white,
                  width: double.infinity,
                  alignment: const Alignment(0.0,0.0),
                  height: 100,
                  child: const Text('결제', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
                ),
                Expanded(child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(children: [
                    const Expanded(child: Image(image: AssetImage('assets/ic_check.png'), width: 70, height: 70,)),
                    Expanded(flex: 3, child: Column(children: [
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(bottom: 30),
                        child: const Text('가상계좌 발급완료', style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center),
                      ),
                      Expanded(child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                        const Text('입금은행', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17)),
                        Text(jsonStr['data']['vbank_data']['bank_name'], style: const TextStyle(color: Colors.black, fontSize: 17))
                      ])),
                      Expanded(child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                        const Text('계좌번호', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17)),
                        Text(jsonStr['data']['vbank_data']['bank_account'], style: const TextStyle(color: Colors.black, fontSize: 17))
                      ])),
                      Expanded(child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                        const Text('예금주', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17)),
                        Text(jsonStr['data']['vbank_data']['bank_username'] ?? '000' ,
                            style: const TextStyle(color: Colors.black, fontSize: 17))
                      ])),
                      Expanded(child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                        const Text('입금기한', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17)),
                        Text('$expireDate 까지', style: const TextStyle(color: Colors.black, fontSize: 17))
                      ])),
                      Expanded(flex: 3 ,child: Container())
                    ])),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      child: TextButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        child: const Text('확인', style: TextStyle(color: Colors.white, fontSize: 17)),
                      ),
                    )
                  ]),
                ))
              ]),
            ),
          );
        });
  }
}
