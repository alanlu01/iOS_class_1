import SwiftUI

enum GardenStyle {
    static let background = Color(red: 0.976, green: 0.973, blue: 0.945)
    static let ink = Color(red: 0.125, green: 0.266, blue: 0.224)
    static let muted = Color(red: 0.443, green: 0.518, blue: 0.455)
    static let paleGreen = Color(red: 0.878, green: 0.922, blue: 0.855)
    static let sage = Color(red: 0.651, green: 0.749, blue: 0.615)
    static let peach = Color(red: 0.980, green: 0.898, blue: 0.827)
    static let terracotta = Color(red: 0.761, green: 0.388, blue: 0.267)
    static let cream = Color(red: 0.996, green: 0.994, blue: 0.977)

    static func display(_ size: CGFloat) -> Font {
        .custom("DMSerifDisplay-Regular", size: size)
    }
}

struct Eyebrow: View {
    let text: String

    var body: some View {
        Text(text.uppercased())
            .font(.system(size: 11, weight: .bold, design: .rounded))
            .tracking(2.2)
            .foregroundStyle(GardenStyle.terracotta)
    }
}

struct SectionHeading: View {
    let title: String
    let subtitle: String?

    init(_ title: String, subtitle: String? = nil) {
        self.title = title
        self.subtitle = subtitle
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.system(size: 23, weight: .bold, design: .rounded))
                .foregroundStyle(GardenStyle.ink)
            if let subtitle {
                Text(subtitle)
                    .font(.system(size: 13, design: .rounded))
                    .foregroundStyle(GardenStyle.muted)
            }
        }
    }
}

struct RemotePlantImage: View {
    let url: URL
    var height: CGFloat = 180

    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .success(let image):
                image.resizable().scaledToFill()
            case .failure:
                fallback(symbol: "leaf")
            default:
                fallback(symbol: "leaf.fill")
                    .overlay(ProgressView().tint(GardenStyle.ink))
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: height)
        .clipped()
        .accessibilityLabel("網路植物照片")
    }

    private func fallback(symbol: String) -> some View {
        Rectangle()
            .fill(GardenStyle.paleGreen)
            .overlay {
                Image(systemName: symbol)
                    .font(.system(size: 40, weight: .ultraLight))
                    .foregroundStyle(GardenStyle.ink.opacity(0.35))
            }
    }
}
