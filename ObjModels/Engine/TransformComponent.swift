//
//  SimpleComponent.swift
//  HelloTriangleIOS
//
//  Created by Eugene Karpenko on 29.01.2023.
//

import Foundation

// Transform component with position and eulers rotations

class TransformComponent {
    var position: simd_float3
    var eulers: simd_float3
    
    init(position: simd_float3, eulers: simd_float3) {
        self.position = position
        self.eulers = eulers
    }
    
    func addRotation(rotaion: simd_float3)
    {
        self.eulers += rotaion
        
        if self.eulers.x > 360 {
            self.eulers.x -= 360
        }
        
        if self.eulers.z > 360 {
            self.eulers.z -= 360
        }
        
        if self.eulers.y > 360 {
            self.eulers.y -= 360
        }
    }
};
