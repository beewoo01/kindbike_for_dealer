import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class TermsPopup extends StatelessWidget {
  final String title;

  const TermsPopup({Key? key, required this.title}) : super(key: key);
  Future<String> getFileData(String path) async {
    return await rootBundle.loadString(path);
  }
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
              child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 23, color: Colors.black)),
            ),
            SizedBox(
              height: 250,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: FutureBuilder(
                  future: getFileData('assets/terms.txt'),
                  builder: (context, AsyncSnapshot snapshot){
                    return Text(snapshot.data.toString(), style: const TextStyle(color: Colors.black));
                  },
                )
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
