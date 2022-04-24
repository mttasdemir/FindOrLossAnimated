//
//  MyFindOrLoss001App.swift
//  MyFindOrLoss001
//
//  Created by Mustafa Taşdemir on 22.01.2022.
//

import SwiftUI

@main
struct MyFindOrLoss001App: App {
    @StateObject var controller: FindOrLossController = FindOrLossController()
    var body: some Scene {
        WindowGroup {
            ContentView(findLossController: controller)
        }
    }
}
