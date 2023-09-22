import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kindbike_for_dealer/Model/ProductModel.dart';
import 'package:kindbike_for_dealer/Singleton/singleton.dart';

import '../API/rest_client.dart';
import '../Dialog/GuidDialog.dart';
import 'HomeContainer.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin{
  Singleton singleton = Singleton();
  late TabController _tabController;
  final _searchText = TextEditingController();
  late List<ProductModel> items, items2;
  List<ProductModel> searchItems = [];
  List<ProductModel> searchItems2 = [];

  void _search(){
    setState(() {
      for(int i = 0; i<items.length; i++){
        if(items[i].product_model!.contains(_searchText.text) && _searchText.text != ''){
          searchItems.add(items[i]);
        }
      }
    });
  }
  void _search2(){
    setState(() {
      for(int i = 0; i<items2.length; i++){
        if(items2[i].product_model!.contains(_searchText.text) && _searchText.text != ''){
          searchItems2.add(items2[i]);
        }
      }
    });
  }

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
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dio = Dio();
    dio.options.headers["Content-Type"] = "application/json";
    final api = RestClient(dio);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(children: [
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.fromLTRB(15, 25, 15, 0),
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/main_bg.png'),
                    fit: BoxFit.cover)),
            child: Center(
                child: Column(children: [
                  Expanded(
                      child: Row(children: [
                        const Image(image: AssetImage('assets/logo_1.png')),
                        Expanded(
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton.icon(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return const GuidPopup();
                                          });
                                    },
                                    icon: const Text('앱 이용 가이드',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)),
                                    label: Image.asset('assets/bt_app_guid.png'),
                                  ),
                                  FutureBuilder(
                                    future: api.existsAlarm(singleton.idx),
                                    builder: (context, AsyncSnapshot snapshot){
                                      return IconButton(
                                        onPressed: () {
                                          HomeContainerState.of(context)?.bottomTapped(14);
                                        },
                                        icon: snapshot.data == 0 ? Image.asset('assets/icon_ring.png') : Image.asset('assets/icon_ring2.png'),
                                      );
                                    },
                                  )
                                ]))
                      ])),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 15),
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: const Color(0xffdddddd).withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 7,
                              offset: const Offset(0, 3))
                        ],
                        color: Colors.white),
                    child: Row(children: [
                      Expanded(
                          child: TextField(
                            controller: _searchText,
                            decoration: const InputDecoration(
                                hintText: '모델명 검색',
                                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                            ),
                            onChanged: (value){
                              if(_tabController.index == 0){
                                searchItems.clear();
                                _search();
                              }else{
                                searchItems2.clear();
                                _search2();
                              }
                            },
                          )),
                      const Image(image: AssetImage('assets/icon_search.png'))
                    ]),
                  )
                ])),
          ),
        ),
        Expanded(
            flex: 3,
            child: Column(children: [
              SizedBox(
                width: double.infinity,
                height: 50,
                child: TabBar(
                  indicatorColor: Colors.black,
                  controller: _tabController,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  tabs: [
                    Container(
                      alignment: Alignment.center,
                      child: const Text(
                        '진행중',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: const Text(
                        '마감',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      ing(context),
                      end(context),
                    ],
                  ))
            ]))
      ]),
    );
  }

  Widget ing(BuildContext context){
    final dio = Dio();
    dio.options.headers["Content-Type"] = "application/json";
    final api = RestClient(dio);

    return FutureBuilder(
      future: api.getProductsIng(),
      builder: (context, AsyncSnapshot snapshot){
        if(snapshot.hasData){
          items = snapshot.data as List<ProductModel>;
          print('items.length = ${items.length}');
          print('searchItems.length = ${searchItems.length}');
          if(items.isNotEmpty){
            return ListView.builder(
                padding: const EdgeInsets.only(top: 10),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: searchItems.isEmpty ? items.length : searchItems.length,
                itemBuilder: (BuildContext context, int index){
                  return GestureDetector(
                    onTap: (){
                      HomeContainerState.of(context)!.homeIdx = searchItems.isEmpty ? items[index].product_idx! : searchItems[index].product_idx!;
                      HomeContainerState.of(context)?.bottomTapped(3);
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
                            child: imageView(context, searchItems.isEmpty ? items[index].product_image :  searchItems[index].product_image),
                          ),
                        ),
                        Expanded(child: Container(
                          margin: const EdgeInsets.only(left: 15),
                          child: Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Expanded(child: Container(
                              alignment: Alignment.centerLeft,
                              child: Text('${searchItems.isEmpty ? items[index].product_model :  searchItems[index].product_model}',
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 17)),
                            )),
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              Text('${searchItems.isEmpty ? items[index].product_year : searchItems[index].product_year}년식', style: const TextStyle(fontSize: 14, color: Colors.black)),
                              Container(width: 1, height: 10, color: Colors.black,),
                              Text(int.parse(searchItems.isEmpty ? items[index].product_mileage! :  searchItems[index].product_mileage!) >= 10000
                                  ? '${int.parse(searchItems.isEmpty ? items[index].product_mileage! :  searchItems[index].product_mileage!) ~/ 10000}만km'
                                  : '${searchItems.isEmpty ? items[index].product_mileage! :  searchItems[index].product_mileage!}km', style: const TextStyle(fontSize: 14, color: Colors.black)),
                              Container(width: 1, height: 10, color: Colors.black,),
                              Text('${searchItems.isEmpty ? items[index].city_name : searchItems[index].city_name}', style: const TextStyle(fontSize: 14, color: Colors.black))
                            ],),
                            Expanded(child: Container(
                              alignment: Alignment.centerLeft,
                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                const Text('남은시간', style: TextStyle(fontSize: 15, color: Colors.black)),
                                Text('${searchItems.isEmpty ? items[index].product_endtime : searchItems[index].product_endtime}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.black))
                              ],),
                            ))
                          ]),
                        ))
                      ]),
                    ),
                  );
                }
            );
          }else{
            return Container(
              alignment: const Alignment(0.0,0.0),
              child: const Text('진행중인 견적이 없습니다.', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
            );
          }
        }else{
          return Container();
        }
      },
    );
  }
  Widget end(BuildContext context){
    final dio = Dio();
    dio.options.headers["Content-Type"] = "application/json";
    final api = RestClient(dio);

    return FutureBuilder(
      future: api.getProductsEnd(),
      builder: (context, AsyncSnapshot snapshot){
        if(snapshot.hasData){
          items2 = snapshot.data as List<ProductModel>;
          if(items2.isNotEmpty){
            return ListView.builder(
                padding: const EdgeInsets.only(top: 10),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: searchItems2.isEmpty ? items2.length : searchItems2.length,
                itemBuilder: (BuildContext context, int index){
                  return GestureDetector(
                    onTap: (){
                      HomeContainerState.of(context)!.homeIdx = searchItems2.isEmpty ? items2[index].product_idx! : searchItems2[index].product_idx!;
                      HomeContainerState.of(context)?.bottomTapped(3);
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
                            child: imageView(context, searchItems2.isEmpty ? items2[index].product_image : searchItems2[index].product_image),
                          ),
                        ),
                        Expanded(child: Container(
                          margin: const EdgeInsets.only(left: 15),
                          child: Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Expanded(child: Container(
                              alignment: Alignment.centerLeft,
                              child: Text('${searchItems2.isEmpty ? items2[index].product_model : searchItems2[index].product_model}',
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 17)),
                            )),
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              Text('${searchItems2.isEmpty ? items2[index].product_year : searchItems2[index].product_year}년식', style: const TextStyle(fontSize: 14, color: Colors.black)),
                              Container(width: 1, height: 10, color: Colors.black,),
                              Text(int.parse(searchItems2.isEmpty ? items2[index].product_mileage! : searchItems2[index].product_mileage!) >= 10000
                                  ? '${int.parse(searchItems2.isEmpty ? items2[index].product_mileage! : searchItems2[index].product_mileage!) ~/ 10000}만km'
                                  : '${searchItems2.isEmpty ? items2[index].product_mileage! : searchItems2[index].product_mileage!}km', style: const TextStyle(fontSize: 14, color: Colors.black)),
                              Container(width: 1, height: 10, color: Colors.black,),
                              Text('${searchItems2.isEmpty ? items2[index].city_name : searchItems2[index].city_name}', style: const TextStyle(fontSize: 14, color: Colors.black))
                            ],),
                            Expanded(child: Container(
                              alignment: Alignment.centerLeft,
                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                const Text('남은시간', style: TextStyle(fontSize: 15, color: Colors.black)),
                                Text('${searchItems2.isEmpty ? items2[index].product_endtime : searchItems2[index].product_endtime}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.black))
                              ],),
                            ))
                          ]),
                        ))
                      ]),
                    ),
                  );
                }
            );
          }else{
            return Container(
              alignment: const Alignment(0.0,0.0),
              child: const Text('마감된 견적이 없습니다.', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
            );
          }
        }else{
          return Container();
        }
      },
    );
  }
}
