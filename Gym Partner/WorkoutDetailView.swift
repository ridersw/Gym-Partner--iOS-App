//
//  WorkoutDetailView.swift
//  Gym Partner
//
//  Created by Shashiraj Walsetwar on 11/16/24.
//

import SwiftUI

struct WorkoutDetailView: View {
    let item: Item // Selected workout log
    let logs: [Item] // All workout logs for progress tracking

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Exercise: \(item.exerciseName)")
                .font(.title)
                .bold()
            Text("Weight: \(item.weight, specifier: "%.1f") kg")
                .font(.headline)
            Text("Reps: \(item.reps)")
                .font(.headline)
            Text("Sets: \(item.sets)")
                .font(.headline)
            Text("Date: \(item.timestamp.formatted(date: .abbreviated, time: .standard))")
                .font(.caption)
                .foregroundColor(.secondary)

            Spacer()

            // Navigate to Progress Chart
            NavigationLink(destination: ProgressView(exerciseName: item.exerciseName, logs: logs)) {
                Text("View Progress")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
        .navigationTitle("Workout Details")
    }
}

#Preview {
    WorkoutDetailView(
        item: Item(exerciseName: "Bench Press", weight: 75, reps: 10, sets: 3, timestamp: Date()),
        logs: []
    )
}
