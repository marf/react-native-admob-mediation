#if __has_include(<React/RCTBridgeModule.h>)
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>
#else
#import "RCTBridgeModule.h"
#import "RCTEventEmitter.h"
#endif

@import GoogleMobileAds;

@interface RNAdmobMediation : RCTEventEmitter <RCTBridgeModule, GADInterstitialDelegate, GADRewardedAdDelegate, GADFullScreenContentDelegate>

@property(nonatomic, strong) GADInterstitial *interstitial;
@property(nonatomic, strong) GADRewardedAd *rewardedAd;

@property(nonatomic, strong) NSString *appOpenUnitId;
@property(nonatomic) GADAppOpenAd* appOpenAd;
@property(weak, nonatomic) NSDate *loadTime;

@end
