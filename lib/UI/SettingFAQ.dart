import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kindbike_for_dealer/Model/NoticeModel.dart';

import '../API/rest_client.dart';
import 'HomeContainer.dart';

class SettingFAQ extends StatefulWidget {
  const SettingFAQ({Key? key}) : super(key: key);

  @override
  State<SettingFAQ> createState() => _SettingFAQState();
}

class _SettingFAQState extends State<SettingFAQ> {
  final _textController = TextEditingController();
  final _focus = FocusNode();
  late List<NoticeModel> items;
  List<NoticeModel> searchItems = [];

  void _search(){
    setState(() {
      for(int i = 0; i<items.length; i++){
        if(items[i].faq_title!.contains(_textController.text)){
          searchItems.add(items[i]);
        }
      }
    });
  }

  void clearText(){
    setState(() {
      _focus.unfocus();
      _textController.clear();
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dio = Dio();
    dio.options.headers["Content-Type"] = "application/json";
    final api = RestClient(dio);

    return WillPopScope(
      onWillPop: (){
        clearText();
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
                      clearText();
                      HomeContainerState.of(context)?.bottomTapped(2);
                    },
                    icon: Image.asset("assets/ic_back.png")),
              ),
              const Text('FAQ', style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),textAlign: TextAlign.center),
              const SizedBox(width: 50)
            ],
            ),
          ),
          Expanded(child: FutureBuilder(
            future: api.getFAQ(),
            builder: (context, AsyncSnapshot snapshot){
              if(snapshot.hasData){
                items = snapshot.data as List<NoticeModel>;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(children: [
                    Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: HexColor('EEEEEE')
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(children: [
                        Expanded(child: TextField(
                          decoration: const InputDecoration(
                              hintText: '검색', border: InputBorder.none),
                          controller: _textController,
                          focusNode: _focus,
                          onChanged: (value){
                            searchItems.clear();
                            _search();
                          },
                        )),
                        const Image(image: AssetImage('assets/icon_search.png'), width: 20, height: 20,)
                      ]),
                    ),
                    Expanded(child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 15),
                        child: ListView.builder(
                            padding: const EdgeInsets.only(top: 5),
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: searchItems.isEmpty ? items.length : searchItems.length ,
                            itemBuilder: (BuildContext context, int index){
                              return Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.only(bottom: 10),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                          color: Colors.grey,
                                          width: 1.0
                                      ),
                                      color: Colors.white
                                  ),
                                  child: ExpansionTile(
                                    title: Text(searchItems.isEmpty ? items[index].faq_title! : searchItems[index].faq_title!,
                                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black),),
                                    initiallyExpanded: false,
                                    backgroundColor: Colors.transparent,
                                    shape: const RoundedRectangleBorder(),
                                    children: [
                                      const Divider(thickness: 1,height: 1,color: Colors.grey,),
                                      Container(
                                        alignment: const Alignment(-1.0,0.0),
                                        margin: const EdgeInsets.only(top: 10),
                                        child: Text(searchItems.isEmpty ? items[index].faq_detail! : searchItems[index].faq_detail!,
                                          style: const TextStyle(fontSize: 14, color: Colors.grey),),
                                      )
                                    ],
                                  )
                              );
                            }
                        )
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
