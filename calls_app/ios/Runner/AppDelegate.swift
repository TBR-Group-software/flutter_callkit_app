import os.log
import UIKit
import CallKit
import PushKit
import Flutter
import flutter_voip_push_notification
import flutter_callkit_voximplant

enum ParsingError: Error {
    case runtimeError(String)
}

struct CallData {
    var channelId: String?
    var callerId: String?
    var callerPhone: String?
    var callerName: String?
    var hasVideo: Bool?
    
    init(with dictionary: [AnyHashable: Any]) throws {
        channelId = dictionary["channel_id"] as? String
        callerId = dictionary["caller_id"] as? String
        callerPhone = dictionary["caller_phone"] as? String
        callerName = dictionary["caller_name"] as? String
        hasVideo = dictionary["has_video"] as? Bool
    }
    
    var dictionary: [String: Any?] {
        return ["channelId": channelId,
                "callerId": callerId,
                "callerPhone": callerPhone,
                "callerName": callerName,
                "hasVideo": hasVideo]
    }
}

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, PKPushRegistryDelegate {
    private let osLog = OSLog(subsystem: "InAppCallDemo", category: "AppDelegate")
    
    private lazy var flutterEngine = FlutterEngine()
    
    private let callDataChannelName = "in_app_calls_demo/call_data"
    private let getCallDataMethod = "getCallData"
    
    private var callsDict: [String: CallData] = [:]
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller = window?.rootViewController as! FlutterViewController
        let callDataChannel = FlutterMethodChannel(name: callDataChannelName, binaryMessenger: controller.binaryMessenger)
        callDataChannel.setMethodCallHandler(handleCallDataMethodCall)
        
        GeneratedPluginRegistrant.register(with: self)
        self.voipRegistration()
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func handleCallDataMethodCall (
        call: FlutterMethodCall,
        result: @escaping FlutterResult
    ) {
        switch call.method {
        case getCallDataMethod:
            getCallData(arguments: call.arguments, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func getCallData(arguments: Any?, result: FlutterResult) {
        os_log("getCallData is called", log: osLog, type: .debug)
        
        
        guard let arguments = arguments as? Dictionary<String, Any> else {
            result(FlutterError.init(code: "invalidArgs",
                                     message: "Invalid argument has been passed",
                                     details: "Dictionary<String, Any> is expected but got \(type(of: arguments))"))
            return
        }
        guard let callId = arguments["callId"] as? String else {
            result(FlutterError.init(code: "invalidArgs",
                                     message: "Invalid argument has been passed",
                                     details: "String is expected but got \(type(of: arguments["callId"]))"))
            return
        }
        let callData = callsDict[callId]
        
        result(callData?.dictionary)
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
        os_log("_:didReceiveIncomingPushWith:for:completion: is called", log: osLog, type: .debug)
        processVoipPush(with: payload.dictionaryPayload, and: completion)
    }
    
    /// Handles VoIP push (deprecated version)
    func pushRegistry(
        _ registry: PKPushRegistry,
        didReceiveIncomingPushWith payload: PKPushPayload,
        for type: PKPushType
    ) {
        os_log("_:didReceiveIncomingPushWith:for: is called", log: osLog, type: .debug)
        processVoipPush(with: payload.dictionaryPayload, and: nil)
    }
    
    /// VoIP token callback
    func pushRegistry(
        _ registry: PKPushRegistry,
        didUpdate credentials: PKPushCredentials,
        for type: PKPushType
    ) {
        os_log("_:didUpdate:for: is called", log: osLog, type: .debug)
        
        // Sends the token data to the Flutter side
        FlutterVoipPushNotificationPlugin.didUpdate(credentials, forType: type.rawValue)
    }
    
    private func processVoipPush(
        with payload: [AnyHashable: Any],
        and completion: (() -> Void)?
    ) {
        os_log("processVoipPush received push payload %@", log: osLog, type: .debug, payload.description)

        guard let callData = try? parseCallDataFromVoipNotification(with: payload) else {
            os_log("processVoipPush parsing call data error", log: osLog, type: .debug)
            completion?()
            return
        }
        
        let uuid = UUID.init()
        callsDict[uuid.uuidString] = callData
        
        let callUpdate = CXCallUpdate()
        callUpdate.localizedCallerName = callData.callerName
        callUpdate.remoteHandle = CXHandle(type: .generic, value: callData.callerId ?? "Unknown")
        callUpdate.supportsHolding = false
        callUpdate.supportsGrouping = false
        callUpdate.supportsUngrouping = false
        callUpdate.supportsDTMF = false
        callUpdate.hasVideo = callData.hasVideo ?? false
        
        let configuration = CXProviderConfiguration(localizedName: "InAppCallsDemo")
        configuration.includesCallsInRecents = true
        configuration.supportsVideo = callData.hasVideo ?? false
        
        // If Flutter engine was inactive, then calling flutterEngine.run() will enable it.
        // It is needed to start Flutter UI running when app receives the call in the killed mode.
        if (UIApplication.shared.applicationState == .inactive) {
            flutterEngine.run()
        }
        
        FlutterCallkitPlugin.sharedInstance.reportNewIncomingCall(
            with: uuid,
            callUpdate: callUpdate,
            providerConfiguration: configuration,
            pushProcessingCompletion: completion
        )
    }
    
    private func parseCallDataFromVoipNotification(
        with payload: [AnyHashable: Any]
    ) throws -> CallData {
        guard let customData = payload["custom"] as? [AnyHashable: Any] else {
            os_log("parseCallDataFromVoipNotification custom data parsing error", log: osLog, type: .debug)
            throw ParsingError.runtimeError("Custom data parsing error")
        }
        guard let additionalData = customData["a"] as? [AnyHashable: Any] else {
            os_log("parseCallDataFromVoipNotification additional data parsing error", log: osLog, type: .debug)
            throw ParsingError.runtimeError("Additional data parsing error")
        }
        return try CallData.init(with: additionalData)
    }
}
