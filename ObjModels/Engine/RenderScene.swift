//
//  RenderScene.swift
//  HelloTriangleIOS
//
//  Created by Eugene Karpenko on 29.01.2023.
//

import Foundation

// Main Scene Class

class RenderScene {
    
    var player: Camera
    var actors: [TransformComponent]
    
    init() {
        player = Camera(
            position: [0, 0.0, 0.0],
            eulers: [0.0, 0.0, 0.0]
        )
        
        actors = [
            TransformComponent(
                position: [0.0, 0.0, 5.0],
                eulers: [0.0, 0.0, 0.0]
            )
        ]
    }
    
    func update() {
        
        player.updateVectors()
        
        for act in actors {
            
            act.addRotation(rotaion: [0.0, 1.0, 0.0])
            
        }
        
    }
}
