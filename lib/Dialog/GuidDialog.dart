import 'package:flutter/material.dart';

class GuidPopup extends StatelessWidget {
  const GuidPopup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 0,
      contentPadding: const EdgeInsets.all(10),
      backgroundColor: Colors.white,
      content: SizedBox(
        width: double.maxFinite,
        child: Column(mainAxisSize: MainAxisSize.min,crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 15),
            child: const Text('앱 이용 가이드', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23, color: Colors.black)),
          ),
          SizedBox(
            height: 250,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Text('이용가이드이용가이드이용가이드이용가이드이용가이드이용가이드이용가이드이용가이드'
                  '이용가이드이용가이드이용가이드이용가이드이용가이드이용가이드이용가이드이용가이드이용가이드이용가이드이용가이드'
                  '이용가이드이용가이드이용가이드이용가이드이용가이드이용가이드이용가이드이용가이드이용가이드이용가이드이용가이드'
                  '이용가이드이용가이드이용가이드이용가이드이용가이드이용가이드이용가이드이용가이드이용가이드이용가이드이용가이드'
                  '이용가이드이용가이드이용가이드이용가이드이용가이드이용가이드이용가이드이용가이드이용가이드이용가이드이용가이드'
                  '이용가이드이용가이드이용가이드이용가이드이용가이드이용가이드이용가이드이용가이드이용가이드이용가이드이용가이드', style: TextStyle(color: Colors.black),),
            ),
          ),
          Container(width: double.infinity, height: 50, margin: const EdgeInsets.only(top: 15), child: TextButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: Colors.black)
                ))),
            onPressed: (){
              Navigator.pop(context);
            },
            child: const Text('확인', style: TextStyle(color: Colors.white, fontSize: 16)),
          ),)
        ]),
      )
    );
  }
}
