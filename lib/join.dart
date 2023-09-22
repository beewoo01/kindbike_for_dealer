import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kindbike_for_dealer/Dialog/TermsDialog.dart';
import 'package:ssh2/ssh2.dart';
import 'package:toast/toast.dart';

import 'API/rest_client.dart';
import 'main.dart';

class Join extends StatefulWidget {
  const Join({Key? key}) : super(key: key);

  @override
  State<Join> createState() => _JoinState();
}

class _JoinState extends State<Join> {
  final idText = TextEditingController();
  final pwText = TextEditingController();
  final checkText = TextEditingController();
  final companyText = TextEditingController();
  final nameText = TextEditingController();
  final positionText = TextEditingController();
  final phoneText = TextEditingController();
  bool first = false, second = false;
  String imagePath = '', imageName = '', imagePath1 = '', imageName1 = '';


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
    ToastContext().init(context);
    final dio = Dio();
    dio.options.headers["Content-Type"] = "application/json";
    final api = RestClient(dio);

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
        resizeToAvoidBottomInset: true,
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
              const Text('회원가입', style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),textAlign: TextAlign.center),
              const SizedBox(width: 50)
            ],
            ),
          ),
          Expanded(child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: const Text('착한바이크경매\n딜러 회원가입', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23)),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20, bottom: 10),
                  child: const Text('아이디', style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold)),
                ),
                TextField(
                  maxLines: 1,
                  maxLength: 30,
                  controller: idText,
                  keyboardType: TextInputType.emailAddress,
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
                  child: const Text('비밀번호', style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold)),
                ),
                TextField(
                  maxLines: 1,
                  maxLength: 30,
                  controller: pwText,
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
                Container(
                  margin: const EdgeInsets.only(top: 20, bottom: 10),
                  child: const Text('비밀번호 확인', style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold)),
                ),
                TextField(
                  maxLines: 1,
                  maxLength: 30,
                  controller: checkText,
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
                Container(
                  margin: const EdgeInsets.only(top: 20, bottom: 10),
                  child: const Text('업체명', style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold)),
                ),
                TextField(
                  maxLines: 1,
                  maxLength: 30,
                  controller: companyText,
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
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: const Text('담당자', style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold)),
                ),
                Row(children: [
                  Expanded(child: Container(
                    margin: const EdgeInsets.only(right: 5),
                    child: TextField(
                      maxLines: 1,
                      maxLength: 10,
                      controller: nameText,
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
                Container(
                  margin: const EdgeInsets.only(top: 20, bottom: 10),
                  child: const Text('연락처', style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold)),
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
                  margin: const EdgeInsets.only(top: 30, bottom: 10),
                  child: const Text('사업자등록증 사진 등록', style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold)),
                ),
                Container(
                  width: double.infinity,
                  height: 50,
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
                          imagePath = pickedImage.path;
                          imageName = pickedImage.name;
                        });
                      }
                    },
                    child: (){
                      if(imageName != ''){
                        return Text(imageName, style: const TextStyle(color: Colors.grey, overflow: TextOverflow.ellipsis));
                      }else{
                        return const Text('+ 사진 올리기', style: TextStyle(color: Colors.grey, overflow: TextOverflow.ellipsis));
                      }
                    }(),
                  )
                ),
                Container(
                  margin: const EdgeInsets.only(top: 30, bottom: 10),
                  child: const Text('업체 사진 등록', style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold)),
                ),
                Container(
                    width: double.infinity,
                    height: 50,
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
                            imagePath1 = pickedImage.path;
                            imageName1 = pickedImage.name;
                          });
                        }
                      },
                      child: (){
                        if(imageName1 != ''){
                          return Text(imageName1, style: const TextStyle(color: Colors.grey, overflow: TextOverflow.ellipsis));
                        }else{
                          return const Text('+ 사진 올리기', style: TextStyle(color: Colors.grey, overflow: TextOverflow.ellipsis));
                        }
                      }(),
                    )
                ),
                Container(
                  margin: const EdgeInsets.only(top: 30),
                  child: Row(children: [
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text('서비스 이용약관(필수)', style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold)),
                      Container(
                          margin: const EdgeInsets.only(top: 5),
                          child: GestureDetector(
                              onTap: (){
                                showDialog(context: context, builder: (BuildContext context){
                                  return const TermsPopup(title: '서비스 이용약관');
                                });
                              },
                              child: const Text('더보기', style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold))))
                    ])),
                    Checkbox(
                      value: first,
                      onChanged: (value) {
                        setState(() {
                          first = value!;
                        });
                      },
                      checkColor: first ? Colors.white : Colors.grey,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      fillColor: MaterialStateColor.resolveWith(
                              (states) => first ? Colors.black : Colors.white),
                      side: MaterialStateBorderSide.resolveWith((states) =>
                      first
                          ? const BorderSide(
                          width: 1.0, color: Colors.black)
                          : const BorderSide(
                          width: 1.0, color: Colors.grey)),
                    ),
                  ])
                ),
                Container(
                    margin: const EdgeInsets.only(top: 30),
                    child: Row(children: [
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const Text('개인정보 이용약관(필수)', style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold)),
                        Container(
                            margin: const EdgeInsets.only(top: 5),
                            child: GestureDetector(
                                onTap: (){
                                  showDialog(context: context, builder: (BuildContext context){
                                    return const TermsPopup(title: '개인정보 이용약관');
                                  });
                                },
                                child: const Text('더보기', style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold))))
                      ])),
                      Checkbox(
                        value: second,
                        onChanged: (value) {
                          setState(() {
                            second = value!;
                          });
                        },
                        checkColor: second ? Colors.white : Colors.grey,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        fillColor: MaterialStateColor.resolveWith(
                                (states) => second ? Colors.black : Colors.white),
                        side: MaterialStateBorderSide.resolveWith((states) =>
                        second
                            ? const BorderSide(
                            width: 1.0, color: Colors.black)
                            : const BorderSide(
                            width: 1.0, color: Colors.grey)),
                      ),
                    ])
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 30),
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black
                  ),
                  child: TextButton(
                    onPressed: () async{
                      if(idText.text == '' || pwText.text == '' || checkText.text == '' || companyText.text == '' ||
                          nameText.text == '' || positionText.text == '' || phoneText.text == '' || imagePath == '' || imagePath1 == ''){
                        Toast.show('필수 정보를 입력해주세요.', duration: Toast.lengthShort, gravity: Toast.bottom);
                      }else if(first == false || second == false){
                        Toast.show('이용약관에 동의해주세요.', duration: Toast.lengthShort, gravity: Toast.bottom);
                      }else if(pwText.text != checkText.text){
                        Toast.show('비밀번호가 일치하지 않습니다.', duration: Toast.lengthShort, gravity: Toast.bottom);
                      }else{
                        await sendSFTP(imagePath);
                        await sendSFTP(imagePath1);
                        api.joinDealer(idText.text, pwText.text, companyText.text, nameText.text,
                            positionText.text, phoneText.text, imageName1, imageName).then((value) => {
                          if(value == -1){
                            Toast.show('중복된 아이디 입니다.', duration: Toast.lengthShort, gravity: Toast.bottom)
                          }else{
                            Toast.show('가입 되었습니다.', duration: Toast.lengthShort, gravity: Toast.bottom),
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (BuildContext context) => const Login()),
                                    (route) => false
                            )
                          }
                        });
                      }
                    },
                    child: const Text('회원가입 승인 요청', style: TextStyle(color: Colors.white, fontSize: 15)),
                  ),
                )
              ]),
            ),
          ))
        ]),
      ),
    );
  }
}
