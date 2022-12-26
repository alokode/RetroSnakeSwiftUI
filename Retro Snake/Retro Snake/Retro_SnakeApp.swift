//
//  Retro_SnakeApp.swift
//  Retro Snake
//
//  Created by Alok Sagar on 26/12/22.
//

import SwiftUI

@main
struct Retro_SnakeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(head: .zero, gameState: .onGoing)
        }
    }
}
