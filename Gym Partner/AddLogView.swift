//
//  AddLogView.swift
//  Gym Partner
//
//  Created by Shashiraj Walsetwar on 11/16/24.
//


//import SwiftUI
//import SwiftData
//
//struct AddLogView: View {
//    @Environment(\.modelContext) private var modelContext
//    @Environment(\.dismiss) private var dismiss
//
//    @State private var selectedExercise = "Bench Press"
//    @State private var weight: Double = 0.0
//    @State private var reps: Int = 0
//    @State private var sets: Int = 0
//    @State private var date = Date()
//
//    // Predefined exercises
//    let exercises = [
//        "Seated Row- Horizontal",
//        "Seated Row- Vertical",
//        "Lat Pull Down",
//        "Shoulder Press",
//        "Cable Lateral Raises",
//        "Tricep Pushdown",
//        "Cable Flyes",
//        "Cable Pushdowns",
//        "Bench Press",
//        "Bicep Curls",
//        "Hammer Curls",
//        "Face Pulls"
//    ]
//
//    var body: some View {
//        ZStack {
//            // Background Gradient
//            LinearGradient(
//                gradient: Gradient(colors: [Color.black, Color.purple.opacity(0.8)]),
//                startPoint: .topLeading,
//                endPoint: .bottomTrailing
//            )
//            .ignoresSafeArea()
//
//            VStack(spacing: 30) {
//                // Header with Gradient Text
//                Text("Add Workout")
//                    .font(.largeTitle)
//                    .bold()
//                    .foregroundStyle(
//                        LinearGradient(
//                            gradient: Gradient(colors: [Color.purple, Color.pink]),
//                            startPoint: .leading,
//                            endPoint: .trailing
//                        )
//                    )
//                    .shadow(color: .pink.opacity(0.4), radius: 5, x: 0, y: 5)
//
//                // Form Fields
//                VStack(spacing: 20) {
//                    // Exercise Picker
//                    VStack(alignment: .leading) {
//                        Text("Exercise")
//                            .font(.headline)
//                            .foregroundColor(.secondary)
//
//                        Picker("Select Exercise", selection: $selectedExercise) {
//                            ForEach(exercises, id: \.self) { exercise in
//                                Text(exercise).tag(exercise)
//                            }
//                        }
//                        .pickerStyle(.menu)
//                        .padding()
//                        .background(
//                            RoundedRectangle(cornerRadius: 12)
//                                .fill(Color(.systemGray6).opacity(0.3))
//                        )
//                    }
//
//                    // Weight
//                    HStack {
//                        Text("Weight (kg):")
//                            .font(.headline)
//                            .foregroundColor(.secondary)
//                        Spacer()
//                        TextField("0", value: $weight, format: .number)
//                            .keyboardType(.decimalPad)
//                            .padding()
//                            .frame(width: 100)
//                            .background(
//                                RoundedRectangle(cornerRadius: 8)
//                                    .fill(Color(.systemGray6).opacity(0.3))
//                            )
//                            .foregroundColor(.primary)
//                    }
//
//                    // Reps
//                    HStack {
//                        Text("Reps:")
//                            .font(.headline)
//                            .foregroundColor(.secondary)
//                        Spacer()
//                        TextField("0", value: $reps, format: .number)
//                            .keyboardType(.numberPad)
//                            .padding()
//                            .frame(width: 100)
//                            .background(
//                                RoundedRectangle(cornerRadius: 8)
//                                    .fill(Color(.systemGray6).opacity(0.3))
//                            )
//                            .foregroundColor(.primary)
//                    }
//
//                    // Sets
//                    HStack {
//                        Text("Sets:")
//                            .font(.headline)
//                            .foregroundColor(.secondary)
//                        Spacer()
//                        TextField("0", value: $sets, format: .number)
//                            .keyboardType(.numberPad)
//                            .padding()
//                            .frame(width: 100)
//                            .background(
//                                RoundedRectangle(cornerRadius: 8)
//                                    .fill(Color(.systemGray6).opacity(0.3))
//                            )
//                            .foregroundColor(.primary)
//                    }
//
//                    // Date Picker
//                    HStack {
//                        Text("Date:")
//                            .font(.headline)
//                            .foregroundColor(.secondary)
//                        Spacer()
//                        DatePicker("", selection: $date, displayedComponents: .date)
//                            .labelsHidden()
//                    }
//                }
//                .padding()
//
//                Spacer()
//
//                // Save Button
//                Button(action: saveLog) {
//                    Text("Save Workout")
//                        .font(.headline)
//                        .bold()
//                        .frame(maxWidth: .infinity)
//                        .padding()
//                        .background(
//                            LinearGradient(
//                                gradient: Gradient(colors: [Color.purple, Color.pink]),
//                                startPoint: .leading,
//                                endPoint: .trailing
//                            )
//                        )
//                        .foregroundColor(.white)
//                        .cornerRadius(15)
//                        .shadow(color: Color.purple.opacity(0.6), radius: 10, x: 0, y: 5)
//                }
//                .padding(.horizontal)
//            }
//            .padding()
//        }
//    }
//
//    private func saveLog() {
//        guard !selectedExercise.isEmpty, weight > 0, reps > 0, sets > 0 else {
//            return
//        }
//
//        let newItem = Item(
//            exerciseName: selectedExercise,
//            weight: weight,
//            reps: reps,
//            sets: sets,
//            timestamp: date
//        )
//        modelContext.insert(newItem)
//        dismiss()
//    }
//}


import SwiftUI
import SwiftData

struct AddLogView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var selectedExercise = "Bench Press"
    @State private var weight: Double = 0.0
    @State private var reps: Int = 0
    @State private var sets: Int = 0
    @State private var date = Date()

    // Alert State
    @State private var showAlert = false
    @State private var alertMessage = ""

    // Predefined exercises
    let exercises = [
        "Bench Press",
        "Squats",
        "Deadlift",
        "Overhead Press",
        "Pull-Ups",
        "Barbell Rows"
    ]

    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(
                gradient: Gradient(colors: [Color.black, Color.purple.opacity(0.8)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    Text("Add Workout")
                        .font(.largeTitle)
                        .bold()
                        .foregroundStyle(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.purple, Color.pink]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .shadow(color: .pink.opacity(0.4), radius: 5, x: 0, y: 5)

                    // Form Fields
                    VStack(spacing: 15) {
                        // Exercise Picker
                        VStack(alignment: .leading) {
                            Text("Exercise")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            Picker("Select Exercise", selection: $selectedExercise) {
                                ForEach(exercises, id: \.self) { exercise in
                                    Text(exercise).tag(exercise)
                                }
                            }
                            .pickerStyle(.menu)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(.systemGray6).opacity(0.3))
                            )
                        }

                        // Weight
                        HStack {
                            Text("Weight (kg):")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            Spacer()
                            TextField("0", value: $weight, format: .number)
                                .keyboardType(.decimalPad)
                                .padding()
                                .frame(width: 100)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color(.systemGray6).opacity(0.3))
                                )
                                .foregroundColor(.primary)
                        }

                        // Reps
                        HStack {
                            Text("Reps:")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            Spacer()
                            TextField("0", value: $reps, format: .number)
                                .keyboardType(.numberPad)
                                .padding()
                                .frame(width: 100)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color(.systemGray6).opacity(0.3))
                                )
                                .foregroundColor(.primary)
                        }

                        // Sets
                        HStack {
                            Text("Sets:")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            Spacer()
                            TextField("0", value: $sets, format: .number)
                                .keyboardType(.numberPad)
                                .padding()
                                .frame(width: 100)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color(.systemGray6).opacity(0.3))
                                )
                                .foregroundColor(.primary)
                        }

                        // Date Picker
                        HStack {
                            Text("Date:")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            Spacer()
                            DatePicker("", selection: $date, displayedComponents: .date)
                                .labelsHidden()
                        }
                    }
                    .padding()

                    Spacer()

                    // Save Button
                    Button(action: saveLog) {
                        Text("Save Workout")
                            .font(.headline)
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.purple, Color.pink]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .foregroundColor(.white)
                            .cornerRadius(15)
                            .shadow(color: Color.purple.opacity(0.6), radius: 10, x: 0, y: 5)
                    }
                    .padding(.horizontal)
                    .alert(isPresented: $showAlert) { // Show alert based on state
                        Alert(title: Text("Save Workout"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                    }
                }
                .padding()
            }
        }
        .onTapGesture {
            // Dismiss the keyboard when tapping outside of input fields
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }

    // MARK: - Save Log
    private func saveLog() {
        // Validation to ensure no empty or invalid data
        guard !selectedExercise.isEmpty, weight > 0, reps > 0, sets > 0 else {
            alertMessage = "Please fill all fields correctly!"
            showAlert = true
            return
        }

        // Create a new Item (workout log)
        let newItem = Item(
            exerciseName: selectedExercise,
            weight: weight,
            reps: reps,
            sets: sets,
            timestamp: date
        )

        // Insert the new item into the database
        do {
            modelContext.insert(newItem)
            try modelContext.save() // Persist changes
            alertMessage = "Workout log saved successfully!"
            showAlert = true
            dismiss() // Close the AddLogView
        } catch {
            alertMessage = "Failed to save the workout log: \(error.localizedDescription)"
            showAlert = true
        }
    }
}
