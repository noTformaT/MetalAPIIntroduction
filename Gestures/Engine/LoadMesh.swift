//
//  LoadMesh.swift
//  HelloTriangleIOS
//
//  Created by Eugene Karpenko on 29.01.2023.
//

import MetalKit

class LoadMesh {
    let modelIOMesh: MDLMesh
    let metalMesh: MTKMesh
    
    init (device: MTLDevice, allocator: MTKMeshBufferAllocator, fileName: String) {
        guard let meshURL = Bundle.main.url(forResource: fileName, withExtension: "obj") else {
            fatalError("Mesh not found")
        }
        
        let vertexDescriptor = MTLVertexDescriptor()
        
        var offset:Int = 0
        
        // Position
        vertexDescriptor.attributes[0].format = .float3
        vertexDescriptor.attributes[0].offset = offset
        vertexDescriptor.attributes[0].bufferIndex = 0
        offset += MemoryLayout<SIMD3<Float>>.stride
        
        vertexDescriptor.layouts[0].stride = offset
        
        let meshDescriptor = MTKModelIOVertexDescriptorFromMetal(vertexDescriptor)
        (meshDescriptor.attributes[0] as! MDLVertexAttribute).name = MDLVertexAttributePosition
        
        let asset = MDLAsset(url: meshURL,
                             vertexDescriptor: meshDescriptor,
                             bufferAllocator: allocator)
        
        modelIOMesh = asset.childObjects(of: MDLMesh.self).first as! MDLMesh
        
        do {
            metalMesh = try MTKMesh(mesh: modelIOMesh, device: device)
        } catch {
            fatalError()
        }
         
    }
}
