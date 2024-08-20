import Flutter
import UIKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    private let downloadService: DownloadService = DownloadServiceImpl(downloadRepository: DownloadRepositoryImpl())
    
    private let METHOD_CHANNEL = "http_downloader/download"
    private let PROGRESS_EVENT_CHANNNEL = "http_downloader/download/progress"
    private let FINISH_EVENT_CHANNEL = "http_downloader/download/finished"
    
    static var progressEventSink: FlutterEventSink? = nil
    static var finishEventSink: FlutterEventSink? = nil
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
      
      let methodChannel = FlutterMethodChannel(name: METHOD_CHANNEL, binaryMessenger: controller.binaryMessenger)
      let progressEventChannel = FlutterEventChannel(name: PROGRESS_EVENT_CHANNNEL, binaryMessenger: controller.binaryMessenger)
      let finishEventChannel = FlutterEventChannel(name: FINISH_EVENT_CHANNEL, binaryMessenger: controller.binaryMessenger)
      
      progressEventChannel.setStreamHandler(ProgressStreamHandler())
      finishEventChannel.setStreamHandler(FinishStreamHandler())
      
      let taskQueue = controller.binaryMessenger.makeBackgroundTaskQueue?()

      methodChannel.setMethodCallHandler({
        [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
            // This method is invoked on the UI thread.
        switch(call.method) {
        case "createDownload":
            NSLog("createDownload")
        case "resumeDownload":
            NSLog("resumeDownload")
        case "cancelDownload":
            NSLog("cancelDownload")
        case "pauseDownload":
            NSLog("pauseDownload")
        case "manualPauseDownload":
            NSLog("manualPauseDownload")
        default:
            NSLog(call.method)
            result(FlutterMethodNotImplemented)
            return
        }
    })

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

class ProgressStreamHandler: NSObject, FlutterStreamHandler {
    
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        
        AppDelegate.progressEventSink = events
        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        return nil
    }
}

class FinishStreamHandler: NSObject, FlutterStreamHandler {
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        
        AppDelegate.finishEventSink = events
        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        return nil
    }
}
