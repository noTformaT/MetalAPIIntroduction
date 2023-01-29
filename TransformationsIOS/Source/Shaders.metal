//
//  Shaders.metal
//  HelloTriangleIOS
//
//  Created by Eugene Karpenko on 27.01.2023.
//

#include <metal_stdlib>
using namespace metal;

#include "definitions.h"

// Basic Fragment Discription class
struct Fragment {
    float4 position [[position]];
    float4 color;
};

// Vertex Shader
vertex Fragment vertexShader(
                             const device Vertex *vertexArray [[buffer(0)]],
                             unsigned int vid [[vertex_id]],
                             constant matrix_float4x4 &model [[buffer(1)]],
                             constant CameraParameters &camera [[buffer(2)]]
                             ) {
    Vertex input = vertexArray[vid];
    
    Fragment output;
    output.position = camera.projection * camera.view * model * float4(input.position.x, input.position.y, 0, 1);
    output.color = input.color;
    
    return output;
}

// Fragment Shader
fragment float4 fragmentShader(Fragment input [[stage_in]]) {
    return input.color;
}
