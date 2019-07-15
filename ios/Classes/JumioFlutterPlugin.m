#import "JumioFlutterPlugin.h"
#import <jumio_flutter/jumio_flutter-Swift.h>

@implementation JumioFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftJumioFlutterPlugin registerWithRegistrar:registrar];
}
@end
