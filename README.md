My Learning (MVVM SwiftUI App)

An iOS learning tracker app built using SwiftUI and the MVVM architecture.
The app helps users set learning goals, track daily progress, and visualize their activity in a beautiful and minimal interface.

Features:
• Set and update personalized learning goals
• Choose goal duration (Week, Month, Year)
• Log learning days or freeze them
• View progress with dynamic streak counters
• Full calendar view for activity tracking
• Dark mode support
• Built with clean and reusable SwiftUI components

Tech Stack:
• SwiftUI
• Combine
• MVVM Pattern
• UIKit Integration (UICalendarView)
• Dynamic Colors & Themes

Project Structure:

LearningApp_MVVM/
│
├── Models/
│   └── ActivityManager.swift
│
├── ViewModels/
│   └── ActivityViewModel.swift
│
├── Views/
│   ├── FirstPage.swift
│   ├── SecondPage.swift
│   ├── LearningGoal.swift
│   └── AllActivity.swift
│
├── Views/Subviews/
│   ├── DateButton.swift
│   ├── SummaryCard.swift
│   ├── MainActionButton.swift
│   ├── WeekCalendarView.swift
│   └── SecondaryActionButtonView.swift
│
├── Resources/
│   └── Colors.swift
│
└── LearningApp_MVVMApp.swift


Future Improvements:
• Add user authentication and cloud sync
• Include motivational reminders
• Support for multiple topics at once

Author:
Maryam Jalal Alzahrani
iOS Developer  | Passionate about learning, design, and creating useful apps.
