class Singleton{
  static final Singleton _instance = Singleton._internal();

  var idx;
  var email;
  var name;
  var phone;
  var token;

  factory Singleton() {
    //기존에 생성된 인스턴스가 아니라면 새롭게 생성되고, 기존 인스턴스가 있다면 기존 것을 반환한다.
    return _instance;
  }

  Singleton._internal() {
    // 초기화
  }
}

late Singleton singleton;

initState() {
  //factory 생성자 호출
  singleton = Singleton();
}