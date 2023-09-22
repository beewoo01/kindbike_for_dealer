
import 'package:dio/dio.dart';
import 'package:kindbike_for_dealer/Model/AccountModel.dart';
import 'package:kindbike_for_dealer/Model/BiddingModel.dart';
import 'package:kindbike_for_dealer/Model/NoticeModel.dart';
import 'package:kindbike_for_dealer/Model/ProductModel.dart';
import 'package:kindbike_for_dealer/Model/QuestionModel.dart';
import 'package:retrofit/http.dart';

import '../Model/AlarmModel.dart';
import '../Model/ReviewModel.dart';


part 'rest_client.g.dart';

// @RestApi(baseUrl: "http://codebrosdev.cafe24.com:8080/motorcycle/")
@RestApi(baseUrl: "http://192.168.0.137:8080/project")

abstract class RestClient{  //수정후 flutter pub run build_runner build
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;


  @GET("/test_client")
  Future<int> test_client(@Query("abs") int abs );

  @POST("/joinDealer")
  Future<int> joinDealer(
      @Query("dealer_id") String dealer_id, @Query("dealer_password") String dealer_password,
      @Query("dealer_company") String dealer_company, @Query("dealer_name") String dealer_name,
      @Query("dealer_position") String dealer_position, @Query("dealer_phone") String dealer_phone,
      @Query("dealer_company_img") String dealer_company_img, @Query("dealer_business_license") String dealer_business_license);

  @GET("/loginDealer")
  Future<int> loginDealer(
      @Query("dealer_id") String dealer_id, @Query("dealer_password") String dealer_password);

  @GET("/findIDForDealer")
  Future<String> findIDForDealer(
      @Query("dealer_name") String dealer_name, @Query("dealer_phone") String dealer_phone);

  @GET("/findPWForDealer")
  Future<String> findPWForDealer(
      @Query("dealer_id") String dealer_id, @Query("dealer_name") String dealer_name, @Query("dealer_phone") String dealer_phone);

  @GET("/getProductsIng")
  Future<List<ProductModel>> getProductsIng();

  @GET("/getProductsEnd")
  Future<List<ProductModel>> getProductsEnd();

  @GET("/getProductsDetail")
  Future<ProductModel> getProductsDetail( @Query("product_idx") int product_idx);

  @GET("/existsRegist")
  Future<int> existsRegist(
      @Query("buy_product_idx") int buy_product_idx,@Query("buy_dealer_idx") int buy_dealer_idx);

  @POST("/registEstimate")
  Future<int> registEstimate(
      @Query("buy_product_idx") int buy_product_idx,@Query("buy_dealer_idx") int buy_dealer_idx,
      @Query("buy_price") String buy_price);

  @GET("/getMyBiddingList")
  Future<List<BiddingModel>> getMyBiddingList(@Query("buy_dealer_idx") int buy_dealer_idx, @Query("state") String state);

  @GET("/getMyBiddingDetail")
  Future<BiddingModel> getMyBiddingDetail(@Query("buy_dealer_idx") int buy_dealer_idx, @Query("product_idx") int product_idx);

  @POST("/insertPay")
  Future<int> insertPay(
      @Query("pay_buy_idx") int pay_buy_idx, @Query("pay_price") int pay_price,
      @Query("pay_detail") String pay_detail);

  @PUT("/updatePayState")
  Future<int> updatePayState(@Query("pay_idx") int pay_idx);

  @GET("/getNotice")
  Future<List<NoticeModel>> getNotice();

  @GET("/getNoticeDetail")
  Future<NoticeModel> getNoticeDetail(@Query("notice_idx") int notice_idx);

  @GET("/getFAQ")
  Future<List<NoticeModel>> getFAQ();

  @GET("/getQuestion")
  Future<List<QuestionModel>> getQuestion(@Query("question_people_idx") int question_people_idx);

  @POST("/registQuestion")
  Future<int> registQuestion(
      @Query("question_people_idx") int question_people_idx,@Query("question_title") String question_title,
      @Query("question_detail") String question_detail);

  @GET("/getQuestionDetail")
  Future<QuestionModel> getQuestionDetail(@Query("question_idx") int question_idx);

  @GET("/getDealerInfo")
  Future<AccountModel> getDealerInfo(@Query("dealer_idx") int dealer_idx);

  @PUT("/updateDealerInfo")
  Future<int> updateDealerInfo(
      @Query("dealer_password") String dealer_password, @Query("dealer_company") String dealer_company,
      @Query("dealer_name") String dealer_name, @Query("dealer_position") String dealer_position,
      @Query("dealer_phone") String dealer_phone, @Query("dealer_company_img") String dealer_company_img,
      @Query("dealer_business_license") String dealer_business_license, @Query("dealer_idx") int dealer_idx);

  @GET("/getReviewList")
  Future<List<ReviewModel>> getReviewList(@Query("buy_dealer_idx") int buy_dealer_idx);

  @GET("/getReviewDetail")
  Future<ReviewModel> getReviewDetail(@Query("dealer_review_idx") int dealer_review_idx);

  @GET("/selectAlarmState")
  Future<int> selectAlarmState(@Query("dealer_idx") int dealer_idx);

  @PUT("/updateDealerAlarm")
  Future<int> updateDealerAlarm(
      @Query("dealer_alarm") int dealer_alarm, @Query("dealer_idx") int dealer_idx);

  @DELETE("/withdrawDealer")
  Future<int> withdrawDealer(@Query("dealer_idx") int dealer_idx);

  @PUT("/updateDealerToken")
  Future<int> updateDealerToken(@Query("dealer_token") String dealer_token, @Query("dealer_idx") int dealer_idx);

  @GET("/existsAlarm")
  Future<int> existsAlarm(@Query("alarm_dealer_dealer_idx") int alarm_dealer_dealer_idx);

  @GET("/selectDealerAlarmList")
  Future<List<AlarmModel>> selectDealerAlarmList(@Query("alarm_dealer_dealer_idx") int alarm_dealer_dealer_idx);

  @PUT("/updatePay")
  Future<int> updatePay(@Query("pay_receipt_id") String pay_receipt_id, @Query("pay_idx") int pay_idx);
}