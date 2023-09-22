import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kindbike_for_dealer/Singleton/singleton.dart';
import 'package:ssh2/ssh2.dart';
import 'package:toast/toast.dart';

import '../API/rest_client.dart';
import '../Model/AccountModel.dart';
import 'HomeContainer.dart';

class SettingMyInfo extends StatefulWidget {
  const SettingMyInfo({Key? key}) : super(key: key);

  @override
  State<SettingMyInfo> createState() => _SettingMyInfoState();
}

class _SettingMyInfoState extends State<SettingMyInfo> {
  String profilePath = '', profileName = '', licensePath = '', licenseName = '';
  late AccountModel model;

  final pwText = TextEditingController();
  final checkText = TextEditingController();
  final companyText = TextEditingController();
  final nameText = TextEditingController();
  final positionText = TextEditingController();
  final phoneText = TextEditingController();

  final pwFocus = FocusNode();
  final checkFocus = FocusNode();
  final companyFocus = FocusNode();
  final nameFocus = FocusNode();
  final positionFocus = FocusNode();
  final phoneFocus = FocusNode();

  void clearText(){
    setState(() {
      pwText.clear();
      checkText.clear();
      companyText.clear();
      nameText.clear();
      positionText.clear();
      phoneText.clear();
      pwFocus.unfocus();
      checkFocus.unfocus();
      companyFocus.unfocus();
      nameFocus.unfocus();
      positionFocus.unfocus();
      phoneFocus.unfocus();
    });
  }
  void afterInsert(){
    setState(() {
      profilePath = '';
      profileName = '';
      licensePath = '';
      licenseName = '';
      pwText.clear();
      checkText.clear();
      pwFocus.unfocus();
      checkFocus.unfocus();
      companyFocus.unfocus();
      nameFocus.unfocus();
      positionFocus.unfocus();
      phoneFocus.unfocus();
    });
  }

  Future<void> sendSFTP(String filePath) async {
    String result = '';
    List? array = [];

    var client = SSHClient(
      host: "110.10.174.243",
      port: 22,
      username: "root",
      passwordOrKey: "code4554!",
    );
    try{
      result = await client.connect() ?? 'Null result';
      if(result == 'session_connected'){
        result = await client.connectSFTP() ?? 'Null result';
        if(result == 'sftp_connected'){
          array = await client.sftpLs('/var/lib/tomcat9/webapps/media/kindbike/dealer') ?? [];
          await client.sftpUpload(
            path: filePath,
            toPath: "/var/lib/tomcat9/webapps/media/kindbike/dealer",
            callback: (progress) async {
              print(progress);
            },
          ) ?? 'Upload failed';

          await client.disconnect();
        }
      }

    } on PlatformException catch (e){
      print(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    Singleton singleton = Singleton();
    ToastContext().init(context);
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
        resizeToAvoidBottomInset: true,
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
                        clearText();
                        HomeContainerState.of(context)?.bottomTapped(2);
                      },
                      icon: Image.asset("assets/ic_back.png")),
                ),
                const Text('내 업체 정보', style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),textAlign: TextAlign.center),
                const SizedBox(width: 50)
              ],
              ),
            ),
            FutureBuilder(
              future: api.getDealerInfo(singleton.idx),
              builder: (context, AsyncSnapshot snapshot){
                if(snapshot.hasData){
                  model = snapshot.data as AccountModel;
                  nameText.text = model.dealer_name!;
                  companyText.text = model.dealer_company!;
                  positionText.text = model.dealer_position!;
                  phoneText.text = model.dealer_phone!;

                  return Column(children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: ClipOval(
                        child: (){
                          if(profileName != ''){
                            return Image.file(File(profilePath),
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,);
                          }else{
                            return Image(image: NetworkImage(
                                'http://codebrosdev.cafe24.com:8080/media/kindbike/dealer/${model.dealer_company_img}'),
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,);
                          }
                        }(),
                      ),
                    ),
                    Container(
                      width: 100,
                      height: 35,
                      margin: const EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.black
                      ),
                      child: TextButton(
                        onPressed: () async{
                          final picker = ImagePicker();
                          final pickedImage = await picker.pickImage(source: ImageSource.gallery);
                          if(pickedImage != null){
                            setState(() {
                              profilePath = pickedImage.path;
                              profileName = pickedImage.name;
                            });
                          }
                        },
                        child: const Text('수정하기', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(20),
                      width: double.infinity,
                      height: 1.0,
                      color: Colors.black,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 20),
                      alignment: const Alignment(-1.0,0.0),
                      child: const Text('아이디', style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(22, 10, 0, 15),
                      alignment: const Alignment(-1.0,0.0),
                      child: Text('${model.dealer_id}', style: const TextStyle(color: Colors.black, fontSize: 16)),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 20),
                      alignment: const Alignment(-1.0,0.0),
                      child: const Text('비밀번호', style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(20, 10, 20, 15),
                      child: TextField(
                        maxLines: 1,
                        maxLength: 30,
                        controller: pwText,
                        focusNode: pwFocus,
                        obscureText: true,
                        decoration: const InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)
                            ), focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)
                        ),
                            hintText: '비밀번호',
                            hintStyle: TextStyle(color: Colors.grey),
                            counterText: ''
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 20),
                      alignment: const Alignment(-1.0,0.0),
                      child: const Text('비밀번호 확인', style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(20, 10, 20, 15),
                      child: TextField(
                        maxLines: 1,
                        maxLength: 30,
                        controller: checkText,
                        focusNode: checkFocus,
                        obscureText: true,
                        decoration: const InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)
                            ), focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)
                        ),
                            hintText: '비밀번호 재입력',
                            hintStyle: TextStyle(color: Colors.grey),
                            counterText: ''
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 20),
                      alignment: const Alignment(-1.0,0.0),
                      child: const Text('업체명', style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(20, 10, 20, 15),
                      child: TextField(
                        maxLines: 1,
                        maxLength: 30,
                        controller: companyText,
                        focusNode: companyFocus,
                        decoration: const InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)
                            ), focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)
                        ),
                            hintText: '업체명',
                            hintStyle: TextStyle(color: Colors.grey),
                            counterText: ''
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 20),
                      alignment: const Alignment(-1.0,0.0),
                      child: const Text('담당자', style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(20, 10, 20, 15),
                      child: Row(children: [
                        Expanded(child: Container(
                          margin: const EdgeInsets.only(right: 5),
                          child: TextField(
                            maxLines: 1,
                            maxLength: 10,
                            controller: nameText,
                            focusNode: nameFocus,
                            keyboardType: TextInputType.text,
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
                        )),
                        Expanded(child: Container(
                          margin: const EdgeInsets.only(left: 5),
                          child: TextField(
                            maxLines: 1,
                            maxLength: 10,
                            controller: positionText,
                            focusNode: positionFocus,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey)
                                ), focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)
                            ),
                                hintText: '직급',
                                hintStyle: TextStyle(color: Colors.grey),
                                counterText: ''
                            ),
                          ),
                        ))
                      ]),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 20),
                      alignment: const Alignment(-1.0,0.0),
                      child: const Text('연락처', style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(20, 10, 20, 15),
                      child: TextField(
                        maxLines: 1,
                        maxLength: 11,
                        controller: phoneText,
                        focusNode: phoneFocus,
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
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 20),
                      alignment: const Alignment(-1.0,0.0),
                      child: const Text('사업자등록증 사진', style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      width: 170,
                      height: 250,
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.grey,
                              width: 1.0
                          )
                      ),
                      child: (){
                        if(licenseName != ''){
                          return Image.file(File(licensePath),
                            width: double.infinity, height: double.infinity, fit: BoxFit.cover,);
                        }else{
                          return Image(image: NetworkImage(
                              'http://codebrosdev.cafe24.com:8080/media/kindbike/dealer/${model.dealer_business_license}'),
                            width: double.infinity, height: double.infinity, fit: BoxFit.cover,);
                        }
                      }(),
                    ),
                    Container(
                      width: double.infinity,
                      height: 50,
                      margin: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: HexColor('EEEEEE'),
                          border: Border.all(width: 1, color: HexColor('DDDDDD'))
                      ),
                      child: TextButton(
                          onPressed: () async{
                            final picker = ImagePicker();
                            final pickedImage = await picker.pickImage(source: ImageSource.gallery);
                            if(pickedImage != null){
                              setState(() {
                                licensePath = pickedImage.path;
                                licenseName = pickedImage.name;
                              });
                            }
                          },
                          child: const Text('+ 사진 올리기', style: TextStyle(color: Colors.grey))),
                    ),
                  ]);
                }else{
                  return Container();
                }
              },
            ),
            Container(
              width: double.infinity,
              height: 55,
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  border: Border.all(width: 1.0, color: Colors.black)
              ),
              child: TextButton(
                  onPressed: () async{
                    if(pwText.text == '' || checkText.text == '' || companyText.text == '' || nameText.text == '' ||
                        positionText.text == '' || phoneText.text == ''){
                      Toast.show('필수 정보를 입력해 주세요.', duration: Toast.lengthShort, gravity: Toast.bottom);
                    }else if(pwText.text != checkText.text){
                      Toast.show('비밀번호가 일치하지 않습니다.', duration: Toast.lengthShort, gravity: Toast.bottom);
                    }else{
                      if(profilePath != '' && licensePath == ''){
                        await sendSFTP(profilePath);
                        api.updateDealerInfo(pwText.text, companyText.text, nameText.text, positionText.text,
                            phoneText.text, profileName, model.dealer_business_license!, singleton.idx).then((value) => {
                          if(value == 1){
                            afterInsert(),
                            Toast.show('수정되었습니다.', duration: Toast.lengthShort, gravity: Toast.bottom),
                          }
                        });
                      }else if(profilePath == '' && licensePath != ''){
                        await sendSFTP(licensePath);
                        api.updateDealerInfo(pwText.text, companyText.text, nameText.text, positionText.text,
                            phoneText.text, model.dealer_company_img!,licenseName, singleton.idx).then((value) => {
                          if(value == 1){
                            afterInsert(),
                            Toast.show('수정되었습니다.', duration: Toast.lengthShort, gravity: Toast.bottom),
                          }
                        });
                      }else if(profilePath != '' && licensePath != ''){
                        await sendSFTP(profilePath);
                        await sendSFTP(licensePath);
                        api.updateDealerInfo(pwText.text, companyText.text, nameText.text, positionText.text,
                            phoneText.text, profileName, licenseName, singleton.idx).then((value) => {
                          if(value == 1){
                            afterInsert(),
                            Toast.show('수정되었습니다.', duration: Toast.lengthShort, gravity: Toast.bottom),
                          }
                        });
                      }else{
                        api.updateDealerInfo(pwText.text, companyText.text, nameText.text, positionText.text,
                            phoneText.text,  model.dealer_company_img!, model.dealer_business_license!, singleton.idx).then((value) => {
                          if(value == 1){
                            afterInsert(),
                            Toast.show('수정되었습니다.', duration: Toast.lengthShort, gravity: Toast.bottom),
                          }
                        });
                      }
                    }
                  },
                  child: const Text('정보수정', style: TextStyle(color: Colors.black))),
            ),
            Container(
              width: double.infinity,
              height: 55,
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black
              ),
              child: TextButton(
                  onPressed: () {
                    HomeContainerState.of(context)?.bottomTapped(12);
                  },
                  child: const Text('업체 후기 보기', style: TextStyle(color: Colors.white))),
            )
          ]),
        ),
      ),
    );
  }
}
