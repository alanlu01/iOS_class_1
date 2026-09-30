import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationStack {
                GardenView()
            }
            .tabItem { Label("我的花園", systemImage: "leaf.fill") }

            NavigationStack {
                PlantLibraryView()
            }
            .tabItem { Label("植物圖鑑", systemImage: "square.grid.2x2.fill") }

            NavigationStack {
                JournalView()
            }
            .tabItem { Label("照顧日誌", systemImage: "book.closed.fill") }
        }
        .tint(GardenStyle.ink)
    }
}
