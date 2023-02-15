//
//  Renderer.swift
//  HelloTriangleIOS
//
//  Created by Eugene Karpenko on 27.01.2023.
//
 
import MetalKit

class Renderer: NSObject, MTKViewDelegate {
    
    // Render include:
    // * Metal Device
    // * Metal Command Queue,
    // * Metal Pipeline State
    // * Metal Vertex Buffer
    
    var parent: ContentView
    var metalDevice: MTLDevice!
    var metalCommandQueue: MTLCommandQueue!
    let pipelineState: MTLRenderPipelineState
    
    var scene: GameScene
    let mesh: LoadMesh
    let groundMesh: LoadMesh
    
    let material: Material
    let groundMaterial: Material
    
    let allocator: MTKMeshBufferAllocator
    let materialLoader: MTKTextureLoader
    let depthStencilState: MTLDepthStencilState
    
    init (_ parent: ContentView, scene: GameScene) {
        self.parent = parent
        
        // Create Metal Device
        if let metalDevice = MTLCreateSystemDefaultDevice() {
            self.metalDevice = metalDevice
        }
        
        // Create Metal Command Queue
        self.metalCommandQueue = metalDevice.makeCommandQueue()
        
        // Crete Mesh Buffer Allocator
        self.allocator = MTKMeshBufferAllocator(device: metalDevice)
        
        // Create Texture Loader/Allocator
        self.materialLoader = MTKTextureLoader(device: metalDevice)
        material = Material(device: metalDevice, allocator: self.materialLoader, fileName: "ColorChecker")
        groundMaterial = Material(device: metalDevice, allocator: self.materialLoader, fileName: "ColorChecker")
        
        // Create triangle Mesh
        mesh = LoadMesh(device: metalDevice, allocator: allocator, fileName: "crash")
        groundMesh = LoadMesh(device: metalDevice, allocator: allocator, fileName: "ground")
        
        // Create Metal Pipeline Descriptor
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        let library = metalDevice.makeDefaultLibrary()                                      // get Metal library from .metal file
        pipelineDescriptor.vertexFunction = library?.makeFunction(name: "vertexShaderLoadMesh")     // get vertex shader function
        pipelineDescriptor.fragmentFunction = library?.makeFunction(name: "fragmentShader") // get fragment shader function
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm                    // use pixel format
        pipelineDescriptor.vertexDescriptor = MTKMetalVertexDescriptorFromModelIO(mesh.metalMesh.vertexDescriptor)
        pipelineDescriptor.depthAttachmentPixelFormat = .depth32Float                       // set depth format
        
        let depthStencilDescriptor = MTLDepthStencilDescriptor()
        depthStencilDescriptor.depthCompareFunction = .less
        depthStencilDescriptor.isDepthWriteEnabled = true
        
        self.depthStencilState = metalDevice.makeDepthStencilState(descriptor: depthStencilDescriptor)!
        
        // Create Metal Pipeline State
        do {
            try pipelineState = metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch {
            fatalError("Fail to create pipeline state")
        }
        
        // Create Render Scene
        self.scene = scene
        
        super.init()
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    
    func draw(in view: MTKView) {
        // update scene
        
        scene.update()
        
        guard let drawable = view.currentDrawable else {
            return
        }
        
        // Create Metal Command Buffer from Metal Command Queue
        let commandBuffer = metalCommandQueue.makeCommandBuffer()
        
        // Create Render Pass Descriptor
        let renderPassDescriptor = view.currentRenderPassDescriptor
        renderPassDescriptor?.colorAttachments[0].clearColor = MTLClearColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0) // set clear clor
        renderPassDescriptor?.colorAttachments[0].loadAction = .clear                                                   // set load action - clear
        renderPassDescriptor?.colorAttachments[0].storeAction = .store                                                  // set store action - store
        
        // Make Metal Render Command Encoder
        let renderEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor!)
        renderEncoder?.setRenderPipelineState(pipelineState)    // set pipeline
        renderEncoder?.setDepthStencilState(depthStencilState)  // set depth stencil
        
        // Make Camera Parameters
        var cameraData: CameraParameters = CameraParameters()
        cameraData.view = scene.player.view!
        
        // Calc aspect ration
        let width = view.drawableSize.width
        let height = view.drawableSize.height
        let asp:Float = Float(height / width)
        
        cameraData.projection = Matrix44.create_perspective_projection(
            fovy: 45,
            aspect: asp,
            near: 0.1,
            far: 20
        )
        
        cameraData.position = scene.player.position!
        
        // Set Vertex Buffer
        renderEncoder?.setVertexBytes(&cameraData, length: MemoryLayout<CameraParameters>.stride, index: 2)
        
        // Set Directional/Sun Light Data
        var sunData: DirectionLight = DirectionLight()
        sunData.base.ambientIntensity = 0.1
        sunData.base.diffuseIntensity = 0.3
        sunData.base.color = scene.sun.color
        sunData.direction = scene.sun.forwards!
        renderEncoder?.setFragmentBytes(&sunData, length: MemoryLayout<DirectionLight>.stride, index: 0)
        
        // draw actors
        
        // Set Texture
        renderEncoder?.setFragmentTexture(material.texture, index: 0)
        
        // Set TextureSampler
        renderEncoder?.setFragmentSamplerState(material.sampler, index: 0)
        
        renderEncoder?.setVertexBuffer(mesh.metalMesh.vertexBuffers[0].buffer, offset: 0, index: 0)
        for act in scene.actors {
            renderEncoder?.setVertexBytes(&(act.model!), length: MemoryLayout<matrix_float4x4>.stride, index: 1)
            
            for submesh in mesh.metalMesh.submeshes {
                renderEncoder?.drawIndexedPrimitives(
                    type: .triangle,
                    indexCount: submesh.indexCount,
                    indexType: submesh.indexType,
                    indexBuffer: submesh.indexBuffer.buffer,
                    indexBufferOffset: submesh.indexBuffer.offset
                )
            }
        }
        
        
        // draw ground tiles
        
        renderEncoder?.setFragmentTexture(groundMaterial.texture, index: 0) // Set texture
        renderEncoder?.setFragmentSamplerState(groundMaterial.sampler, index: 0) // Set TextureSampler
        renderEncoder?.setVertexBuffer(groundMesh.metalMesh.vertexBuffers[0].buffer, offset: 0, index: 0) // Set vertex buffer
        
        for act in scene.groundTiles {
            renderEncoder?.setVertexBytes(&(act.model!), length: MemoryLayout<matrix_float4x4>.stride, index: 1)
            
            for submesh in groundMesh.metalMesh.submeshes {
                renderEncoder?.drawIndexedPrimitives(
                    type: .triangle,
                    indexCount: submesh.indexCount,
                    indexType: submesh.indexType,
                    indexBuffer: submesh.indexBuffer.buffer,
                    indexBufferOffset: submesh.indexBuffer.offset
                )
            }
        }
        
        // Set present mode and end encoding
        renderEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        
        // Commit Commands
        commandBuffer?.commit()
    }
}
