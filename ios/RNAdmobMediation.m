#import "RNAdmobMediation.h"

#if __has_include(<React/RCTUtils.h>)
#import <React/RCTUtils.h>
#else
#import "RCTUtils.h"
#endif

const int INTERSTITIAL          = 1 << 0;
const int REWARDED_VIDEO        = 1 << 1;

static NSString *const kEventSdkInitialized = @"onSdkInitialized";

static NSString *const kEventInterstitialLoaded = @"onInterstitialLoaded";
static NSString *const kEventInterstitialShown = @"onInterstitialShown";
static NSString *const kEventInterstitialFailedShown = @"onInterstitialFailedShown";
static NSString *const kEventInterstitialWillDismissScreen = @"onInterstitialWillDismissScreen";
static NSString *const kEventInterstitialDismissed = @"onInterstitialDismissed";
static NSString *const kEventInterstitialWillLeaveApplication = @"onInterstitialWillLeaveApplication";

static NSString *const kEventRewardedVideoLoaded = @"onRewardedVideoLoaded";
static NSString *const kEventRewardedVideoFailedToLoad = @"onRewardedVideoFailedToLoad";
static NSString *const kEventRewardedVideoDidPresent = @"onRewardedVideoPresented";
static NSString *const kEventRewardedVideoFailedToPresent = @"onRewardedVideoFailedToPresent";
static NSString *const kEventRewardedVideoDismissed = @"onRewardedVideoDismissed";
static NSString *const kEventRewardedVideoEarnedReward = @"onRewardedEarnedReward";

static NSString *const kEventAppOpenLoaded = @"onAppOpenLoaded";
static NSString *const kEventAppOpenFailedToLoad = @"onAppOpenFailedToLoad";
static NSString *const kEventAppOpenFailedShown = @"onAppOpenFailedShown";
static NSString *const kEventonAppOpenDismissed = @"onAppOpenDismissed";
static NSString *const kEventonAppOpenShown = @"onAppOpenShown";

#pragma mark implementation of plugin

@implementation RNAdmobMediation

- (dispatch_queue_t)methodQueue {
    return dispatch_get_main_queue();
}

- (void)createAndLoadInterstitial:(NSString *)adUnitId {
  GADInterstitial *interstitial =
    [[GADInterstitial alloc] initWithAdUnitID:adUnitId];
  interstitial.delegate = self;
  [interstitial loadRequest:[GADRequest request]];
  self.interstitial = interstitial;
}

- (void)createAndLoadRewardedAd:(NSString *)adUnitId  {
  GADRewardedAd *rewardedAd = [[GADRewardedAd alloc]
                               initWithAdUnitID:adUnitId];
  GADRequest *request = [GADRequest request];
  [rewardedAd loadRequest:request completionHandler:^(GADRequestError * _Nullable error) {
    if (error) {
       [self sendEventWithName:kEventRewardedVideoFailedToLoad body:nil];
    } else {
      [self sendEventWithName:kEventRewardedVideoLoaded body:nil];
    }
  }];
  self.rewardedAd = rewardedAd;
}

- (BOOL)wasLoadTimeLessThanNHoursAgo:(int)n {
  NSDate *now = [NSDate date];
  NSTimeInterval timeIntervalBetweenNowAndLoadTime = [now timeIntervalSinceDate:self.loadTime];
  double secondsPerHour = 3600.0;
  double intervalInHours = timeIntervalBetweenNowAndLoadTime / secondsPerHour;
  return intervalInHours < n;
}

- (void)requestAppOpenAd {
  self.appOpenAd = nil;
  [GADAppOpenAd loadWithAdUnitID:self.appOpenUnitId
                         request:[GADRequest request]
                     orientation:UIInterfaceOrientationPortrait
               completionHandler:^(GADAppOpenAd *_Nullable appOpenAd, NSError *_Nullable error) {
                 if (error) {
                   NSLog(@"Failed to load app open ad: %@", error);
                   [self sendEventWithName:kEventAppOpenFailedToLoad body:[error localizedDescription]];
                   return;
                 }
                 self.appOpenAd = appOpenAd;
                 self.appOpenAd.fullScreenContentDelegate = self;
                 self.loadTime = [NSDate date];
                 [self sendEventWithName:kEventAppOpenLoaded body:nil];
               }];
}


RCT_EXPORT_MODULE();

- (NSArray<NSString *> *)supportedEvents {
    return @[
             kEventSdkInitialized,

             kEventInterstitialLoaded,
             kEventInterstitialShown,
             kEventInterstitialFailedShown,
             kEventInterstitialWillDismissScreen,
             kEventInterstitialDismissed,
             kEventInterstitialWillLeaveApplication,
             
             kEventRewardedVideoLoaded,
             kEventRewardedVideoFailedToLoad,
             kEventRewardedVideoDidPresent,
             kEventRewardedVideoFailedToPresent,
             kEventRewardedVideoDismissed,
             kEventRewardedVideoEarnedReward,
             
             kEventAppOpenLoaded,
             kEventAppOpenFailedToLoad,
             kEventAppOpenFailedShown,
             kEventonAppOpenDismissed,
             kEventonAppOpenShown
             ];
}

#pragma mark exported methods

RCT_EXPORT_METHOD(initialize:(int)appOpenEnabled
                  appOpenUnitId:(NSString*)appOpenUnitId) {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[GADMobileAds sharedInstance] startWithCompletionHandler:^(GADInitializationStatus *_Nullable status){
            [self sendEventWithName:kEventSdkInitialized body:nil];
            
            if(appOpenEnabled){
                self.appOpenUnitId = appOpenUnitId;
                [self requestAppOpenAd];
            }
        }];
    });
}

RCT_EXPORT_METHOD(showAppOpenAd:(NSString*)appOpenUnitId) {
    dispatch_async(dispatch_get_main_queue(), ^{
        GADAppOpenAd *ad = self.appOpenAd;
          self.appOpenAd = nil;

          if (ad && [self wasLoadTimeLessThanNHoursAgo:4]) {
            UIViewController *rootController = [[UIApplication sharedApplication] keyWindow].rootViewController;
            [ad presentFromRootViewController:rootController];

          } else {
            // If you don't have an ad ready, request one.
              self.appOpenUnitId = appOpenUnitId;
              [self requestAppOpenAd];
          }
    });
}

RCT_EXPORT_METHOD(show:(int)adType result:(RCTResponseSenderBlock)callback) {
    dispatch_async(dispatch_get_main_queue(), ^{
        if(adType == INTERSTITIAL){
            if (self.interstitial.isReady) {
              [self.interstitial presentFromRootViewController:[[UIApplication sharedApplication] keyWindow].rootViewController];
                callback(@[@YES]);
            } else {
                callback(@[@NO]);
            }
        }
        else if(adType == REWARDED_VIDEO)
        {
            if (self.rewardedAd.isReady) {
                [self.rewardedAd presentFromRootViewController:[[UIApplication sharedApplication] keyWindow].rootViewController delegate:self];
                callback(@[@YES]);
            } else {
              callback(@[@NO]);
            }
        }
    });
}


RCT_EXPORT_METHOD(cache:(int)adType adUnitId:(NSString*)adUnitId) {
    dispatch_async(dispatch_get_main_queue(), ^{
        if(adType == INTERSTITIAL)
            [self createAndLoadInterstitial:adUnitId];
        else if(adType == REWARDED_VIDEO)
            [self createAndLoadRewardedAd:adUnitId];
    });
}

#pragma mark Events

#pragma mark - App open events

/// Tells the delegate that the ad failed to present full screen content.
- (void)ad:(nonnull id<GADFullScreenPresentingAd>)ad
    didFailToPresentFullScreenContentWithError:(nonnull NSError *)error {
  NSLog(@"didFailToPresentFullSCreenCContentWithError");
  [self sendEventWithName:kEventAppOpenFailedShown body:[error localizedDescription]];
  //[self requestAppOpenAd];

}

/// Tells the delegate that the ad presented full screen content.
- (void)adDidPresentFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
  NSLog(@"adDidPresentFullScreenContent");
  self.appOpenAd = ad;
  [self sendEventWithName:kEventonAppOpenShown body:nil];
}

/// Tells the delegate that the ad dismissed full screen content.
- (void)adDidDismissFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
  NSLog(@"adDidDismissFullScreenContent");
  [self sendEventWithName:kEventonAppOpenDismissed body:nil];
  //[self requestAppOpenAd];
}

#pragma mark - Interstitial events

/// Tells the delegate an ad request succeeded.
- (void)interstitialDidReceiveAd:(GADInterstitial *)ad {
  [self sendEventWithName:kEventInterstitialLoaded body:nil];
}

/// Tells the delegate an ad request failed.
- (void)interstitial:(GADInterstitial *)ad
    didFailToReceiveAdWithError:(GADRequestError *)error {
    [self sendEventWithName:kEventInterstitialFailedShown body:[error localizedDescription]];
}

/// Tells the delegate that an interstitial will be presented.
- (void)interstitialWillPresentScreen:(GADInterstitial *)ad {
  [self sendEventWithName:kEventInterstitialShown body:nil];
}

/// Tells the delegate the interstitial is to be animated off the screen.
- (void)interstitialWillDismissScreen:(GADInterstitial *)ad {
  [self sendEventWithName:kEventInterstitialWillDismissScreen body:nil];
}

/// Tells the delegate the interstitial had been animated off the screen.
- (void)interstitialDidDismissScreen:(GADInterstitial *)ad {
    //self.interstitial = [self createAndLoadInterstitial];
  [self sendEventWithName:kEventInterstitialDismissed body:nil];
}

/// Tells the delegate that a user click will open another app
/// (such as the App Store), backgrounding the current app.
- (void)interstitialWillLeaveApplication:(GADInterstitial *)ad {
  [self sendEventWithName:kEventInterstitialWillLeaveApplication body:nil];
}

#pragma mark - Rewarded video events

/// Tells the delegate that the user earned a reward.
- (void)rewardedAd:(GADRewardedAd *)rewardedAd userDidEarnReward:(GADAdReward *)reward {
    [self sendEventWithName:kEventRewardedVideoEarnedReward body:@{@"amount":reward.amount,@"name":reward.type}];
}

/// Tells the delegate that the rewarded ad was presented.
- (void)rewardedAdDidPresent:(GADRewardedAd *)rewardedAd {
  [self sendEventWithName:kEventRewardedVideoDidPresent body:nil];
}

/// Tells the delegate that the rewarded ad failed to present.
- (void)rewardedAd:(GADRewardedAd *)rewardedAd didFailToPresentWithError:(NSError *)error {
  [self sendEventWithName:kEventRewardedVideoFailedToPresent body:@{@"error":error}];
}

/// Tells the delegate that the rewarded ad was dismissed.
- (void)rewardedAdDidDismiss:(GADRewardedAd *)rewardedAd {
  [self sendEventWithName:kEventRewardedVideoDismissed body:nil];
}

@end
