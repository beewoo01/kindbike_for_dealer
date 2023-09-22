import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kindbike_for_dealer/Dialog/AccountDialog.dart';
import 'package:toast/toast.dart';

import 'API/rest_client.dart';
import 'main.dart';

class FindAccount extends StatefulWidget {
  const FindAccount({Key? key}) : super(key: key);

  @override
  State<FindAccount> createState() => _FindAccountState();
}

class _FindAccountState extends State<FindAccount> with TickerProviderStateMixin{
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (BuildContext context) => const Login()),
                (route) => false
        );
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
                      onPressed: (){Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (BuildContext context) => const Login()),
                              (route) => false
                      );},
                      icon: Image.asset("assets/ic_back.png")),
                ),
                const Text('계정찾기', style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),textAlign: TextAlign.center),
                const SizedBox(width: 50)
              ],
              ),
            ),
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
                    child: const Text('아이디 찾기', style: TextStyle( fontSize: 15, fontWeight: FontWeight.bold),),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: const Text('비밀번호 찾기', style: TextStyle( fontSize: 15, fontWeight: FontWeight.bold),),
                  )
                ],),
            ),
            Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    findID(context),
                    findPW(context),
                  ],
                ))
          ],)

      ),
    );
  }
  Widget findID(BuildContext context){
    ToastContext().init(context);
    final dio = Dio();
    dio.options.headers["Content-Type"] = "application/json";
    final api = RestClient(dio);

    final nameText = TextEditingController();
    final phoneText = TextEditingController();

    void clearText() {
      setState(() {
        nameText.clear();
        phoneText.clear();
      });
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          margin: const EdgeInsets.only(top: 20, bottom: 10),
          child: const Text('이름', style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold)),
        ),
        TextField(
          maxLines: 1,
          maxLength: 10,
          controller: nameText,
          textInputAction: TextInputAction.done,
          decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)
              ), focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey)
          ),
              hintText: '이름',
              hintStyle: TextStyle(color: Colors.grey),
              counterText: ''
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 20, bottom: 10),
          child: const Text('연락처', style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold)),
        ),
        TextField(
          maxLines: 1,
          maxLength: 11,
          controller: phoneText,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.done,
          decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)
              ), focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey)
          ),
              hintText: '\'-\'빼고 입력',
              hintStyle: TextStyle(color: Colors.grey),
              counterText: ''
          ),
        ),
        Container(
          width: double.infinity,
          height: 50,
          margin: const EdgeInsets.only(top: 40),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.black
          ),
          child: TextButton(
              onPressed: (){
                api.findIDForDealer(nameText.text, phoneText.text).then((value) => {
                  clearText(),
                  if(value == 'x'){
                    Toast.show('존재하지 않는 계정입니다.', duration: Toast.lengthShort, gravity: Toast.bottom)
                  }else{
                    showDialog(context: context, builder: (BuildContext context){
                      return AccountDialog(content: '아이디는', keyStr: value);
                    })
                  }
                });
              },
              child: const Text('아이디 찾기', style: TextStyle(color: Colors.white, fontSize: 17),),
          ),
        )
      ]),
    );
  }

  Widget findPW(BuildContext context){
    ToastContext().init(context);
    final dio = Dio();
    dio.options.headers["Content-Type"] = "application/json";
    final api = RestClient(dio);

    final idText = TextEditingController();
    final nameText = TextEditingController();
    final phoneText = TextEditingController();

    void clearText() {
      setState(() {
        idText.clear();
        nameText.clear();
        phoneText.clear();
      });
    }
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          margin: const EdgeInsets.only(top: 20, bottom: 10),
          child: const Text('아이디', style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold)),
        ),
        TextField(
          maxLines: 1,
          maxLength: 30,
          controller: idText,
          decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)
              ), focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey)
          ),
              hintText: '아이디',
              hintStyle: TextStyle(color: Colors.grey),
              counterText: ''
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 20, bottom: 10),
          child: const Text('이름', style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold)),
        ),
        TextField(
          maxLines: 1,
          maxLength: 10,
          controller: nameText,
          decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)
              ), focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey)
          ),
              hintText: '이름',
              hintStyle: TextStyle(color: Colors.grey),
              counterText: ''
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 20, bottom: 10),
          child: const Text('연락처', style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold)),
        ),
        TextField(
          maxLines: 1,
          maxLength: 11,
          controller: phoneText,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)
              ), focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey)
          ),
              hintText: '\'-\'빼고 입력',
              hintStyle: TextStyle(color: Colors.grey),
              counterText: ''
          ),
        ),
        Container(
          width: double.infinity,
          height: 50,
          margin: const EdgeInsets.only(top: 40),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.black
          ),
          child: TextButton(
            onPressed: (){
              api.findPWForDealer(idText.text, nameText.text, phoneText.text).then((value) => {
                clearText(),
                if(value == 'x'){
                  Toast.show('존재하지 않는 계정입니다.', duration: Toast.lengthShort, gravity: Toast.bottom)
                }else{
                  showDialog(context: context, builder: (BuildContext context){
                    return AccountDialog(content: '비밀번호는', keyStr: value);
                  })
                }
              });
            },
            child: const Text('비밀번호 찾기', style: TextStyle(color: Colors.white, fontSize: 17),),
          ),
        )
      ])
    );
  }
}
