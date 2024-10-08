import Tapjoy
import Vrtcal_Adapters_Wrapper_Parent

// Must be NSObject for TJPlacementDelegate
class VrtcalTapjoyAdaptersWrapper: NSObject, AdapterWrapperProtocol {
    
    var appLogger: Logger
    var sdkEventsLogger: Logger
    var sdk = SDK.tapjoy
    var delegate: AdapterWrapperDelegate
    var tjPlacement: TJPlacement?
    
    required init(
        appLogger: Logger,
        sdkEventsLogger: Logger,
        delegate: AdapterWrapperDelegate
    ) {
        self.appLogger = appLogger
        self.sdkEventsLogger = sdkEventsLogger
        self.delegate = delegate
    }
    
    func initializeSdk() {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(tjcConnectSuccess(notif:)),
            name: NSNotification.Name(rawValue: TJC_CONNECT_SUCCESS), 
            object: nil
        )
            
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(tjcConnectFail(notif:)),
            name: NSNotification.Name(rawValue: TJC_CONNECT_FAILED),
            object: nil
        )
        
        // Enable Debug
        Tapjoy.setDebugEnabled(true)

        // Edit the global privacy singleton
        let tjPrivacyPolicy = Tapjoy.getPrivacyPolicy()
        tjPrivacyPolicy.subjectToGDPRStatus = .false
        tjPrivacyPolicy.userConsentStatus = .true
        tjPrivacyPolicy.belowConsentAgeStatus = .false
        tjPrivacyPolicy.usPrivacy = "1---"
        
        // Twitmore's SDK Key
        // https://ltv.tapjoy.com/s/627e825a-40ef-8000-8000-bedff60013c5/setting#app
        Tapjoy.connect("mbAVpNXZSzC0d9I0lTHXawEBBFpgzq63v8WLQZDHxEUgwXPlk5bvyAXjK4Sl")
    }
    
    func handle(adTechConfig: AdTechConfig) {
        
        switch adTechConfig.placementType {
                
            case .banner:
                appLogger.log("Tapjoy does not support banners")

            case .interstitial:
                appLogger.log("Tapjoy Interstitial")
                
                guard let tjPlacement = TJPlacement(
                    name: adTechConfig.adUnitId,
                    delegate: self
                ) else {
                    sdkEventsLogger.log("No placement")
                    return
                }
                tjPlacement.requestContent()
                self.tjPlacement = tjPlacement
                
            case .rewardedVideo:
                fatalError("rewardedVideo not supported for TapJoy")
                
            case .showDebugView:
                appLogger.log("TapJoy doesn't have a debug view")
        }
    }
    
    func showInterstitial() -> Bool {
        if let tjPlacement {
            tjPlacement.showContent(with: delegate.viewController)
            return true
        }
        
        return false
    }
    
    func destroyInterstitial() {
        tjPlacement = nil
    }
}

extension VrtcalTapjoyAdaptersWrapper {
    @objc func tjcConnectSuccess(notif: NSNotification) {
        sdkEventsLogger.log("Tapjoy initialized")
    }

    @objc func tjcConnectFail(notif: NSNotification) {
        sdkEventsLogger.log("Tapjoy initialization failed: \(notif)")
    }
}


extension VrtcalTapjoyAdaptersWrapper: TJPlacementDelegate {
    func requestDidSucceed(_ placement: TJPlacement) {
        sdkEventsLogger.log("Tapjoy requestDidSucceed")
    }
    
    func requestDidFail(_ placement: TJPlacement, error: Error?) {
        sdkEventsLogger.log("Tapjoy requestDidFail: \(String(describing: error))")
    }
    
    func contentIsReady(_ placement: TJPlacement) {
        sdkEventsLogger.log("Tapjoy contentIsReady")
    }

    func contentDidAppear(_ placement: TJPlacement) {
        sdkEventsLogger.log("Tapjoy contentDidAppear")
    }
    
    func contentDidDisappear(_ placement: TJPlacement) {
        sdkEventsLogger.log("Tapjoy contentDidDisappear")
    }

    func didClick(_ placement: TJPlacement) {
        sdkEventsLogger.log("Tapjoy didClick")
    }
    
    func placement(_ placement: TJPlacement, didRequestPurchase request: TJActionRequest?, productId: String?) {
        sdkEventsLogger.log("Tapjoy placement didRequestPurchase")
    }

    func placement(_ placement: TJPlacement, didRequestReward request: TJActionRequest?, itemId: String?, quantity: Int32) {
        sdkEventsLogger.log("Tapjoy placement didRequestReward")
    }
}
