//
//  HelloTriangleIOSApp.swift
//  HelloTriangleIOS
//
//  Created by Eugene Karpenko on 27.01.2023.
//

import SwiftUI

@main
struct Application: App {
    @StateObject private var gameScene = RenderScene()
    var body: some Scene {
        WindowGroup {
            AppView().environmentObject(gameScene)
        }
    }
}
