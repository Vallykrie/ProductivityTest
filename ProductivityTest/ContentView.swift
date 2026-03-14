//
//  ContentView.swift
//  ProductivityTest
//
//  Created by Nathan Sudiara on 09/03/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        TaskListView()
    }
}

#Preview {
    ContentView()
        .modelContainer(for: AcademicTask.self, inMemory: true)
}
