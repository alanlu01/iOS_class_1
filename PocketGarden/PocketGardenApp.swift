import SwiftUI

@main
struct PocketGardenApp: App {
    @StateObject private var garden = GardenStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(garden)
        }
    }
}
