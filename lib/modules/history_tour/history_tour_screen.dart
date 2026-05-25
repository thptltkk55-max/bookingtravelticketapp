import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doan_clean_achitec/dark_mode.dart';
import 'package:doan_clean_achitec/models/history/history_model.dart';
import 'package:doan_clean_achitec/modules/history_tour/history_tour_controller.dart';
import 'package:doan_clean_achitec/models/tour/tour_model.dart';
import 'package:doan_clean_achitec/modules/auth/user_controller.dart';
import 'package:doan_clean_achitec/modules/home/home.dart';
import 'package:doan_clean_achitec/routes/app_pages.dart';
import 'package:doan_clean_achitec/shared/constants/app_style.dart';
import 'package:doan_clean_achitec/shared/utils/app_bar_widget.dart';
import 'package:doan_clean_achitec/shared/utils/app_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:rive/rive.dart';

import '../../shared/shared.dart';

// ignore: must_be_immutable
class HistoryScreen extends GetView<HistoryTourController> {
  HistoryScreen({super.key});

  UserController userController = Get.put(UserController());
  HomeController homeController = Get.put(HomeController());

  AppController appController = Get.find();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadIndicatorRive();
      controller.getAllTourModelData();
    });

    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: CustomAppBar(
          titles: StringConst.history.tr,
          backgroundColor: appController.isDarkModeOn.value
              ? ColorConstants.darkAppBar
              : ColorConstants.primaryButton,
          iconBgrColor: ColorConstants.grayTextField,
        ),
        backgroundColor: appController.isDarkModeOn.value
            ? ColorConstants.darkBackground
            : ColorConstants.lightBackground,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TabBar(
                    isScrollable: true,
                    labelColor: appController.isDarkModeOn.value
                        ? ColorConstants.primaryButton
                        : ColorConstants.primaryButton,
                    unselectedLabelColor: ColorConstants.gray600,
                    indicatorColor: appController.isDarkModeOn.value
                        ? ColorConstants.primaryButton
                        : ColorConstants.primaryButton,
                    tabs: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.24,
                        child: Tab(text: 'Waiting'),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.24,
                        child: Tab(text: 'Upcoming'),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.24,
                        child: Tab(text: 'Happenning'),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.24,
                        child: Tab(text: 'Completed'),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.24,
                        child: Tab(text: 'Cancelled'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  HistoryItemFinish(status: "waiting"),
                  HistoryItemFinish(status: "coming"),
                  HistoryItemFinish(status: "happenning"),
                  HistoryItemFinish(status: "completed"),
                  HistoryItemFinish(status: "canceled"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HistoryItemFinish extends GetView<HistoryTourController> {
  final String status;
  HistoryItemFinish({
    super.key,
    required this.status,
  });

  final AppController appController = Get.find();
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => controller.refreshHistory(),
      child: Obx(
        () {
          final tourItems = _tourItemsByStatus();
          final historyItems = _historyItemsByStatus();
          final itemCount = _safeItemCount(tourItems, historyItems);
          return controller.isShowLoading.value
              ? Center(
                  child: SizedBox(
                    height: getSize(120),
                    width: getSize(120),
                    child: RiveAnimation.asset(
                      "assets/icons/riv/ic_checkerror.riv",
                      onInit: (artboard) {
                        StateMachineController stateMachineController =
                            controller.getRiveController(artboard);
                        controller.check = stateMachineController
                            .findSMI("Check") as SMITrigger;
                        controller.error = stateMachineController
                            .findSMI("Error") as SMITrigger;
                        controller.reset = stateMachineController
                            .findSMI("Reset") as SMITrigger;
                      },
                    ),
                  ),
                )
              : itemCount > 0
                  ? SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: getSize(16),
                          horizontal: getSize(24),
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: itemCount,
                          itemBuilder: (BuildContext context, int rowIndex) {
                            final tourModel = tourItems[rowIndex];
                            final historyModel = historyItems[rowIndex];
                            return GestureDetector(
                              onTap: () {
                                if (status == "waiting") {
                                  Get.snackbar(
                                    StringConst.notification.tr,
                                    StringConst
                                        .waitForTheAdminToApproveTheTour.tr,
                                  );
                                } else if (status == "canceled") {
                                  Get.snackbar(StringConst.notification.tr,
                                      '${StringConst.tourCanceled.tr}!!!');
                                } else if (status == "coming") {
                                  Get.toNamed(
                                    Routes.TOUR_QR_CODE_DETAIL,
                                    arguments: {
                                      'arg1': tourModel,
                                      'arg2': "upcoming",
                                      'arg3': historyModel,
                                    },
                                  );
                                } else if (status == "happenning") {
                                  Get.toNamed(
                                    Routes.TOUR_QR_CODE_DETAIL,
                                    arguments: {
                                      'arg1': tourModel,
                                      'arg2': "happenning",
                                      'arg3': historyModel,
                                    },
                                  );
                                } else if (status == "completed") {
                                  Get.toNamed(
                                    Routes.TOUR_QR_CODE_DETAIL,
                                    arguments: {
                                      'arg1': tourModel,
                                      'arg2': "completed",
                                      'arg3': historyModel,
                                    },
                                  );
                                }
                              },
                              child: Padding(
                                padding:
                                    EdgeInsets.symmetric(vertical: getSize(12)),
                                child: _buildItemHistory(
                                  tourModel: tourModel,
                                  historyModel: historyModel,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  : Center(
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: getSize(20)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Lottie.asset(
                              AssetHelper.imgLottieNodate,
                              width: getSize(200),
                              height: getSize(200),
                              fit: BoxFit.fill,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: getSize(48.0),
                              ),
                              child: Text(
                                '${StringConst.looksLike.tr}!',
                                style: AppStyles.black000Size14Fw400FfMont
                                    .copyWith(
                                  color: appController.isDarkModeOn.value
                                      ? ColorConstants.lightAppBar
                                      : ColorConstants.darkBackground,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(
                              height: getSize(64),
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.toNamed(Routes.TOUR);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Lottie.asset(
                                    AssetHelper.imgLottieArrowRight,
                                    width: getSize(32),
                                    height: getSize(32),
                                    fit: BoxFit.fill,
                                  ),
                                  SizedBox(
                                    width: getSize(16),
                                  ),
                                  InkWell(
                                    child: Text(
                                      StringConst.seeTour.tr,
                                      style: AppStyles.blueSize16Fw400FfMont,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
        },
      ),
    );
  }

  List<TourModel> _tourItemsByStatus() {
    if (status == 'waiting') return controller.getListHisWaiting.value ?? [];
    if (status == 'coming') return controller.getListUpComing.value ?? [];
    if (status == 'happenning') {
      return controller.getListHisHappenning.value ?? [];
    }
    if (status == 'completed') {
      return controller.getListHisCompleted.value ?? [];
    }
    if (status == 'canceled') return controller.getListHisCancel.value ?? [];
    return [];
  }

  List<HistoryModel> _historyItemsByStatus() {
    if (status == 'waiting') {
      return controller.getListHisWaitingToDate.value ?? [];
    }
    if (status == 'coming') {
      return controller.getListHisUpComingToDate.value ?? [];
    }
    if (status == 'happenning') {
      return controller.getListHisHappenningToDate.value ?? [];
    }
    if (status == 'completed') {
      return controller.getListHisCompletedToDate.value ?? [];
    }
    if (status == 'canceled') {
      return controller.getListHisCancelToDate.value ?? [];
    }
    return [];
  }

  int _safeItemCount(
    List<TourModel> tourItems,
    List<HistoryModel> historyItems,
  ) {
    final tourCount = tourItems.length;
    final historyCount = historyItems.length;
    return tourCount < historyCount ? tourCount : historyCount;
  }
}

// ignore: must_be_immutable, camel_case_types
class _buildItemHistory extends StatelessWidget {
  TourModel? tourModel;
  HistoryModel? historyModel;
  _buildItemHistory({
    required this.tourModel,
    required this.historyModel,
  });

  HistoryTourController historyTourController =
      Get.put(HistoryTourController());
  AppController appController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(
        getSize(12),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(getSize(16)),
        color: appController.isDarkModeOn.value
            ? ColorConstants.darkCard
            : ColorConstants.lightCard,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  tourModel?.nameTour ?? '',
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: appController.isDarkModeOn.value
                      ? AppStyles.white000Size16Fw500FfMont
                      : AppStyles.black000Size16Fw500FfMont,
                ),
                SizedBox(
                  height: getSize(8),
                ),
                Text(
                  historyModel?.bookingDate == null
                      ? "failing"
                      : historyTourController.timestampToString(
                          historyModel?.bookingDate ?? Timestamp.now()),
                  style: appController.isDarkModeOn.value
                      ? AppStyles.white000Size14Fw400FfMont
                      : AppStyles.black000Size14Fw400FfMont,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  height: getSize(8),
                ),
                Text(
                  '${historyModel?.totalPrice} VND',
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: AppStyles.blue000Size14Fw400FfMont,
                ),
              ],
            ),
          ),
          SizedBox(
            width: getSize(30),
          ),
          Expanded(
            flex: 1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(getSize(14)),
              child: tourModel?.images?.isNotEmpty == true
                  ? AppImage.widget(
                      tourModel?.images?.first,
                      height: getSize(77),
                      width: getSize(77),
                      fit: BoxFit.cover,
                      fallback: AssetHelper.city_1,
                    )
                  : Image.asset(
                      height: getSize(77),
                      width: getSize(77),
                      AssetHelper.city_1,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
