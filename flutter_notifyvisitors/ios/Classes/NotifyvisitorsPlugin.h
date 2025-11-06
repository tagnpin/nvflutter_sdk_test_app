#import <Flutter/Flutter.h>
#import <notifyvisitors/notifyvisitors.h>
#if __has_include(<UserNotifications/UserNotifications.h>)
#import <UserNotifications/UserNotifications.h>
#else
#import "UserNotifications.h"
#endif
#define TAG @"[FLUTTER-NOTIFYVISITORS]:"
#define PLUGIN_VERSION @"1.4.0"
#define SHOW @"show"
#define SHOW_INAPP_MESSAGE @"showInAppMessage"
#define NOTIFICATION_CENTER @"showNotifications"
#define OPEN_NOTIFICATION_CENTER @"openNotificationCenter"
#define EVENT @"event"
#define STOP_SHOW_INAPP @"stopNotifications"
#define STOP_PUSH @"stopPushNotifications"
#define GET_NOTIFICATION_DATA @"notificationDataListener"
#define NOTIFICATION_CENTER_DATA @"notificationCenterData"
#define GET_NOTIFICATION_CENTER_DETAILS @"getNotificationCenterDetails"
#define NOTIFICATION_COUNT @"notificationCount"
#define SCHEDULE_NOTIFICATION @"scheduleNotification"
#define HIT_USER @"userIdentifier"
#define SET_USER_IDENTIFIER @"setUserIdentifier"
#define STOP_GEOFENCE @"stopGeofencePushforDateTime"
#define PUSH_CLICK @"getLinkInfo"
#define SCROLL_VIEW_DID_SCROLL @"scrollViewDidScroll_IOS"
#define CHAT_BOT @"startChatBot"
#define NV_UID @"getNvUID"
#define EVENT_SURVEY_INFO @"getEventSurveyInfo"
#define NV_SUBSCRIBE_CATEGORY @"subscribePushCategory"
#define NV_NOTIFICATION_CENTER_COUNT @"notificationCenterCount"
#define NV_REQUEST_IN_APP @"requestInAppReview"
#define NV_REGISTRATION_TOKEN @"registrationToken"
#define KNOWN_USER_IDENTIFIED @"knownUserIdentified"
#define TRACK_SCREEN @"trackScreen"
#define GET_SESSION_DATA @"getSessionData"
#define NOTIFICATION_CLICK_CALLBACK @"notificationClickCallback"

#define ANDROID_AUTO_START @"autoStartPermission"
#define ANDROID_CREATE_NOTIFICATION_CHANNEL @"createNotificationChannel"
#define ANDROID_DELETE_NOTIFICATION_CHANNEL @"deleteNotificationChannel"
#define ANDROID_CREATE_NOTIFICATION_CHANNEL_GROUP @"createNotificationChannelGroup"
#define ANDROID_DELETE_NOTIFICATION_CHANNEL_GROUP @"deleteNotificationChannelGroup"
#define ANDROID_PUSH_PERMISSION_PROMPT @"pushPermissionPrompt"
#define ANDROID_ENABLE_PUSH_PERMISSION @"enablePushPermission"
#define ANDROID_NATIVE_PUSH_PERMISSION_PROMPT @"nativePushPermissionPrompt"
#define ANDROID_IS_PAYLOAD_FROM_NV_PLATFORM @"isPayloadFromNvPlatform"
#define ANDROID_GET_NV_FCM_PAYLOAD @"getNV_FCMPayload"


@interface NotifyvisitorsPlugin : NSObject<FlutterPlugin, notifyvisitorsDelegate, UNUserNotificationCenterDelegate>{
    NSMutableArray *_handlers;
    FlutterResult _lastEvent;
}

@property (strong, nonatomic) FlutterMethodChannel * _Nullable channel;

+ (instancetype _Nullable )sharedInstance;


// SDK initialization

+(void)nvInitialize;

+(void)initializeWithBrandId:(NSInteger)brandID secretKey:(NSString *_Nullable)secretKey launchingOptions:(NSDictionary *_Nullable)launchingOptions;


//App State Handler function

+(void)applicationDidEnterBackground:(UIApplication *_Nullable)application;
+(void)sceneDidEnterBackground:(UIScene *_Nullable)scene API_AVAILABLE(ios(13.0));

+(void)applicationWillEnterForeground:(UIApplication *_Nullable)application;
+(void)sceneWillEnterForeground:(UIScene *_Nullable)scene API_AVAILABLE(ios(13.0));

+(void)applicationDidBecomeActive:(UIApplication *_Nullable)application;
+(void)sceneDidBecomeActive:(UIScene *_Nullable)scene API_AVAILABLE(ios(13.0));

+(void)applicationWillTerminate;

//Deeplink Handler function

+(void)openUrl:(UIApplication *_Nullable)application openURL:(NSURL *_Nullable)url;
+(void)scene:(UIScene *_Nullable)scene willConnectToSession:(UISceneSession *_Nullable)session options:(UISceneConnectionOptions *_Nullable)connectionOptions API_AVAILABLE(ios(13.0));
+(void)scene:(UIScene *_Nullable)scene openURLContexts:(NSSet<UIOpenURLContext *> *_Nullable)URLContexts API_AVAILABLE(ios(13.0));

//Universal link Handler functions

+(void)continueUserActivityWith:(NSUserActivity*_Nullable)userActivity;
+(void)scene:(UIScene *_Nullable)scene continueUserActivity:(NSUserActivity *_Nullable)userActivity API_AVAILABLE(ios(13.0));

// Push notification registration

+(void)registerPushWithDelegate:(id _Nullable)delegate App:(UIApplication * _Nullable)application launchOptions:(NSDictionary *_Nullable)launchOptions;

+(void)application:(UIApplication *_Nullable)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *_Nullable)deviceToken;

+(void)application:(UIApplication *_Nullable)application didFailToRegisterForRemoteNotificationsWithError:(NSError *_Nullable)error;
    

// Push Notifications Click Handler functions

+(void)application:(UIApplication *_Nullable)application didReceiveRemoteNotification:(NSDictionary *_Nullable)userInfo;

+(void)willPresentNotification:(UNNotification *_Nullable)notification withCompletionHandler:(void (^_Nullable)(UNNotificationPresentationOptions options))completionHandler API_AVAILABLE(ios(10.0));

+(void)didReceiveNotificationResponse:(UNNotificationResponse *_Nullable)response API_AVAILABLE(ios(10.0));

+(void)application:(UIApplication *_Nullable)application didReceiveRemoteNotification:(NSDictionary *_Nullable)userInfo
fetchCompletionHandler:(void (^_Nullable)(UIBackgroundFetchResult))completionHandler;

@end
