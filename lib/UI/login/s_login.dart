import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kindbike_for_dealer/API/rest_client.dart';
import 'package:kindbike_for_dealer/Dialog/LoginDialog.dart';
import 'package:kindbike_for_dealer/Singleton/singleton.dart';
import 'package:kindbike_for_dealer/UI/HomeContainer.dart';
import 'package:kindbike_for_dealer/common/w_height_and_width.dart';
import 'package:kindbike_for_dealer/join.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../findAccount.dart';

class LoginScreen extends StatefulWidget {
  String token;
  LoginScreen(this.token, {Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final idText = TextEditingController();
  final pwText = TextEditingController();
  final idFocus = FocusNode();
  final pwFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    final dio = Dio();
    dio.options.headers["Content-Type"] = "application/json";
    final api = RestClient(dio); //RestApi
    Singleton singleton = Singleton();

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/login_bg.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Expanded(
                  child: Container(),
                ),
                const Expanded(
                  child: Image(
                    image: AssetImage('assets/ic_logo1.png'),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                height30,
                buildTextField(
                    "아이디", Icons.person, TextInputType.emailAddress, false)
                    .pSymmetric(h: 10),
                height10,
                buildTextField(
                    "비밀번호", Icons.lock, TextInputType.visiblePassword, true)
                    .pSymmetric(h: 10),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: TextButton(
                    onPressed: () {
                      idText.text = 'test@test.com';
                      pwText.text = 'qw#2486258';
                      api.loginDealer(idText.text, pwText.text).then((value) {
                        print("loginDealer");
                        if(value > 0) {
                          print("value > 0");
                          singleton.idx = value;

                          api.updateDealerToken(widget.token.toString(), value).then((value) {
                            print("updateDealerToken");
                            if(value == 1) {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeContainer()));
                            }
                          });
                        } else {
                          showDialog(context: context, builder: (BuildContext context) {
                            return const FailLoginPopup();
                          });
                        }

                      });

                    },
                    style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all(Colors.white),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(color: Colors.black)))),
                    child: "로그인".text.black.make(),
                  ),
                ).pSymmetric(h: 10, v: 20),

                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const FindAccount()));
                  },
                  child: const Text(
                    '아이디/비밀번호 찾기 >',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white),
                  ),
                ),

                Expanded(child: Container()),

                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Join()));
                    },
                    child: '회원가입'.text.white.size(15).make()
                ).pOnly(bottom: 30),



              ],
            ),
          ),
        ],
      ),
    );
  }



  TextField buildTextField(
      String title, IconData icon, TextInputType inputType, bool obscureText) {
    return TextField(
      maxLines: 1,
      maxLength: 30,
      style: const TextStyle(color: Colors.white),
      keyboardType: inputType,
      obscureText: obscureText,
      decoration: InputDecoration(
          enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white)),
          focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white)),
          prefixIcon: Icon(
            icon,
            color: Colors.white,
          ),
          //ImageIcon(AssetImage("assets/icon_id.png"), color: Colors.white,),
          hintText: title,
          hintStyle: const TextStyle(color: Colors.white),
          counterText: ''),
    );
  }
}
