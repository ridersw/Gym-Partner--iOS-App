import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item] // Query to fetch workout logs from the database

    @State private var selectedExercise: String = "Bench Press" // Default selected exercise
    @State private var allExercises: [String] = [] // List of unique exercise names

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
            
                // Header
                Text("Workout Log")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.purple)
                    .padding(.horizontal)
                    .padding(.top)

                // Statistics Section
                HStack(spacing: 16) {
                    StatCard(title: "Volume", value: "\(calculateTotalVolume()) kg", icon: "chart.bar.fill", color: .green)
                    StatCard(title: "Best", value: "\(calculateBestWeight()) kg", icon: "trophy.fill", color: .yellow)
                }
                .padding(.horizontal)

                // View Progress Button
                NavigationLink(destination: ProgressView(exerciseName: selectedExercise, logs: items)) {
                    Text("View Progress")
                        .font(.headline)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.horizontal)

                // Dropdown Selector
                Picker("Exercise", selection: $selectedExercise) {
                    ForEach(allExercises, id: \.self) { exercise in
                        Text(exercise)
                    }
                }
                .pickerStyle(.menu)
                .padding(.horizontal)
                .background(RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.2)))
                .padding(.horizontal)

                // Sessions List
                List {
                    // Today's Sessions
                    let todayLogs = filterLogs(for: selectedExercise, date: Date())
                    if !todayLogs.isEmpty {
                        Section(header: Text("Today")) {
                            ForEach(todayLogs) { log in
                                NavigationLink(destination: WorkoutDetailView(item: log, logs: items)) {
                                    SessionCard(log: log, time: log.timestamp.formatted(date: .omitted, time: .shortened))
                                }
                            }
                            .onDelete(perform: { offsets in
                                deleteItems(offsets: offsets, from: todayLogs)
                            })
                        }
                    }

                    // Previous Sessions
                    let previousLogs = filterLogs(for: selectedExercise, date: nil, excludeToday: true)
                    if !previousLogs.isEmpty {
                        Section(header: Text("Previous")) {
                            ForEach(previousLogs) { log in
                                NavigationLink(destination: WorkoutDetailView(item: log, logs: items)) {
                                    SessionCard(log: log, time: log.timestamp.formatted(date: .abbreviated, time: .omitted))
                                }
                            }
                            .onDelete(perform: { offsets in
                                deleteItems(offsets: offsets, from: previousLogs)
                            })
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
            }
            .onAppear {
                loadUniqueExercises()
            }
            .navigationTitle("")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddLogView()) {
                        Image(systemName: "plus")
                            .font(.title)
                            .foregroundColor(.purple)
                    }
                }
            }
        }
    }

    // MARK: - Helper Functions

    private func calculateTotalVolume() -> Int {
        let filteredLogs = items.filter { $0.exerciseName == selectedExercise }
        let totalVolume = filteredLogs.reduce(0) { partialResult, log in
            partialResult + (log.weight * Double(log.reps * log.sets))
        }
        return Int(totalVolume.rounded())
    }

    private func calculateBestWeight() -> Int {
        let filteredLogs = items.filter { $0.exerciseName == selectedExercise }
        let maxWeight = filteredLogs.map { $0.weight }.max() ?? 0
        return Int(maxWeight)
    }

    private func loadUniqueExercises() {
        let exercises = Set(items.map { $0.exerciseName })
        allExercises = Array(exercises).sorted()
        selectedExercise = allExercises.first ?? ""
    }

    private func filterLogs(for exercise: String, date: Date?, excludeToday: Bool = false) -> [Item] {
        let filteredByExercise = items.filter { $0.exerciseName == exercise }

        let filteredByDate: [Item]
        if let date = date {
            filteredByDate = filteredByExercise.filter { Calendar.current.isDate($0.timestamp, inSameDayAs: date) }
        } else {
            filteredByDate = filteredByExercise
        }

        if excludeToday {
            return filteredByDate.filter { !Calendar.current.isDate($0.timestamp, inSameDayAs: Date()) }
        }

        return filteredByDate
    }

    private func deleteItems(offsets: IndexSet, from logs: [Item]) {
        withAnimation {
            offsets.forEach { index in
                let itemToDelete = logs[index]
                modelContext.delete(itemToDelete)
            }
        }
    }
}

// MARK: - Custom Views

/// A card displaying workout stats like volume and best weight
struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color) // Icon with the specified color
                Spacer()
            }
            Text(value)
                .font(.largeTitle)
                .bold()
                .foregroundColor(color) // Stat value with the specified color
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary) // Subtle title text
        }
        .padding()
        .frame(maxWidth: .infinity) // Ensures it stretches to fit available space
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
    }
}

/// A card displaying details of a single workout session
struct SessionCard: View {
    let log: Item
    let time: String

    var body: some View {
        HStack {
            // Weight Icon
            Circle()
                .fill(Color.purple)
                .frame(width: 40, height: 40)
                .overlay(
                    Text("\(Int(log.weight))")
                        .font(.headline)
                        .foregroundColor(.white)
                )
            VStack(alignment: .leading) {
                // Display the name of the workout
                Text(log.exerciseName)
                    .font(.headline)
                    .bold()
                // Display details like sets, reps, and weight
                Text("\(log.sets) sets · \(log.reps) reps · \(Int(log.weight))kg")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
            // Display time of the session
            Text(time)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
    }
}


#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}

