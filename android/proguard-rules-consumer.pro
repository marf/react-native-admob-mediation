# Add project specific ProGuard rules here.
# By default, the flags in this file are appended to flags specified
# in C:\Dev\adt\sdk/tools/proguard/proguard-android.txt
# You can edit the include path and order by changing the proguardFiles
# directive in build.gradle.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# Add any project specific keep options here:

# If your project uses WebView with JS, uncomment the following
# and specify the fully qualified class name to the JavaScript interface
# class:
#-keepclassmembers class fqcn.of.javascript.interface.for.webview {
#   public *;
#}

# AdMediator
-keep class com.admediator.** { *; }

# Appodeal
-keep class com.appodeal.** { *; }
-dontwarn com.appodeal.**
-keep class com.appodealx.** { *; }
-dontwarn com.appodealx.**
-keepattributes EnclosingMethod, InnerClasses, Signature, JavascriptInterface

# Amazon
-keep class com.amazon.** { *; }
-dontwarn com.amazon.**

# Mopub
-keep public class com.mopub.**
-keepclassmembers class com.mopub.** { public *; }
-dontwarn com.mopub.**
-keep class * extends com.mopub.mobileads.CustomEventBanner {}
-keepclassmembers class com.mopub.mobileads.CustomEventBannerAdapter {!private !public !protected *;}
-keep class * extends com.mopub.mobileads.CustomEventInterstitial {}
-keep class * extends com.mopub.nativeads.CustomEventNative {}
-keep class * extends com.mopub.mobileads.CustomEventRewardedVideo {}
-keep class * extends com.mopub.nativeads.CustomEventRewardedAd {}
-keepclassmembers class ** { @com.mopub.common.util.ReflectionTarget *; }
-dontwarn com.mopub.volley.toolbox.**
-keepclassmembers,allowshrinking,allowobfuscation class com.android.volley.NetworkDispatcher {
    void processRequest();
}
-keepclassmembers,allowshrinking,allowobfuscation class com.android.volley.CacheDispatcher {
    void processRequest();
}
-keep public class android.webkit.JavascriptInterface {}
-keepnames class * implements android.os.Parcelable {
    public static final ** CREATOR;
}

# Applovin
-keepattributes Signature,InnerClasses,Exceptions,*Annotation*
-keep public class com.applovin.sdk.AppLovinSdk { *; }
-keep public class com.applovin.sdk.AppLovin* { public protected *; }
-keep public class com.applovin.nativeAds.AppLovin* { public protected *; }
-keep public class com.applovin.adview.* { public protected *; }
-keep public class com.applovin.mediation.* { public protected *; }
-keep public class com.applovin.mediation.ads.* { public protected *; }
-keep public class com.applovin.communicator.* { public protected *; }
-keep public class com.applovin.impl.sdk.utils.BundleUtils { public protected *; }
-keep public class com.applovin.impl.**.AppLovin* { public protected *; }
-keep public class com.applovin.impl.**.*Impl { public protected *; }
-keep public class com.applovin.impl.adview.AppLovinOrientationAwareInterstitialActivity { *; }
-keepclassmembers class com.applovin.sdk.AppLovinSdkSettings { private java.util.Map localSettings; }
-keep class com.applovin.mediation.adapters.** { *; }
-keep class com.applovin.mediation.adapter.** { *; }
-keep class com.google.android.gms.ads.identifier.** { *; }
-dontwarn com.applovin.**

# Facebook
-keep public class com.facebook.ads.** { public protected *; }
-keepnames public class com.facebook.ads.** { public protected *; }
-keeppackagenames com.facebook.*
-dontwarn com.facebook.ads.**

# Chartboost
-keep class com.chartboost.** { *; }
-dontwarn com.chartboost.**

# Unity Ads
-keepattributes SourceFile,LineNumberTable
-keepattributes JavascriptInterface
-keep class android.webkit.JavascriptInterface { *; }
-keep class com.unity3d.ads.** { *; }
-keep class com.unity3d.services.** { *; }
-dontwarn com.google.ar.core.**

# Yandex
-keep class com.yandex.metrica.impl.** { *; }
-dontwarn com.yandex.metrica.impl.**
-keep class com.yandex.metrica.* { *; }
-dontwarn com.yandex.metrica.*
-keep class com.yandex.mobile.ads.** { *; }
-dontwarn com.yandex.mobile.ads.**
-keepattributes *Annotation*
-keep class com.android.installreferrer.api.* { *; }
-dontwarn com.android.installreferrer.api.*

# StartApp
-keep class com.startapp.** { *;}
-keep class com.truenet.** { *;}
-dontwarn com.startapp.**
-dontwarn android.webkit.JavascriptInterface
-keepattributes Exceptions, InnerClasses, Signature, Deprecated, SourceFile, LineNumberTable, *Annotation*, EnclosingMethod
-dontwarn org.jetbrains.annotations.**

# Flurry
-keep class com.flurry.** { *; }
-dontwarn com.flurry.**
-keepattributes *Annotation*,EnclosingMethod,Signature
-keepclasseswithmembers class * {
  public <init>(android.content.Context, android.util.AttributeSet, int);
}
-keep class * extends java.util.ListResourceBundle { protected Object[][] getContents(); }
-keep public class com.google.android.gms.common.internal.safeparcel.SafeParcelable { public static final *** NULL; }
-keepnames @com.google.android.gms.common.annotation.KeepName class *
-keepclassmembernames class * { @com.google.android.gms.common.annotation.KeepName *; }
-keepnames class * implements android.os.Parcelable { public static final ** CREATOR; }

# Vungle
-keep class com.vungle.warren.** { *; }
-dontwarn com.vungle.warren.error.VungleError$ErrorCode

# Vungle/Moat SDK
-keep class com.moat.** { *; }
-dontwarn com.moat.**

# Vungle/Fetch
-keepnames class com.tonyodev.fetch.Fetch

# Vungle/Okio
-keepnames class okio.Okio
-dontwarn org.codehaus.mojo.animal_sniffer.IgnoreJRERequirement

# Vungle/Retrofit
-dontwarn okio.**
-dontwarn retrofit2.Platform$Java8
-keepnames class retrofit2.converter.gson.GsonConverterFactory
-keepnames class retrofit2.Retrofit

# Vungle/Gson
-keepattributes Signature
-keepattributes *Annotation*
-dontwarn sun.misc.**
-keep class com.google.gson.** { *; }

# Vungle/Google Android Advertising ID
-keep class com.google.android.gms.internal.** { *; }
-dontwarn com.google.android.gms.ads.identifier.**

# Vungle/okhttp3
-keep class okhttp3.logging.HttpLoggingInterceptor
-keepnames class okhttp3.HttpUrl
-keep class okhttp3.internal.publicsuffix.PublicSuffixDatabase

# MyTarget
-keep class com.my.target.** { *; }
-dontwarn com.my.target.**
-dontwarn com.my.target.core.net.cookie.**
-keep class com.google.android.exoplayer2.** { *; }
-keep class com.google.android.gms.ads.identifier.AdvertisingIdClient {
    com.google.android.gms.ads.identifier.AdvertisingIdClient$Info getAdvertisingIdInfo(android.content.Context);
}
-keep class com.google.android.gms.ads.identifier.AdvertisingIdClient$Info {
    java.lang.String getId();
    boolean isLimitAdTrackingEnabled();
}

# Mintegral
-keepattributes Signature
-keepattributes *Annotation*
-keep class com.mintegral.** {*; }
-keep interface com.mintegral.** {*; }
-keep class android.support.v4.** { *; }
-dontwarn com.mintegral.**
-keep class **.R$* { public static final int mintegral*; }
-keep class com.alphab.** {*; }
-keep interface com.alphab.** {*; }

# Admob
-keep class com.google.android.gms.ads.** { *; }

# Tapjoy
-keep class com.tapjoy.** { *; }
-keep class com.moat.** { *; }
-keepattributes JavascriptInterface
-keepattributes *Annotation*
-keep class * extends java.util.ListResourceBundle { protected Object[][] getContents(); }
-keep public class com.google.android.gms.common.internal.safeparcel.SafeParcelable { public static final *** NULL; }
-keepnames @com.google.android.gms.common.annotation.KeepName class *
-keepclassmembernames class * { @com.google.android.gms.common.annotation.KeepName *; }
-keepnames class * implements android.os.Parcelable { public static final ** CREATOR; }
-keep class com.google.android.gms.ads.identifier.** { *; }
-dontwarn com.tapjoy.**

# IronSource
-keepclassmembers class com.ironsource.sdk.controller.IronSourceWebView$JSInterface { public *; }
-keepclassmembers class * implements android.os.Parcelable { public static final android.os.Parcelable$Creator *; }
-keep public class com.google.android.gms.ads.** { public *; }
-keep class com.ironsource.adapters.** { *; }
-keepnames class com.ironsource.mediationsdk.IronSource
-dontwarn com.ironsource.mediationsdk.**
-dontwarn com.ironsource.adapters.**
-dontwarn com.moat.**
-keep class com.moat.** { public protected private *; }

# AdColonyV3
-keepclassmembers class * { @android.webkit.JavascriptInterface <methods>; }
-keep class com.adcolony.** { *; }
-dontwarn com.adcolony.**
-dontwarn android.app.Activity

# Inmobi
-keepattributes SourceFile,LineNumberTable
-keep class com.inmobi.** { *; }
-dontwarn com.inmobi.**
-keep public class com.google.android.gms.**
-dontwarn com.google.android.gms.**
-dontwarn com.squareup.picasso.**
-keep class com.google.android.gms.ads.identifier.AdvertisingIdClient{public *;}
-keep class com.google.android.gms.ads.identifier.AdvertisingIdClient$Info{public *;}

# Picasso
-keep class com.squareup.picasso.** {*;}
-dontwarn com.squareup.picasso.**
-dontwarn com.squareup.okhttp.**

# Moat
-keep class com.moat.** {*;}
-dontwarn com.moat.**

# AVID
-keep class com.integralads.avid.library.** {*;}

# Ogury
-dontwarn io.presage.**

# Google
-keep class com.google.android.gms.common.GooglePlayServicesUtil { *; }
-keep class com.google.android.gms.common.GoogleApiAvailability { *; }
-keep class com.google.android.gms.ads.identifier.** { *; }
-dontwarn com.google.android.gms.**

# Legacy
-keep class org.apache.http.** { *; }
-dontwarn org.apache.http.**
-dontwarn android.net.http.**

# Google Play Services library
-keep class * extends java.util.ListResourceBundle {
  protected Object[][] getContents();
}
-keep public class com.google.android.gms.common.internal.safeparcel.SafeParcelable {
  public static final *** NULL;
}
-keepnames class * implements android.os.Parcelable
-keepclassmembers class * implements android.os.Parcelable {
  public static final *** CREATOR;
}
-keep @interface android.support.annotation.Keep
-keep @android.support.annotation.Keep class *
-keepclasseswithmembers class * {
  @android.support.annotation.Keep <fields>;
}
-keepclasseswithmembers class * {
  @android.support.annotation.Keep <methods>;
}
-keep @interface com.google.android.gms.common.annotation.KeepName
-keepnames @com.google.android.gms.common.annotation.KeepName class *
-keepclassmembernames class * {
  @com.google.android.gms.common.annotation.KeepName *;
}
-keep @interface com.google.android.gms.common.util.DynamiteApi
-keep public @com.google.android.gms.common.util.DynamiteApi class * {
  public <fields>;
  public <methods>;
}
-keep class com.google.android.gms.common.GooglePlayServicesNotAvailableException {*;}
-keep class com.google.android.gms.common.GooglePlayServicesRepairableException {*;}

# Google Play Services library 9.0.0 only
-dontwarn android.security.NetworkSecurityPolicy
-keep public @com.google.android.gms.common.util.DynamiteApi class * { *; }

# support-v4
-keep class android.support.v4.app.Fragment { *; }
-keep class android.support.v4.app.FragmentActivity { *; }
-keep class android.support.v4.app.FragmentManager { *; }
-keep class android.support.v4.app.FragmentTransaction { *; }
-keep class android.support.v4.content.ContextCompat { *; }
-keep class android.support.v4.content.LocalBroadcastManager { *; }
-keep class android.support.v4.util.LruCache { *; }
-keep class android.support.v4.view.PagerAdapter { *; }
-keep class android.support.v4.view.ViewPager { *; }
-keep class android.support.v4.content.ContextCompat { *; }

# support-v7-widget
-keep class android.support.v7.widget.** { *; }

# MultiDex
-keepnames class android.support.multidex.MultiDex

# AndroidX
-keep @interface androidx.annotation.Keep
-keep @androidx.annotation.Keep class *
-keepclasseswithmembers class * {
  @androidx.annotation.Keep <fields>;
}
-keepclasseswithmembers class * {
  @androidx.annotation.Keep <methods>;
}
-keep class androidx.fragment.app.Fragment { *; }
-keep class androidx.fragment.app.FragmentActivity{ *; }
-keep class androidx.fragment.app.FragmentManager { *; }
-keep class androidx.fragment.app.FragmentTransaction { *; }
-keep class androidx.core.content.ContextCompat { *; }
-keep class androidx.localbroadcastmanager.content.LocalBroadcastManager { *; }
-keep class androidx.collection.LruCache { *; }
-keep class androidx.viewpager.widget.PagerAdapter { *; }
-keep class androidx.viewpager.widget.ViewPager { *; }
-keep class androidx.core.content.ContextCompat { *; }
-keep class androidx.appcompat.widget.** { *; }

# AndroidX Multidex
-keepnames class androidx.multidex.MultiDex