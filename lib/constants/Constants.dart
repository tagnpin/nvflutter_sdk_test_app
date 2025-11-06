import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Constants {
  static const headingText = 'headingText';
  static const showInAppBannerSurvey = 'showInAppBannerSurvey';
  static const showInAppBannerSurveyWithCallback =
      'showInAppBannerSurveyWithCallback';
  static const inAppBannerSurveyInputParamsInfo =
      'inAppBannerSurveyInputParamsInfo';
  static const showNativeDisplayViewButton = 'showNativeDisPlayButton';
  static const nativeDisplayContainerView = 'nativeDisplayContainerView';
  static const trackEventInputParamsInfo = 'trackEventInputParamsInfo';
  static const trackEvent = 'trackEvent';
  static const trackUserInputParamsInfo = 'trackUserInputParamsInfo';
  static const trackUserWithCallback = 'trackUserWithCallback';
  static const trackUser = 'trackUser';
  static const trackScreenNameParamsInfo = 'trackScreenNameParamsInfo';
  static const trackScreenName = 'trackScreenName';
  static const notificationCenterStandard = 'standardNotificationCenter';
  static const notificationCenterAdvance = 'advanceNotificationCenter';
  static const notificationCenterAdvanceWithCallback =
      'advanceNotificationCenterWithCallback';
  static const gotoSecondPage = 'gotoSecondPage';

  static const bellIconNotificationCenter = 'bellIconNotificationCenter';
  static const notificationCenterUnreadCount =
      'unreadCountOfNotificationCenter';
  static const notificationCenterDataCallback =
      'callbackDataOfNotificationCenter';
  static const getNotificationCenterDetails = 'getNotificationCenterDetails';
  static const getNVUID = 'getNVUID';
  static const appStoreReview = 'giveAppStoreRatingReview';
  static const setPushPreferenceInputsInfo = 'setPushPreferenceInputsInfo';
  static const setPushPreference = 'setPushPreferences';
  static const unsubscribeAllPushStatusInfo = 'unsubscribeAllPushStatusInfo';
  static const unsubscribeAllPush = 'unsubscribeAllPush';
  static const getPushSubscriptionID = 'getPushSubscriptionID';
  static const clearBadgeNumberFromAppIcon = 'clearAppIconPushBadge';
  static const getSessionData = 'getSessionData';
  static const viewTypeText = 'viewTypeText';
  static const viewTypeButton = 'viewTypeButton';
  static const viewTypeInput = 'viewTypeInput';
  static const viewTypeToggleButton = 'viewTypeToggleButton';
  static const viewTypeNotificationCenterAdvanceInputs =
      'viewTypeAdvanceNotificationCenterInputs';
  static const viewTypeContainer = 'viewTypeContainer';

  static const notifyvisitorsAppUIData = [
    {
      'contentTitle': 'nv-flutter SDK ~ 1.3.2 (Live A/c Brand ID : 8115)',
      'actionType': headingText,
      'viewType': viewTypeText,
    },
    {
      'contentTitle': 'Get Session Data',
      'actionType': getSessionData,
      'viewType': viewTypeButton,
    },
    {
      'contentTitle': 'Parent Container View for Native Display',
      'actionType': nativeDisplayContainerView,
      'viewType': viewTypeContainer,
    },
    {
      'contentTitle': 'Notification Center (Standard)',
      'actionType': notificationCenterStandard,
      'viewType': viewTypeButton,
    },
    {
      'contentTitle': 'Advance Notification Center Inputs View',
      'actionType': viewTypeNotificationCenterAdvanceInputs,
      'viewType': viewTypeText,
    },
    {
      'contentTitle': 'Notification Center (Advance)',
      'actionType': notificationCenterAdvance,
      'viewType': viewTypeButton,
    },
    {
      'contentTitle': 'Notification Center (Advance) With Callback',
      'actionType': notificationCenterAdvanceWithCallback,
      'viewType': viewTypeButton,
    },
    {
      'contentTitle': 'Get Notification Center Data in Callback',
      'actionType': notificationCenterDataCallback,
      'viewType': viewTypeButton,
    },
    {
      'contentTitle': 'Get Unread Count of Notification Center',
      'actionType': notificationCenterUnreadCount,
      'viewType': viewTypeButton,
    },
    {
      'contentTitle': 'Get Center Data in Callback Type 2',
      'actionType': getNotificationCenterDetails,
      'viewType': viewTypeButton,
    },
    {
      'contentTitle': 'InApp Banner and Survey User Token & Custom Rule Info',
      'actionType': inAppBannerSurveyInputParamsInfo,
      'viewType': viewTypeText,
    },
    {
      'contentTitle': 'Show InApp Banner and Survey',
      'actionType': showInAppBannerSurvey,
      'viewType': viewTypeButton,
    },
    {
      'contentTitle': 'Load Native Display Button {propertyName: "home"}',
      'actionType': showNativeDisplayViewButton,
      'viewType': viewTypeButton,
    },
    {
      'contentTitle': 'Parent Container View for Native Display',
      'actionType': nativeDisplayContainerView,
      'viewType': viewTypeContainer,
    },
    {
      'contentTitle': 'Event name & attributes Info',
      'actionType': trackEventInputParamsInfo,
      'viewType': viewTypeText,
    },
    {
      'contentTitle': 'Track Event',
      'actionType': trackEvent,
      'viewType': viewTypeButton,
    },
    {
      'contentTitle': 'UserID & User Params Info',
      'actionType': trackUserInputParamsInfo,
      'viewType': viewTypeText,
    },
    {
      'contentTitle': 'Track User',
      'actionType': trackUser,
      'viewType': viewTypeButton,
    },
    {
      'contentTitle': 'Track User with Callback',
      'actionType': trackUserWithCallback,
      'viewType': viewTypeButton,
    },
    {
      'contentTitle': 'Track ScreenName Param Info',
      'actionType': trackScreenNameParamsInfo,
      'viewType': viewTypeText,
    },
    {
      'contentTitle': 'Track Screen Name Event',
      'actionType': trackScreenName,
      'viewType': viewTypeButton,
    },
    {
      'contentTitle': 'get NVUID',
      'actionType': getNVUID,
      'viewType': viewTypeButton,
    },
    {
      'contentTitle': "Request Appl's AppStore Review",
      'actionType': appStoreReview,
      'viewType': viewTypeButton,
    },
    {
      'contentTitle': 'Set Push Preference (Category) Info',
      'actionType': setPushPreferenceInputsInfo,
      'viewType': viewTypeText,
    },
    {
      'contentTitle': 'Set Push Preferences',
      'actionType': setPushPreference,
      'viewType': viewTypeButton,
    },
    {
      'contentTitle': 'Unsubscribe All Notifyvisitors Push Status Info',
      'actionType': unsubscribeAllPushStatusInfo,
      'viewType': viewTypeText,
    },
    {
      'contentTitle': 'Unsubscribe All Notifyvisitors Push',
      'actionType': unsubscribeAllPush,
      'viewType': viewTypeButton,
    },
    {
      'contentTitle': 'Get Notifyvisitors Push SubscriptionID',
      'actionType': getPushSubscriptionID,
      'viewType': viewTypeButton,
    },
    {
      'contentTitle': 'Goto Second page',
      'actionType': gotoSecondPage,
      'viewType': viewTypeButton,
    }
  ];

  static String osName = Platform.isAndroid
      ? 'android'
      : Platform.isIOS
          ? 'ios'
          : '';

  static String get currentDateTime {
    DateTime now = DateTime.now();
    String currentFormatedTime = DateFormat('dd_MM_yyyy_hh_mm').format(now);
    return '_$currentFormatedTime';
  }

  static final String tmpUserEmail = Platform.isAndroid
      ? 'deepa.m$currentDateTime@notifyvisitors.com'
      : Platform.isIOS
          ? 'ashraf$currentDateTime@notifyvisitors.com'
          : 'divya.g$currentDateTime@notifyvisitors.com';

  static final String tmpUserName = Platform.isAndroid
      ? 'Deepa'
      : Platform.isIOS
          ? 'Mohammad Ashraf'
          : 'Divya Gupta';

  static const String tabDisplayNameOne = 'Tab 1 (tg1)';
  static const String tabLabelOne = 'tg1';
  static const String tabDisplayNameTwo = 'Tab 2 (tg2)';
  static const String tabLabelTwo = 'tg2';
  static const String tabDisplayNameThree = 'Others';
  static const String tabLabelthree = 'others';

  static const notificationCenterTabsInfo = {
    'label_one': tabLabelOne,
    'name_one': tabDisplayNameOne,
    'label_two': tabLabelTwo,
    'name_two': tabDisplayNameTwo,
    'label_three': tabLabelthree,
    'name_three': tabDisplayNameThree,
  };

  static final bannerSurveyUserToken = <String, dynamic>{
    'name': '$tmpUserName',
    'email': '$tmpUserEmail',
    'city': 'New Delhi',
    'pinCode': 110058,
    'eID': 50,
  };

  static const bannerSurveyCustomRule = <String, dynamic>{
    'screenName': 'dashboard',
    'productType': 'appearal',
    'category': 'fashion',
    'price': 499,
    'balance': 350,
    'coupon': 'testflutterCoupon',
  };

  static final eventAttributes = <String, dynamic>{
    'name': bannerSurveyUserToken['name'],
    'email': bannerSurveyUserToken['email'],
    'user_score': '340',
    'plan_type': 3,
    'mobileNo': '9900000000',
  };

  // static const eventAttributes = <String, dynamic>{
  //   'name': bannerSurveyUserToken['name'],
  //   'email': bannerSurveyUserToken['email'],
  //   'user_score': '340',
  //   'plan_type': 3,
  //   'mobileNo': '9900000000',
  // };

  static String trackEventName = 'test_flutter_event_$osName';

  static final String trackUserID = 'test_flutter_user_from_$osName';
  static final trackUserParams = bannerSurveyUserToken;
  static final pushCatInfo = ['sales', 'service', 'develop', 'marketting'];

  static String trackHomeScreenName = 'flutter_home_screen';
  static String trackProductScreenName = 'flutter_product_screen';
}
