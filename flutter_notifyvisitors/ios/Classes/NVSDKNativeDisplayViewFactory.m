//
//  NVSDKNativeDisplayViewFactory.m
//  flutter_notifyvisitors
//
//  Created by Notifyvisitors Macbook Air 4 on 24/07/25.
//

#import "NVSDKNativeDisplayViewFactory.h"
#import "NVSDKNativeDisplayEmbedPlatformView.h"

@implementation NVSDKNativeDisplayViewFactory {
    NSObject<FlutterBinaryMessenger>* _messenger;
}

-(instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
    self = [super init];
    if (self) {
        _messenger = messenger;
    }
    return self;
}

// Required method from FlutterPlatformViewFactory
- (NSObject<FlutterPlatformView>*)createWithFrame:(CGRect)frame
                                   viewIdentifier:(int64_t)viewId
                                        arguments:(id _Nullable)args {
    return [[NVSDKNativeDisplayEmbedPlatformView alloc] initWithFrame: frame viewIdentifier: viewId arguments: args binaryMessenger: _messenger];
}

// Optional: If you need to deserialize arguments, provide a codec.
// FlutterStandardMessageCodec is generally sufficient for most cases.
- (NSObject<FlutterMessageCodec>*)createArgsCodec {
    return [FlutterStandardMessageCodec sharedInstance];
}


@end
