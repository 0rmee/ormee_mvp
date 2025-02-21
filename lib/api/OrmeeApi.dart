import 'package:flutter_dotenv/flutter_dotenv.dart';

class API {
  // 싱글톤 인스턴스 생성
  static final API _instance = API._internal();

  late final String ip;
  late final String hostConnect;

  // private 생성자
  API._internal() {
    ip = dotenv.env['SERVER_IP'] ?? '';
    hostConnect = "https://$ip.nip.io:8443";
  }

  // factory 생성자 반환
  factory API() {
    return _instance;
  }
}
