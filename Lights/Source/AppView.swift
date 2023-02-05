//
//  AppView.swift
//  HelloTriangleIOS
//
//  Created by Eugene Karpenko on 27.01.2023.
//

import SwiftUI

struct AppView: View {
    
    @EnvironmentObject var gameScene: GameScene
    
    var body: some View {
        ContentView()
            .gesture(
                DragGesture().onChanged { gesture in
                    gameScene.spinCamera(offset: gesture.translation)
                }
            )
    }
}
