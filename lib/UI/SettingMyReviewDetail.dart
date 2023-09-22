import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

import '../API/rest_client.dart';
import '../Model/ReviewModel.dart';
import 'HomeContainer.dart';

class SettingMyReviewDetail extends StatefulWidget {
  const SettingMyReviewDetail({Key? key}) : super(key: key);

  @override
  State<SettingMyReviewDetail> createState() => _SettingMyReviewDetailState();
}

class _SettingMyReviewDetailState extends State<SettingMyReviewDetail> {
  @override
  Widget build(BuildContext context) {
    final dio = Dio();
    dio.options.headers["Content-Type"] = "application/json";
    final api = RestClient(dio);
    int idx = HomeContainerState.of(context)!.reviewIdx;

    return WillPopScope(
      onWillPop: (){
        HomeContainerState.of(context)?.bottomTapped(12);
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
                      HomeContainerState.of(context)?.bottomTapped(12);
                    },
                    icon: Image.asset("assets/ic_back.png")),
              ),
              const Text('업체 후기', style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),textAlign: TextAlign.center),
              const SizedBox(width: 50)
            ],
            ),
          ),
          Expanded(child: FutureBuilder(
            future: api.getReviewDetail(idx),
            builder: (context, AsyncSnapshot snapshot){
              if(snapshot.hasData){
                ReviewModel model = snapshot.data as ReviewModel;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Expanded( child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: HexColor('EEEEEE')
                      ),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('${model.product_model}', style: const TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold)),
                        Expanded(child: Row(children: [
                          const Align(
                            alignment: Alignment(0.0, 1.0),
                            child: Text('실 매입금액', style: TextStyle(fontSize: 17, color: Colors.black, fontWeight: FontWeight.bold),),
                          ),
                          Expanded(child: Align(
                            alignment: const Alignment(1.0, 1.0),
                            child: Text(NumberFormat('###,###,###,###').format(model.pay_price),
                                style: const TextStyle(fontSize: 30, color: Colors.black, fontWeight: FontWeight.bold)),),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 5),
                            alignment: const Alignment(0.0, 1.0),
                            child: const Text('원', style: TextStyle(fontSize: 17, color: Colors.black, fontWeight: FontWeight.bold)),
                          )
                        ]))
                      ]),
                    )),
                    Expanded(child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: 15),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: HexColor('EEEEEE'), width: 1.0),
                        color: Colors.white
                      ),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const Text('감가사항', style: TextStyle(fontSize: 17, color: Colors.black, fontWeight: FontWeight.bold)),
                        Expanded(child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Text('${model.pay_detail}', style: const TextStyle(fontSize: 15, color: Colors.black),),
                        ))
                      ]),
                    ),),
                    Container(
                      margin: const EdgeInsets.only(top: 25),
                      child: const Text('후기내용', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black))
                    ),
                    Row(children: [
                      RatingBar(
                        ignoreGestures: true,
                        initialRating: double.parse(model.dealer_review_rating!),
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 30.0,
                        ratingWidget: RatingWidget(
                          full: Image.asset('assets/main_star.png'),
                          empty: Image.asset('assets/main_star2.png'),
                          half: Image.asset('assets/main_star3.png'),
                        ),
                        onRatingUpdate: (rating){},
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: Text('${model.dealer_review_rating}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 22)),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 5),
                        child: const Text('점', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 15)),
                      )
                    ]),
                    Expanded(flex: 3, child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: 5, bottom: 15),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: HexColor('EEEEEE')
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Text('${model.dealer_review_detail}', style: const TextStyle(color: Colors.black, fontSize: 16)),
                      ),
                    ))
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
