import Foundation

struct Plant: Identifiable, Hashable {
    let id: String
    let name: String
    let englishName: String
    let subtitle: String
    let description: String
    let light: String
    let water: String
    let tip: String
    let imageURL: URL

    static let all: [Plant] = [
        Plant(
            id: "monstera",
            name: "龜背芋",
            englishName: "Monstera",
            subtitle: "把熱帶的從容，帶進房間",
            description: "大大的裂葉像一扇小窗，讓平凡的角落也有雨林氣息。適合放在有明亮散射光的地方。",
            light: "明亮散射光",
            water: "土表乾了再澆透",
            tip: "每週轉動盆栽一次，葉片會長得更平均。",
            imageURL: URL(string: "https://images.unsplash.com/photo-1750341005643-e79d6ec30979?auto=format&fit=crop&w=900&q=80")!
        ),
        Plant(
            id: "pothos",
            name: "黃金葛",
            englishName: "Pothos",
            subtitle: "新手也能養好的綠色朋友",
            description: "垂墜的藤蔓很適合書架或窗邊。即使偶爾忘記照顧，也能慢慢長出新葉。",
            light: "中等到明亮散射光",
            water: "土壤上層乾燥時澆水",
            tip: "剪下帶節點的枝條放進水裡，還能繁殖新的一盆。",
            imageURL: URL(string: "https://images.unsplash.com/photo-1534726955665-2cb2d145f2ad?auto=format&fit=crop&w=900&q=80")!
        ),
        Plant(
            id: "snakeplant",
            name: "虎尾蘭",
            englishName: "Snake plant",
            subtitle: "安靜站在角落的堅強室友",
            description: "挺直的葉片有俐落的線條，很適合忙碌的生活。它耐旱，照顧時記得少即是多。",
            light: "散射光，也耐低光",
            water: "盆土完全乾燥再澆",
            tip: "別讓盆底長時間積水，這是照顧虎尾蘭最重要的事。",
            imageURL: URL(string: "https://images.unsplash.com/photo-1744255788331-98dfc8be9401?auto=format&fit=crop&w=900&q=80")!
        )
    ]
}

enum CareKind: String, Codable {
    case water
    case sunlight
    case note

    var title: String {
        switch self {
        case .water: "澆水"
        case .sunlight: "曬太陽"
        case .note: "植物筆記"
        }
    }

    var symbol: String {
        switch self {
        case .water: "drop.fill"
        case .sunlight: "sun.max.fill"
        case .note: "square.and.pencil"
        }
    }
}

struct CareRecord: Identifiable, Codable {
    var id = UUID()
    let plantID: String
    let kind: CareKind
    let date: Date
    let note: String?
}

private struct GardenState: Codable {
    var selectedPlantID = Plant.all[0].id
    var records: [CareRecord] = []
}

@MainActor
final class GardenStore: ObservableObject {
    @Published private var state: GardenState {
        didSet { save() }
    }

    private let storageKey = "PocketGarden.state.v1"

    init() {
        if ProcessInfo.processInfo.arguments.contains("-resetGardenState") {
            UserDefaults.standard.removeObject(forKey: storageKey)
        }
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let saved = try? JSONDecoder().decode(GardenState.self, from: data) {
            state = saved
        } else {
            state = GardenState()
        }
    }

    var selectedPlant: Plant {
        Plant.all.first(where: { $0.id == state.selectedPlantID }) ?? Plant.all[0]
    }

    var records: [CareRecord] { state.records.sorted { $0.date > $1.date } }

    var totalCareActions: Int { state.records.filter { $0.kind != .note }.count }

    var caredDays: Int {
        Set(state.records.filter { $0.kind != .note }.map { Calendar.current.startOfDay(for: $0.date) }).count
    }

    var growthProgress: Double {
        let careCount = state.records.filter { $0.plantID == selectedPlant.id && $0.kind != .note }.count
        return min(1, Double(careCount) / 8)
    }

    func plant(for id: String) -> Plant {
        Plant.all.first(where: { $0.id == id }) ?? Plant.all[0]
    }

    func select(_ plant: Plant) {
        state.selectedPlantID = plant.id
    }

    func didCareToday(_ kind: CareKind, plantID: String? = nil) -> Bool {
        let id = plantID ?? selectedPlant.id
        return state.records.contains {
            $0.plantID == id && $0.kind == kind && Calendar.current.isDateInToday($0.date)
        }
    }

    func record(_ kind: CareKind, note: String? = nil) {
        if kind != .note && didCareToday(kind) { return }
        let entry = CareRecord(plantID: selectedPlant.id, kind: kind, date: .now, note: note)
        state.records.insert(entry, at: 0)
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(state) else { return }
        UserDefaults.standard.set(data, forKey: storageKey)
    }
}
