import SwiftUI

struct PlantLibraryView: View {
    @EnvironmentObject private var garden: GardenStore

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                header
                ForEach(Plant.all) { plant in
                    NavigationLink(value: plant) {
                        plantCard(plant)
                    }
                    .buttonStyle(.plain)
                    .accessibilityIdentifier("plantCard_\(plant.id)")
                }
                Text("照片由 Unsplash 提供，需連接網路載入。")
                    .font(.system(size: 11, design: .rounded))
                    .foregroundStyle(GardenStyle.muted)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 2)
            }
            .padding(.horizontal, 22)
            .padding(.top, 17)
            .padding(.bottom, 32)
        }
        .background(GardenStyle.background.ignoresSafeArea())
        .toolbar(.hidden, for: .navigationBar)
        .navigationDestination(for: Plant.self) { plant in
            PlantDetailView(plant: plant)
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Eyebrow(text: "MEET YOUR GREEN FRIENDS")
            Text("植物圖鑑")
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .foregroundStyle(GardenStyle.ink)
            Text("挑一株喜歡的植物，開始每天的小小照顧。")
                .font(.system(size: 14, design: .rounded))
                .foregroundStyle(GardenStyle.muted)
        }
    }

    private func plantCard(_ plant: Plant) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            RemotePlantImage(url: plant.imageURL, height: 190)
                .overlay(alignment: .topTrailing) {
                    if garden.selectedPlant.id == plant.id {
                        Text("我的植物")
                            .font(.system(size: 11, weight: .bold, design: .rounded))
                            .foregroundStyle(GardenStyle.ink)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(GardenStyle.cream, in: Capsule())
                            .padding(13)
                    }
                }
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(plant.englishName)
                        .font(GardenStyle.display(17))
                        .foregroundStyle(GardenStyle.terracotta)
                    Text(plant.name)
                        .font(.system(size: 23, weight: .bold, design: .rounded))
                        .foregroundStyle(GardenStyle.ink)
                    Text(plant.subtitle)
                        .font(.system(size: 12, design: .rounded))
                        .foregroundStyle(GardenStyle.muted)
                }
                Spacer()
                Image(systemName: "arrow.up.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(GardenStyle.ink)
                    .frame(width: 35, height: 35)
                    .background(GardenStyle.paleGreen, in: Circle())
            }
            .padding(17)
        }
        .background(GardenStyle.cream, in: RoundedRectangle(cornerRadius: 23))
        .clipShape(RoundedRectangle(cornerRadius: 23))
    }
}

private struct PlantDetailView: View {
    @EnvironmentObject private var garden: GardenStore
    @Environment(\.dismiss) private var dismiss
    let plant: Plant

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                RemotePlantImage(url: plant.imageURL, height: 300)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .padding(.bottom, 25)

                Eyebrow(text: plant.englishName)
                Text(plant.name)
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundStyle(GardenStyle.ink)
                    .padding(.top, 5)
                Text(plant.subtitle)
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundStyle(GardenStyle.terracotta)
                    .padding(.top, 5)
                Text(plant.description)
                    .font(.system(size: 15, design: .rounded))
                    .lineSpacing(6)
                    .foregroundStyle(GardenStyle.ink)
                    .padding(.top, 17)

                VStack(alignment: .leading, spacing: 14) {
                    SectionHeading("照顧小卡")
                    careRow(symbol: "sun.max.fill", title: "光線", detail: plant.light)
                    careRow(symbol: "drop.fill", title: "水分", detail: plant.water)
                    careRow(symbol: "heart.text.square.fill", title: "小提醒", detail: plant.tip)
                }
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(GardenStyle.cream, in: RoundedRectangle(cornerRadius: 22))
                .padding(.top, 25)

                Button {
                    garden.select(plant)
                    dismiss()
                } label: {
                    HStack {
                        Spacer()
                        Image(systemName: garden.selectedPlant.id == plant.id ? "checkmark" : "leaf.fill")
                        Text(garden.selectedPlant.id == plant.id ? "正在照顧這株植物" : "選這株當我的植物")
                        Spacer()
                    }
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundStyle(GardenStyle.cream)
                    .padding(18)
                    .background(GardenStyle.ink, in: RoundedRectangle(cornerRadius: 18))
                }
                .buttonStyle(.plain)
                .accessibilityIdentifier("selectPlantButton")
                .padding(.top, 22)
            }
            .padding(.horizontal, 22)
            .padding(.top, 14)
            .padding(.bottom, 35)
        }
        .background(GardenStyle.background.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("植物小檔案")
                    .font(.system(size: 15, weight: .bold, design: .rounded))
            }
        }
    }

    private func careRow(symbol: String, title: String, detail: String) -> some View {
        HStack(alignment: .top, spacing: 13) {
            Image(systemName: symbol)
                .font(.system(size: 16))
                .foregroundStyle(GardenStyle.terracotta)
                .frame(width: 28)
            Text(title)
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundStyle(GardenStyle.ink)
                .frame(width: 44, alignment: .leading)
            Text(detail)
                .font(.system(size: 14, design: .rounded))
                .foregroundStyle(GardenStyle.muted)
            Spacer(minLength: 0)
        }
    }
}
