import Flutter
import UIKit

import Netverify

public class SwiftJumioFlutterPlugin: NSObject, FlutterPlugin, NetverifyViewControllerDelegate {
  var netverifyViewController:NetverifyViewController?
  var result: FlutterResult?
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "com.fondeadora.mobile/jumio_flutter", binaryMessenger: registrar.messenger())
    let instance = SwiftJumioFlutterPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard call.method == "scanDocument" else {
        result(FlutterMethodNotImplemented)
        return
    }
    
    if(call.method == "scanDocument"){
      self.result = result
      
      if let args = call.arguments as? [String: Any],
        
        let apiKey = args["apiKey"] as? String,
        let apiSecret = args["apiSecret"] as? String,
        let scanReference = args["scanReference"] as? String,
        let userReference = args["userReference"] as? String {
        
        self.initializeSdk(apiKey:apiKey, apiSecret: apiSecret, scanReference: scanReference, userReference: userReference)
        
      } else {
        self.result?(nil)
      }
    }
  }
    
  private func initializeSdk(apiKey: String, apiSecret:String, scanReference: String, userReference:String) {
    
    let config:NetverifyConfiguration = NetverifyConfiguration()
    config.delegate = self
    
    config.apiToken = apiKey
    config.apiSecret = apiSecret
    
    config.dataCenter = JumioDataCenterUS
    
    let alpha3CountryCode = ISOCountryConverter.convert(toAlpha3: "MX")
    config.preselectedCountry = alpha3CountryCode
    
    var documentTypes: NetverifyDocumentType = []
    documentTypes.insert(.identityCard)
    documentTypes.insert(.passport)
    config.preselectedDocumentTypes = documentTypes
    
    config.customerInternalReference = scanReference
    config.userReference = userReference
    
    config.cameraPosition = JumioCameraPositionBack
    config.statusBarStyle = UIStatusBarStyle.lightContent
    config.sendDebugInfoToJumio = false
    
    self.netverifyViewController = NetverifyViewController(configuration: config)
    
    if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad) {
      self.netverifyViewController?.modalPresentationStyle = UIModalPresentationStyle.formSheet;
    }
  }
    
  private func scanDocument() {
    let window: UIWindow = ((UIApplication.shared.delegate?.window)!)!
    window.rootViewController!.present(self.netverifyViewController!, animated: true, completion: nil)
  }
  
  public func netverifyViewController(_ netverifyViewController: NetverifyViewController, didFinishInitializingWithError error: NetverifyError?) {
    self.scanDocument()
  }
  
  public func netverifyViewController(_ netverifyViewController: NetverifyViewController, didFinishWith documentData: NetverifyDocumentData, scanReference: String) {
    
    let resultDict = self.mapResultData(scanReference: scanReference, documentData: documentData)
    
    self.netverifyViewController?.dismiss(animated: true) {
      self.netverifyViewController?.destroy()
      self.netverifyViewController = nil
    }
    
    self.result?(resultDict)
  }
  
  public func netverifyViewController(_ netverifyViewController: NetverifyViewController, didCancelWithError error: NetverifyError?, scanReference: String?) {
    
    self.netverifyViewController?.dismiss(animated: true) {
      self.netverifyViewController?.destroy()
      self.netverifyViewController = nil
        
      self.result?(nil)
    }
  }
  
  private func mapResultData(scanReference: String, documentData: NetverifyDocumentData) -> Dictionary<String,String> {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    
    var resultDict: [String: String] = [:]
    
    resultDict["scanReference"] = scanReference
    resultDict["addressLine"] = documentData.addressLine
    resultDict["city"] = documentData.city
    resultDict["firstName"] = documentData.firstName
    resultDict["idNumber"] = documentData.idNumber
    resultDict["issuingCountry"] = documentData.issuingCountry
    resultDict["lastName"] = documentData.lastName
    resultDict["optionalData1"] = documentData.optionalData1
    resultDict["optionalData2"] = documentData.optionalData2
    resultDict["originatingCountry"] = documentData.originatingCountry
    resultDict["personalNumber"] = documentData.personalNumber
    resultDict["postCode"] = documentData.postCode
    resultDict["selectedCountry"] = documentData.selectedCountry
    
    if let date = documentData.expiryDate {
      resultDict["expiryDate"] = dateFormatter.string(from: date)
    } else {
      resultDict["expiryDate"] = nil
    }
    
    var genderStr:String
    switch (documentData.gender) {
    case .unknown:
      genderStr = ""
    case .F:
      genderStr = "F"
    case .M:
      genderStr = "M"
    case .X:
      genderStr = "X"
    default:
      genderStr = ""
    }
    resultDict["gender"] = genderStr
    
    var documentTypeStr:String
    switch (documentData.selectedDocumentType) {
    case .driverLicense:
      documentTypeStr = "DRIVER_LICENSE"
      break;
    case .identityCard:
      documentTypeStr = "IDENTITY_CARD"
      break;
    case .passport:
      documentTypeStr = "PASSPORT"
      break;
    case .visa:
      documentTypeStr = "VISA"
      break;
    default:
      documentTypeStr = ""
      break;
    }
    resultDict["selectedDocumentType"] = documentTypeStr
    
    resultDict["mrzLine1"] = documentData.mrzData?.line1
    resultDict["mrzLine2"] = documentData.mrzData?.line2
    resultDict["mrzLine3"] = documentData.mrzData?.line3
    
    return resultDict
  }
    
}
