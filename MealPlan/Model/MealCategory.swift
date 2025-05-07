//
//  MealCategory.swift
//  MealPlan
//
//  Created by Nadiv Herath on 2025-05-04.
//
import Foundation

// Enum to categorize each meal
enum MealCategory: String, Codable, CaseIterable, Identifiable {
    case breakfast
    case lunch
    case dinner
    case snack

    // For use in Picker or ForEach
    var id: String { self.rawValue }

    // User-friendly display
    var displayName: String {
        switch self {
        case .breakfast: return "Breakfast"
        case .lunch: return "Lunch"
        case .dinner: return "Dinner"
        case .snack: return "Snack"
        }
    }

    // Optional: Emoji icon for UI
    var icon: String {
        switch self {
        case .breakfast: return "🍳"
        case .lunch: return "🥪"
        case .dinner: return "🍽"
        case .snack: return "🍎"
        }
    }
}
