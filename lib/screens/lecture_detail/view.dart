import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ormee_mvp/designs/OrmeeAppbar.dart';
import 'package:ormee_mvp/designs/OrmeeColor.dart';
import 'package:ormee_mvp/designs/OrmeeToast.dart';
import 'package:ormee_mvp/designs/OrmeeTypo.dart';
import 'package:ormee_mvp/designs/Indicator.dart';
import 'package:ormee_mvp/designs/StickyHeaderDelegate.dart';
import 'package:ormee_mvp/screens/lecture_detail/model.dart';
import 'package:ormee_mvp/screens/lecture_detail/service.dart';
import 'package:ormee_mvp/screens/lecture_detail/view_model.dart';
import 'package:ormee_mvp/screens/quiz_auth/view.dart';

class LectureDetail extends StatefulWidget {
  LectureDetail({
    super.key,
  });

  @override
  State<LectureDetail> createState() => _LectureDetailState();
}

class _LectureDetailState extends State<LectureDetail> {
  final lectureId = Get.parameters['lectureId'];

  final LectureController controller = Get.put(LectureController());
  final TextEditingController _controller = TextEditingController();
  final isTextFieldNotEmpty = false.obs;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
    controller.fetchLectureDetail(lectureId!).then((_) {
      final lectureDetail = controller.lectureDetail.value;
      if (lectureDetail != null) {
        controller.fetchMessageDetail(lectureDetail.id);
      }
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    isTextFieldNotEmpty.value = _controller.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Stack(
        children: [
          Scaffold(
            backgroundColor: OrmeeColor.white,
            appBar: OrmeeAppBar(
              leftIcon: SvgPicture.asset(
                'assets/icons/left.svg',
              ),
              leftAction: () => Get.back(),
              title: controller.lectureDetail.value?.title ?? "",
              rightIcon:
                  controller.lectureDetail.value?.messageAvailable == true
                      ? SvgPicture.asset("assets/icons/mail-02.svg")
                      : null,
              rightAction:
                  controller.lectureDetail.value?.messageAvailable == true
                      ? () {
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return customDialog(
                                context,
                                _controller,
                                isTextFieldNotEmpty,
                                controller.message.value?.title,
                                controller.lectureDetail.value?.name,
                                controller.message.value?.id,
                              );
                            },
                          );
                        }
                      : null,
              rightIconColor: OrmeeColor.primaryPuple[400],
            ),
            body: Obx(() {
              if (controller.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }
              final detail = controller.lectureDetail.value;
              if (detail == null) {
                return Center(child: Text('No lecture details available'));
              }
              return RefreshIndicator(
                onRefresh: () => controller.fetchLectureDetail(lectureId!),
                child: DefaultTabController(
                  length: 1,
                  child: NestedScrollView(
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
                      return <Widget>[
                        SliverToBoxAdapter(
                          child: Column(
                            children: [
                              Container(
                                width: double.maxFinite,
                                padding: EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 20),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 45,
                                      height: 45,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: OrmeeColor.gray[100],
                                        border: Border.all(
                                          color: OrmeeColor.gray[100]!,
                                          width: 1.0,
                                        ),
                                        image: DecorationImage(
                                          image: detail.profileImage != null
                                              ? NetworkImage(
                                                      detail.profileImage!)
                                                  as ImageProvider
                                              : AssetImage(
                                                  'assets/images/defalut_profile.png'),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    T4_16px(text: "${detail.name}"),
                                  ],
                                ),
                              ),
                              Container(
                                color: OrmeeColor.gray[50],
                                height: 8,
                                width: double.maxFinite,
                              ),
                            ],
                          ),
                        ),
                        SliverPersistentHeader(
                          delegate: StickyTabBarDelegate(
                            tabBar: TabBar(
                              padding: EdgeInsets.zero,
                              dividerColor: OrmeeColor.gray[200],
                              indicatorPadding: EdgeInsets.zero,
                              labelPadding: EdgeInsets.zero,
                              indicatorSize: TabBarIndicatorSize.label,
                              overlayColor:
                                  MaterialStateProperty.all(Colors.white),
                              tabs: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: SizedBox(
                                    width: 130,
                                    child: Tab(
                                      child: T5_14px(
                                        text: "퀴즈 ${detail.activeQuizCount}",
                                        color: OrmeeColor.primaryPuple[400],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                              labelColor: OrmeeColor.primaryPuple[400],
                              unselectedLabelColor: OrmeeColor.gray[800],
                              indicator: CustomLabelIndicator(
                                color: OrmeeColor.primaryPuple[400]!,
                                borderRadius: BorderRadius.circular(1.0),
                              ),
                            ),
                          ),
                          pinned: true,
                        ),
                      ];
                    },
                    body: TabBarView(
                      children: [
                        Obx(() {
                          final quizList =
                              controller.lectureDetail.value?.quizList;

                          if (quizList == null || quizList.isEmpty) {
                            return Center(child: Text("No quizzes available"));
                          }

                          return ListView.builder(
                            padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                            itemCount: quizList.length,
                            itemBuilder: (context, index) {
                              final quiz = quizList[index];
                              return Padding(
                                padding: EdgeInsets.only(bottom: 16),
                                child: GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    Get.to(QuizAuth(
                                      quizId: quiz.id,
                                      quizTitle: quiz.quizName,
                                      quizAvailable: quiz.quizAvailable,
                                    ));
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 16, horizontal: 20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: OrmeeColor.gray[200]!,
                                        width: 1.0,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Expanded(
                                              child: T4_16px(
                                                text: "${quiz.quizName}",
                                                color: quiz.quizAvailable
                                                    ? OrmeeColor.gray[900]
                                                    : OrmeeColor.gray[300],
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 16),
                                        Row(
                                          children: [
                                            C1_12px_M(
                                              text: "${quiz.quizDate}",
                                              color: OrmeeColor.gray[400],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
          Visibility(
            visible: controller.lectureDetail.value?.messageAvailable == true,
            child: Positioned(
              top: 44 + MediaQuery.of(context).padding.top,
              right: 9,
              child: Material(
                color: Colors.transparent,
                child: Image.asset(
                  'assets/images/message.png',
                  width: 88,
                  height: 37,
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}

Widget customDialog(BuildContext context, TextEditingController controller,
    RxBool isTextFieldNotEmpty, title, teacherName, messageId) {
  final isSubmitting = false.obs;

  return Dialog(
    child: SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          color: OrmeeColor.white,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: T4_16px(
                    text: '${title}',
                    overflow: TextOverflow.visible,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: SvgPicture.asset("assets/icons/xLarge.svg"),
                ),
              ],
            ),
            SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: OrmeeColor.gray[100]!,
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  C1_12px_M(text: '받는 사람:', color: OrmeeColor.gray[500]),
                  C1_12px_M(text: '${teacherName}'),
                ],
              ),
            ),
            SizedBox(height: 16),
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: OrmeeColor.gray[100]!),
                color: OrmeeColor.gray[100],
              ),
              child: TextField(
                controller: controller,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Pretendard',
                  color: Colors.black,
                ),
                cursorColor: OrmeeColor.gray[600],
                decoration: InputDecoration(
                  hintText: '번호는 쉼표로 구분해서 제출해 주세요.\nex) 1, 7, 18, 22',
                  hintStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Pretendard',
                    color: OrmeeColor.gray[400]!,
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  border: InputBorder.none,
                  fillColor: OrmeeColor.gray[100],
                ),
                maxLines: null,
                onChanged: (value) {
                  final filteredValue =
                      value.replaceAll(RegExp(r'[^0-9,\s]'), '');
                  if (value != filteredValue) {
                    controller.value = TextEditingValue(
                      text: filteredValue,
                      selection:
                          TextSelection.collapsed(offset: filteredValue.length),
                    );
                  }
                },
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Spacer(),
                Obx(() {
                  return TextButton(
                    onPressed:
                        (isTextFieldNotEmpty.value && !isSubmitting.value)
                            ? () async {
                                isSubmitting.value = true;
                                final submission = MessageSubmission(
                                  context: controller.text.trim(),
                                );
                                try {
                                  await LectureService().submitMessage(
                                    submission,
                                    messageId,
                                  );
                                  Get.back(); // Close dialog
                                  OrmeeToast.show(context, "제출 완료 되었습니다.");
                                } catch (e) {
                                  OrmeeToast.show(
                                      context, "제출이 완료 되지 않았습니다. 다시 시도해주세요.");
                                } finally {
                                  isSubmitting.value = false;
                                }
                              }
                            : null,
                    child: C1_12px_M(
                      text: "제출하기",
                      color: isTextFieldNotEmpty.value
                          ? OrmeeColor.white
                          : OrmeeColor.gray[600]!,
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: isTextFieldNotEmpty.value
                          ? OrmeeColor.primaryPuple[300]
                          : OrmeeColor.gray[100]!,
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                })
              ],
            )
          ],
        ),
      ),
    ),
  );
}
