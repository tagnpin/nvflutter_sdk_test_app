#import "NotifyvisitorsPlugin.h"
#import "NVSDKNativeDisplayViewFactory.h"

BOOL nvDismissNCenterOnAction;

BOOL nvPushObserverReady;

//BOOL nvPushObserverReady;
typedef void (^nvPushClickCheckRepeatHandler)(BOOL isnvPushActionRepeat);
typedef void (^nvPushClickCheckRepeatBlock)(nvPushClickCheckRepeatHandler completionHandler);
int nvCheckPushClickTimeCounter = 0;

FlutterResult chatBotCallback;
FlutterResult showCallback = NULL;
FlutterResult eventCallback = NULL;
FlutterResult commonCallback = NULL;

FlutterResult onKnownUserFoundCallback = NULL;
FlutterResult notificationCenterCallback = NULL;


NSString * tab1Label;
NSString * tab1Name;
NSString * tab2Label;
NSString * tab2Name;
NSString * tab3Label;
NSString * tab3Name;

NSString * selectedTabTextColor;
NSString * unselectedTabTextColor;
NSString * selectedTabBgColor;
NSString * unselectedTabBgColor;

NSString * tabTextFontName;
NSInteger tabTextFontSize;
NSInteger selectedTabIndex;

UIColor * mSelectedTabTextColor;
UIColor * mUnselectedTabTextColor;
UIColor * mSelectedTabBgColor;
UIColor * mUnselectedTabBgColor;


@implementation NotifyvisitorsPlugin

+ (instancetype)sharedInstance {
    static NotifyvisitorsPlugin *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [NotifyvisitorsPlugin new];
    });
    return sharedInstance;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    NSLog(@"%@ REGISTER WITH REGISTRAR !!", TAG);
    NSLog(@"%@ PLUGIN_VERSION : %@ !!", TAG, PLUGIN_VERSION);
    NotifyvisitorsPlugin.sharedInstance.channel = [FlutterMethodChannel
                                                   methodChannelWithName:@"flutter_notifyvisitors"
                                                   binaryMessenger:[registrar messenger]];
    //NotifyvisitorsPlugin* instance = [[NotifyvisitorsPlugin alloc] init];
    
    [registrar addMethodCallDelegate:NotifyvisitorsPlugin.sharedInstance channel:NotifyvisitorsPlugin.sharedInstance.channel];
    
    // Register your Objective-C PlatformViewFactory
    NVSDKNativeDisplayViewFactory *nvNativeDisplayFactory = [[NVSDKNativeDisplayViewFactory alloc] initWithMessenger: [registrar messenger]];
    // "notifyvisitors_embed_view" is the unique identifier that will be used in Dart's UiKitView
    [registrar registerViewFactory: nvNativeDisplayFactory withId:@"notifyvisitors_embed_view"];
    // initialize variables
    [NotifyvisitorsPlugin.sharedInstance nvInit];
}

- (void) nvInit{
    NSLog(@"%@ NV INIT !!", TAG);
    [self setNvDeepLinkObserver];
    _handlers = [[NSMutableArray alloc] init];
    [notifyvisitors sharedInstance].delegate = self;
}


#pragma mark - Flutter calls from Dart file (flutter_notifyvisitors.dart)

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"getPlatformVersion" isEqualToString:call.method]) {
        result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
    } else if([SHOW isEqualToString:call.method]){
        [self show:call withResult:result];
    }  else if([SHOW_INAPP_MESSAGE isEqualToString:call.method]){
        [self showInAppMessage: call withResult: result];
    } else if([OPEN_NOTIFICATION_CENTER isEqualToString:call.method]){
        [self openNotificationCenter:call withResult:result];
    } else if([NOTIFICATION_CENTER isEqualToString:call.method]){
        [self appInbox: call withResult: result];
    } else if([EVENT isEqualToString:call.method]){
        [self event:call withResult:result];
    } else if([STOP_SHOW_INAPP isEqualToString:call.method]){
        [self stopShowInapp:call withResult:result];
    } else if([STOP_PUSH isEqualToString:call.method]){
        [self stopPushNotification:call withResult:result];
    } else if([GET_NOTIFICATION_DATA isEqualToString:call.method]){
        [self notificationCenterData:call withResult:result];
    } else if([NOTIFICATION_COUNT isEqualToString:call.method]){
        [self notificationCount:call withResult:result];
    } else if([SCHEDULE_NOTIFICATION isEqualToString:call.method]){
        [self scheduleNotification:call withResult:result];
    } else if([HIT_USER isEqualToString:call.method]){
        [self userIdentifier:call withResult:result];
    } else if([SET_USER_IDENTIFIER isEqualToString:call.method]){
        [self setUserIdentifier: call withResult: result];
    } else if([STOP_GEOFENCE isEqualToString:call.method]) {
        [self stopGeofence:call withResult:result];
    } else if([PUSH_CLICK isEqualToString:call.method]){
        [self getLinkInfo:call withResult:result];
    } else if([EVENT_SURVEY_INFO isEqualToString:call.method]){
        [self getEventSurveyInfo:call withResult:result];
    } else if([SCROLL_VIEW_DID_SCROLL isEqualToString:call.method]){
        [self scrollViewDidScroll:call withResult:result];
    } else if([CHAT_BOT isEqualToString:call.method]){
        [self startChatBot:call withResult:result];
    } else if([NV_UID isEqualToString:call.method]){
        [self getNvUid:call withResult:result];
    } else if([NV_SUBSCRIBE_CATEGORY isEqualToString:call.method]){
        [self subscribePushCategory:call withResult:result];
    } else if([NV_NOTIFICATION_CENTER_COUNT isEqualToString:call.method]){
        [self getNotificationCenterCount:call withResult:result];
    } else if([NV_REQUEST_IN_APP isEqualToString:call.method]){
        [self requestInAppReview:call withResult:result];
    } else if([NV_REGISTRATION_TOKEN isEqualToString:call.method]){
        [self getRegistrationToken:call withResult:result];
    } else if([NOTIFICATION_CENTER_DATA isEqualToString:call.method]){
        [self notificationCenterInfo:call withResult:result];
    } else if([GET_NOTIFICATION_CENTER_DETAILS isEqualToString:call.method]){
        [self getNotificationCenterDetails: call withResult: result];
    } else if([KNOWN_USER_IDENTIFIED isEqualToString:call.method]){
        [self knownUserIdentified: call withResult: result];
    } else if ([TRACK_SCREEN isEqualToString: call.method]) {
        [self trackScreen: call withResult: result];
    }  else if([GET_SESSION_DATA isEqualToString:call.method]) {
        [self getSessionData: call withResult: result];
    } else if([NOTIFICATION_CLICK_CALLBACK isEqualToString:call.method]) {
        [self notificationClickCallback: call withResult: result];
    } else if([ANDROID_AUTO_START isEqualToString:call.method] || [ANDROID_CREATE_NOTIFICATION_CHANNEL isEqualToString:call.method] || [ANDROID_DELETE_NOTIFICATION_CHANNEL isEqualToString:call.method] || [ANDROID_CREATE_NOTIFICATION_CHANNEL_GROUP isEqualToString:call.method] || [ANDROID_DELETE_NOTIFICATION_CHANNEL_GROUP isEqualToString:call.method] || [ANDROID_PUSH_PERMISSION_PROMPT isEqualToString:call.method] || [ANDROID_ENABLE_PUSH_PERMISSION isEqualToString:call.method] || [ANDROID_NATIVE_PUSH_PERMISSION_PROMPT isEqualToString:call.method] || [ANDROID_IS_PAYLOAD_FROM_NV_PLATFORM isEqualToString:call.method] || [ANDROID_GET_NV_FCM_PAYLOAD isEqualToString:call.method]) {
        
        NSLog(@"%@ NOT AVAILABLE IN iOS !!", TAG);
    }
    
    else {
        result(FlutterMethodNotImplemented);
    }
}

#pragma mark - Show inAppMessage (Banner/Survey methods)

-(void)showInAppMessage:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSLog(@"%@ SHOW INAPP MESSAGE  !!", TAG);
    @try{
        [self show: call withResult: result];
        /*
         //         [self nvNativeShowInAppMessage: mUserToken CustomRule: mCustomRule completionResponse:^(NSDictionary *dictResValue) {
         //             if ([dictResValue count] > 0) {
         //                 NSLog(@"dictResValue = %@", dictResValue);
         //                 NSError *nvError = nil;
         //                 NSData *nvJsonData = [NSJSONSerialization dataWithJSONObject: dictResValue options: NSJSONWritingPrettyPrinted error: &nvError];
         //                 NSString *nvJsonString = [[NSString alloc] initWithData: nvJsonData encoding: NSUTF8StringEncoding];
         //                 result(nvJsonString);
         //             }
         //         }];
         */
        
    }
    @catch(NSException *exception){
        NSLog(@"%@ SHOW INAPP MESSAGE ERROR : %@", TAG, exception.reason);
    }
}

- (void) show:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSLog(@"%@ SHOW !!", TAG);
    @try{
        showCallback = result;
        NSMutableDictionary *mUserToken = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *mCustomRule = [[NSMutableDictionary alloc] init];
        
        NSDictionary *userToken ;
        @try{
            userToken = call.arguments[@"tokens"];
            if (![userToken isEqual:[NSNull null]]){
                mUserToken = [userToken mutableCopy];
            } else{
                mUserToken = nil;
            }
        }
        @catch(NSException *exception){
            NSLog(@"%@ USER TOKENS ERROR : %@", TAG, exception.reason);
        }
        
        NSDictionary *customRule;
        @try{
            customRule = call.arguments[@"customRules"];
            if (![customRule isEqual:[NSNull null]]){
                mCustomRule = [customRule mutableCopy];
            } else{
                mCustomRule = nil;
            }
        }
        @catch(NSException *exception){
            NSLog(@"%@ CUSTOM RULE ERROR : %@", TAG, exception.reason);
        }
        
        NSLog(@"%@ CALL NATIVE SHOW() FUNCTION !!", TAG);
        [notifyvisitors Show:mUserToken CustomRule:mCustomRule];
        
    }
    @catch(NSException *exception){
        NSLog(@"%@ SHOW ERROR : %@", TAG, exception.reason);
    }
}

- (void) stopShowInapp:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSLog(@"%@ STOP-SHOW-INAPP !!", TAG);
    @try{
        [notifyvisitors DismissAllNotifyvisitorsInAppNotifications];
    }
    @catch(NSException *exception){
        NSLog(@"%@ STOP-SHOW-INAPP ERROR : %@", TAG, exception.reason);
    }
}

- (void) scrollViewDidScroll:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSLog(@"%@ SCROLLVIEW DID SCROLL !!", TAG);
    @try{
        UIScrollView *nvScrollview;
        [notifyvisitors scrollViewDidScroll: nvScrollview];
    }
    @catch(NSException *exception){
        NSLog(@"%@ SCROLLVIEW-DID-SCROLL ERROR : %@", TAG, exception.reason);
    }
}

- (void) getEventSurveyInfo:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSLog(@"%@ GET EVENT SURVEY INF0 !!", TAG);
    @try{
        commonCallback = result;
    }
    @catch(NSException *exception){
        NSLog(@"%@ ERROR : %@", TAG, exception.reason);
    }
}

#pragma mark - Open Notification Center old and new method with Close button Callback

- (void) openNotificationCenter:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSLog(@"%@ OPEN NOTIFICATION CENTER !!", TAG);
    @try{
        notificationCenterCallback = result;
        [self appInbox: call withResult: result];
        
        //        if(notificationCenterCallback != NULL) {
        //            NSError *nvError = nil;
        //            NSData *nvJsonData = [NSJSONSerialization dataWithJSONObject: @{@"onCenterClose": @"testonCenterClose"} options: NSJSONWritingPrettyPrinted error: &nvError];
        //            NSString *nvJsonString = [[NSString alloc] initWithData: nvJsonData encoding: NSUTF8StringEncoding];
        //            [self.channel invokeMethod: @"NotificationCenterResponse" arguments: nvJsonString];
        //        }  else{
        //            NSLog(@"%@ : NOTIFICATION CENTER CALLBACK CONTEXT IS NULL !!", TAG);
        //        }
        
    }
    @catch(NSException *exception){
        NSLog(@"%@ OPEN NOTIFICATION CENTER ERROR : %@", TAG, exception.reason);
    }
}

- (void) appInbox:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSLog(@"%@ SHOW NOTIFICATIONS !!", TAG);
    tab1Label = nil;
    tab1Name = nil;
    tab2Label = nil;
    tab2Name = nil;
    tab3Label = nil;
    tab3Name = nil;
    selectedTabTextColor = nil;
    unselectedTabTextColor = nil;
    selectedTabBgColor = nil;
    unselectedTabBgColor = nil;
    tabTextFontName = nil;
    tabTextFontSize = 13;
    selectedTabIndex = 0;
    mSelectedTabTextColor = nil;
    mUnselectedTabTextColor = nil;
    mSelectedTabBgColor = nil;
    mUnselectedTabBgColor = nil;
    
    NSMutableDictionary *appInboxInfo;
    NSMutableDictionary * temp;
    @try{
        temp = call.arguments[@"appInboxInfo"];
        if (![temp isEqual:[NSNull null]]) {
            appInboxInfo = [[NSMutableDictionary alloc] init];
            appInboxInfo = [temp mutableCopy];
            
            
            if (appInboxInfo[@"label_one"] && ![appInboxInfo[@"label_one"] isEqual: [NSNull null]]) {
                tab1Label = appInboxInfo[@"label_one"];
            }
            
            if (appInboxInfo[@"name_one"] && ![appInboxInfo[@"name_one"] isEqual: [NSNull null]]) {
                tab1Name = appInboxInfo[@"name_one"];
            }
            
            if (appInboxInfo[@"label_two"] && ![appInboxInfo[@"label_two"] isEqual: [NSNull null]]) {
                tab2Label = appInboxInfo[@"label_two"];
            }
            
            if (appInboxInfo[@"name_two"] && ![appInboxInfo[@"name_two"] isEqual: [NSNull null]]) {
                tab2Name = appInboxInfo[@"name_two"];
            }
            
            if (appInboxInfo[@"label_three"] && ![appInboxInfo[@"label_three"] isEqual: [NSNull null]]) {
                tab3Label = appInboxInfo[@"label_three"];
            }
            
            if (appInboxInfo[@"name_three"] && ![appInboxInfo[@"name_three"] isEqual: [NSNull null]]) {
                tab3Name = appInboxInfo[@"name_three"];
            }
            
            if (appInboxInfo[@"selectedTabTextColor"] && ![appInboxInfo[@"selectedTabTextColor"] isEqual: [NSNull null]]) {
                selectedTabTextColor =  appInboxInfo[@"selectedTabTextColor"];
                mSelectedTabTextColor = [self GetColor:selectedTabTextColor];
                
            }
            
            if (appInboxInfo[@"unselectedTabTextColor"] && ![appInboxInfo[@"unselectedTabTextColor"] isEqual: [NSNull null]]) {
                unselectedTabTextColor = appInboxInfo[@"unselectedTabTextColor"];
                mUnselectedTabTextColor =  [self GetColor:unselectedTabTextColor];
            }
            
            if (appInboxInfo[@"selectedTabBgColor"] && ![appInboxInfo[@"selectedTabBgColor"] isEqual: [NSNull null]]) {
                selectedTabBgColor = appInboxInfo[@"selectedTabBgColor"];
                mSelectedTabBgColor = [self GetColor:selectedTabBgColor];
            }
            
            if (appInboxInfo[@"unselectedTabBgColor_ios"] && ![appInboxInfo[@"unselectedTabBgColor_ios"] isEqual: [NSNull null]]) {
                unselectedTabBgColor = appInboxInfo[@"unselectedTabBgColor_ios"];
                mUnselectedTabBgColor = [self GetColor:unselectedTabBgColor];
            }
            
            if (appInboxInfo[@"selectedTabIndex_ios"] && ![appInboxInfo[@"selectedTabIndex_ios"] isEqual: [NSNull null]]) {
                selectedTabIndex = [appInboxInfo[@"selectedTabIndex_ios"]integerValue];
            }
            
            if (appInboxInfo[@"tabTextFontName_ios"] && ![appInboxInfo[@"tabTextFontName_ios"] isEqual: [NSNull null]]) {
                tabTextFontName = appInboxInfo[@"tabTextFontName_ios"];
            }
            
            if (appInboxInfo[@"tabTextFontSize_ios"] && ![appInboxInfo[@"tabTextFontSize_ios"] isEqual: [NSNull null]]) {
                tabTextFontSize = [appInboxInfo[@"tabTextFontSize_ios"]integerValue];
            }
            
            NVCenterStyleConfig *nvConfig = [[NVCenterStyleConfig alloc] init];
            
            if (tab1Label != nil && [tab1Label length] > 0 && ![tab1Label isEqual: [NSNull null]]){
                if(tab1Name!= nil && [tab1Name length] > 0 && ![tab1Name isEqual: [NSNull null]]){
                    [nvConfig setFirstTabWithTabLable: tab1Label TagDisplayName: tab1Name];
                }
            }
            
            if (tab2Label != nil && [tab2Label length] > 0 && ![tab2Label isEqual: [NSNull null]]){
                if(tab2Name!= nil && [tab2Name length] > 0 && ![tab2Name isEqual: [NSNull null]]){
                    [nvConfig setSecondTabWithTabLable: tab2Label TagDisplayName: tab2Name];
                }
            }
            
            if (tab3Label != nil && [tab3Label length] > 0 && ![tab3Label isEqual: [NSNull null]]){
                if(tab3Name!= nil && [tab3Name length] > 0 && ![tab3Name isEqual: [NSNull null]]){
                    [nvConfig setThirdTabWithTabLable: tab3Label TagDisplayName: tab3Name];
                }
            }
            
            if (mSelectedTabTextColor != nil && ![mSelectedTabTextColor isEqual: [NSNull null]]){
                nvConfig.selectedTabTextColor = mSelectedTabTextColor;
            }
            
            if (mUnselectedTabTextColor != nil && ![mUnselectedTabTextColor isEqual: [NSNull null]]){
                nvConfig.unselectedTabTextColor = mUnselectedTabTextColor;
            }
            
            if (mSelectedTabBgColor != nil && ![mSelectedTabBgColor isEqual: [NSNull null]]){
                nvConfig.selectedTabBgColor = mSelectedTabBgColor;
            }
            
            if (mUnselectedTabBgColor != nil && ![mUnselectedTabBgColor isEqual: [NSNull null]]){
                nvConfig.unselectedTabBgColor = mUnselectedTabBgColor;
            }
            
            if(selectedTabIndex != 0){
                nvConfig.selectedTabIndex = selectedTabIndex;
            }
            
            if (tabTextFontName != nil && [tabTextFontName length] > 0 && ![tabTextFontName isEqual: [NSNull null]]){
                nvConfig.tabTextfont = [UIFont fontWithName: tabTextFontName size: tabTextFontSize];
            }
            [notifyvisitors notificationCenterWithConfiguration: nvConfig];
        } else{
            NSLog(@"%@ Empty JSON Object Going for Standard App Inbox", TAG);
            [notifyvisitors notificationCenter];
        }
        
        NSString *nvResourcePlistPath = [[NSBundle mainBundle] pathForResource: @"nvResourceValues" ofType: @"plist"];
        if ([[NSFileManager defaultManager] fileExistsAtPath: nvResourcePlistPath]) {
            NSDictionary *nvResourceData = [NSDictionary dictionaryWithContentsOfFile: nvResourcePlistPath];
            if ([nvResourceData count] > 0) {
                NSDictionary *nvResourceBooleans = [nvResourceData objectForKey: @"nvBooleans"];
                
                if ([nvResourceBooleans count] > 0) {
                    if (nvResourceBooleans [@"DismissNotificationCenterOnAction"]) {
                        nvDismissNCenterOnAction = [nvResourceBooleans [@"DismissNotificationCenterOnAction"] boolValue];
                    } else {
                        nvDismissNCenterOnAction = YES;
                    }
                    NSLog(@"NV DISMISS NOTIFICATION CENTER ON ACTION = %@", nvDismissNCenterOnAction ? @"YES" : @"NO");
                    
                } else {
                    NSLog(@"NV RESOURCE BOOLEANS NOT FOUND !!");
                }
                
            } else {
                NSLog(@"NV RESOURCE DATA NOT FOUND !!");
            }
            
        } else {
            NSLog(@"NV RESOURCE VALUES PLIST NOT FOUND !!");
        }
    } @catch(NSException *exception){
        NSLog(@"%@ ERROR : %@", TAG, exception.reason);
    }
}

- (void) getNotificationCenterCount:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSLog(@"%@ GET NOTIFICATION CENTER COUNT  !!", TAG);
    @try{
        NSString * tab1Label;
        NSString * tab1Name;
        NSString * tab2Label;
        NSString * tab2Name;
        NSString * tab3Label;
        NSString * tab3Name;
        NSMutableDictionary *appInboxInfo = [[NSMutableDictionary alloc] init];
        
        NSDictionary *tabCountInfo ;
        @try{
            tabCountInfo = call.arguments[@"tabCountInfo"];
            if (![tabCountInfo isEqual:[NSNull null]]){
                appInboxInfo = [tabCountInfo mutableCopy];
                tab1Label = nil;
                tab1Name = nil;
                tab2Label = nil;
                tab2Name = nil;
                tab3Label = nil;
                tab3Name = nil;
                
                if (appInboxInfo[@"label_one"] && ![appInboxInfo[@"label_one"] isEqual: [NSNull null]]) {
                    tab1Label = appInboxInfo[@"label_one"];
                }
                
                if (appInboxInfo[@"name_one"] && ![appInboxInfo[@"name_one"] isEqual: [NSNull null]]) {
                    tab1Name = appInboxInfo[@"name_one"];
                }
                
                if (appInboxInfo[@"label_two"] && ![appInboxInfo[@"label_two"] isEqual: [NSNull null]]) {
                    tab2Label = appInboxInfo[@"label_two"];
                }
                
                if (appInboxInfo[@"name_two"] && ![appInboxInfo[@"name_two"] isEqual: [NSNull null]]) {
                    tab2Name = appInboxInfo[@"name_two"];
                }
                
                if (appInboxInfo[@"label_three"] && ![appInboxInfo[@"label_three"] isEqual: [NSNull null]]) {
                    tab3Label = appInboxInfo[@"label_three"];
                }
                
                if (appInboxInfo[@"name_three"] && ![appInboxInfo[@"name_three"] isEqual: [NSNull null]]) {
                    tab3Name = appInboxInfo[@"name_three"];
                }
                
                NVCenterStyleConfig *nvConfig = [[NVCenterStyleConfig alloc] init];
                
                if (tab1Label != nil && [tab1Label length] > 0 && ![tab1Label isEqual: [NSNull null]]){
                    if(tab1Name!= nil && [tab1Name length] > 0 && ![tab1Name isEqual: [NSNull null]]){
                        [nvConfig setFirstTabWithTabLable: tab1Label TagDisplayName: tab1Name];
                    }
                }
                
                if (tab2Label != nil && [tab2Label length] > 0 && ![tab2Label isEqual: [NSNull null]]){
                    if(tab2Name!= nil && [tab2Name length] > 0 && ![tab2Name isEqual: [NSNull null]]){
                        [nvConfig setSecondTabWithTabLable: tab2Label TagDisplayName: tab2Name];
                    }
                }
                
                if (tab3Label != nil && [tab3Label length] > 0 && ![tab3Label isEqual: [NSNull null]]){
                    if(tab3Name!= nil && [tab3Name length] > 0 && ![tab3Name isEqual: [NSNull null]]){
                        [nvConfig setThirdTabWithTabLable: tab3Label TagDisplayName: tab3Name];
                    }
                }
                
                [notifyvisitors getNotificationCenterCountWithConfiguration: nvConfig countResult:^(NSDictionary * nvCenterCounts) {
                    [self sendTabCountResponse:nvCenterCounts responseToSend:result];
                }];
                
            } else{
                NSLog(@"%@ Empty JSON Object Going for Standard Tab count", TAG);
                [notifyvisitors getNotificationCenterCountWithConfiguration: Nil countResult:^(NSDictionary * nvCenterCounts) {
                    [self sendTabCountResponse:nvCenterCounts responseToSend:result];
                }];
                
            }
        }
        @catch(NSException *exception){
            NSLog(@"%@ TAB COUNT INFO ERROR : %@", TAG, exception.reason);
        }
        
    } @catch(NSException *exception){
        NSLog(@"%@ ERROR : %@", TAG, exception.reason);
    }
}

- (void) notificationCount:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSLog(@"%@ NOTIFICATION COUNT !!", TAG);
    @try{
        [notifyvisitors GetUnreadPushNotification:^(NSInteger nvUnreadPushCount) {
            NSString *jCount = nil;
            jCount = [@(nvUnreadPushCount) stringValue];
            result(jCount);
        }];
    }
    @catch(NSException *exception){
        NSLog(@"%@ NOTIFICATION COUNT ERROR : %@", TAG, exception.reason);
    }
}

- (void) notificationCenterInfo:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSLog(@"%@ NOTIFICATION-CENTER-DATA !!", TAG);
    @try{
        
        [notifyvisitors getNotificationCenterData:^(NSDictionary * _Nullable response) {
            if([response count] > 0){
                NSError *nvError = nil;
                NSData *nvJsonData = [NSJSONSerialization dataWithJSONObject: response options:NSJSONWritingPrettyPrinted error: &nvError];
                NSString *nvJsonString = [[NSString alloc] initWithData: nvJsonData encoding: NSUTF8StringEncoding];
                result(nvJsonString);
            }else{
                result(@"null");
            }
        }];
    }
    @catch(NSException *exception){
        NSLog(@"%@ NOTIFICATION-CENTER-INFO ERROR : %@", TAG, exception.reason);
    }
}

- (void) notificationCenterData:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSLog(@"%@ NOTIFICATION-CENTER-DATA !!", TAG);
    @try{
        [notifyvisitors GetNotificationCentreData:^(NSMutableArray * nvNotificationCenterData) {
            if([nvNotificationCenterData count] > 0){
                NSError *nvError = nil;
                NSData *nvJsonData = [NSJSONSerialization dataWithJSONObject: nvNotificationCenterData options:NSJSONWritingPrettyPrinted error: &nvError];
                NSString *nvJsonString = [[NSString alloc] initWithData: nvJsonData encoding: NSUTF8StringEncoding];
                result(nvJsonString);
            }else{
                result(@"null");
            }
        }];
    }
    @catch(NSException *exception){
        NSLog(@"%@ NOTIFICATION-CENTER-DATA ERROR : %@", TAG, exception.reason);
    }
    
}

- (void) getNotificationCenterDetails:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSLog(@"%@ GET-NOTIFICATION-CENTER-DETAILS !!", TAG);
    @try{
        [notifyvisitors getNotificationCenterData:^(NSDictionary * _Nullable response) {
            if([response count] > 0){
                NSError *nvError = nil;
                NSData *nvJsonData = [NSJSONSerialization dataWithJSONObject: response options:NSJSONWritingPrettyPrinted error: &nvError];
                NSString *nvJsonString = [[NSString alloc] initWithData: nvJsonData encoding: NSUTF8StringEncoding];
            [self.channel invokeMethod: @"NotificationCenterDataResponse" arguments: nvJsonString];
            }else{
                NSLog(@"%@ : GET-NOTIFICATION-CENTER-DETAILS CALLBACK CONTEXT IS NULL !!", TAG);
            }
        }];
    }
    @catch(NSException *exception){
        NSLog(@"%@ GET-NOTIFICATION-CENTER-DETAILS ERROR : %@", TAG, exception.reason);
    }
}

- (void) sendTabCountResponse : (NSDictionary *) nvCenterCounts responseToSend:(FlutterResult) result{
    NSError *nvError = nil;
    NSData *nvJsonData = nil;
    NSString *nvJsonString = nil;
    nvJsonData = [NSJSONSerialization dataWithJSONObject: nvCenterCounts options:NSJSONWritingPrettyPrinted error: &nvError];
    nvJsonString = [[NSString alloc] initWithData: nvJsonData encoding: NSUTF8StringEncoding];
    result(nvJsonString);
}

#pragma mark - Track Events method

- (void) event:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSLog(@"%@ EVENT !!", TAG);
    
    @try{
        eventCallback = result;
        NSMutableDictionary *jAttributes = [[NSMutableDictionary alloc] init];
        int nvScope = 0;
        
        NSString *eventName;
        @try{
            eventName = call.arguments[@"eventName"];
            if([eventName isEqual:[NSNull null]] || [eventName length] == 0){
                eventName = nil;
            }
        }
        @catch(NSException *exception){
            NSLog(@"%@ EVENT-NAME ERROR : %@", TAG, exception.reason);
        }
        
        NSDictionary *attributes = call.arguments[@"attributes"];
        if (![attributes isEqual:[NSNull null]]){
            jAttributes = [attributes mutableCopy];
        }else{
            jAttributes = nil;
        }
        
        
        NSString *lifeTimeValue = call.arguments[@"lifeTimeValue"];
        if([lifeTimeValue isEqual:[NSNull null]] || [lifeTimeValue length] == 0){
            lifeTimeValue = nil;
        }
        
        NSString *scope = call.arguments[@"scope"];
        if([scope isEqual:[NSNull null]] ){
            nvScope = 0;
        } else if([scope length] == 0){
            nvScope = 0;
        }else{
            nvScope = [scope intValue];
        }
        
        @try{
            NSLog(@"Event Name : %@", eventName);
            NSLog(@"Attributes : %@", jAttributes);
            NSLog(@"Life Time Value : %@", lifeTimeValue);
            NSLog(@"Scope : %@", scope);
        } @catch(NSException *exception){
            NSLog(@"%@ PARAMETERS ERROR : %@", TAG, exception.reason);
        }
        
        [notifyvisitors trackEvents:eventName Attributes:jAttributes lifetimeValue:lifeTimeValue Scope:nvScope];
    }
    @catch(NSException *exception){
        NSLog(@"%@ EVENT ERROR : %@", TAG, exception.reason);
    }
}

- (void) trackScreen:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSLog(@"%@ TRACK-SCREEN !!", TAG);
    @try{
        NSString *nvFlutterCustomScreenName = nil;
        @try{
            nvFlutterCustomScreenName = call.arguments[@"screenName"];
            if([nvFlutterCustomScreenName isEqual:[NSNull null]] || [nvFlutterCustomScreenName length] == 0){
                nvFlutterCustomScreenName = nil;
            }
        }
        @catch(NSException *exception){
            NSLog(@"%@ CUSTOM-SCREEN-NAME ERROR : %@", TAG, exception.reason);
        }
        
        if ([nvFlutterCustomScreenName length] > 0 && ![nvFlutterCustomScreenName isEqualToString: @""] && ![nvFlutterCustomScreenName isEqual: [NSNull null]]) {
            [notifyvisitors trackScreen: nvFlutterCustomScreenName];
        } else {
            NSLog(@"%@ TRACK-SCREEN ERROR : Required parameter missing Screen Name can not be null / empty string", TAG);
        }
    }
    @catch(NSException *exception){
        NSLog(@"%@ TRACK-SCREEN ERROR : %@", TAG, exception.reason);
    }
}

#pragma mark - Push Notifications related methods

- (void) scheduleNotification:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSLog(@"%@ SCHEDULE-NOTIFICATION !!", TAG);
    
    @try{
        NSString * nId;
        @try{
            nId = call.arguments[@"nid"];
            if([nId isEqual:[NSNull null]] || [nId length] == 0){
                nId = nil;
            }
        }
        @catch(NSException *exception){
            NSLog(@"NID ERROR : %@", exception.reason);
        }
        
        NSString * tag;
        @try{
            tag = call.arguments[@"tag"];
            if([tag isEqual:[NSNull null]] || [tag length] == 0){
                tag = nil;
            }
        }
        @catch(NSException *exception){
            NSLog(@"TAG ERROR : %@", exception.reason);
        }
        
        NSString * time;
        @try{
            time = call.arguments[@"time"];
            if([time isEqual:[NSNull null]] || [time length] == 0){
                time = nil;
            }
        }
        @catch(NSException *exception){
            NSLog(@"TIME ERROR : %@", exception.reason);
        }
        
        NSString * title;
        @try{
            title = call.arguments[@"title"];
            if([title isEqual:[NSNull null]] || [title length] == 0){
                title = nil;
            }
        }
        @catch(NSException *exception){
            NSLog(@"TITLE ERROR : %@", exception.reason);
        }
        
        NSString * message;
        @try{
            message = call.arguments[@"msg"];
            if([message isEqual:[NSNull null]] || [message length] == 0){
                message = nil;
            }
        }
        @catch(NSException *exception){
            NSLog(@"MSG ERROR : %@", exception.reason);
        }
        
        NSString * url;
        @try{
            url = call.arguments[@"url"];
            if([url isEqual:[NSNull null]] || [url length] == 0){
                url = nil;
            }
        }
        @catch(NSException *exception){
            NSLog(@"URL ERROR : %@", exception.reason);
        }
        
        NSString * icon;
        @try{
            icon = call.arguments[@"icon"];
            if([icon isEqual:[NSNull null]] || [icon length] == 0){
                icon = nil;
            }
        }
        @catch(NSException *exception){
            NSLog(@"ICON ERROR : %@", exception.reason);
        }
        
        [notifyvisitors schedulePushNotificationwithNotificationID:nId Tag:tag TimeinSecond:time Title:title Message:message URL:url Icon:icon];
        
    }
    @catch(NSException *exception){
        NSLog(@"%@ SCHEDULE-NOTIFICATION ERROR : %@", TAG, exception.reason);
    }
}

- (void) stopPushNotification:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSLog(@"%@ STOP-PUSH-NOTIFICTION !!", TAG);
    @try{
        //BOOL value = call.arguments[@"value"];
        //[notifyvisitors stopPushNotification:value];
    }
    @catch(NSException *exception){
        NSLog(@"%@ STOP-PUSH-NOTIFICTION ERROR : %@", TAG, exception.reason);
    }
}

- (void) stopGeofence:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSLog(@"%@ STOP-GEOFENCE !!", TAG);
    @try{
        NSInteger nvAdditionalHours = 0;
        
        NSString * nvDateTime;
        @try{
            nvDateTime = call.arguments[@"dateTime"];
            if ([nvDateTime isEqual:[NSNull null]] || [nvDateTime length] == 0){
                nvDateTime = nil;
            }
            
        }
        @catch(NSException *exception){
            NSLog(@"DATE TIME ERROR : %@", exception.reason);
        }
        
        NSString * additionalHours;
        @try{
            additionalHours = call.arguments[@"additionalHours"];;
            if ([additionalHours isEqual:[NSNull null]] || [additionalHours length] == 0){
                nvAdditionalHours = 0;
            }else{
                nvAdditionalHours  = [additionalHours intValue];
            }
        }
        @catch(NSException *exception){
            NSLog(@"ADDITIONAL HOURS ERROR : %@", exception.reason);
        }
        
        NSLog(@"%@ CALL NATIVE FUNCTION !!", TAG);
        [notifyvisitors stopGeofencePushforDateTime: nvDateTime additionalHours: nvAdditionalHours];
    }
    @catch(NSException *exception){
        NSLog(@"%@ STOP-GEOFENCE ERROR : %@", TAG, exception.reason);
    }
}

- (void) subscribePushCategory:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSLog(@"%@ SUBSCRIBE PUSH CATEGORY  !!", TAG);
    NSArray *categoryArray;
    bool unsubscribeSignal = false;
    NSMutableDictionary * temp;
    @try{
        temp = call.arguments[@"categoryArray"];
        if (![temp isEqual:[NSNull null]]){
            categoryArray = [[NSArray alloc] init];
            categoryArray = [temp mutableCopy];
            
            @try{
                unsubscribeSignal = [call.arguments[@"unsubscribeSignal"] boolValue];
            }@catch(NSException *exception){
                NSLog(@" ERROR : %@", exception.reason);
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [notifyvisitors pushPreferences: categoryArray isUnsubscribeFromAll: unsubscribeSignal ? YES : NO];
            });
        }
    }@catch(NSException *exception){
        NSLog(@"%@ ERROR : %@", TAG, exception.reason);
    }
}

- (void) getRegistrationToken:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSLog(@"%@ GET REGISTRATION TOKEN  !!", TAG);
    @try{
        NSString *nvPushToken = [notifyvisitors getPushRegistrationToken];
        if([nvPushToken length] > 0){
            result(nvPushToken);
        }else{
            result(@"null");
        }
    }@catch(NSException *exception){
        NSLog(@"%@ ERROR : %@", TAG, exception.reason);
    }
}

#pragma mark - Track User Methods

- (void) userIdentifier:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSLog(@"%@ USER-IDENTIFIER !!", TAG);
    @try{
        NSMutableDictionary *mUserParams = [[NSMutableDictionary alloc] init];
        
        NSString *userId;
        @try{
            userId = call.arguments[@"userId"];
            if([userId isEqual:[NSNull null]] || [userId length] == 0){
                userId = nil;
            }
        }
        @catch(NSException *exception){
            NSLog(@"USER-ID ERROR : %@", exception.reason);
        }
        
        NSDictionary *attributes;
        @try{
            attributes = call.arguments[@"attributes"];
            if (![attributes isEqual:[NSNull null]]){
                mUserParams = [attributes mutableCopy];
            } else{
                mUserParams = nil;
            }
        }
        @catch(NSException *exception){
            NSLog(@"ATTRIBUTES ERROR : %@", exception.reason);
        }
        
        NSLog(@"%@ CALL NATIVE FUNCTION !!", TAG);
        [notifyvisitors UserIdentifier: userId UserParams: mUserParams];
    }
    @catch(NSException *exception){
        NSLog(@"%@ USER-IDENTIFIER ERROR : %@", TAG, exception.reason);
    }
}

- (void) setUserIdentifier:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSLog(@"%@ SET USER IDENTIFIER !!", TAG);
    @try {
        NSDictionary *nvUserParamsDict = nil;
        @try{
            nvUserParamsDict = call.arguments[@"attributes"];
        }
        @catch(NSException *exception){
            NSLog(@"ATTRIBUTES ERROR : %@", exception.reason);
        }
        
        NSLog(@"%@ CALL NATIVE setUserIdentifier() FUNCTION !!", TAG);
        
        if ([nvUserParamsDict count] > 0) {
            [notifyvisitors userIdentifierWithUserParams: nvUserParamsDict onUserTrackListener:^(NSDictionary *onUserTrackResponseDict) {
                if ([onUserTrackResponseDict count] > 0) {
                    NSError *nvError = nil;
                    NSData *nvJsonData = [NSJSONSerialization dataWithJSONObject: onUserTrackResponseDict options: NSJSONWritingPrettyPrinted error: &nvError];
                    NSString *nvJsonString = [[NSString alloc] initWithData: nvJsonData encoding: NSUTF8StringEncoding];
                    result(nvJsonString);
                }
            }];
        } else {
            [notifyvisitors userIdentifierWithUserParams: nil onUserTrackListener:^(NSDictionary *onUserTrackResponseDict) {
                if ([onUserTrackResponseDict count] > 0) {
                    NSError *nvError = nil;
                    NSData *nvJsonData = [NSJSONSerialization dataWithJSONObject: onUserTrackResponseDict options: NSJSONWritingPrettyPrinted error: &nvError];
                    NSString *nvJsonString = [[NSString alloc] initWithData: nvJsonData encoding: NSUTF8StringEncoding];
                    result(nvJsonString);
                }
            }];
        }
    }
    @catch(NSException *exception){
        NSLog(@"%@ SET USER IDENTIFIER ERROR : %@", TAG, exception.reason);
    }
}

- (void) getNvUid:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSLog(@"%@ GET NV-UID  !!", TAG);
    @try {
        NSString * nvUIDStr = [notifyvisitors getNvUid];
        if ([nvUIDStr length] > 0 && ![nvUIDStr isEqualToString: @""] && ![nvUIDStr isEqual: [NSNull null]] && ![nvUIDStr isEqualToString: @"(null)"]) {
            result(nvUIDStr);
            } else {
                result(@"null");
            }
    }
    @catch(NSException *exception){
        NSLog(@"%@ GET NV-UID ERROR : %@", TAG, exception.reason);
    }
}

- (void) knownUserIdentified:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSLog(@"%@ GET KNOWN USER IDENTIFIED INFO !!", TAG);
    @try{
        onKnownUserFoundCallback = result;
    }
    @catch(NSException *exception){
        NSLog(@"%@ ERROR : %@", TAG, exception.reason);
    }
}

#pragma mark - ChatBot Methods

- (void) startChatBot:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSLog(@"%@ START CHAT BOT !!", TAG);
    @try{
      //  NSString *screenName = call.arguments[@"screenName"];
        // [notifyvisitors startChatBotWithScreenName: screenName];
    }
    @catch(NSException *exception){
        NSLog(@"%@ START CHAT-BOT ERROR : %@", TAG, exception.reason);
    }
}

- (void)NotifyvisitorsChatBotActionCallbackWithUserInfo:(NSDictionary *)userInfo {
    NSLog(@"%@ CHAT-BOT ACTION CALLBACK !!", TAG);
    @try {
        if ([userInfo count] > 0) {
            NSError *nvError = nil;
            NSData *nvJsonData = [NSJSONSerialization dataWithJSONObject: userInfo options: NSJSONWritingPrettyPrinted error: &nvError];
            NSString *nvJsonString = [[NSString alloc] initWithData: nvJsonData encoding: NSUTF8StringEncoding];
            [self.channel invokeMethod:@"ChatBotResponse" arguments:nvJsonString];
        }else{
            NSLog(@"%@ CHAT-BOT DATA IS NULL  !!", TAG);
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@ CHAT-BOT ACTION CALLBACK ERROR : %@", TAG, exception.reason);
    }
    
}


#pragma mark - GetLinkInfo and other callbacks handler methods

- (void) getLinkInfo:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSLog(@"%@ GET LINK INFO !!", TAG);
    @try{
        nvPushObserverReady = YES;
        [[NSNotificationCenter defaultCenter] addObserverForName: @"nvNotificationClickCallback" object:nil queue:nil usingBlock:^(NSNotification *notification) {
            NSDictionary *nvUserInfo = [notification userInfo];
            if ([nvUserInfo count] > 0) {
                NSError * err;
                NSData * jsonData = [NSJSONSerialization dataWithJSONObject:nvUserInfo options:0 error:&err];
                NSString * myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                [self.channel invokeMethod:@"GetLinkInfo" arguments:myString];
            }else{
                NSLog(@"%@ NOTIFICATION DATA IS NULL  !!", TAG);
            }
        }];
    }
    @catch(NSException *exception){
        NSLog(@"%@ ERROR : %@", TAG, exception.reason);
    }
}

-(void)notifyvisitorsEventsResponseCallback:(NSDictionary *)callback {
    NSLog(@"%@ GET EVENT RESPONSE WITH USER INFO  !!", TAG);
    @try {
        if([callback count] > 0) {
            NSError *nvError = nil;
            NSData *nvJsonData = [NSJSONSerialization dataWithJSONObject: callback options: NSJSONWritingPrettyPrinted error: &nvError];
            NSString *nvJsonString = [[NSString alloc] initWithData: nvJsonData encoding: NSUTF8StringEncoding];
            
            NSString * eventName = nil;
            if (callback[@"eventName"]) {
                eventName = callback[@"eventName"];
            }
            // clicked is event or survey
        if([eventName isEqualToString: @"Survey Submit"] || [eventName isEqualToString: @"Survey Attempt"] || [eventName isEqualToString: @"Banner Clicked"] || [eventName isEqualToString: @"Banner Impression"]) {
                if(showCallback != NULL){
                    [self.channel invokeMethod:@"ShowResponse" arguments:nvJsonString];
                } else{
                    NSLog(@"%@ SHOW CALLBACK CONTEXT IS NULL !!", TAG);
                }
            }else{
                if(eventCallback != NULL){
                    [self.channel invokeMethod:@"EventResponse" arguments:nvJsonString];
                }  else{
                    NSLog(@"%@ EVENT CALLBACK CONTEXT IS NULL  !!", TAG);
                }
            }
            
            if(commonCallback != NULL) {
                [self.channel invokeMethod:@"EventSurveyCallback" arguments:nvJsonString];
            }  else{
                NSLog(@"%@ EVENT-SURVEY CALLBACK CONTEXT IS NULL !!", TAG);
            }
            
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@ GET EVENT RESPONSE WITH USER INFO ERROR : %@", TAG, exception.reason);
    }
}

- (void)notifyvisitorsKnownUserIdentified:(NSDictionary *)userInfo {
    NSLog(@"%@ GET DATA WHEN KNOWN USER IDENTIFIED !!", TAG);
    @try {
        if([userInfo count] > 0) {
            NSError *nvError = nil;
            NSData *nvJsonData = [NSJSONSerialization dataWithJSONObject: userInfo options: NSJSONWritingPrettyPrinted error: &nvError];
            NSString *nvJsonString = [[NSString alloc] initWithData: nvJsonData encoding: NSUTF8StringEncoding];
                if(onKnownUserFoundCallback != NULL){
                    [self.channel invokeMethod: @"KnownUserIdentified" arguments: nvJsonString];
                }  else{
                    NSLog(@"%@ GET KNOWN USER IDENTIFIED DATA CALLBACK CONTEXT IS NULL  !!", TAG);
                }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@ GET DATA WHEN KNOWN USER IDENTIFIED ERROR : %@", TAG, exception.reason);
    }
}

- (void)setNvDeepLinkObserver {
    @try{
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"nvDeepLinkData" object: nil];
        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(sendLinkInfo:) name: @"nvDeepLinkData" object: nil];
    }@catch (NSException *exception) {
        NSLog(@"%@ SEND-LINK-INFO ERROR : %@", TAG, exception.reason);
    }
}

- (void) notificationClickCallback:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSLog(@"%@ NOTIFICATION CLICK CALLBACK !!", TAG);
    @try{
        nvPushObserverReady = YES;
        [[NSNotificationCenter defaultCenter] addObserverForName: @"nvNotificationClickCallback" object:nil queue:nil usingBlock:^(NSNotification *notification) {
            NSDictionary *nvUserInfo = [notification userInfo];
            if ([nvUserInfo count] > 0) {
                NSError * err;
                NSData * jsonData = [NSJSONSerialization dataWithJSONObject:nvUserInfo options:0 error:&err];
                NSString * myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                [self.channel invokeMethod:@"NotificationClickCallback" arguments: myString];
            }else{
                NSLog(@"%@ NOTIFICATION DATA IS NULL  !!", TAG);
            }
        }];
    }
    @catch(NSException *exception){
        NSLog(@"%@ NOTIFICATION CLICK CALLBACK ERROR : %@", TAG, exception.reason);
    }
}


#pragma mark - Other Methods

- (void) requestInAppReview:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSLog(@"%@ REQUEST IN APP REVIEW  !!", TAG);
    @try{
        [notifyvisitors requestAppleAppStoreInAppReview];
    }@catch(NSException *exception){
        NSLog(@"%@ ERROR : %@", TAG, exception.reason);
    }
}

- (void) getSessionData:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSLog(@"%@ GET SESSION DATA  !!", TAG);
    @try {
        NSString *nvFinalSessionJSONStr = @"";
        NSDictionary *nvSessionDataDict = [notifyvisitors getSessionData];
        if ([nvSessionDataDict count] > 0) {
            NSError *nvError = nil;
            NSData *nvJsonData = [NSJSONSerialization dataWithJSONObject: nvSessionDataDict options: NSJSONWritingPrettyPrinted error: &nvError];
            NSString *nvJsonString = [[NSString alloc] initWithData: nvJsonData encoding: NSUTF8StringEncoding];
            if ([nvJsonString length] > 0 && ![nvJsonString isEqualToString: @""] && ![nvJsonString isEqual: [NSNull null]]) {
                nvFinalSessionJSONStr = nvJsonString;
            }
            
        }
        result(nvFinalSessionJSONStr);
    }
    @catch(NSException *exception){
        NSLog(@"%@ GET SESSION DATA ERROR : %@", TAG, exception.reason);
    }
}



-(UIColor*)GetColor:(NSString *)ColorString {
    if ([[ColorString substringToIndex:1]isEqualToString:@"#"]) {
        unsigned int c;
        if ([ColorString characterAtIndex:0] == '#') {
            [[NSScanner scannerWithString:[ColorString substringFromIndex:1]] scanHexInt:&c];
        } else {
            [[NSScanner scannerWithString:ColorString] scanHexInt:&c];
        }
        return [UIColor colorWithRed:((c & 0xff0000) >> 16)/255.0 green:((c & 0xff00) >> 8)/255.0 blue:(c & 0xff)/255.0 alpha:1.0];
    } else {
        NSString *sep = @"()";
        NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:sep];
        NSString *rgba = [ColorString componentsSeparatedByCharactersInSet:set][1];
        CGFloat R = [[rgba componentsSeparatedByString:@","][0] floatValue];
        CGFloat G = [[rgba componentsSeparatedByString:@","][1] floatValue];
        CGFloat B = [[rgba componentsSeparatedByString:@","][2] floatValue];
        CGFloat alpha = [[rgba componentsSeparatedByString:@","][3] floatValue];
        UIColor *ResultColor = [UIColor colorWithRed:R/255 green:G/255 blue:B/255 alpha:alpha];
        return ResultColor;
    }
}

#pragma mark - AppDelegate Integration Methods (INITIALIZE Notifyvisitors SDK and Basic Integration Methods)

// SDK initialization

+ (void)initializeWithBrandId:(NSInteger)brandID secretKey:(NSString *)secretKey launchingOptions:(NSDictionary *)launchingOptions {
    
NSLog(@"%@ INITIALIZE WITH BRANDID SECRETKEY & LAUNCHING-OPTIONS !!", TAG);
    [[self sharedInstance] nvTurnOffAutomaticScreenViewEventForFlutter];
            NSString *nvMode = nil;
        #if DEBUG
            nvMode = @"debug";
        #else
            nvMode = @"live";
        #endif
            [notifyvisitors initializeWithBrandId: brandID secretKey: secretKey appMode: nvMode launchingOptions: launchingOptions];
    }

+(void)nvInitialize {
    NSLog(@"%@ INITIALIZE !!", TAG);
    [[self sharedInstance] nvTurnOffAutomaticScreenViewEventForFlutter];
    NSString *nvMode = nil;
#if DEBUG
    nvMode = @"debug";
#else
    nvMode = @"live";
#endif
    [notifyvisitors Initialize:nvMode];
    
}

//Applecation State Handler functions

+(void)applicationDidEnterBackground:(UIApplication *)application{
    @try{
        NSLog(@"%@ APPLICATION DID ENTER BACKGROUND !!", TAG);
        [notifyvisitors applicationDidEnterBackground: application];
        
    }@catch(NSException *exception){
        NSLog(@"%@ ERROR : %@", TAG, exception.reason);
    }
}

+ (void)sceneDidEnterBackground:(UIScene *)scene {
    @try{
        NSLog(@"%@ SCENE DID ENTER BACKGROUND !!", TAG);
        [notifyvisitors sceneDidEnterBackground:scene];
        
    }@catch(NSException *exception){
        NSLog(@"%@ ERROR : %@", TAG, exception.reason);
    }
}

+ (void)applicationWillEnterForeground:(UIApplication *)application {
    @try{
        NSLog(@"%@ APPLICATION WILL ENTER FOREGROUND !!", TAG);
        [notifyvisitors applicationWillEnterForeground: application];
    }@catch(NSException *exception){
        NSLog(@"%@ ERROR : %@", TAG, exception.reason);
    }
}

+ (void)sceneWillEnterForeground:(UIScene *)scene {
    @try{
        NSLog(@"%@ SCENE WILL ENTER FOREGROUND !!", TAG);
        [notifyvisitors sceneWillEnterForeground: scene];
    }@catch(NSException *exception){
        NSLog(@"%@ ERROR : %@", TAG, exception.reason);
    }
}


+(void)applicationDidBecomeActive:(UIApplication *)application {
    @try{
        NSLog(@"%@ APPLICATION DID BECOME ACTIVE !!", TAG);
        [notifyvisitors applicationDidBecomeActive: application];
    }@catch(NSException *exception){
        NSLog(@"%@ ERROR : %@", TAG, exception.reason);
    }
    
}

+ (void)sceneDidBecomeActive:(UIScene *)scene {
    @try{
        NSLog(@"%@ SCENE DID BECOME ACTIVE !!", TAG);
        [notifyvisitors sceneDidBecomeActive: scene];
    }@catch(NSException *exception){
        NSLog(@"%@ ERROR : %@", TAG, exception.reason);
    }
    
}

+(void)applicationWillTerminate{
    @try{
        NSLog(@"%@ APPLICATION WILL TERMINATE !!", TAG);
        [notifyvisitors applicationWillTerminate];
    }
    @catch(NSException *exception){
        NSLog(@"%@ ERROR : %@", TAG, exception.reason);
    }
    
}

//Deeplink Handler function

+(void)openUrl:(UIApplication *_Nullable)application openURL:(NSURL*)url{
    NSLog(@"%@ OPEN URL !!", TAG);
    @try{
        [notifyvisitors OpenUrlWithApplication:application Url:url];
    }
    @catch(NSException *exception){
        NSLog(@"%@ ERROR : %@", TAG, exception.reason);
    }
}

+ (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    @try{
        NSLog(@"%@ SCENE WILL CONNECT TO SESSION !!", TAG);
        [notifyvisitors scene: scene willConnectToSession: session options: connectionOptions];
    }@catch(NSException *exception){
        NSLog(@"%@ ERROR : %@", TAG, exception.reason);
    }
    
}

+ (void)scene:(UIScene *)scene openURLContexts:(NSSet<UIOpenURLContext *> *)URLContexts {
    @try{
        NSLog(@"%@ SCENE OPEN URL CONTEXTS !!", TAG);
        [notifyvisitors scene: scene openURLContexts: URLContexts];
        
    }@catch(NSException *exception){
        NSLog(@"%@ ERROR : %@", TAG, exception.reason);
    }
    
}

//Universal link Handler functions

+(void)continueUserActivityWith:(NSUserActivity *)userActivity {
    @try{
        NSLog(@"%@ CONTINUE USER ACTIVITY !!", TAG);
        [notifyvisitors continueUserActivityWith: userActivity];
    }@catch(NSException *exception){
        NSLog(@"%@ ERROR : %@", TAG, exception.reason);
    }
    
}

+(void)scene:(UIScene *)scene continueUserActivity:(NSUserActivity *)userActivity {
    @try{
        NSLog(@"%@ SCENE CONTINUE USER ACTIVITY !!", TAG);
        [notifyvisitors scene: scene continueUserActivity: userActivity];
    }@catch(NSException *exception){
        NSLog(@"%@ ERROR : %@", TAG, exception.reason);
    }
}

// Push notification registration

+(void)registerPushWithDelegate:(id _Nullable)delegate App:(UIApplication * _Nullable)application launchOptions:(NSDictionary *_Nullable)launchOptions {
    NSLog(@"%@ REGISTER PUSH WITH DELEGATE !!", TAG);
    @try{
        [notifyvisitors RegisterPushWithDelegate: delegate App: application launchOptions: launchOptions];
    } @catch(NSException *exception){
        NSLog(@"%@ ERROR : %@", TAG, exception.reason);
    }
}

+(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken  {
    NSLog(@"%@ DID REGISTER FOR REMOTE NOTIFICATIONS WITH DEVICE TOKEN !!", TAG);
    @try{
        [notifyvisitors DidRegisteredNotification: application deviceToken: deviceToken];
    }
    @catch(NSException *exception){
        NSLog(@"%@ ERROR : %@", TAG, exception.reason);
    }
    
}


+(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    @try{
        NSLog(@"%@ DID FAIL TO REGISTER FOR REMOTE NOTIFICATIONS WITH ERROR = %@", TAG, error.localizedDescription);
    }
    @catch(NSException *exception){
        NSLog(@"%@ ERROR : %@", TAG, exception.reason);
    }
    
}

// Push Notifications Click Handler functions

+(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    @try{
        NSLog(@"%@ DID RECEIVE REMOTE NOTIFICATION !!", TAG);
    [notifyvisitors didReceiveRemoteNotificationWithUserInfo: userInfo];
    }
    @catch(NSException *exception){
        NSLog(@"%@ ERROR : %@", TAG, exception.reason);
    }
}

+(void)willPresentNotification:(UNNotification *_Nullable)notification withCompletionHandler:(void (^_Nullable)(UNNotificationPresentationOptions options))completionHandler  API_AVAILABLE(ios(10.0)){
    NSLog(@"%@ WILL PRESENT NOTIFICATION !!", TAG);
    @try{
        [notifyvisitors willPresentNotification: notification withCompletionHandler: completionHandler];
    }
    @catch(NSException *exception){
        NSLog(@"%@ ERROR : %@", TAG, exception.reason);
    }
}

+(void)didReceiveNotificationResponse:(UNNotificationResponse *_Nullable)response  API_AVAILABLE(ios(10.0)){
    NSLog(@"%@ DID RECEIVE NOTIFICATION RESPONSE !!", TAG);
    @try{
        //  NSLog(@"didReceiveNotificationResponse triggered with nvPushObserverReady value = %@", nvPushObserverReady ? @"YES" : @"NO");
        if(!nvPushObserverReady) {
            [self nvPushClickCheckInSeconds: 1 withBlock: ^(nvPushClickCheckRepeatHandler completionHandler) {
                [notifyvisitors didReceiveNotificationResponse: response];
            }];
        } else {
            [notifyvisitors didReceiveNotificationResponse: response];
        }
        
    }
    @catch(NSException *exception){
        NSLog(@"%@ ERROR : %@", TAG, exception.reason);
        
    }
}

+(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"%@ DID RECEIVE REMOTE NOTIFICATION !!", TAG);
    @try{
        [notifyvisitors didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
    }
    @catch(NSException *exception){
        NSLog(@"%@ ERROR : %@", TAG, exception.reason);
    }
    
}

+(void)nvPushClickCheckInSeconds:(int)seconds withBlock: (nvPushClickCheckRepeatBlock) nvPushCheckBlock {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, seconds * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        nvCheckPushClickTimeCounter = nvCheckPushClickTimeCounter + seconds;
        if(!nvPushObserverReady) {
            if (nvCheckPushClickTimeCounter < 20) {
                return [self nvPushClickCheckInSeconds: seconds withBlock: nvPushCheckBlock];
                //[self irDispatchReatforTrackingDataInSeconds: seconds withBlock: irBlock];
            } else {
                //irTempTrackResponse = @{@"Authentication" : @"failed",@"http_code": @"408"};
                nvPushCheckBlock(^(BOOL isRepeat) {
                    if (isRepeat) {
                        if (nvCheckPushClickTimeCounter < 20) {
                            return [self nvPushClickCheckInSeconds: seconds withBlock: nvPushCheckBlock];
                        }
                    }
                });
            }
        } else {
            nvPushCheckBlock(^(BOOL isRepeat) {
                if (isRepeat) {
                    if (nvCheckPushClickTimeCounter < 20) {
                        return [self nvPushClickCheckInSeconds: seconds withBlock: nvPushCheckBlock];
                    }
                }
            });
        }
    });
}


-(void)nvTurnOffAutomaticScreenViewEventForFlutter {
    NSUserDefaults *nvflutterCustomUserDefaults = [[NSUserDefaults alloc] initWithSuiteName: @"com.cp.plugin.notifyvisitors"];
    [nvflutterCustomUserDefaults setBool: YES forKey: @"nv_isSDKRunningInCP"];
    [nvflutterCustomUserDefaults synchronize];
}
@end
