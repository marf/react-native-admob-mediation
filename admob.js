'use strict';

import {
  NativeModules,
  NativeEventEmitter,
} from 'react-native';

const RNAdmobMediation = NativeModules.RNAdmobMediation;

const INTERSTITIAL          = 1 << 0;
const REWARDED_VIDEO        = 1 << 1;

const eventEmitter = new NativeEventEmitter(RNAdmobMediation);

const eventHandlers = {
  onSdkInitialized: 'onSdkInitialized',

  onInterstitialLoaded: "onInterstitialLoaded",
  onInterstitialShown: "onInterstitialShown",
  onInterstitialFailedShown: "onInterstitialFailedShown",
  onInterstitialWillDismissScreen: "onInterstitialWillDismissScreen",
  onInterstitialDismissed: "onInterstitialDismissed",
  onInterstitialWillLeaveApplication: "onInterstitialWillLeaveApplication",

  onRewardedVideoLoaded: "onRewardedVideoLoaded",
  onRewardedVideoFailedToLoad: "onRewardedVideoFailedToLoad",
  onRewardedVideoPresented: "onRewardedVideoPresented",
  onRewardedVideoFailedToPresent: "onRewardedVideoFailedToPresent",
  onRewardedVideoShown: "onRewardedVideoShown",
  onRewardedVideoDismissed: "onRewardedVideoDismissed",
  onRewardedEarnedReward: "onRewardedEarnedReward"


};

const LogLevel = {
  none: 'none',
  debug: 'debug',
  verbose: 'verbose'
}

const Gender = {
  male: 'male',
  female: 'female',
  other: 'other'
}

const _subscriptions = new Map();

const addEventListener = (event, handler) => {
  const mappedEvent = eventHandlers[event];
  if (mappedEvent) {
    let listener;
    listener = eventEmitter.addListener(mappedEvent, handler);
    _subscriptions.set(handler, listener);
    return {
      remove: () => removeEventListener(event, handler)
    };
  } else {
    console.warn(`Trying to subscribe to unknown event: "${event}"`);
    return {
      remove: () => {},
    };
  }
};

const removeEventListener = (type, handler) => {
  const listener = _subscriptions.get(handler);
  if (!listener) {
    return;
  }
  listener.remove();
  _subscriptions.delete(handler);
};

const removeAllListeners = () => {
  _subscriptions.forEach((listener, key, map) => {
    listener.remove();
    map.delete(key);
  });
};

module.exports = {
  ...RNAdmobMediation,
  INTERSTITIAL,
  REWARDED_VIDEO,
  LogLevel,
  Gender,
  addEventListener,
  removeEventListener,
  removeAllListeners,
  initialize: () => RNAdmobMediation.initialize(),
  show: (adType, cb = () => {}) => RNAdmobMediation.show(adType, cb),
  cache: (adType, adUnitId) => RNAdmobMediation.cache(adType, adUnitId),
  showTestScreen: () => RNAdmobMediation.showTestScreen(),
  getVersion: (cb = () => {}) => RNAdmobMediation.getVersion(cb),
  setAge: (age) => RNAdmobMediation.setAge(age),
  setGender: (gender) => RNAdmobMediation.setGender(gender),
  setUserId: (id) => RNAdmobMediation.setUserId(id),
};
