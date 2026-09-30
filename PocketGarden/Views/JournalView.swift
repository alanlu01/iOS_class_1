import SwiftUI

struct JournalView: View {
    @EnvironmentObject private var garden: GardenStore

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                header
                stats
                weekStrip
                recordsSection
            }
            .padding(.horizontal, 22)
            .padding(.top, 17)
            .padding(.bottom, 35)
        }
        .background(GardenStyle.background.ignoresSafeArea())
        .toolbar(.hidden, for: .navigationBar)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Eyebrow(text: "GROWING TOGETHER")
            Text("照顧日誌")
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .foregroundStyle(GardenStyle.ink)
            Text("那些認真生活的小瞬間，都會留在這裡。")
                .font(.system(size: 14, design: .rounded))
                .foregroundStyle(GardenStyle.muted)
        }
    }

    private var stats: some View {
        HStack(spacing: 12) {
            statCard(value: garden.totalCareActions, label: "照顧次數", symbol: "heart.fill", color: GardenStyle.paleGreen)
            statCard(value: garden.caredDays, label: "照顧天數", symbol: "calendar", color: GardenStyle.peach)
        }
    }

    private func statCard(value: Int, label: String, symbol: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: symbol)
                .font(.system(size: 18))
                .foregroundStyle(GardenStyle.ink)
            Text("\(value)")
                .font(GardenStyle.display(38))
                .foregroundStyle(GardenStyle.ink)
            Text(label)
                .font(.system(size: 12, weight: .semibold, design: .rounded))
                .foregroundStyle(GardenStyle.muted)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(color, in: RoundedRectangle(cornerRadius: 20))
    }

    private var weekStrip: some View {
        VStack(alignment: .leading, spacing: 15) {
            SectionHeading("最近七天")
            HStack(spacing: 0) {
                ForEach((0..<7).reversed(), id: \.self) { offset in
                    let date = Calendar.current.date(byAdding: .day, value: -offset, to: .now) ?? .now
                    let cared = garden.records.contains {
                        $0.kind != .note && Calendar.current.isDate($0.date, inSameDayAs: date)
                    }
                    VStack(spacing: 7) {
                        Text(date.formatted(.dateTime.weekday(.narrow)))
                            .font(.system(size: 11, weight: .medium, design: .rounded))
                            .foregroundStyle(GardenStyle.muted)
                        Image(systemName: cared ? "leaf.fill" : "circle")
                            .font(.system(size: cared ? 13 : 20, weight: .light))
                            .foregroundStyle(cared ? GardenStyle.cream : GardenStyle.sage)
                            .frame(width: 34, height: 34)
                            .background(cared ? GardenStyle.ink : GardenStyle.paleGreen, in: Circle())
                        Text(date.formatted(.dateTime.day()))
                            .font(.system(size: 11, weight: .semibold, design: .rounded))
                            .foregroundStyle(GardenStyle.ink)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(18)
        .background(GardenStyle.cream, in: RoundedRectangle(cornerRadius: 22))
    }

    private var recordsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeading("所有紀錄", subtitle: "共 \(garden.records.count) 則")
            if garden.records.isEmpty {
                VStack(spacing: 10) {
                    Image(systemName: "leaf")
                        .font(.system(size: 35, weight: .ultraLight))
                        .foregroundStyle(GardenStyle.sage)
                    Text("還沒有紀錄")
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundStyle(GardenStyle.ink)
                    Text("回到花園，開始第一次照顧吧。")
                        .font(.system(size: 13, design: .rounded))
                        .foregroundStyle(GardenStyle.muted)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 34)
                .background(GardenStyle.cream, in: RoundedRectangle(cornerRadius: 21))
            } else {
                ForEach(garden.records) { record in
                    recordCard(record)
                }
            }
        }
    }

    private func recordCard(_ record: CareRecord) -> some View {
        HStack(alignment: .top, spacing: 13) {
            Image(systemName: record.kind.symbol)
                .font(.system(size: 17))
                .foregroundStyle(GardenStyle.ink)
                .frame(width: 40, height: 40)
                .background(record.kind == .sunlight ? GardenStyle.peach : GardenStyle.paleGreen, in: Circle())
            VStack(alignment: .leading, spacing: 4) {
                Text("\(garden.plant(for: record.plantID).name) · \(record.kind.title)")
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundStyle(GardenStyle.ink)
                if let note = record.note {
                    Text(note)
                        .font(.system(size: 13, design: .rounded))
                        .foregroundStyle(GardenStyle.muted)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Text(record.date.formatted(.dateTime.month(.twoDigits).day(.twoDigits).hour().minute()))
                    .font(.system(size: 11, design: .rounded))
                    .foregroundStyle(GardenStyle.muted)
            }
            Spacer(minLength: 0)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(GardenStyle.cream, in: RoundedRectangle(cornerRadius: 18))
    }
}
