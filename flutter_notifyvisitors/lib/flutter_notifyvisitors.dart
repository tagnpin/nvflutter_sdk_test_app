import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'PushPromptInfo.dart';

// Handlers for various events
typedef void ShowCallback(String response);
typedef void EventCallback(String response);
typedef void GetClickInfo(String response);
typedef void NotificationClickData(String response);
typedef void OnKnownUserFound(String response);
//typedef void ChatBotClick(String response);
typedef void EventSurvryInfo(String response);
typedef void PromptCallback(String response);
typedef void NotificationCenterCallback(String response);
typedef void NotificationCenterDataCallback(String response);

class Notifyvisitors {
  static Notifyvisitors shared = new Notifyvisitors();

  MethodChannel _channel = const MethodChannel('flutter_notifyvisitors');

  PushPromptInfo? pushPromptInfo;

  // event handlers
  ShowCallback? _showCallback;
  EventCallback? _eventCallback;
  OnKnownUserFound? _onKnownUserFoundCallback;
  GetClickInfo? _getClickInfo;
  NotificationClickData? _notificationClickData;
  //ChatBotClick? _chatBotClick;
  EventSurvryInfo? _eventSurvryInfo;
  PromptCallback? _promptCallback;
  NotificationCenterCallback? _notificationCenterCallback;
  NotificationCenterDataCallback? _notificationCenterDataCallback;

  Notifyvisitors() {
    this._channel.setMethodCallHandler(_handleMethod);
  }

  Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  Future<void> show(var tokens, var customRules, var fragmentName,
      ShowCallback handler) async {
    _showCallback = handler;
    var inAppInfo = {
      'tokens': tokens,
      'customRules': customRules,
      'fragmentName': fragmentName
    };
    await _channel.invokeMethod('show', inAppInfo);
  }

  Future<String> showInAppMessage(var tokens, var customRules, var fragmentName,
      ShowCallback handler) async {
    _showCallback = handler;

    var inAppInfo = {
      'tokens': tokens,
      'customRules': customRules,
      'fragmentName': fragmentName
    };

    String callback =
        await _channel.invokeMethod('showInAppMessage', inAppInfo);
    return callback;
  }

  Future<void> showNotifications(var appInboxInfo, int dismiss) async {
    var showInfo = {'dismissValue': dismiss, 'appInboxInfo': appInboxInfo};
    await _channel.invokeMethod('showNotifications', showInfo);
  }

  Future<void> openNotificationCenter(
      var appInboxInfo, int dismiss, NotificationCenterCallback handler) async {
    _notificationCenterCallback = handler;
    var showInfo = {'dismissValue': dismiss, 'appInboxInfo': appInboxInfo};
    await _channel.invokeMethod('openNotificationCenter', showInfo);
  }

  Future<void> event(String eventName, var attributes, String lifeTimeValue,
      String scope, EventCallback handler) async {
    _eventCallback = handler;
    var eventInfo = {
      'eventName': eventName,
      'attributes': attributes,
      'lifeTimeValue': lifeTimeValue,
      'scope': scope
    };
    await _channel.invokeMethod('event', eventInfo);
  }

  Future<void> userIdentifier(String userId, var attributes) async {
    var userInfo = {'userId': userId, 'attributes': attributes};
    await _channel.invokeMethod('userIdentifier', userInfo);
  }

  Future<String> setUserIdentifier(var attributes) async {
    var userInfo = {'attributes': attributes};
    String callback =
        await _channel.invokeMethod('setUserIdentifier', userInfo);
    return callback;
  }

  Future<void> knownUserIdentified(OnKnownUserFound handler) async {
    _onKnownUserFoundCallback = handler;
    await _channel.invokeMethod('knownUserIdentified');
  }

  Future<void> stopNotifications() async {
    await _channel.invokeMethod('stopNotifications');
  }

  Future<void> stopPushNotifications(bool value) async {
    var valueInfo = {"value": value};
    await _channel.invokeMethod('stopPushNotifications', valueInfo);
  }

  Future<String> getNotificationData() async {
    String info = await _channel.invokeMethod('notificationDataListener');
    return info;
  }

  Future<String> getNotificationCount() async {
    String count = await _channel.invokeMethod('notificationCount');
    return count;
  }

  Future<void> scheduleNotification(String nid, String tag, String time,
      String title, String msg, String url, String icon) async {
    var notificationInfo = {
      'nid': nid,
      'tag': tag,
      'time': time,
      'title': title,
      'msg': msg,
      'url': url,
      'icon': icon
    };
    await _channel.invokeMethod('scheduleNotification', notificationInfo);
  }

  Future<void> stopGeofencePushforDateTime(
      String dateTime, String additionalHours) async {
    var timeInfo = {'dateTime': dateTime, 'additionalHours': additionalHours};
    await _channel.invokeMethod('stopGeofencePushforDateTime', timeInfo);
  }

  Future<void> getLinkInfo(GetClickInfo handler) async {
    _getClickInfo = handler;
    await _channel.invokeMethod('getLinkInfo');
  }

  Future<void> notificationClickCallback(NotificationClickData handler) async {
    _notificationClickData = handler;
    await _channel.invokeMethod('notificationClickCallback');
  }

  Future<void> autoStartPermission() async {
    await _channel.invokeMethod('autoStartPermission');
  }

  /*Future<void> startChatBot(String screenName, ChatBotClick handler) async {
    _chatBotClick = handler;
    var botInfo = {"screenName": screenName};
    await _channel.invokeMethod('startChatBot', botInfo);
  }*/

  Future<String> getNvUID() async {
    String nvUdid = await _channel.invokeMethod('getNvUID');
    return nvUdid;
  }

  Future<void> createNotificationChannel(
      String channelId,
      String channelName,
      String channelDescription,
      String channelImportance,
      bool enableLights,
      bool shouldVibrate,
      String lightColor,
      String soundFileName) async {
    var channelInfo = {
      'channelId': channelId,
      'channelName': channelName,
      'channelDescription': channelDescription,
      'channelImportance': channelImportance,
      'enableLights': enableLights,
      'shouldVibrate': shouldVibrate,
      'lightColor': lightColor,
      'soundFileName': soundFileName
    };
    await _channel.invokeMethod('createNotificationChannel', channelInfo);
  }

  Future<void> deleteNotificationChannel(String channelId) async {
    var channelInfo = {
      'channelId': channelId,
    };
    await _channel.invokeMethod('deleteNotificationChannel', channelInfo);
  }

  Future<void> createNotificationChannelGroup(
      String groupId, String groupName) async {
    var channelInfo = {'groupId': groupId, 'groupName': groupName};
    await _channel.invokeMethod('createNotificationChannelGroup', channelInfo);
  }

  Future<void> deleteNotificationChannelGroup(String groupId) async {
    var channelInfo = {'groupId': groupId};
    await _channel.invokeMethod('deleteNotificationChannelGroup', channelInfo);
  }

  Future<void> getEventSurveyInfo(EventSurvryInfo handler) async {
    _eventSurvryInfo = handler;
    await _channel.invokeMethod('getEventSurveyInfo');
  }

  Future<void> scrollViewDidScrollIOS() async {
    await _channel.invokeMethod('scrollViewDidScroll_IOS');
  }

  Future<String> getRegistrationToken() async {
    String token = await _channel.invokeMethod('registrationToken');
    return token;
  }

  Future<String> getSessionData() async {
    String data = await _channel.invokeMethod('getSessionData');
    return data;
  }

  Future<String> requestInAppReview() async {
    String response = await _channel.invokeMethod('requestInAppReview');
    return response;
  }

  Future<void> subscribePushCategory(
      var categoryArray, bool unsubscribeSignal) async {
    var categoryInfo = {
      'categoryArray': categoryArray,
      'unsubscribeSignal': unsubscribeSignal
    };
    await _channel.invokeMethod('subscribePushCategory', categoryInfo);
  }

  Future<String> getNotificationCenterCount(var tabCountInfo) async {
    var tabInfo = {'tabCountInfo': tabCountInfo};
    String countInfo =
        await _channel.invokeMethod('notificationCenterCount', tabInfo);
    return countInfo;
  }

  Future<void> pushPermissionPrompt(
      pushPromptInfo, PromptCallback handler) async {
    _promptCallback = handler;
    var temp;
    if (pushPromptInfo != null) {
      temp = parsePromptData(pushPromptInfo);
    } else {
      pushPromptInfo = new PushPromptInfo();
      temp = parsePromptData(pushPromptInfo);
    }
    await _channel.invokeMethod('pushPermissionPrompt', temp);
  }

  Future<void> enablePushPermission(bool isAllowed) async {
    var data = {
      'isAllowed': isAllowed,
    };
    await _channel.invokeMethod('enablePushPermission', data);
  }

  Future<String> nativePushPermissionPrompt() async {
    return await _channel.invokeMethod('nativePushPermissionPrompt');
  }

  Future<String> getNotificationCenterData() async {
    String info = await _channel.invokeMethod('notificationCenterData');
    return info;
  }

//for multiple callback
  Future<void> getNotificationCenterDetails(
      NotificationCenterDataCallback handler) async {
    _notificationCenterDataCallback = handler;
    await _channel.invokeMethod('getNotificationCenterDetails');
  }

  Map<String, String> parsePromptData(PushPromptInfo pushPromptInfo) {
    var promptInfo = {
      "title": pushPromptInfo.title,
      "titleTextColor": pushPromptInfo.titleTextColor,
      "description": pushPromptInfo.description,
      "descriptionTextColor": pushPromptInfo.descriptionTextColor,
      "backgroundColor": pushPromptInfo.backgroundColor,
      "buttonOneBorderColor": pushPromptInfo.buttonOneBorderColor,
      "buttonOneBackgroundColor": pushPromptInfo.buttonOneBackgroundColor,
      "buttonOneBorderRadius": pushPromptInfo.buttonOneBorderRadius,
      "buttonOneText": pushPromptInfo.buttonOneText,
      "buttonOneTextColor": pushPromptInfo.buttonOneTextColor,
      "buttonTwoText": pushPromptInfo.buttonTwoText,
      "buttonTwoTextColor": pushPromptInfo.buttonTwoTextColor,
      "buttonTwoBackgroundColor": pushPromptInfo.buttonTwoBackgroundColor,
      "buttonTwoBorderColor": pushPromptInfo.buttonTwoBorderColor,
      "buttonTwoBorderRadius": pushPromptInfo.buttonTwoBorderRadius,
      "numberOfSessions": pushPromptInfo.numberOfSessions,
      "resumeInDays": pushPromptInfo.setResumeInDays,
      "numberOfTimesPerSession": pushPromptInfo.setNumberOfTimesPerSession
    };
    return promptInfo;
  }

  Future<String> isPayloadFromNvPlatform(var fcmPayload) async {
    var data = {'notificationData': fcmPayload};
    String b = await _channel.invokeMethod('isPayloadFromNvPlatform', data);
    return b;
  }

  Future<void> getNV_FCMPayload(var fcmPayload) async {
    var data = {'notificationData': fcmPayload};
    await _channel.invokeMethod('getNV_FCMPayload', data);
  }

  Future<void> trackScreen(var screenName) async {
    var data = {'screenName': screenName};
    await _channel.invokeMethod('trackScreen', data);
  }

  // Private function that gets called by ObjC/Java
  Future<Null> _handleMethod(MethodCall call) async {
    if (call.method == "GetLinkInfo" && this._getClickInfo != null) {
      this._getClickInfo!(call.arguments.toString());
    } else if (call.method == "NotificationClickCallback" &&
        this._notificationClickData != null) {
      this._notificationClickData!(call.arguments.toString());
    } else if (call.method == "ShowResponse" && this._showCallback != null) {
      this._showCallback!(call.arguments.toString());
    } else if (call.method == "EventResponse" && this._eventCallback != null) {
      this._eventCallback!(call.arguments.toString());
    } /*else if (call.method == "ChatBotResponse" && this._chatBotClick != null) {
      this._chatBotClick!(call.arguments.toString());
    }*/
    else if (call.method == "promptResponse" && this._promptCallback != null) {
      this._promptCallback!(call.arguments.toString());
    } /*else if (call.method == "EventSurveyResponse" &&
        this._eventSurvryInfo != null) {
      this._eventSurvryInfo!(call.arguments.toString());
    }*/
    else if (call.method == "EventSurveyResponse" &&
        this._eventSurvryInfo != null) {
      this._eventSurvryInfo!(call.arguments.toString());
    } else if (call.method == "KnownUserIdentified" &&
        this._onKnownUserFoundCallback != null) {
      this._onKnownUserFoundCallback!(call.arguments.toString());
    } else if (call.method == "NotificationCenterResponse" &&
        this._notificationCenterCallback != null) {
      this._notificationCenterCallback!(call.arguments.toString());
    } else if (call.method == "NotificationCenterDataResponse" &&
        this._notificationCenterDataCallback != null) {
      this._notificationCenterDataCallback!(call.arguments.toString());
    }
    return null;
  }
}

//defining widget as a class which client will implement in their app
//communicates with NV’s native SDK via platform channels
//renders the embedded UI as per the remote config.
class NotifyVisitorsEmbedWidget extends StatelessWidget {
  final String propertyName;

  //key is used internally by Flutter’s widget tree system.
  //propertyName is your own custom logic/parameter needed to render your widget.
  const NotifyVisitorsEmbedWidget({
    Key? key,
    required this.propertyName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String viewType = 'notifyvisitors_embed_view';
    final Map<String, dynamic> creationParams = <String, dynamic>{
      'propertyName': propertyName,
    };

    if (Platform.isAndroid) {
      return AndroidView(
        viewType: viewType,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else if (Platform.isIOS) {
      return UiKitView(
        viewType: viewType,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else {
      return const Center(
        child: Text('Platform not supported'),
      );
    }
  }
}
