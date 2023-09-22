import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:kindbike_for_dealer/UI/Alarm.dart';
import 'package:kindbike_for_dealer/UI/Bidding.dart';
import 'package:kindbike_for_dealer/UI/BiddingDetail.dart';
import 'package:kindbike_for_dealer/UI/HomeDetail.dart';
import 'package:kindbike_for_dealer/UI/Setting.dart';
import 'package:kindbike_for_dealer/UI/SettingFAQ.dart';
import 'package:kindbike_for_dealer/UI/SettingMyInfo.dart';
import 'package:kindbike_for_dealer/UI/SettingMyReview.dart';
import 'package:kindbike_for_dealer/UI/SettingMyReviewDetail.dart';
import 'package:kindbike_for_dealer/UI/SettingNotice.dart';
import 'package:kindbike_for_dealer/UI/SettingNoticeDetail.dart';
import 'package:kindbike_for_dealer/UI/SettingQuestion.dart';
import 'package:kindbike_for_dealer/UI/SettingQuestionAdd.dart';
import 'package:kindbike_for_dealer/UI/SettingQuestionDetail.dart';

import 'Home.dart';

class HomeContainer extends StatefulWidget {
  const HomeContainer({Key? key}) : super(key: key);

  @override
  State<HomeContainer> createState() => HomeContainerState();
}

class HomeContainerState extends State<HomeContainer> {
  static HomeContainerState? of(BuildContext context) => context.findAncestorStateOfType<HomeContainerState>();
  int bottomSelectedIndex = 1;

  int homeIdx = 0, noticeIdx = 0, questionIdx = 0, biddingIdx = 0, reviewIdx = 0;

  List<Widget> listWidget = [
    const Bidding(),               //0 견적요청
    const Home(),                  //1 메인화면
    const Setting(),               //2 설정화면
    const HomeDetail(),            //3 매입상세
    const BiddingDetail(),         //4 입찰상세
    const SettingFAQ(),            //5  FAQ
    const SettingMyInfo(),         //6  내 업체정보
    const SettingNotice(),         //7  공지사항
    const SettingNoticeDetail(),   //8  공지사항상세
    const SettingQuestion(),       //9  문의하기
    const SettingQuestionAdd(),    //10 문의등록
    const SettingQuestionDetail(), //11 문의상세
    const SettingMyReview(),       //12 업체후기
    const SettingMyReviewDetail(), //13 업체후기상세
    const Alarm(),


  ];

  PageController pageController = PageController(
    initialPage: 1,
    keepPage: true,
  );

  void pageChanged(int index) {
    setState(() {
      if (index < 3) bottomSelectedIndex = bottomSelectedIndex;
    });
  }

  void bottomTapped(int index) {
    setState(() {
      if (index < 3) {
        bottomSelectedIndex = index;
      }
      pageController.jumpToPage(index);
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: PageView.builder(
          controller: pageController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (index) {
            pageChanged(index);
          },
          itemCount: listWidget.length,
          itemBuilder: (BuildContext context, int index) {
            return listWidget[index];
          },
        ),
        bottomNavigationBar: ConvexAppBar(
          backgroundColor: Colors.white,
          color: Colors.grey,
          activeColor: Colors.black,
          style: TabStyle.fixedCircle,
          initialActiveIndex: bottomSelectedIndex,
          items: [
            TabItem(icon: Image.asset('assets/icon_01.png'), activeIcon: Image.asset('assets/icon_03.png'), title: '견적'),
            TabItem(icon: Image.asset('assets/bt_main.png'), activeIcon: Image.asset('assets/bt_main.png'), title: '홈'),
            TabItem(icon: Image.asset('assets/icon_02.png'), activeIcon: Image.asset('assets/icon_04.png'), title: '설정')
          ],
          onTap: (index){
            bottomTapped(index);
          },
        )
    );
  }
}
