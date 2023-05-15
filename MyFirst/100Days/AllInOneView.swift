//
//  MapView.swift
//  MyFirst
//
//  Created by MAC on 21.02.2023.
//

import SwiftUI
import CoreLocation
import UserNotifications
import CoreHaptics

class LocationFetcher: NSObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    var lastKnownLocation: CLLocationCoordinate2D?

    override init() {
        super.init()
        manager.delegate = self
    }

    func start() {
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastKnownLocation = locations.first?.coordinate
    }
}


struct AllInOneView: View {
    
    let locationFetcher = LocationFetcher()
    @State private var engine: CHHapticEngine?

    
    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
        }
    }
    
    func simpleSuccess() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    func complexSuccess() {
        // make sure that the device supports haptics
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        var events = [CHHapticEvent]()

        // create one intense, sharp tap
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
        events.append(event)

        // convert those events into a pattern and play it immediately
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
    }
    
    func complexSuccess2() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        var events = [CHHapticEvent]()

        for i in stride(from: 0, to: 1, by: 0.1) {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(i))
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(i))
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: i)
            events.append(event)
        }

        for i in stride(from: 0, to: 1, by: 0.1) {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(1 - i))
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(1 - i))
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 1 + i)
            events.append(event)
        }

        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
    }

        var body: some View {
            ZStack {
                Color.mint.ignoresSafeArea()
                VStack {
                    ZStack {
                        Rectangle()
                            .frame(width: 360, height: 140)
                            .cornerRadius(40)
                            .foregroundStyle(.ultraThickMaterial)
                        Text("MapKit").offset(y: -45).bold()
                        VStack(spacing: 10) {
                            Button("Start Tracking Location") {
                                locationFetcher.start()
                            }

                            Button("Read Location") {
                                if let location = locationFetcher.lastKnownLocation {
                                    print("Your location is \(location)")
                                } else {
                                    print("Your location is unknown")
                                }
                            }
                        }
                    }
                    
                    ZStack {
                        Rectangle()
                            .frame(width: 360, height: 140)
                            .cornerRadius(40)
                            .foregroundStyle(.ultraThickMaterial)
                        Text("Notifications").offset(y: -45).bold()
                        VStack(spacing: 10) {
                            Button("Request Permission") {
                                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                                    if success {
                                        print("All set!")
                                    } else if let error = error {
                                        print(error.localizedDescription)
                                    }
                                }                }

                            Button("5 sec Notification") {
                                let content = UNMutableNotificationContent()
                                content.title = "New notification"
                                content.subtitle = "It's working !!"
                                content.sound = UNNotificationSound.default

                                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

                                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

                                UNUserNotificationCenter.current().add(request)
                            }
                        }
                    }
                    VStack(spacing: 20){
                        Group {
                            Text("Test Vibro").onAppear(perform: prepareHaptics)
                                .onTapGesture(perform: complexSuccess)
                            Text("Custom Vibro").onAppear(perform: prepareHaptics)
                                .onTapGesture(perform: complexSuccess2)
                            Text("UIKit haptic").onTapGesture(perform: simpleSuccess)
                        }
                    }
                    
                    
                    
                }
            }
        }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        AllInOneView()
    }
}
