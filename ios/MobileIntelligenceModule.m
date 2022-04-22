//
//  MobileIntelligenceModule.m
//  MDIDemo
//
//  Created by Suhail Ranger on 21/09/20.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>
#import <React/RCTEventDispatcher.h>

@interface RCT_EXTERN_MODULE(MobileIntelligenceModule, NSObject)

RCT_EXTERN_METHOD(setupSDK:(id)data result:(RCTPromiseResolveBlock)result reject:(RCTPromiseRejectBlock)reject);
RCT_EXTERN_METHOD(submitData:(RCTPromiseResolveBlock)result reject:(RCTPromiseRejectBlock)reject);
RCT_EXTERN_METHOD(trackField:(id)data result:(RCTPromiseResolveBlock)result reject:(RCTPromiseRejectBlock)reject);
RCT_EXTERN_METHOD(trackCustomData:(id)customDataObject result:(RCTPromiseResolveBlock)result reject:(RCTPromiseRejectBlock)reject);
RCT_EXTERN_METHOD(trackTextChange:(NSString*)viewId text:(NSString*)text result:(RCTPromiseResolveBlock)result reject:(RCTPromiseRejectBlock)reject);
RCT_EXTERN_METHOD(trackFocusChange:(NSString)viewId isFocus:(BOOL)isFocus result:(RCTPromiseResolveBlock)result reject:(RCTPromiseRejectBlock)reject);
RCT_EXTERN_METHOD(silentAuth:(id)data result:(RCTPromiseResolveBlock)result reject:(RCTPromiseRejectBlock)reject);
RCT_EXTERN_METHOD(updateOptions:(id)data result:(RCTPromiseResolveBlock)result reject:(RCTPromiseRejectBlock)reject);

@end
