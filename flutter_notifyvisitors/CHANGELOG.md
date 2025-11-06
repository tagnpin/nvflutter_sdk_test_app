## CHANGE LOG

### Version 1.4.0 *(July 25, 2025)*
-------------------------------------------
- Android Updates:
  - ANR related bug resolved.
  - Android 35 updates.
  - New Native Display template introduced in nudge section.
- iOS Updates:
  - New Native Display template introduced in nudge section.
- getSessionData() function implimented.
- Minor bug fixes
- Code optimisation and performance enhancement.

### Version 1.3.4 *(June 18, 2025)*
-------------------------------------------
- Minor bug fixes
- Code optimisation and performance enhancement.

### Version 1.3.3 *(June 16, 2025)*
-------------------------------------------
- Android Updates:
  - ANR related cache resolved.
  - Crash related to receiver resolved.
- Minor bug fixes
- Code optimisation and performance enhancement.

### Version 1.3.2 *(June 13, 2025)*
-------------------------------------------
- Android Updates:
  - ANR related issues resolved.
  - Notification center callback crash resolved.
- iOS Updates
  - Default System events optimised
  - Screen Tracking concept optimised
  - inAppBanner click callback data format updated
- Minor bug fixes
- Code optimisation and performance enhancement.

### Version 1.3.1 *(May 07, 2025)*
-------------------------------------------
- Android Updates:
  - Target SDK set to version 35
- Minor bug fixes
- Code optimisation and performance enhancement.

### Version 1.3.0 *(May 05, 2025)*
-------------------------------------------
- Android Updates:
  - Context related crash in Notification Center resolved.
  - Default System events added.
  - Screen Tracking concept introduced.
  - Default Push icon settings removed from Plugin in Push Notifications.
- iOS Updates
  - Default System events added
  - Screen Tracking concept introduced
- Minor bug fixes
- Code optimisation and performance enhancement.

### Version 1.2.4 *(April 22, 2025)*
-------------------------------------------
- Android Updates:
  - ANR issue resolved
- Minor bug fixes
- Code optimisation and performance enhancement.

### Version 1.2.3 *(February 20, 2025)*
-------------------------------------------
- iOS Updates:
  - Push conversion tracking optimised.
  - Universal Link added as new target for push click (available for all push templates)
  - "Push_Clicked" event callback added in the event response callback for all cta targets of the push notification.
  - Callback added in setUserIdentifier method.
- Minor bug fixes
- Code optimisation and performance enhancement.

### Version 1.2.2 *(January 23, 2025)*
-------------------------------------------
- Android Updates:
  - Native Push Permission Prompt white box in background bug resolved.
  - Callback added in show method.
  - In the User request, the cookies handler bug was resolved.  
  - Callback added in userIdentifier method.
  - New target added on push click "Universal Link" (available for all push templates).
  - "Push_Clicked" callback added for all cta targets in the push. This new callback will be received in the getEventResponse()     callback. Till now it has been received only when we set "Navigate to App" from the NotifyVisitors dashboard while creating a push but now we added this in all types of targets which include Navigate to App, Navigate to Web, Share, Navigate to Third-Party App, Call & Universal Link.
  - Callback added on Notification Center's close button.
  - TimerPush dark theme bug resolved.
  - Banner/Survey callback response time minimized.
  - Added new function to receive payload from FCM & send it to NV
- Minor bug fixes
- Code optimisation and performance enhancement.

### Version 1.2.1 *(December 07, 2024)*
-------------------------------------------
- iOS Updates:
  - Push notifications stats optimised.
- Minor bug fixes
- Code optimisation and performance enhancement.

### Version 1.2.0 *(July 19, 2024)*
-------------------------------------------
- Android Updates:
  - App push conversion tracking enabled
  - Push permission prompt on android 13, 14 devices
  - Encryption google play warning bug resolved.
  - Handler added for push registered callback.
- iOS Updates:
  - App push conversion tracking enabled
  - App Privacy manifest plist file included
  - Push and Notification Center Click callback parameters parsed with dataType instead of string only in all format
  - NSUserDefault values updated to fix empty data on app logout
- Minor bug fixes
- Code optimisation and performance enhancement.

### Version 1.1.6 *(DEC 21, 2023)*
-------------------------------------------
- FRAMEWORK INTRODUCED IN IOS
- NEW NOTIFICATION CENTER DATA FORAMAT
- BANNER CALLBACK

### Version 1.1.5 *(SEP 28, 2023)*
-------------------------------------------
- NOTIFICATION COUNT FIX IN ANDROID
- FLOATIING NOTIFICATION FIX IN ANDROID
- Change in Push Permission Count Android

### Version 1.1.4 *(SEP 28, 2023)*
-------------------------------------------
- FCM CORE ISSUE FIX ANDROID

### Version 1.1.3 *(SEP 14, 2023)*
-------------------------------------------
- IMPORT ISSUE FIX ANDROID

### Version 1.1.2 *(SEP 13, 2023)*
-------------------------------------------
- IMPORT ISSUE FIX ANDROID

### Version 1.1.1 *(SEP 13, 2023)*
-------------------------------------------
- IMPORT ISSUE FIX ANDROID

### Version 1.1.0 *(SEP 12, 2023)*
-------------------------------------------
- IOS GEOFENCE CODE REMOVED
- Android Push Prompt Added
- Encryption System Added Android and IOS

### Version 1.0.9 *(FEB 3, 2023)*
-------------------------------------------
- IOS INSTALL COUNT ISSUE FIX

### Version 1.0.8 *(NOV 3, 2022)*
-------------------------------------------
- IOS VARIABLE CONFLICT ISSUE FIX

### Version 1.0.7 *(MAY 25, 2022)*
-------------------------------------------
- IOS EVENTS ATTRIBUTES ISSUE FIXED

### Version 1.0.6 *(MAY 17, 2022)*
-------------------------------------------
- FCM service issue fixed

### Version 1.0.5 *(MAY 6, 2022)*
-------------------------------------------
- Android 12 Support click fixed

### Version 1.0.4 *(MAY 6, 2022)*
-------------------------------------------
- Android 12 Support

### Version 1.0.3 *(March 24, 2022)*
-------------------------------------------
- Null Sound Safty fixed
- New App Inbox

### Version 1.0.2 *(March 24, 2022)*
-------------------------------------------
- Initialize has been renamed to nvInitialize in IOS

### Version 1.0.1 *(March 22, 2022)*
-------------------------------------------
- Swift Support in IOS

### Version 1.0.0 *(July 1, 2021)*
-------------------------------------------
- Initial Release.
- Supports NotifyVisitors Android SDK
- Supports NotifyVisitors IOS SDK
