import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nvflutter_sdk_test_app/constants/Constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_notifyvisitors/flutter_notifyvisitors.dart';
import 'package:flutter_notifyvisitors/PushPromptInfo.dart';
import 'package:nvflutter_sdk_test_app/secondpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants/Constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notifyvisitors Flutter SDK Test App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xffF8862C)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Notifyvisitors Flutter SDK Test App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int nvCenterBadgeCounter = 0;
  bool nvIsActivePushSubscriber = true;
  String nvUnSubscribePushBtnTitle = '';
  //bool _isNativeDisplayVisible = false; // Track visibility status
  // Widget _nvNativeDisplayWidget = NotifyVisitorsEmbedWidget(propertyName: "home");

  @override
  void initState() {
    super.initState();

    PushPromptInfo nvPopupDesign = PushPromptInfo();
    Notifyvisitors.shared.pushPermissionPrompt(nvPopupDesign, (response) {
      debugPrint('Android Push Permission Prompt = $response');
      _showToast("!! Android Push Permission Prompt !!", response.toString(),
          ToastGravity.BOTTOM);
    });

    debugPrint(
        'on initState get notification center count data !! with dateTime');
    Notifyvisitors.shared
        .getNotificationCenterCount(Constants.notificationCenterTabsInfo)
        .then((value) {
      debugPrint('getNotificationCenterCount = $value');
      final callbackObj = jsonDecode(value) as Map<String, dynamic>;
      int allCount = callbackObj['totalCount'];
      debugPrint('getNotificationCenterCount allCount = $allCount');
      setState(() {
        nvCenterBadgeCounter = allCount;
      });
    });
    setState(() {
      Notifyvisitors.shared.getLinkInfo((response) {
        print("getLinkInfo() called !!");

        final Map<String, dynamic> jsonResponse = jsonDecode(response);
        // Nested notifyvisitors_cta (new format !!)
        Map<String, dynamic>? notifyCta = jsonResponse['notifyvisitors_cta'];

        if (notifyCta != null) {
          debugPrint("notifyvisitors_cta found : $notifyCta");
          Map<String, dynamic>? notifyParameters =
              notifyCta?['parameters'] != null
                  ? Map<String, dynamic>.from(notifyCta!['parameters'])
                  : null;

          /* String? screenName = notifyParameters?['screenName'] ?? '';
                  MaterialPageRoute pageRoute;
                  switch (screenName) {
                    case 'myparamVal1':
                      pageRoute = MaterialPageRoute( builder: (context) => SecondPage(nvResponseData: paramsData.toString()));
                    default:
                      pageRoute = MaterialPageRoute(builder: (context) => SecondPage(nvResponseData: paramsData.toString()));
                  }
                  
                  Navigator.push(context, pageRoute); */

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      SecondPage(nvResponseData: jsonResponse)));
        } else {
          Map<String, dynamic>? parameters_OLDFormat =
              jsonResponse['parameters'] != null
                  ? Map<String, dynamic>.from(jsonResponse['parameters'])
                  : null;

          if (parameters_OLDFormat != null) {
            // myparamKey1: myparamVal1
            print("old parameters found = $parameters_OLDFormat");

            /* String? screenName = notifyParameters?['screenName'] ?? '';
                  MaterialPageRoute pageRoute;
                  switch (screenName) {
                    case 'myparamVal1':
                      pageRoute = MaterialPageRoute( builder: (context) => SecondPage(nvResponseData: paramsData.toString()));
                    default:
                      pageRoute = MaterialPageRoute(builder: (context) => SecondPage(nvResponseData: paramsData.toString()));
                  }
                  
                  Navigator.push(context, pageRoute); */

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        SecondPage(nvResponseData: jsonResponse)));
          } else {
            print("parameters not found");
          }
        }
        _showToast("!! Notifyvisitors GetLinkInfo() data callback !!",
            jsonResponse.toString(), ToastGravity.BOTTOM);
      });

      Notifyvisitors.shared.getEventSurveyInfo((response) {
        debugPrint('getEventSurveyInfo() data callback = $response');
        _showToast("!! Notifyvisitors getEventSurveyInfo() data callback !!",
            response.toString(), ToastGravity.BOTTOM);
      });

      Notifyvisitors.shared.knownUserIdentified((response) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response);
        String nvUIDStr = jsonResponse['nv_uid'];
        debugPrint('knownUserIdentified() data callback nvUIDStr = $nvUIDStr');
        if (nvUIDStr.isNotEmpty) {
          debugPrint(
              'You can now pass this nvUID tou your store now nvUIDStr = $nvUIDStr to ');
        }
        _showToast("!! Notifyvisitors knownUserIdentified() data callback !!",
            jsonResponse.toString(), ToastGravity.CENTER,
            timeInSecForIos: 5);
      });

      Notifyvisitors.shared.notificationClickCallback((response) {
        _showToast("!! notificationClickCallback() data callback !!",
            response.toString(), ToastGravity.CENTER,
            timeInSecForIos: 10);
        debugPrint("notificationClickData response : $response");
      });

      setInitialPrefs().whenComplete(() {
        updateUnSubscribePushBtnTitle();
      });
    });
  }

  // Future<void> performRedirectionWithData(
  //     Map<String, dynamic>? paramsData) async {
  //   // myparamKey1: myparamVal1
  //   debugPrint('performRedirectionWithData = ${paramsData}');

  //   String? screenName = paramsData?['myparamKey1'] ?? '';
  //   MaterialPageRoute pageRoute;
  //   switch (screenName) {
  //     case 'myparamVal1':
  //       pageRoute = MaterialPageRoute(
  //           builder: (context) =>
  //               SecondPage(nvResponseData: paramsData.toString()));
  //     default:
  //       pageRoute = MaterialPageRoute(
  //           builder: (context) =>
  //               SecondPage(nvResponseData: paramsData.toString()));
  //   }

  //   Navigator.push(context, pageRoute);
  //   //Navigator.push(context, MaterialPageRoute( builder: (context) => SecondPage(nvResponseData: sampleJSON.toString())));
  // }

  Future<void> setInitialPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('nvIsActivePushSubscriber')) {
      prefs.setBool("nvIsActivePushSubscriber", true);
    }
    nvIsActivePushSubscriber = prefs.getBool('nvIsActivePushSubscriber')!;
  }

  Future<void> updateUnSubscribePushBtnTitle() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    nvIsActivePushSubscriber = prefs.getBool('nvIsActivePushSubscriber')!;
    setState(() {
      if (nvIsActivePushSubscriber == true) {
        nvUnSubscribePushBtnTitle = 'Unsubscribe for All Notifyvisitors Push';
      } else {
        nvUnSubscribePushBtnTitle =
            'Subscribe Again for All Notifyvisitors Push';
      }
    });
  }

  // void _toggleNativeDisplayVisibility() {
  //   setState(() {
  //     _isNativeDisplayVisible = !_isNativeDisplayVisible;
  //   });
  // }

  _handleButtonActionWithBtnName(String btnName) async {
    debugPrint('handle Button Action With btnName = $btnName');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    switch (btnName) {
      case Constants.getSessionData:
        {
          Notifyvisitors.shared.getSessionData().then((value) {
            debugPrint('getSessionData() response = $value');
            _showToast("!! Get Session Data !!", value.toString(),
                ToastGravity.BOTTOM);
          });

          break;
        }
      case Constants.notificationCenterStandard:
        {
          Notifyvisitors.shared.showNotifications(null, 0);

          break;
        }
      case Constants.notificationCenterAdvance:
        {
          _showAdvanceNotificationCenter();
          break;
        }
      case Constants.notificationCenterAdvanceWithCallback:
        {
          debugPrint("notificationCenterAdvanceWithCallback() called");

          Notifyvisitors.shared.openNotificationCenter(
              Constants.notificationCenterTabsInfo, 0, (response) {
            debugPrint("Open Notification Center with Callback = $response");
            _showToast("!! Open Notification Center with Callback !!",
                response.toString(), ToastGravity.BOTTOM);
          });
          setState(() {
            nvCenterBadgeCounter = 0;
          });
          break;
        }
      case Constants.notificationCenterUnreadCount:
        {
          Notifyvisitors.shared
              .getNotificationCenterCount(Constants.notificationCenterTabsInfo)
              .then((value) {
            _showToast("!! Notification Center Unread Count !!",
                value.toString(), ToastGravity.BOTTOM);
          });
          break;
        }
      case Constants.notificationCenterDataCallback:
        {
          Notifyvisitors.shared.getNotificationCenterData().then((value) {
            _showToast("!! Notification Center Data callback !!",
                value.toString(), ToastGravity.CENTER);
          });
          break;
        }
      case Constants.getNotificationCenterDetails:
        {
          Notifyvisitors.shared.getNotificationCenterDetails((value) {
            print("get Notification Center Details = $value");
            _showToast("!! get Notification Center Details !!",
                value.toString(), ToastGravity.TOP);
          });
          break;
        }
      case Constants.showInAppBannerSurvey:
        {
          Notifyvisitors.shared.show(Constants.bannerSurveyUserToken,
              Constants.bannerSurveyCustomRule, null, (var response) {
            debugPrint("show method inline callback : \n$response");
            _showToast("!! InApp Banner/Survey Events Response !!",
                response.toString(), ToastGravity.BOTTOM);
          });
          break;
        }
      case Constants.showInAppBannerSurveyWithCallback:
        {
          debugPrint("showInAppMessage() called");
          Notifyvisitors.shared.showInAppMessage(
              Constants.bannerSurveyUserToken,
              Constants.bannerSurveyCustomRule,
              null, (var response) {
            debugPrint(
                "new show method inline impression/click callback : \n$response");
            _showToast("!! new method InApp Banner/Survey Events Response !!",
                response.toString(), ToastGravity.BOTTOM);
          }).then((response) {
            //print banner success/fail
            debugPrint("Banner status (Active/InActive) Response = $response");
            _showToast("!! Banner status (Active/InActive) Response  !!",
                response.toString(), ToastGravity.TOP);
          });
          break;
        }
      case Constants.showNativeDisplayViewButton:
        {
          debugPrint("showNativeDisplayViewButton() called");
          setState(() {
            //  _nvNativeDisplayWidget = const NotifyVisitorsEmbedWidget(propertyName: "home");
          });
          //_toggleNativeDisplayVisibility();
          break;
        }
      case Constants.trackEvent:
        {
          Notifyvisitors.shared.event(
              Constants.trackEventName, Constants.eventAttributes, '200', '2',
              (var response) {
            _showToast("!! Track Event Response !!", response.toString(),
                ToastGravity.BOTTOM);
          });
          break;
        }
      case Constants.trackUser:
        {
          Notifyvisitors.shared
              .userIdentifier(Constants.trackUserID, Constants.trackUserParams);
          break;
        }

      case Constants.trackUserWithCallback:
        {
          debugPrint("trackUserWithCallback() called !!");

          Notifyvisitors.shared
              .setUserIdentifier(Constants.trackUserParams)
              .then((response) {
            debugPrint("set user Identifier Response = $response");
            _showToast("!! set user Identifier Response !!",
                response.toString(), ToastGravity.BOTTOM,
                timeInSecForIos: 5);
          });
          break;
        }
      case Constants.trackScreenName:
        {
          debugPrint(
              "trackScreen triggered with screen Name = ${Constants.trackHomeScreenName}");
          Notifyvisitors.shared.trackScreen(Constants.trackHomeScreenName);
          break;
        }
      case Constants.getNVUID:
        {
          Notifyvisitors.shared.getNvUID().then((value) {
            String nvUIDStr = value.toString();
            if (nvUIDStr.isNotEmpty) {
              debugPrint(
                  'You can now pass this nvUID tostr tou your store now nvUIDStr = $nvUIDStr to ');
            }
            _showToast(
                "!! Get NVUID !!", value.toString(), ToastGravity.BOTTOM);
          });
          break;
        }
      case Constants.appStoreReview:
        {
          Notifyvisitors.shared.requestInAppReview().then((result) {
            _showToast("!! App Store / PlayStore Review Result !!",
                result.toString(), ToastGravity.BOTTOM);
          });
          break;
        }
      case Constants.setPushPreference:
        {
          await prefs.setBool('nvIsActivePushSubscriber', true);
          setState(() {
            nvIsActivePushSubscriber =
                prefs.getBool('nvIsActivePushSubscriber')!;
            Notifyvisitors.shared.subscribePushCategory(
                Constants.pushCatInfo, !nvIsActivePushSubscriber);
            updateUnSubscribePushBtnTitle();
          });
          break;
        }
      case Constants.unsubscribeAllPush:
        {
          if (prefs.containsKey('nvIsActivePushSubscriber')) {
            final bool? currentStatus =
                prefs.getBool('nvIsActivePushSubscriber');
            if (currentStatus == true) {
              await prefs.setBool('nvIsActivePushSubscriber', false);
            } else {
              await prefs.setBool('nvIsActivePushSubscriber', true);
            }
          } else {
            await prefs.setBool('nvIsActivePushSubscriber', true);
          }

          setState(() {
            nvIsActivePushSubscriber =
                prefs.getBool('nvIsActivePushSubscriber')!;
            Notifyvisitors.shared
                .subscribePushCategory([], !nvIsActivePushSubscriber);
            updateUnSubscribePushBtnTitle();
          });
          break;
        }
      case Constants.getPushSubscriptionID:
        {
          Notifyvisitors.shared.getRegistrationToken().then((value) {
            debugPrint('Notifyvisitors Push SubscriptionID = $value');
            _showToast("!! Notifyvisitors Push SubscriptionID !!",
                value.toString(), ToastGravity.BOTTOM);
          });
          break;
        }
      case Constants.gotoSecondPage:
        {
          debugPrint('gotoSecondPage !!!');
          final Map<String, dynamic> sampleJSON = {};
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      SecondPage(nvResponseData: sampleJSON)));

          //(context, Builder(builder: (context) => SecondPage(nvResponseData: sampleJSON.toString()))));
          break;
        }
      default:
        {
          break;
        }
    }
  }

  _showAdvanceNotificationCenter() {
    Notifyvisitors.shared
        .showNotifications(Constants.notificationCenterTabsInfo, 0);
    setState(() {
      nvCenterBadgeCounter = 0;
    });
  }

  _showToast(String title, String message, ToastGravity gravity,
      {int timeInSecForIos = 3}) {
    Fluttertoast.showToast(
      msg: "$title:\n\n$message",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: timeInSecForIos,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          widget.title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          Stack(
            children: <Widget>[
              IconButton(
                  icon: const Icon(
                    Icons.notifications_outlined,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    _showAdvanceNotificationCenter();
                  }),
              nvCenterBadgeCounter != 0
                  ? Positioned(
                      right: 11,
                      top: 11,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 14,
                          minHeight: 14,
                        ),
                        child: Text(
                          '$nvCenterBadgeCounter',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : Container()
            ],
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: List.generate(Constants.notifyvisitorsAppUIData.length,
                (index) {
              final item = Constants.notifyvisitorsAppUIData[index];
              if (item['viewType'] == Constants.viewTypeText &&
                  item['actionType'] == Constants.headingText) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Text(
                      item['contentTitle'] ?? '',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              } else if (item['viewType'] == Constants.viewTypeContainer) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Container(
                    height: 200,
                    color: Colors.grey[400],
                    child:
                        const NotifyVisitorsEmbedWidget(propertyName: "home"),
                  ),
                );
              } else if (item['viewType'] == Constants.viewTypeButton) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff005f73),
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      _handleButtonActionWithBtnName(
                          item['actionType'].toString());
                    },
                    child: Text(
                      item['actionType'] == Constants.unsubscribeAllPush
                          ? nvUnSubscribePushBtnTitle
                          : (item['contentTitle'] ?? ''),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              } else {
                // Add more conditions for other view types as needed
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Text(
                    item['contentTitle'] ?? '',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              }
            }),
          ),
        ),
        //       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        //       child: Constants.notifyvisitorsAppUIData[index]['viewType'] == Constants.viewTypeText &&
        //               Constants.notifyvisitorsAppUIData[index]['actionType'] ==
        //                   Constants.headingText
        //           ? Center(
        //               child: Padding(
        //                 padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        //                 child: Text(
        //                   Constants.notifyvisitorsAppUIData[index]
        //                       ['contentTitle']!,
        //                   style: const TextStyle(
        //                     fontSize: 14,
        //                     fontWeight: FontWeight.bold,
        //                   ),
        //                   textAlign: TextAlign.center,
        //                 ),
        //               ),
        //             )
        //           : Constants.notifyvisitorsAppUIData[index]['viewType'] == Constants.viewTypeText &&
        //                   Constants.notifyvisitorsAppUIData[index]['actionType'] ==
        //                       Constants.viewTypeNotificationCenterAdvanceInputs
        //               ? RichText(
        //                   text: const TextSpan(
        //                     style: TextStyle(
        //                       fontSize: 14.0,
        //                       color: Colors.black,
        //                     ),
        //                     children: <TextSpan>[
        //                       // lable 1 display......................
        //                       TextSpan(text: '{displayName: '),
        //                       TextSpan(
        //                         text: Constants.tabDisplayNameOne,
        //                         style: TextStyle(
        //                           fontWeight: FontWeight.bold,
        //                         ),
        //                       ),
        //                       TextSpan(text: ', Label: '),
        //                       TextSpan(
        //                         text: Constants.tabLabelOne,
        //                         style: TextStyle(
        //                           fontWeight: FontWeight.bold,
        //                         ),
        //                       ),
        //                       TextSpan(text: '}\n'),

        //                       // Label 2 display ....................

        //                       TextSpan(text: '{displayName: '),
        //                       TextSpan(
        //                         text: Constants.tabDisplayNameTwo,
        //                         style: TextStyle(
        //                           fontWeight: FontWeight.bold,
        //                         ),
        //                       ),
        //                       TextSpan(text: ', Label: '),
        //                       TextSpan(
        //                         text: Constants.tabLabelTwo,
        //                         style: TextStyle(
        //                           fontWeight: FontWeight.bold,
        //                         ),
        //                       ),
        //                       TextSpan(text: '}\n'),

        //                       // Label 3 dispay .........................

        //                       TextSpan(text: '{displayName: '),
        //                       TextSpan(
        //                         text: Constants.tabDisplayNameThree,
        //                         style: TextStyle(
        //                           fontWeight: FontWeight.bold,
        //                         ),
        //                       ),
        //                       TextSpan(text: ', Label: '),
        //                       TextSpan(
        //                         text: Constants.tabLabelthree,
        //                         style: TextStyle(
        //                           fontWeight: FontWeight.bold,
        //                         ),
        //                       ),
        //                       TextSpan(text: '}\n'),
        //                     ],
        //                   ),
        //                   textAlign: TextAlign.center,
        //                 )
        //               : Constants.notifyvisitorsAppUIData[index]['viewType'] == Constants.viewTypeText &&
        //                       Constants.notifyvisitorsAppUIData[index]['actionType'] ==
        //                           Constants.inAppBannerSurveyInputParamsInfo
        //                   ? RichText(
        //                       text: TextSpan(
        //                         style: const TextStyle(
        //                           fontSize: 14.0,
        //                           color: Colors.black,
        //                         ),
        //                         children: <TextSpan>[
        //                           const TextSpan(text: 'User Token =\n'),
        //                           TextSpan(
        //                             text: Constants.bannerSurveyUserToken
        //                                 .toString(),
        //                             style: const TextStyle(
        //                               fontWeight: FontWeight.bold,
        //                             ),
        //                           ),
        //                           const TextSpan(text: '\n\nCustom Rule =\n'),
        //                           TextSpan(
        //                             text: Constants.bannerSurveyCustomRule
        //                                 .toString(),
        //                             style: const TextStyle(
        //                               fontWeight: FontWeight.bold,
        //                             ),
        //                           ),
        //                         ],
        //                       ),
        //                       textAlign: TextAlign.center,
        //                     )
        //                   : Constants.notifyvisitorsAppUIData[index]['viewType'] == Constants.viewTypeText &&
        //                           Constants.notifyvisitorsAppUIData[index]['actionType'] ==
        //                               Constants.trackEventInputParamsInfo
        //                       ? RichText(
        //                           text: TextSpan(
        //                             style: const TextStyle(
        //                               fontSize: 14.0,
        //                               color: Colors.black,
        //                             ),
        //                             children: <TextSpan>[
        //                               const TextSpan(text: 'Event Name = '),
        //                               TextSpan(
        //                                 text: Constants.trackEventName,
        //                                 style: const TextStyle(
        //                                   fontWeight: FontWeight.bold,
        //                                 ),
        //                               ),
        //                               const TextSpan(
        //                                   text: '\n\nEvent Attributes =\n'),
        //                               TextSpan(
        //                                 text: Constants.eventAttributes
        //                                     .toString(),
        //                                 style: const TextStyle(
        //                                   fontWeight: FontWeight.bold,
        //                                 ),
        //                               ),
        //                             ],
        //                           ),
        //                           textAlign: TextAlign.center,
        //                         )
        //                       : Constants.notifyvisitorsAppUIData[index]['viewType'] == Constants.viewTypeText &&
        //                               Constants.notifyvisitorsAppUIData[index]
        //                                       ['actionType'] ==
        //                                   Constants.trackUserInputParamsInfo
        //                           ? RichText(
        //                               text: TextSpan(
        //                                 style: const TextStyle(
        //                                   fontSize: 14.0,
        //                                   color: Colors.black,
        //                                 ),
        //                                 children: <TextSpan>[
        //                                   const TextSpan(text: 'UserID = '),
        //                                   TextSpan(
        //                                     text: Constants.trackUserID,
        //                                     style: const TextStyle(
        //                                       fontWeight: FontWeight.bold,
        //                                     ),
        //                                   ),
        //                                   const TextSpan(
        //                                       text: '\n\nUser Params =\n'),
        //                                   TextSpan(
        //                                     text: Constants.trackUserParams
        //                                         .toString(),
        //                                     style: const TextStyle(
        //                                       fontWeight: FontWeight.bold,
        //                                     ),
        //                                   ),
        //                                 ],
        //                               ),
        //                               textAlign: TextAlign.center,
        //                             )
        //                           : Constants.notifyvisitorsAppUIData[index]['viewType'] == Constants.viewTypeText &&
        //                                   Constants.notifyvisitorsAppUIData[index]
        //                                           ['actionType'] ==
        //                                       Constants.trackScreenNameParamsInfo
        //                               ? RichText(
        //                                   text: TextSpan(
        //                                     style: const TextStyle(
        //                                       fontSize: 14.0,
        //                                       color: Colors.black,
        //                                     ),
        //                                     children: <TextSpan>[
        //                                       const TextSpan(
        //                                           text:
        //                                               'Track custome Screen name = '),
        //                                       TextSpan(
        //                                         text: Constants
        //                                             .trackHomeScreenName,
        //                                         style: const TextStyle(
        //                                           fontWeight: FontWeight.bold,
        //                                         ),
        //                                       ),
        //                                     ],
        //                                   ),
        //                                   textAlign: TextAlign.center,
        //                                 )
        //                               : Constants.notifyvisitorsAppUIData[index]['viewType'] == Constants.viewTypeText && Constants.notifyvisitorsAppUIData[index]['actionType'] == Constants.setPushPreferenceInputsInfo
        //                                   ? RichText(
        //                                       text: TextSpan(
        //                                         style: const TextStyle(
        //                                           fontSize: 14.0,
        //                                           color: Colors.black,
        //                                         ),
        //                                         children: <TextSpan>[
        //                                           const TextSpan(
        //                                               text:
        //                                                   'Subscribe to Push Categories = '),
        //                                           TextSpan(
        //                                             text:
        //                                                 "\n${Constants.pushCatInfo.toString()}",
        //                                             style: const TextStyle(
        //                                               fontWeight:
        //                                                   FontWeight.bold,
        //                                             ),
        //                                           ),
        //                                         ],
        //                                       ),
        //                                       textAlign: TextAlign.center,
        //                                     )
        //                                   : Constants.notifyvisitorsAppUIData[index]['viewType'] == Constants.viewTypeText && Constants.notifyvisitorsAppUIData[index]['actionType'] == Constants.unsubscribeAllPushStatusInfo
        //                                       ? RichText(
        //                                           text: TextSpan(
        //                                             style: const TextStyle(
        //                                               fontSize: 14.0,
        //                                               color: Colors.black,
        //                                             ),
        //                                             children: <TextSpan>[
        //                                               const TextSpan(
        //                                                   text:
        //                                                       'Is a Notifyvisitors Push Active Subscriber = '),
        //                                               TextSpan(
        //                                                 text:
        //                                                     nvIsActivePushSubscriber
        //                                                         .toString(),
        //                                                 style: const TextStyle(
        //                                                   fontWeight:
        //                                                       FontWeight.bold,
        //                                                 ),
        //                                               ),
        //                                             ],
        //                                           ),
        //                                           textAlign: TextAlign.center,
        //                                         )
        //                                       : Constants.notifyvisitorsAppUIData[index]['viewType'] == Constants.viewTypeContainer
        //                                           ? Container(
        //                                               height: 200,
        //                                               color: Colors.grey[400],
        //                                               child:
        //                                                   const NotifyVisitorsEmbedWidget(
        //                                                       propertyName:
        //                                                           "home"),
        //                                             )
        //                                           : Constants.notifyvisitorsAppUIData[index]['viewType'] == Constants.viewTypeButton
        //                                               ? ElevatedButton(
        //                                                   style: ElevatedButton
        //                                                       .styleFrom(
        //                                                     backgroundColor:
        //                                                         const Color(
        //                                                             0xff005f73), //#005f73
        //                                                     foregroundColor:
        //                                                         Colors.white,
        //                                                     textStyle:
        //                                                         const TextStyle(
        //                                                       fontWeight:
        //                                                           FontWeight
        //                                                               .bold,
        //                                                     ),
        //                                                   ),
        //                                                   onPressed: () {
        //                                                     _handleButtonActionWithBtnName(Constants
        //                                                         .notifyvisitorsAppUIData[
        //                                                             index][
        //                                                             'actionType']
        //                                                         .toString());
        //                                                   },
        //                                                   child: Text(
        //                                                     Constants.notifyvisitorsAppUIData[
        //                                                                     index]
        //                                                                 [
        //                                                                 'actionType'] ==
        //                                                             Constants
        //                                                                 .unsubscribeAllPush
        //                                                         ? nvUnSubscribePushBtnTitle
        //                                                         : Constants.notifyvisitorsAppUIData[
        //                                                                 index][
        //                                                             'contentTitle']!,
        //                                                     style:
        //                                                         const TextStyle(
        //                                                       fontWeight:
        //                                                           FontWeight
        //                                                               .bold,
        //                                                     ),
        //                                                   ),
        //                                                 )
        //                                               : null,
        //     );
        //   },
        // ),
      ),
    );
  }
}
