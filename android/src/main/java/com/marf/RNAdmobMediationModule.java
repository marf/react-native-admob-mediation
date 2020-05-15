package com.marf;
import android.os.Handler;
import android.os.Looper;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.facebook.react.bridge.Arguments;

import androidx.annotation.NonNull;

import com.google.android.gms.ads.AdListener;
import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.InterstitialAd;
import com.google.android.gms.ads.MobileAds;
import com.google.android.gms.ads.rewarded.RewardItem;
import com.google.android.gms.ads.rewarded.RewardedAd;
import com.google.android.gms.ads.rewarded.RewardedAdCallback;
import com.google.android.gms.ads.rewarded.RewardedAdLoadCallback;

public class RNAdmobMediationModule extends ReactContextBaseJavaModule {

	private final ReactApplicationContext reactContext;

	private int INTERSTITIAL = 1 << 0;
	private int REWARDED_VIDEO = 1 << 1;

	private InterstitialAd mInterstitialAd;
	private RewardedAd rewardedAd;

	public RNAdmobMediationModule(ReactApplicationContext reactContext) {
		super(reactContext);
		this.reactContext = reactContext;
	}

	@Override
	public String getName() {
		return "RNAdmobMediation";
	}

	private void createAndLoadInterstitial(final String adUnitId){
		new Handler(Looper.getMainLooper()).post(new Runnable() {
			@Override
			public void run () {
				mInterstitialAd = new InterstitialAd(reactContext);
				mInterstitialAd.setAdUnitId(adUnitId);
				mInterstitialAd.loadAd(new AdRequest.Builder().build());

				mInterstitialAd.setAdListener(new AdListener() {
					@Override
					public void onAdLoaded() {
						sendEventToJS("onInterstitialLoaded", null);
					}

					@Override
					public void onAdFailedToLoad(int errorCode) {
						WritableMap params = Arguments.createMap();
						params.putInt("errorCode", errorCode);

						sendEventToJS("onInterstitialFailedShown", params);
					}

					@Override
					public void onAdOpened() {
						sendEventToJS("onInterstitialShown", null);
					}

					@Override
					public void onAdClicked() {
						sendEventToJS("onInterstitialClicked", null);
					}

					@Override
					public void onAdLeftApplication() {
						sendEventToJS("onInterstitialWillLeaveApplication", null);
					}

					@Override
					public void onAdClosed() {
						sendEventToJS("onInterstitialDismissed", null);
					}
				});
			}
		});
	}

	private void createAndLoadRewardedVideo(final String adUnitId){
		new Handler(Looper.getMainLooper()).post(new Runnable() {
			@Override
			public void run() {
				rewardedAd = new RewardedAd(reactContext, adUnitId);

				RewardedAdLoadCallback adLoadCallback = new RewardedAdLoadCallback() {
					@Override
					public void onRewardedAdLoaded() {
						sendEventToJS("onRewardedVideoLoaded", null);
					}

					@Override
					public void onRewardedAdFailedToLoad(int errorCode) {
						WritableMap params = Arguments.createMap();
						params.putInt("errorCode", errorCode);

						sendEventToJS("onRewardedVideoFailedToLoad", params);
					}
				};
				rewardedAd.loadAd(new AdRequest.Builder().build(), adLoadCallback);
			}
		});

	}

	@ReactMethod
	public void initialize() {
		if(this.reactContext != null) {
			MobileAds.initialize(this.reactContext.getCurrentActivity());
		}
		sendEventToJS("onSdkInitialized", null);
	}

	@ReactMethod
	public void show(final int adType, final Callback callback){
		new Handler(Looper.getMainLooper()).post(new Runnable() {
			@Override
			public void run () {
				boolean result = false;
				if(adType == INTERSTITIAL) {
					if (mInterstitialAd.isLoaded()) {
						mInterstitialAd.show();
						result = true;
					} else {
						result = false;
					}
				}
				else if(adType == REWARDED_VIDEO){
					if (rewardedAd.isLoaded()) {
						RewardedAdCallback adCallback = new RewardedAdCallback() {
							@Override
							public void onRewardedAdOpened() {
								sendEventToJS("onRewardedVideoPresented", null);
							}

							@Override
							public void onRewardedAdClosed() {
								sendEventToJS("onRewardedVideoDismissed", null);
							}

							@Override
							public void onUserEarnedReward(@NonNull RewardItem reward) {
								WritableMap params = Arguments.createMap();
								params.putString("amount", reward.getType());
								params.putInt("type", reward.getAmount());

								sendEventToJS("onRewardedEarnedReward", params);
							}

							@Override
							public void onRewardedAdFailedToShow(int errorCode) {
								WritableMap params = Arguments.createMap();
								params.putInt("errorCode", errorCode);

								sendEventToJS("onRewardedVideoFailedToPresent", params);
							}
						};
						rewardedAd.show(reactContext.getCurrentActivity(), adCallback);
						result = true;
					} else {
						result = false;
					}
				}

				if (callback != null) {
					callback.invoke(result);
				}
			}
		});
	}

	@ReactMethod
	public void cache(int adType, String adUnitId){
		if(adType == INTERSTITIAL)
            createAndLoadInterstitial(adUnitId);
		else if(adType == REWARDED_VIDEO)
            createAndLoadRewardedVideo(adUnitId);
	}

	private void sendEventToJS(String eventName, WritableMap params){
		reactContext
				.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
				.emit(eventName, params);
	}
}
