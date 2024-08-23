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
          if let urlString = args["urlString"] as? String {
              Task {
                  NSLog("Start")
                  let serviceResult: ServiceResult<Int> = await self.downloadService.createDownload(urlString: urlString)
                  let response = MethodChannelResponse(serviceResult: serviceResult)
//                  result(response)
                  
                    result(String(data: try JSONEncoder().encode(response), encoding: .utf8) )
              }
          } else {
              result(FlutterError.init(code: "errorSetDebug", message: "data or format error", details: nil))
          }
          
                  
      case "resumeDownload":
          
          result("resumeDownload")
      case "cancelDownload":
          result("cancelDownload")
      case "pauseDownload":
          result("pauseDownload")
      case "manualPauseDownload":
          result("manualPauseDownload")
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
