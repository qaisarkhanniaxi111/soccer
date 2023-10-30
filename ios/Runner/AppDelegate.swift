import UIKit
import Flutter
//This Import Is For Google Maps For IOS
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
//   Google Maps API KEY For IOS
  GMSServices.provideAPIKey("AIzaSyANgTBPJjQopd8YQhA5_HV2uxLBFVY0NgE")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
