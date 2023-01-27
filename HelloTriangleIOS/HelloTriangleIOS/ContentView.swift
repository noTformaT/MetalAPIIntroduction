//
//  ContentView.swift
//  HelloTriangleIOS
//
//  Created by Eugene Karpenko on 27.01.2023.
//

import SwiftUI
import MetalKit

struct ContentView: UIViewRepresentable {
    
    
    func makeCoordinator() -> Renderer {
        Renderer(self)
    }
    
    func makeUIView(context: UIViewRepresentableContext<ContentView>) -> some UIView {
        let mtkView = MTKView()
        mtkView.delegate = context.coordinator
        mtkView.preferredFramesPerSecond = 60
        mtkView.enableSetNeedsDisplay = true

        if let metalDevice = MTLCreateSystemDefaultDevice() {
            mtkView.device = metalDevice
        }

        mtkView.framebufferOnly = false
        mtkView.drawableSize = mtkView.frame.size

        return mtkView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
//    func makeCoordinator() -> Renderer {
//        Renderer(self)
//    }
//
//    func makeUIView(context: UIViewRepresentableContext<ContentView>) -> some MTKView {
//        let mtkView = MTKView()
//        mtkView.delegate = context.coordinator
//        mtkView.preferredFramesPerSecond = 60
//        mtkView.enableSetNeedsDisplay = true
//
//        if let metalDevice = MTLCreateSystemDefaultDevice() {
//            mtkView.device = metalDevice
//        }
//
//        mtkView.framebufferOnly = false
//        mtkView.drawableSize = mtkView.frame.size
//
//        return mtkView
//    }
//
//    func updateUIView(_ uiView: MTKView, context: UIViewRepresentableContext<ContentView>) {
//
//    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
