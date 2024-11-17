import SwiftUI
import Charts

struct ProgressView: View {
    let exerciseName: String
    let logs: [Item] // All workout logs for the selected exercise

    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(
                gradient: Gradient(colors: [Color.black, Color.purple.opacity(0.8)]),
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {
                // Header Section
                HStack {
                    
                    Text("Progress Chart")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                    Spacer()
                    Spacer() // Balances the back button
                }
                .padding()

                // Title
                Text("Progress for \(exerciseName)")
                    .font(.title)
                    .bold()
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.purple, Color.pink]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .shadow(color: .pink.opacity(0.4), radius: 5, x: 0, y: 5)

                // Statistics Section
                HStack(spacing: 16) {
                    StatCard(
                        title: "Growth",
                        value: "\(calculateGrowth())%",
                        icon: "chart.line.uptrend.xyaxis",
                        gradient: Gradient(colors: [Color.green.opacity(0.8), Color.green])
                    )
                    StatCard(
                        title: "Personal Best",
                        value: "\(String(format: "%.1f", calculatePersonalBest()))kg",
                        icon: "trophy.fill",
                        gradient: Gradient(colors: [Color.yellow.opacity(0.8), Color.orange])
                    )
                }
                .padding(.horizontal)

                // Additional Details Section
                VStack(alignment: .leading, spacing: 10) {
                    detailRow(title: "Starting Volume", value: "\(String(format: "%.1f", calculateStartingVolume())) kg")
                    detailRow(title: "Current Volume", value: "\(String(format: "%.1f", calculateCurrentVolume())) kg")
                    detailRow(title: "Total Sessions", value: "\(filteredLogs.count)")
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color(.systemGray6).opacity(0.2))
                        .background(BlurView(style: .systemUltraThinMaterial))
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.white.opacity(0.5), Color.purple.opacity(0.3)]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1
                                )
                        )
                        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                )
                .padding(.horizontal)

                // Chart View
                Chart {
                    ForEach(filteredLogs) { log in
                        LineMark(
                            x: .value("Date", log.timestamp, unit: .day),
                            y: .value("Volume", calculateVolume(for: log))
                        )
                        .interpolationMethod(.catmullRom) // Smooth line
                        .lineStyle(StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                        .foregroundStyle(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.blue, Color.purple]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                    }
                }
                .chartXAxis {
                    AxisMarks(position: .bottom) { _ in
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel(format: .dateTime.weekday(), centered: true)
                            .foregroundStyle(Color.white.opacity(0.8))
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .leading) { _ in
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel()
                            .foregroundStyle(Color.white.opacity(0.8))
                    }
                }
                .frame(height: 250)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color(.systemGray6).opacity(0.2))
                        .background(BlurView(style: .systemUltraThinMaterial))
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.white.opacity(0.5), Color.purple.opacity(0.3)]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1
                                )
                        )
                        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                )

                Spacer()
            }
            .padding()
        }
    }

    // MARK: - Helper Functions

    private func calculateGrowth() -> String {
        let startVolume = calculateStartingVolume()
        let currentVolume = calculateCurrentVolume()
        guard startVolume > 0 else { return "No Data" }

        let growth = ((currentVolume - startVolume) / startVolume) * 100
        return String(format: "%.1f", growth)
    }

    private func calculateVolume(for log: Item) -> Double {
        return log.weight * Double(log.reps) * Double(log.sets)
    }

    private func calculateStartingVolume() -> Double {
        guard let firstLog = filteredLogs.first else { return 0 }
        return calculateVolume(for: firstLog)
    }

    private func calculateCurrentVolume() -> Double {
        guard let lastLog = filteredLogs.last else { return 0 }
        return calculateVolume(for: lastLog)
    }

    private func calculatePersonalBest() -> Double {
        return filteredLogs.map { $0.weight }.max() ?? 0
    }

    private var filteredLogs: [Item] {
        logs.filter { $0.exerciseName == exerciseName }
    }

    // MARK: - Detail Row View
    private func detailRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.subheadline)
                .bold()
                .foregroundColor(.primary)
        }
    }
}

// MARK: - Blur Effect View
struct BlurView: UIViewRepresentable {
    let style: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

