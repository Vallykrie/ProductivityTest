//
//  ProductivityTestApp.swift
//  ProductivityTest
//
//  Created by Nathan Sudiara on 09/03/26.
//

import SwiftUI
import SwiftData

@main
struct ProductivityTestApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: AcademicTask.self)
    }
}
