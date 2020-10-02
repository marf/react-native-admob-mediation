package com.marf;

import static androidx.lifecycle.Lifecycle.Event.ON_START;

import android.app.Activity;
import android.app.Application;
import android.content.Context;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;
import androidx.annotation.NonNull;
import androidx.lifecycle.LifecycleObserver;
import androidx.lifecycle.LifecycleOwner;
import androidx.lifecycle.OnLifecycleEvent;
import androidx.lifecycle.ProcessLifecycleOwner;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.WritableMap;
import com.google.android.gms.ads.AdError;
import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.FullScreenContentCallback;
import com.google.android.gms.ads.appopen.AppOpenAd;
import com.google.android.gms.ads.LoadAdError;

import java.util.Calendar;
import java.util.Date;

/** Prefetches App Open Ads. */
public class AppOpenManager {
    private static final String LOG_TAG = "AppOpenManager";
    //private static final String AD_UNIT_ID = "ca-app-pub-1073146421422541/2196946717";
    private AppOpenAd appOpenAd = null;
    private long loadTime = 0;
    private String appOpenUnitId;

    private AppOpenAd.AppOpenAdLoadCallback loadCallback;

    private Activity currentActivity;

    private ReactApplicationContext context = null;

    private RNAdmobMediationModule module = null;

    /** Constructor */
    public AppOpenManager(ReactApplicationContext context, RNAdmobMediationModule module) {
        this.context = context;
        this.module = module;
        //this.application = activity.getApplication();
        //this.application.registerActivityLifecycleCallbacks(this);
        //ProcessLifecycleOwner.get().getLifecycle().addObserver(this);
    }

    /** Request an ad */
    public void fetchAd() {
        // Have unused ad, no need to fetch another.
        if (isAdAvailable()) {
            return;
        }

        loadCallback =
                new AppOpenAd.AppOpenAdLoadCallback() {
                    /**
                     * Called when an app open ad has loaded.
                     *
                     * @param ad the loaded app open ad.
                     */
                    @Override
                    public void onAppOpenAdLoaded(AppOpenAd ad) {
                        AppOpenManager.this.appOpenAd = ad;
                        AppOpenManager.this.loadTime = (new Date()).getTime();
                        module.sendEventToJS("onAppOpenLoaded", null);
                    }

                    /**
                     * Called when an app open ad has failed to load.
                     *
                     * @param loadAdError the error.
                     */
                    @Override
                    public void onAppOpenAdFailedToLoad(LoadAdError loadAdError) {
                        // Handle the error.
                        WritableMap params = Arguments.createMap();
                        params.putString("error", loadAdError.toString());

                        module.sendEventToJS("onAppOpenFailedToLoad", params);
                    }

                };

        new Handler(Looper.getMainLooper()).post(new Runnable() {
            @Override
            public void run() {
                AdRequest request = getAdRequest();
                AppOpenAd.load(context.getApplicationContext(), appOpenUnitId, request, AppOpenAd.APP_OPEN_AD_ORIENTATION_PORTRAIT, loadCallback);
            }
        });
    }

    /** Creates and returns ad request. */
    private AdRequest getAdRequest() {
        return new AdRequest.Builder().build();
    }

    public void show(){
        new Handler(Looper.getMainLooper()).post(new Runnable() {
            @Override
            public void run() {
                FullScreenContentCallback fullScreenContentCallback =
                        new FullScreenContentCallback() {
                            @Override
                            public void onAdDismissedFullScreenContent() {
                                // Set the reference to null so isAdAvailable() returns false.
                                AppOpenManager.this.appOpenAd = null;
                                isShowingAd = false;
                                //fetchAd();

                                module.sendEventToJS("onAppOpenDismissed", null);
                            }

                            @Override
                            public void onAdFailedToShowFullScreenContent(AdError adError) {
                                WritableMap params = Arguments.createMap();
                                params.putString("error", adError.toString());
                                module.sendEventToJS("onAppOpenFailedShown", params);
                            }

                            @Override
                            public void onAdShowedFullScreenContent() {
                                isShowingAd = true;
                                module.sendEventToJS("onAppOpenShown", null);
                            }
                        };


                appOpenAd.show(context.getCurrentActivity(), fullScreenContentCallback);
            }
        });
    }

    /** Utility method that checks if ad exists and can be shown. */
    public boolean isAdAvailable() {
        return appOpenAd != null && wasLoadTimeLessThanNHoursAgo(4);
    }

    private boolean wasLoadTimeLessThanNHoursAgo(int hours){
        Calendar now = Calendar.getInstance();
        long timeAgo = now.getTimeInMillis() - AppOpenManager.this.loadTime;

        return !(timeAgo > hours*60*60*1000);
    }

    private static boolean isShowingAd = false;

    /** Shows the ad if one isn't already showing. */
    public void showAdIfAvailable(String appOpenUnitId) {
        // Only show ad if there is not already an app open ad currently showing
        // and an ad is available.
        if (!isShowingAd && isAdAvailable()) {
            Log.d(LOG_TAG, "Will show ad.");
            show();
        } else {
            this.appOpenUnitId = appOpenUnitId;
            Log.d(LOG_TAG, "Can not show ad.");
            fetchAd();
        }
    }
}
