import UIKit
import CallKit
import PushKit
import Flutter
import flutter_voip_push_notification
import flutter_callkit_voximplant

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, PKPushRegistryDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        self.voipRegistration()
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    /// Register for VoIP notifications
    private func voipRegistration() {
        // Create a push registry object
        let voipRegistry = PKPushRegistry(queue: DispatchQueue.main)
        // Set the registry's delegate to self
        voipRegistry.delegate = self
        // Set the push type to VoIP
        voipRegistry.desiredPushTypes = [.voIP]
    }
    
    /// Handles VoIP push
    func pushRegistry(
        _ registry: PKPushRegistry,
        didReceiveIncomingPushWith payload: PKPushPayload,
        for type: PKPushType,
        completion: @escaping () -> Void
    ) {
        processVoipPush(with: payload.dictionaryPayload, and: completion)
    }
    
    /// Handles VoIP push (deprecated version)
    func pushRegistry(
        _ registry: PKPushRegistry,
        didReceiveIncomingPushWith payload: PKPushPayload,
        for type: PKPushType
    ) {
        processVoipPush(with: payload.dictionaryPayload, and: nil)
    }
    
    /// VoIP token callback
    func pushRegistry(
        _ registry: PKPushRegistry,
        didUpdate credentials: PKPushCredentials,
        for type: PKPushType
    ) {
        // Sends the token data to the Flutter side
        FlutterVoipPushNotificationPlugin.didUpdate(credentials, forType: type.rawValue)
    }
    
    private func processVoipPush(
        with payload: Dictionary<AnyHashable, Any>,
        and completion: (() -> Void)?
    ) {
        let uuid = UUID.init()
        
        let callUpdate = CXCallUpdate()
        callUpdate.localizedCallerName = "Name Name"
        
        let configuration = CXProviderConfiguration(localizedName: "ExampleLocalizedName")
        
        FlutterCallkitPlugin.sharedInstance.reportNewIncomingCall(
            with: uuid,
            callUpdate: callUpdate,
            providerConfiguration: configuration,
            pushProcessingCompletion: completion
        )
    }
}
