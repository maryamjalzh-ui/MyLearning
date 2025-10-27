//
//  Colors.swift
//  LearningApp_MVVM
//
//  Created by Maryam Jalal Alzahrani on 05/05/1447 AH.
//

import Foundation
import SwiftUI

// MARK: - Hex Color Helper
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(.sRGB, red: Double(r)/255, green: Double(g)/255, blue: Double(b)/255, opacity: Double(a)/255)
    }
}

// MARK: - App Colors (Dynamic)
extension Color {
    // 🩶 خلفية تتغير حسب المود
    static var primaryBackground: Color { Color(.systemBackground) }
    
    // 🩺 خلفية ثانوية (مثل الكروت)
    static var darkGreyBackground: Color { Color(.secondarySystemBackground) }

    // 🟧 اللون البرتقالي الرئيسي
    static let accentOrange = Color(hex: "#E06D06")

    // 🧊 اللون السماوي (Freezed)
    static let freezedCyan = Color(hex: "01A8B3")

    // 🎨 ألوان الحالات
    static let LoggedColor = Color(hex: "#321B07")   // ممكن تستبدلينه لاحقاً لو تبين أكثر وضوح
    static let FreezedColor = Color(hex: "#003A3D")

    // ✍️ ألوان النصوص (ديناميكية)
    static var primaryText: Color { Color.primary }
    static var secondaryText: Color { Color.secondary }

    // ☁️ لون شريط إدخال أو مكونات فرعية
    static var inputBarColor: Color { Color(.tertiarySystemBackground) }

    // ✨ تأثير التوهج
    static var buttonGlow: Color { accentOrange.opacity(0.4) }
}
