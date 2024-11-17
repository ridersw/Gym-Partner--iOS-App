//
//  Item.swift
//  Gym Partner
//
//  Created by Shashiraj Walsetwar on 11/16/24.
//

import Foundation
import SwiftData

@Model
final class Item: Identifiable {
    var id: UUID
    var exerciseName: String
    var weight: Double
    var reps: Int
    var sets: Int
    var timestamp: Date

    init(
        id: UUID = UUID(),
        exerciseName: String,
        weight: Double,
        reps: Int,
        sets: Int,
        timestamp: Date = Date()
    ) {
        self.id = id
        self.exerciseName = exerciseName
        self.weight = weight
        self.reps = reps
        self.sets = sets
        self.timestamp = timestamp
    }
}

