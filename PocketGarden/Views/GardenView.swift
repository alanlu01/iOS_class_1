import SwiftUI

struct GardenView: View {
    @EnvironmentObject private var garden: GardenStore
    @State private var showingNoteEditor = false
    @State private var lastAction: CareKind?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 25) {
                topBar
                introduction
                heroCard
                growthCard
                careSection
                tipCard
            }
            .padding(.horizontal, 22)
            .padding(.top, 15)
            .padding(.bottom, 35)
        }
        .background(GardenStyle.background.ignoresSafeArea())
        .toolbar(.hidden, for: .navigationBar)
        .sheet(isPresented: $showingNoteEditor) {
            NoteEditorView()
                .environmentObject(garden)
                .presentationDetents([.medium, .large])
        }
        .alert(lastAction == .water ? "澆水完成！" : "曬太陽完成！", isPresented: Binding(
            get: { lastAction != nil },
            set: { if !$0 { lastAction = nil } }
        )) {
            Button("繼續照顧", role: .cancel) { lastAction = nil }
        } message: {
            Text("\(garden.selectedPlant.name)今天又多了一點元氣。照顧紀錄已存入日誌。")
        }
    }

    private var topBar: some View {
        HStack(alignment: .center) {
            HStack(spacing: 8) {
                Image(systemName: "leaf.fill")
                    .font(.system(size: 15, weight: .semibold))
                    .frame(width: 32, height: 32)
                    .foregroundStyle(GardenStyle.cream)
                    .background(GardenStyle.ink, in: Circle())
                Text("植日")
                    .font(.system(size: 23, weight: .bold, design: .rounded))
                    .foregroundStyle(GardenStyle.ink)
                Text("POCKET GARDEN")
                    .font(GardenStyle.display(10))
                    .tracking(0.6)
                    .foregroundStyle(GardenStyle.muted)
            }
            Spacer()
            Text(Date.now.formatted(.dateTime.month(.twoDigits).day(.twoDigits)))
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .foregroundStyle(GardenStyle.ink)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(GardenStyle.cream, in: Capsule())
        }
    }

    private var introduction: some View {
        VStack(alignment: .leading, spacing: 8) {
            Eyebrow(text: "A LITTLE GREEN, EVERY DAY")
            Text("把日子，\n種得慢一點。")
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .lineSpacing(5)
                .foregroundStyle(GardenStyle.ink)
                .fixedSize(horizontal: false, vertical: true)
            Text("今天也來看看你的綠色朋友吧。")
                .font(.system(size: 14, design: .rounded))
                .foregroundStyle(GardenStyle.muted)
        }
        .padding(.top, 5)
    }

    private var heroCard: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                Image("GardenHero")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .bottom)
                    .clipped()
                    .accessibilityLabel("盆栽植物插畫")

                LinearGradient(
                    colors: [GardenStyle.cream.opacity(0.75), .clear, GardenStyle.ink.opacity(0.6)],
                    startPoint: .top,
                    endPoint: .bottom
                )

                VStack(alignment: .leading, spacing: 5) {
                    Label("我的植物", systemImage: "heart.fill")
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .padding(.horizontal, 13)
                        .padding(.vertical, 8)
                        .foregroundStyle(GardenStyle.ink)
                        .background(GardenStyle.cream.opacity(0.9), in: Capsule())
                    Spacer()
                    Text(garden.selectedPlant.englishName)
                        .font(GardenStyle.display(17))
                        .foregroundStyle(GardenStyle.cream.opacity(0.85))
                    Text(garden.selectedPlant.name)
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                        .foregroundStyle(GardenStyle.cream)
                    Text("一起慢慢長大")
                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                        .foregroundStyle(GardenStyle.cream.opacity(0.9))
                }
                .padding(21)
            }
            .clipShape(RoundedRectangle(cornerRadius: 26))
        }
        .frame(height: 340)
    }

    private var growthCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                SectionHeading("成長紀錄", subtitle: "每一次照顧，都算數")
                Spacer()
                Text("\(Int(garden.growthProgress * 100))%")
                    .font(GardenStyle.display(29))
                    .foregroundStyle(GardenStyle.terracotta)
            }
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule().fill(GardenStyle.paleGreen)
                    Capsule().fill(GardenStyle.ink)
                        .frame(width: max(8, geometry.size.width * garden.growthProgress))
                }
            }
            .frame(height: 8)
            Text("累積 8 次照顧，就讓這株植物的成長條填滿。")
                .font(.system(size: 12, design: .rounded))
                .foregroundStyle(GardenStyle.muted)
        }
        .padding(19)
        .background(GardenStyle.cream, in: RoundedRectangle(cornerRadius: 22))
    }

    private var careSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeading("今天的照顧", subtitle: "一點點心意，剛剛好")
            HStack(spacing: 12) {
                careButton(kind: .water, title: "澆一點水", subtitle: "讓葉子喝飽", color: GardenStyle.paleGreen)
                careButton(kind: .sunlight, title: "曬曬太陽", subtitle: "收集今日陽光", color: GardenStyle.peach)
            }
            Button {
                showingNoteEditor = true
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: "square.and.pencil")
                        .font(.system(size: 18))
                    Text("寫一則植物筆記")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                    Spacer()
                    Image(systemName: "arrow.up.right")
                        .font(.system(size: 12, weight: .bold))
                }
                .foregroundStyle(GardenStyle.ink)
                .padding(17)
                .background(GardenStyle.cream, in: RoundedRectangle(cornerRadius: 18))
            }
            .buttonStyle(.plain)
            .accessibilityIdentifier("addNoteButton")
        }
    }

    private func careButton(kind: CareKind, title: String, subtitle: String, color: Color) -> some View {
        let complete = garden.didCareToday(kind)
        return Button {
            garden.record(kind)
            lastAction = kind
        } label: {
            VStack(alignment: .leading, spacing: 13) {
                Image(systemName: complete ? "checkmark.circle.fill" : kind.symbol)
                    .font(.system(size: 27))
                    .frame(height: 32)
                VStack(alignment: .leading, spacing: 3) {
                    Text(complete ? "今日已完成" : title)
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                    Text(complete ? "明天再來看看" : subtitle)
                        .font(.system(size: 11, design: .rounded))
                        .opacity(0.76)
                }
            }
            .foregroundStyle(GardenStyle.ink)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(18)
            .frame(height: 122)
            .background(color, in: RoundedRectangle(cornerRadius: 20))
        }
        .buttonStyle(.plain)
        .disabled(complete)
        .accessibilityIdentifier(kind == .water ? "waterButton" : "sunlightButton")
    }

    private var tipCard: some View {
        HStack(alignment: .top, spacing: 13) {
            Image(systemName: "lightbulb.fill")
                .font(.system(size: 18))
                .foregroundStyle(GardenStyle.terracotta)
                .frame(width: 38, height: 38)
                .background(GardenStyle.peach, in: Circle())
            VStack(alignment: .leading, spacing: 5) {
                Text("今日小知識")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundStyle(GardenStyle.ink)
                Text(garden.selectedPlant.tip)
                    .font(.system(size: 13, design: .rounded))
                    .foregroundStyle(GardenStyle.muted)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer(minLength: 0)
        }
        .padding(18)
        .background(GardenStyle.cream, in: RoundedRectangle(cornerRadius: 20))
    }
}

private struct NoteEditorView: View {
    @EnvironmentObject private var garden: GardenStore
    @Environment(\.dismiss) private var dismiss
    @State private var text = ""

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 15) {
                Eyebrow(text: "GARDEN NOTES")
                Text("記下今天的發現")
                    .font(.system(size: 27, weight: .bold, design: .rounded))
                    .foregroundStyle(GardenStyle.ink)
                TextEditor(text: $text)
                    .scrollContentBackground(.hidden)
                    .padding(10)
                    .background(GardenStyle.cream, in: RoundedRectangle(cornerRadius: 18))
                    .accessibilityIdentifier("noteTextEditor")
                Text("例如：長出了新葉、換了靠窗的位置……")
                    .font(.system(size: 12, design: .rounded))
                    .foregroundStyle(GardenStyle.muted)
                Spacer(minLength: 0)
            }
            .padding(22)
            .background(GardenStyle.background.ignoresSafeArea())
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("取消") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("儲存") {
                        garden.record(.note, note: text.trimmingCharacters(in: .whitespacesAndNewlines))
                        dismiss()
                    }
                    .fontWeight(.bold)
                    .disabled(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    .accessibilityIdentifier("saveNoteButton")
                }
            }
        }
        .tint(GardenStyle.ink)
    }
}
