//
//  AddLogView.swift
//  Gym Partner
//
//  Created by Shashiraj Walsetwar on 11/16/24.
//

import SwiftUI
import SwiftData

struct AddLogView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var selectedExercise = "Bench Press"
    @State private var customExercise = ""
    @State private var weight: Double = 0.0
    @State private var reps: Int = 0
    @State private var sets: Int = 0
    @State private var date = Date()
    
    // Predefined exercises
        let exercises = [
            "Bench Press",
            "Squats",
            "Deadlift",
            "Overhead Press",
            "Pull-Ups",
            "Barbell Rows",
            "Other"
        ]

    var body: some View {
        Form {
            // Picker for selecting the exercise
            Picker("Exercise", selection: $selectedExercise) {
                ForEach(exercises, id: \.self) { exercise in
                    Text(exercise)
                }
            }
            .pickerStyle(.menu)
            if selectedExercise == "Other" {
                TextField("Enter custom exercise", text: $customExercise)
                    .textFieldStyle(.roundedBorder)
            }
            Stepper("Weight: \(weight, specifier: "%.1f") kg", value: $weight, in: 0...500, step: 1)
            Stepper("Reps: \(reps)", value: $reps, in: 1...50)
            Stepper("Sets: \(sets)", value: $sets, in: 1...20)
            DatePicker("Workout Date", selection: $date, displayedComponents: .date)
                            .datePickerStyle(.compact)


            Button("Save Workout") {
            let newItem = Item(
                exerciseName: selectedExercise, // Use the selected exercise
                weight: weight,
                reps: reps,
                sets: sets,
                timestamp: date
            )
            modelContext.insert(newItem) // Save the workout to the database
            dismiss() // Close the view
        }
        .disabled(selectedExercise.isEmpty) // Disable button if exercise name is empty
        }
        .navigationTitle("Add Workout")
    }
}

#Preview {
    AddLogView()
        .modelContainer(for: Item.self, inMemory: true)
}
