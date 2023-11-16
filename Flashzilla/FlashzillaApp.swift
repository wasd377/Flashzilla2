//
//  FlashzillaApp.swift
//  Flashzilla
//
//  Created by Natalia D on 05.11.2023.
//

import SwiftUI

@main
struct FlashzillaApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(ViewModel())
        }
    }
}
