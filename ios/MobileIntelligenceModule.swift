//
//  MobileIntelligenceModule.swift
//  Runner
//
//  Created by Suhail Ranger on 21/09/20.
//

import Foundation
import MobileIntelligence

@objc(MobileIntelligenceModule)
class MobileIntelligenceModule : RCTEventEmitter {
  
  @objc override init() {
    super.init()
  }
  
  @objc override func supportedEvents() -> [String]! {
    return ["init", "setupSDK", "submitData", "trackField", "silentAuth", "updateOptions", "trackTextChange", "trackFocusChange", "trackCustomData"]
  }
  
  @objc override class func requiresMainQueueSetup() -> Bool {
    return true
  }
  
  @objc func setupSDK(_ data: Any?, result: RCTPromiseResolveBlock, reject:RCTPromiseRejectBlock) -> Void {
    
    if let d = data as? [String: Any], let clientId = d["clientId"] as? String, let sessionKey = d["sessionKey"] as? String, let environment = d["environment"] as? String {
      
      let userIdHash = d["userIdHash"] as? String ?? ""
      let enableBehaviorBiometrics = d["enableBehaviorBiometrics"] as? Bool ?? true
      let enableClipboardTracking = d["enableClipboardTracking"] as? Bool ?? true
      let flow = d["flow"] as? String ?? ""
      
      
      var options = Options()
      options.clientId = clientId//"616c9cea-4801-4503-bfd7-01b37167ee4f"
      options.sessionKey = sessionKey//"d3863f93-dab5-4633-a53f-7fa8aa06b8ac"
      options.userIdHash = userIdHash
      options.flow = flow
      options.enableBehaviorBiometrics = enableBehaviorBiometrics
      options.enableClipboardTracking = enableClipboardTracking
      options.environment = environment.contains("production") ? Options.ENV_PRODUCTION : Options.ENV_SANDBOX
      
      DispatchQueue.main.async {
        MobileIntelligence(withOptions: options)
      }
      
      result(Response(status: true, message: "Initialized successfully").dictionary)
      return
    }
    result(Response(status: false, message: "Failed to initialize").dictionary)
  }
  
  @objc func trackCustomData(_ data: Any?, result: @escaping RCTPromiseResolveBlock, reject:RCTPromiseRejectBlock) -> Void  {
  // no-op, text change is automatically handled
  }
  
  @objc func trackTextChange(_ viewId: String, text: String, result: @escaping RCTPromiseResolveBlock, reject:RCTPromiseRejectBlock) -> Void  {
  // no-op, text change is automatically handled
  }
  
  @objc func trackFocusChange(_ viewId: String, isFocus: Bool, result: @escaping RCTPromiseResolveBlock, reject:RCTPromiseRejectBlock) -> Void  {
  // no-op, text change is automatically handled
  }
  
  @objc func submitData(_ result: @escaping RCTPromiseResolveBlock, reject:RCTPromiseRejectBlock) -> Void  {
    DispatchQueue.main.async {
      MobileIntelligence.submitData { (res) in
        result(res.dictionary)
      }
    }
  }
  
  @objc func updateOptions(_ data: Any?, result: @escaping RCTPromiseResolveBlock, reject:RCTPromiseRejectBlock) -> Void  {
    if let d = data as? [String: Any] {
      
      let flow = d["flow"] as? String ?? ""
      let userIdHash = d["userIdHash"] as? String ?? ""
      let sessionKey = d["sessionKey"] as? String ?? ""
      
      let options = UpdateOptions(sessionKey: sessionKey, userIdHash: userIdHash, flow: flow)
      
      MobileIntelligence.updateOptions(options: options) { response in
        result(response)
      }
    } else {
      result(Response(status: false, message: "Failed to update options").dictionary)
    }
  }
  
  @objc func trackField(_ data: Any?, result: @escaping RCTPromiseResolveBlock, reject:RCTPromiseRejectBlock) -> Void {
    if let d = data as? [String: Any], let key = d["key"] as? String, let text = d["text"] as? String {
      DispatchQueue.main.async {
        MobileIntelligence.trackField(forKey: key, text: text)
      }
      result(Response(status: true, message: "Captured successfully").dictionary)
      return
    }
    result(Response(status: false, message: "Failed to capture").dictionary)
  }
  
  @objc func silentAuth(_ data: Any?, result:  @escaping RCTPromiseResolveBlock, reject:RCTPromiseRejectBlock) -> Void {
    if let d = data as? [String: Any], let number = d["number"] as? String, let correlationId = d["correlationId"] as? String {
      MobileIntelligence.silentAuth(forNumber: number, correlationId: correlationId) { (success) in
        if success {
          result(Response(status: true, message: "Succeed").dictionary)
        } else {
          result(Response(status: false, message: "Failed").dictionary)
        }
      }
      return
    }
    
    result(Response(status: false, message: "Failed").dictionary)
  }
  
  
  override func constantsToExport() -> [AnyHashable : Any]! {
    return [
      "x": 1,
      "y": 2,
      "z": "Arbitrary string"
    ]
  }
  
}

struct Response : Codable {
  var status = true
  var message = ""
}

extension Encodable {
  var dictionary: [String: Any]? {
    guard let data = try? JSONEncoder().encode(self) else { return nil }
    return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
  }
}
