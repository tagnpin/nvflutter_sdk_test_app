//
//  NVSDKNativeDisplayViewFactory.h
//  flutter_notifyvisitors
//
//  Created by Notifyvisitors Macbook Air 4 on 24/07/25.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h> // Import Flutter headers

// Declare your view factory class, conforming to FlutterPlatformViewFactory
@interface NVSDKNativeDisplayViewFactory : NSObject <FlutterPlatformViewFactory>

// Initialize method for the factory
-(instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;

@end
