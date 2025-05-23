// lecture_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ormee_mvp/screens/lecture_detail/model.dart';
import 'package:ormee_mvp/screens/lecture_detail/service.dart';

class LectureController extends GetxController {
  final LectureService _service = LectureService();

  var isLoading = false.obs;
  var lectureDetail = Rx<LectureDetailModel?>(null);
  var message = Rx<Message?>(null);
  var error = Rx<String?>(null);

  Future<void> fetchLectureDetail(String lectureId) async {
    isLoading(true);
    error(null);

    try {
      final detail = await _service.fetchLectureDetail(lectureId);
      lectureDetail.value = detail;
    } catch (e) {
      error(e.toString());
      Get.snackbar(
        '오류',
        '강의 정보를 불러오는데 실패했습니다.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchMessageDetail(String lectureId) async {
    isLoading(true);
    error(null);

    try {
      final detail = await _service.fetchMessageDetail(lectureId);
      message.value = detail;
    } catch (e) {
      error(e.toString());
      debugPrint("메세지 정보를 불러오는데 실패했습니다.");
      // Get.snackbar(
      //   '오류',
      //   '강의 정보를 불러오는데 실패했습니다.',
      //   snackPosition: SnackPosition.BOTTOM,
      //   duration: const Duration(seconds: 3),
      // );
    } finally {
      isLoading(false);
    }
  }
}
