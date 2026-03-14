# Productivity Task Tracker

A modern, glassmorphic iOS application built with **SwiftUI** and **SwiftData** designed to help university students prioritize their academic tasks using the ICE scoring model.

## Core Features
- **ICE Priority Scoring**: Calculate priority based on **Impact**, **Confidence**, and **Ease** (a score out of 1000).
- **Offline Storage**: All tasks are seamlessly saved locally on your device using Apple's new `SwiftData` framework.
- **Glassmorphic UI**: Beautiful gradients and ultra-thin material designs for a premium user experience.
- **Dynamic Sorting**: Sort your academic tasks by Priority Score or Due Date.

## How Priority is Calculated
`Impact (1-10) x Confidence (1-10) x Ease (1-10) = Priority Score (out of 1000)`

## Prerequisites
- macOS 14.0+ (Sonoma or later recommended)
- Xcode 15.0+ 
- iOS 17.0+ Simulator or physical device

## How to Run the App
1. **Clone the Repository**
   ```bash
   git clone <your-repository-url>
   cd ProductivityTest
   ```
2. **Open the Project in Xcode**
   Open the `ProductivityTest.xcodeproj` file in Xcode.
   ```bash
   open ProductivityTest.xcodeproj
   ```
   *Alternatively, just double-click `ProductivityTest.xcodeproj` in Finder.*
3. **Select a Simulator or Device**
   At the top center of the Xcode window, click the device name (e.g., "Any iOS Device") and select a simulator like **iPhone 15 Pro** from the dropdown menu.
4. **Build and Run**
   Click the **Play button ▶️** in the top left corner of Xcode, or press `Cmd + R` on your keyboard.
   The simulator will boot up, compile the app, and launch it automatically.

## Usage Guide
- **Adding a Task**: Tap the `+ New Task` button at the bottom. Fill in the details, use the sliders to rate Impact, Confidence, and Ease. Watch the priority score live update!
- **Completion**: Tap the circle to the right of any task to mark it as completed. You can toggle out completed tasks in the top right menu.
- **Sorting**: Tap the filter icon in the top right `(line.3.horizontal.decrease.circle)` to sort your task list dynamically by ICE priority or Due Date.
- **Deleting**: Swipe left or long-press on a task to delete it.

## Built With
- **SwiftUI**: Declarative UI layout logic.
- **SwiftData**: Persistent local data storage.

Enjoy your newly prioritized academic life!
