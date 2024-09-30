import Flutter
import UIKit
import GoogleMaps
import AVFoundation



@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      
    GeneratedPluginRegistrant.register(with: self)
      do {
          try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
          try AVAudioSession.sharedInstance().setActive(true)
      } catch {
          print("Failed to set up AVAudioSession.")
      }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
