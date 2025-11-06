//
//  NVSDKNativeDisplayEmbedPlatformView.m
//  flutter_notifyvisitors
//
//  Created by Notifyvisitors Macbook Air 4 on 24/07/25.
//

#import "NVSDKNativeDisplayEmbedPlatformView.h"
#import <notifyvisitorsNudges/notifyvisitorsNudges-Swift.h>

@implementation NVSDKNativeDisplayEmbedPlatformView {
    //   UIView *containerView;
       FlutterMethodChannel *_methodChannel; // For communication
   }

-(instancetype)initWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id)args binaryMessenger:(NSObject<FlutterBinaryMessenger> *)messenger {
    
    self = [super init];
    if (self) {

        notifyvisitorsNativeDisplay *nvNudgesNativeDisplay = [notifyvisitorsNativeDisplay sharedInstance];
         NSLog(@"notifyvisitors nudges iOS file load args: %@", args);
        if (args && [args isKindOfClass:[NSDictionary class]]) {
            NSDictionary *creationParams = (NSDictionary *)args;
            NSString *nvPropertyName = [NSString stringWithFormat: @"%@", creationParams[@"propertyName"]];
            if ([nvPropertyName length] > 0 && ![nvPropertyName isEqualToString: @""] && ![nvPropertyName isEqual: [NSNull null]]) {
                 NSLog(@"notifyvisitors nudges iOS nvPropertyName found : %@", nvPropertyName);
                UIView *nvNativeDisplayView = [nvNudgesNativeDisplay loadContentForPropertyName: nvPropertyName];
                nvNativeDisplayView.backgroundColor = [UIColor clearColor];
                nvNativeDisplayView.translatesAutoresizingMaskIntoConstraints = YES; // ✅ VERY IMPORTANT
                nvNativeDisplayView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
                _nvContainerView = nvNativeDisplayView;
            } else {
                NSLog(@"notifyvisitors nudges iOS propertyName found not found or empty.");
                UIView *nvEmptyDisplayView = [[UIView alloc] initWithFrame: frame];
                _nvContainerView = nvEmptyDisplayView;
            }

        } else {
            UIView *nvEmptyDisplayView = [[UIView alloc] initWithFrame: frame];
            _nvContainerView = nvEmptyDisplayView;
        }
    }
    return self;
}

- (UIView*)view {
    return self.nvContainerView;
}

//// Implement dispose if you need to clean up resources when the view is removed
- (void)dealloc {
    // Clean up MethodChannel handler to prevent crashes if view is deallocated
    [_methodChannel setMethodCallHandler:nil];
}

@end
