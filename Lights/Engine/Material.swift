//
//  Material.swift
//  HelloTriangleIOS
//
//  Created by Eugene Karpenko on 03.02.2023.
//

import MetalKit

class Material {
    let texture: MTLTexture
    let sampler: MTLSamplerState
    
    init(device: MTLDevice, allocator: MTKTextureLoader, fileName: String) {
        guard let materialURL = Bundle.main.url(forResource: fileName, withExtension: ".jpg") else {
            fatalError("Texture not found")
        }
        
        let options: [MTKTextureLoader.Option : Any] = [
            .SRGB: false
        ]
        
        do {
            texture = try allocator.newTexture(URL: materialURL, options: options)
        } catch {
            fatalError("Couldn't create textre")
        }
        
        let samplerDescriptor = MTLSamplerDescriptor()
        samplerDescriptor.sAddressMode = .repeat
        samplerDescriptor.tAddressMode = .repeat
        samplerDescriptor.minFilter = .nearest
        samplerDescriptor.magFilter = .linear
        
        sampler = device.makeSamplerState(descriptor: samplerDescriptor)!
    }
}
