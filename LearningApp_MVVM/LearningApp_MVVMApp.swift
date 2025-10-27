//
//  LearningApp_MVVMApp.swift
//  LearningApp_MVVM
//
//  Created by Maryam Jalal Alzahrani on 05/05/1447 AH.
//

import SwiftUI

@main
struct LearningApp_MVVMApp: App {
    @StateObject private var activityManager = ActivityManager()

    var body: some Scene {
        WindowGroup {
            FirstPage()
                .environmentObject(activityManager)
        }
    }
}
