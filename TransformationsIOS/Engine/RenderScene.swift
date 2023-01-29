//
//  RenderScene.swift
//  HelloTriangleIOS
//
//  Created by Eugene Karpenko on 29.01.2023.
//

import Foundation

class RenderScene {
    
    var player: Camera
    var triangles: [SimpleComponent]
    
    init() {
        player = Camera(
            position: [0, 0.0, 0.0],
            eulers: [0.0, 0.0, 0.0]
        )
        
        triangles = [
            SimpleComponent(
                position: [0.0, 0.0, 5.0],
                eulers: [0.0, 0.0, 0.0]
            )
        ]
    }
    
    func update() {
        
        player.updateVectors()
        
        for triangle in triangles {
            
            triangle.eulers.y += 1
            if triangle.eulers.y > 360 {
                triangle.eulers.y -= 360
            }
            
        }
        
    }
}
