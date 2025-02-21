import 'package:get/get.dart';
import 'package:ormee_mvp/api/OrmeeApi.dart';
import 'package:ormee_mvp/screens/teacher/quiz_detail/model.dart';

class QuizDetailService extends GetConnect {
  QuizDetailService() {
    final api = API();
    httpClient.baseUrl = '${api.hostConnect}';
    httpClient.timeout = const Duration(seconds: 10);

    httpClient.addRequestModifier<dynamic>((request) async {
      request.headers['Accept'] = 'application/json';
      request.headers['Content-Type'] = 'application/json; charset=utf-8';
      return request;
    });
  }

  Future<QuizDetail> fetchQuiz(String quizId) async {
    final String url = '/quizes/$quizId';
    final response = await get(url);

    if (response.statusCode == 200) {
      return QuizDetail.fromJson(response.body['data']);
    } else {
      throw Exception('Failed to fetch quizzes');
    }
  }

  Future<bool> deleteQuiz(String quizId) async {
    final String url = '/quizes/teacher/$quizId';
    final response = await delete(url);

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to delete quizzes');
    }
  }
}
