// ignore_for_file: deprecated_member_use

import 'package:doan_clean_achitec/dark_mode.dart';
import 'package:doan_clean_achitec/modules/home/home.dart';
import 'package:doan_clean_achitec/modules/tour/tour_controller.dart';
import 'package:doan_clean_achitec/shared/constants/app_style.dart';
import 'package:doan_clean_achitec/shared/shared.dart';
import 'package:doan_clean_achitec/shared/utils/app_bar_widget.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../routes/app_pages.dart';
import '../../shared/utils/convert_date_time.dart';
import 'booking_controller.dart';

// ignore: must_be_immutable
class BookingScreen extends GetView<BookingController> {
  BookingScreen({super.key});

  HomeController homeController = Get.find();
  BookingController bookingController = Get.put(BookingController());
  TourController tourController = Get.put(TourController());
  final AppController appController = Get.find();

  static String dateSelected = '';

  final List<String> items = [
    'Thành phố Hồ Chí Minh',
    'Hà Nội',
    'Đà Nẵng',
  ];

  List<String> get _dropdownItems {
    final source = tourController.items.value?.isNotEmpty == true
        ? tourController.items.value!
        : items;
    final seen = <String>{};
    final values = <String>[];

    for (final rawItem in source) {
      final item = rawItem.trim();
      if (item.isNotEmpty && seen.add(item)) {
        values.add(item);
      }
    }

    final duplicatedValues =
        source.where((item) => item.trim().isNotEmpty).fold<Map<String, int>>(
      <String, int>{},
      (counts, item) {
        final value = item.trim();
        counts[value] = (counts[value] ?? 0) + 1;
        return counts;
      },
    )..removeWhere((key, value) => value < 2);

    if (duplicatedValues.isNotEmpty) {
      debugPrint(
        '[BOOKING_DROPDOWN] duplicated values: $duplicatedValues',
      );
    }

    return values;
  }

  String? _safeDropdownValue(List<String> dropdownItems) {
    final selectedValue = bookingController.selectedValue.value.trim();
    final matchCount =
        dropdownItems.where((item) => item == selectedValue).length;

    debugPrint('[BOOKING_DROPDOWN] selected value: $selectedValue');
    debugPrint('[BOOKING_DROPDOWN] item values: $dropdownItems');

    if (matchCount == 1) {
      return selectedValue;
    }

    if (dropdownItems.isNotEmpty) {
      final nextValue = dropdownItems.first;
      debugPrint(
        '[BOOKING_DROPDOWN] reset invalid selected value "$selectedValue" '
        'to "$nextValue"',
      );
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (bookingController.selectedValue.value != nextValue) {
          bookingController.selectedValue.value = nextValue;
        }
      });
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: ColorConstants.blue,
    ));
    return WillPopScope(
      onWillPop: () async {
        if (homeController.currentIndex.value != 0) {
          homeController.currentIndex.value = 0;
          return false;
        }
        return true;
      },
      child: Obx(
        () {
          final dropdownItems = _dropdownItems;
          final selectedDropdownValue = _safeDropdownValue(dropdownItems);

          return Scaffold(
          backgroundColor: appController.isDarkModeOn.value
              ? ColorConstants.darkBackground
              : ColorConstants.lightBackground,
          appBar: CustomAppBar(
            titles: StringConst.booking.tr,
            backgroundColor: appController.isDarkModeOn.value
                ? ColorConstants.darkAppBar
                : ColorConstants.primaryButton,
            iconBgrColor: ColorConstants.grayTextField,
            onTap: () {
              if (homeController.currentIndex.value != 0) {
                homeController.currentIndex.value = 0;
              }
            },
          ),
          body: SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: getSize(16),
                    ),
                    Text(
                      StringConst.chooseYourFavorite.tr,
                      style: AppStyles.botTitle000Size14Fw400FfMont.copyWith(
                        color: appController.isDarkModeOn.value
                            ? ColorConstants.dividerColor
                            : ColorConstants.botTitle,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: getSize(46),
                    ),
                    DropdownButtonHideUnderline(
                      child: DropdownButton2<String>(
                        isExpanded: true,
                        underline: Divider(
                          thickness: 0.5,
                          color: appController.isDarkModeOn.value
                              ? ColorConstants.darkCard
                              : ColorConstants.lightCard,
                        ),
                        items: dropdownItems
                            .map(
                              (String item) => DropdownMenuItem<String>(
                                value: item,
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      AssetHelper.icLocation,
                                      colorFilter: ColorFilter.mode(
                                        appController.isDarkModeOn.value
                                            ? ColorConstants.white
                                            : ColorConstants.accent1,
                                        BlendMode.srcIn,
                                      ),
                                      width: getSize(34),
                                    ),
                                    SizedBox(
                                      width: getSize(16),
                                    ),
                                    Expanded(
                                      child: Text(
                                        item,
                                        style: AppStyles
                                            .botTitle000Size14Fw400FfMont
                                            .copyWith(
                                          color:
                                              appController.isDarkModeOn.value
                                                  ? ColorConstants.white
                                                  : ColorConstants.botTitle,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                        value: selectedDropdownValue,
                        hint: Text(
                          StringConst.pleaseSelect.tr,
                          style:
                              AppStyles.botTitle000Size14Fw400FfMont.copyWith(
                            color: appController.isDarkModeOn.value
                                ? ColorConstants.white
                                : ColorConstants.botTitle,
                          ),
                        ),
                        onChanged: (value) {
                          if (value != null) {
                            debugPrint(
                              '[BOOKING_DROPDOWN] changed value: $value',
                            );
                            bookingController.selectedValue.value = value;
                          }
                        },
                        buttonStyleData: ButtonStyleData(
                          padding: EdgeInsets.symmetric(
                            horizontal: getSize(16),
                            vertical: getSize(8),
                          ),
                          decoration: BoxDecoration(
                            color: appController.isDarkModeOn.value
                                ? ColorConstants.darkCard
                                : ColorConstants.lightCard,
                            borderRadius: BorderRadius.circular(
                              getSize(14),
                            ),
                            boxShadow: const [],
                          ),
                          elevation: 2,
                        ),
                        dropdownStyleData: DropdownStyleData(
                          padding: EdgeInsets.only(left: getSize(16)),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: appController.isDarkModeOn.value
                                ? ColorConstants.darkCard
                                : ColorConstants.lightCard,
                          ),
                          scrollbarTheme: ScrollbarThemeData(
                            radius: const Radius.circular(40),
                            thickness: MaterialStateProperty.all(6),
                            thumbVisibility: MaterialStateProperty.all(true),
                          ),
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          padding: EdgeInsets.only(
                            left: 0,
                            right: 14,
                            bottom: 4,
                            top: 4,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: getSize(46),
                    ),
                    GestureDetector(
                      onTap: () async {
                        final result = await Get.toNamed(Routes.SELECT_DATE);
                        if (result is List<DateTime?>) {
                          dateSelected =
                              '${result[0]?.getStartDate} - ${result[1]?.getEndDate}';
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: appController.isDarkModeOn.value
                              ? ColorConstants.darkCard
                              : ColorConstants.lightCard,
                          borderRadius: BorderRadius.circular(getSize(14)),
                        ),
                        padding: EdgeInsets.only(
                          left: getSize(34),
                          top: getSize(16),
                          bottom: getSize(16),
                          right: getSize(16),
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              AssetHelper.icCalendar,
                              width: getSize(32),
                              colorFilter: ColorFilter.mode(
                                appController.isDarkModeOn.value
                                    ? ColorConstants.white
                                    : ColorConstants.accent1,
                                BlendMode.srcIn,
                              ),
                            ),
                            SizedBox(
                              width: getSize(16),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  StringConst.selectDate.tr,
                                  style: AppStyles.botTitle000Size14Fw400FfMont
                                      .copyWith(
                                    color: appController.isDarkModeOn.value
                                        ? ColorConstants.white
                                        : ColorConstants.botTitle,
                                  ),
                                ),
                                SizedBox(
                                  height: getSize(8.0),
                                ),
                                SizedBox(
                                  width: getSize(220),
                                  child: Text(
                                    dateSelected.isEmpty
                                        ? StringConst.pleaseSelect.tr
                                        : dateSelected,
                                    style: AppStyles
                                        .botTitle000Size14Fw400FfMont
                                        .copyWith(
                                      color: appController.isDarkModeOn.value
                                          ? ColorConstants.white
                                          : ColorConstants.black,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: getSize(46),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: getSize(48),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(getSize(16)),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            alignment: Alignment.center,
                            backgroundColor: ColorConstants.primaryButton,
                          ),
                          onPressed: () {
                            Get.toNamed(Routes.TOUR);
                          },
                          child: Text(
                            StringConst.booking.tr,
                            style: AppStyles.white000Size18Fw500FfMont,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: getSize(46),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: getSize(48),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(getSize(16)),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            alignment: Alignment.center,
                            backgroundColor: appController.isDarkModeOn.value
                                ? ColorConstants.darkCard
                                : ColorConstants.btnCanCel,
                          ),
                          onPressed: () {
                            if (homeController.currentIndex.value != 0) {
                              homeController.currentIndex.value = 0;
                            }
                          },
                          child: Text(
                            StringConst.cancel.tr,
                            style: appController.isDarkModeOn.value
                                ? AppStyles.white000Size18Fw500FfMont
                                : AppStyles.black000Size18Fw500FfMont,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          );
        },
      ),
    );
  }
}
