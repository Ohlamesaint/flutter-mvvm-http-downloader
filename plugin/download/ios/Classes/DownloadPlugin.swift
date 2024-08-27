import Flutter
import UIKit

public class DownloadPlugin: NSObject, FlutterPlugin {
    
    private let downloadService: DownloadService = DownloadServiceImpl(downloadRepository: DownloadRepositoryImpl())
    
    private static let METHOD_CHANNEL = "http_downloader/download"
    private static let PROGRESS_EVENT_CHANNNEL = "http_downloader/download/progress"
    private static let FINISH_EVENT_CHANNEL = "http_downloader/download/finished"
    
    static var progressEventSink: FlutterEventSink? = nil
    static var finishEventSink: FlutterEventSink? = nil
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let methodChannel = FlutterMethodChannel(name: METHOD_CHANNEL, binaryMessenger: registrar.messenger())
        let progressEventChannel = FlutterEventChannel(name: PROGRESS_EVENT_CHANNNEL, binaryMessenger:  registrar.messenger())
        let finishEventChannel = FlutterEventChannel(name: FINISH_EVENT_CHANNEL, binaryMessenger:  registrar.messenger())
        
        progressEventChannel.setStreamHandler(ProgressStreamHandler())
        finishEventChannel.setStreamHandler(FinishStreamHandler())
      
      
        let instance = DownloadPlugin()
        registrar.addMethodCallDelegate(instance, channel: methodChannel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        NSLog(call.method)
        if call.method == "getPlatformVersion" {
            result("iOS: \(UIDevice.current.systemVersion)")
            return
        }
        guard let args = call.arguments as? [String: Any] else {
            result(FlutterError.init(code: "errorSetDebug", message: "data or format error", details: nil))
            return
        }
        
        
      switch(call.method) {
      case "createDownload":
          
          guard let urlString = args["urlString"] as? String else {
              result(FlutterError.init(code: "errorSetDebug", message: "data or format error", details: nil))
              return
          }
          guard let isConcurrent = args["isConcurrent"] as? Bool else {
              result(FlutterError.init(code: "errorSetDebug", message: "data or format error", details: nil))
              return
          }
          
          Task {
              let serviceResult: ServiceResult<Int> = await self.downloadService.createDownload(urlString: urlString, isConcurrent:  isConcurrent)
              let response = MethodChannelResponse(serviceResult: serviceResult)
              result(String(data: try JSONEncoder().encode(response), encoding: .utf8) )
          }
              
              
          
                  
      case "resumeDownload":
          guard let downloadID = args["downloadID"] as? String else {
              result(FlutterError.init(code: "errorSetDebug", message: "data or format error", details: nil))
              return
          }
          
          Task {
              do {
                  let serviceResult: ServiceResult<Int> = await self.downloadService.resumeDownload(downloadID: downloadID)
                  let response = MethodChannelResponse(serviceResult: serviceResult)
                  result(String(data: try JSONEncoder().encode(response), encoding: .utf8))
              } catch {
                  result(FlutterError.init(code: "jsonSerailizationError", message: "resumeDownload response serialization failed", details: nil))
              }
          }
          
          
          
      case "cancelDownload":
          guard let downloadID = args["downloadID"] as? String else {
              result(FlutterError.init(code: "errorSetDebug", message: "data or format error", details: nil))
              return
          }
          
          Task {
              do {
                  let serviceResult: ServiceResult<Int> = await self.downloadService.cancelDownload(downloadID: downloadID)
                  let response = MethodChannelResponse(serviceResult: serviceResult)
                  result(String(data: try JSONEncoder().encode(response), encoding: .utf8))
              } catch {
                  result(FlutterError.init(code: "jsonSerailizationError", message: "cancelDownload response serialization failed", details: nil))
              }
          }
      case "pauseDownload":
          guard let downloadID = args["downloadID"] as? String else {
              result(FlutterError.init(code: "errorSetDebug", message: "data or format error", details: nil))
              return
          }
          
          Task {
              do {
                  let serviceResult: ServiceResult<Int> = await self.downloadService.pauseDownload(downloadID: downloadID)
                  let response = MethodChannelResponse(serviceResult: serviceResult)
                  result(String(data: try JSONEncoder().encode(response), encoding: .utf8))
              } catch {
                  result(FlutterError.init(code: "jsonSerailizationError", message: "pauseDownload response serialization failed", details: nil))
              }
          }
      case "manualPauseDownload":
          guard let downloadID = args["downloadID"] as? String else {
              result(FlutterError.init(code: "errorSetDebug", message: "data or format error", details: nil))
              return
          }
          
          Task {
              do {
                  let serviceResult: ServiceResult<Int> = await self.downloadService.manualPauseDownload(downloadID: downloadID)
                  let response = MethodChannelResponse(serviceResult: serviceResult)
                  result(String(data: try JSONEncoder().encode(response), encoding: .utf8))
              } catch {
                  result(FlutterError.init(code: "jsonSerailizationError", message: "manualPauseDownload response serialization failed", details: nil))
              }
          }
      default:
          NSLog(call.method)
          result(FlutterMethodNotImplemented)
      }
    }
}

class ProgressStreamHandler: NSObject, FlutterStreamHandler {
    
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        NSLog("ProgressStreamHandler Configured")
        DownloadPlugin.progressEventSink = events
        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        return nil
    }
}

class FinishStreamHandler: NSObject, FlutterStreamHandler {
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        NSLog("FinishStreamHandler Configured")
        DownloadPlugin.finishEventSink = events
        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        return nil
    }
}
