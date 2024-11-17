//
//  ProgressView.swift
//  Gym Partner
//
//  Created by Shashiraj Walsetwar on 11/16/24.
//

import SwiftUI
import Charts

struct ProgressView: View {
    let exerciseName: String
    let logs: [Item]

    var body: some View {
        VStack {
            Text("Progress for \(exerciseName)")
                .font(.headline)
                .padding()

            Chart {
                ForEach(filteredLogs) { log in
                    LineMark(
                        x: .value("Date", log.timestamp),
                        y: .value("Weight", log.weight)
                    )
                    .symbol(by: .value("Date", log.timestamp)) // Optional markers for data points
                }
            }
            .chartXAxis {
                AxisMarks(position: .bottom)
            }
            .chartYAxis {
                AxisMarks(position: .leading)
            }
            .chartYAxisLabel("Weight (kg)", position: .leading, alignment: .center)
            .chartXAxisLabel("Date", position: .bottom, alignment: .center)
            .padding()

            Spacer()
        }
        .navigationTitle("Progress Chart")
    }

    // Filter logs for the selected exercise
    private var filteredLogs: [Item] {
        logs.filter { $0.exerciseName == exerciseName }
    }
}

#Preview {
    let sampleLogs = [
        Item(exerciseName: "Bench Press", weight: 70, reps: 10, sets: 3, timestamp: Date()),
        Item(exerciseName: "Bench Press", weight: 75, reps: 10, sets: 3, timestamp: Date().addingTimeInterval(-86400)),
        Item(exerciseName: "Bench Press", weight: 80, reps: 10, sets: 3, timestamp: Date().addingTimeInterval(-2 * 86400))
    ]
    return ProgressView(exerciseName: "Bench Press", logs: sampleLogs)
}
