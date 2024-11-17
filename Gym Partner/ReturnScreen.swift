import SwiftUI
import SwiftData

struct ReturnScreen: View {
    @AppStorage("username") private var username: String = ""

    // Fetch workout logs
    @Query private var items: [Item]

    // Computed properties for stats
    private var totalWorkouts: Int {
        items.count
    }

    private var currentStreak: Int {
        calculateCurrentStreak()
    }

    var body: some View {
        NavigationView {
            ZStack {
                // Background
                LinearGradient(
                    gradient: Gradient(colors: [Color.black, Color.purple]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 40) {
                    // Welcome Back Message
                    Text("Welcome back, \(username)")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)

                    // Subtitle
                    Text("Ready to crush your workout?")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.8))

                    // Stats Cards
                    HStack(spacing: 20) {
                        StatCard(
                            title: "Current Streak",
                            value: "\(currentStreak) days",
                            icon: "sparkles",
                            gradient: Gradient(colors: [Color.purple, Color.blue])
                        )
                        StatCard(
                            title: "Total Workouts",
                            value: "\(totalWorkouts)",
                            icon: "trophy.fill",
                            gradient: Gradient(colors: [Color.orange, Color.yellow])
                        )
                    }
                    .padding(.horizontal)

                    Spacer()

                    // Navigation Button
                    NavigationLink(destination: ContentView()) {
                        Text("Go to Dashboard")
                            .font(.headline)
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.blue, Color.purple]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .foregroundColor(.white)
                            .cornerRadius(15)
                            .padding(.horizontal, 40)
                            .shadow(color: .purple.opacity(0.5), radius: 5, x: 0, y: 5)
                    }
                }
                .padding(.top, 40)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Fixes navigation in landscape
    }

    // MARK: - Helper Methods

    /// Calculate the current workout streak in days
    private func calculateCurrentStreak() -> Int {
        // Sort logs by date (most recent first)
        let sortedLogs = items.sorted(by: { $0.timestamp > $1.timestamp })

        guard let mostRecentLog = sortedLogs.first else {
            return 0 // No workouts, streak is 0
        }

        var streak = 1 // Start streak at 1 for the most recent workout
        var currentDate = Calendar.current.startOfDay(for: mostRecentLog.timestamp)

        for log in sortedLogs.dropFirst() {
            let logDate = Calendar.current.startOfDay(for: log.timestamp)

            // Calculate the difference in days
            let dayDifference = Calendar.current.dateComponents([.day], from: logDate, to: currentDate).day ?? 0

            if dayDifference == 1 {
                // Log is on the previous day, increment streak
                streak += 1
                currentDate = logDate
            } else if dayDifference > 1 {
                // Break the loop if there's a gap of more than 1 day
                break
            }
        }

        return streak
    }

}

#Preview {
    ReturnScreen()
        .modelContainer(for: Item.self, inMemory: true) // Mock environment
}

