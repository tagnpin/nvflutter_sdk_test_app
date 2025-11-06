//
//  NVSDKNativeDisplayEmbedPlatformView.h
//  flutter_notifyvisitors
//
//  Created by Notifyvisitors Macbook Air 4 on 24/07/25.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKey.h>
#import <Flutter/Flutter.h> // Import Flutter headers

@interface NVSDKNativeDisplayEmbedPlatformView : NSObject <FlutterPlatformView>

@property(nonatomic, strong) UIView * _Nullable nvContainerView;
// Initialize method that will be called by the factory
- (instancetype _Nonnull )initWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id _Nullable)args binaryMessenger:(NSObject<FlutterBinaryMessenger>*_Nullable)messenger;

// The required method from FlutterPlatformView protocol
- (UIView*_Nonnull)view;

@end
