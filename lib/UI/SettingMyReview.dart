import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kindbike_for_dealer/Singleton/singleton.dart';

import '../API/rest_client.dart';
import '../Model/ReviewModel.dart';
import 'HomeContainer.dart';

class SettingMyReview extends StatefulWidget {
  const SettingMyReview({Key? key}) : super(key: key);

  @override
  State<SettingMyReview> createState() => _SettingMyReviewState();
}

class _SettingMyReviewState extends State<SettingMyReview> {
  Singleton singleton = Singleton();

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

    return WillPopScope(
      onWillPop: (){
        HomeContainerState.of(context)?.bottomTapped(6);
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
                      HomeContainerState.of(context)?.bottomTapped(6);
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
            future: api.getReviewList(singleton.idx),
            builder: (context, AsyncSnapshot snapshot){
              if(snapshot.hasData){
                List<ReviewModel> list = snapshot.data as List<ReviewModel>;
                return ListView.builder(
                    padding: const EdgeInsets.only(top: 10),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: list.length,
                    itemBuilder: (BuildContext context, int index){
                      return GestureDetector(
                        onTap: (){
                          HomeContainerState.of(context)!.reviewIdx = list[index].dealer_review_idx!;
                          HomeContainerState.of(context)?.bottomTapped(13);
                        },
                        child: Container(
                          width: double.infinity,
                          height: 80,
                          padding: const EdgeInsets.all(7),
                          margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: HexColor('EEEEEE')
                          ),
                          child: Row(children: [
                            SizedBox(
                              width: 70,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: imageView(context, list[index].product_image),
                              ),
                            ),
                            Expanded(child: Container(
                              margin: const EdgeInsets.only(left: 15),
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Expanded(child: Align(
                                  alignment: const Alignment(-1.0,0.8),
                                  child: Text('${list[index].product_model}',
                                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16),),
                                )),
                                Expanded(child: RatingBar(
                                  ignoreGestures: true,
                                  initialRating: double.parse(list[index].dealer_review_rating!),
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemSize: 20.0,
                                  ratingWidget: RatingWidget(
                                    full: Image.asset('assets/main_star.png'),
                                    empty: Image.asset('assets/main_star2.png'),
                                    half: Image.asset('assets/main_star3.png'),
                                  ),
                                  onRatingUpdate: (rating){},
                                ),),
                              ]),
                            )),
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
          ))
        ]),
      ),
    );
  }
}
