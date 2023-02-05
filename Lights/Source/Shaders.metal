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
    float2 texcoord;
    float3 normal;
    float3 cameraPosition;
    float3 fragmentPosition;
    float pointsize[[point_size]];
};

struct VertexIn {
    float4 position [[ attribute(0) ]];
    float2 texcoord [[ attribute(1) ]];
    float3 normal [[ attribute(2) ]];
};

// Vertex Shader
vertex Fragment vertexShaderLoadMesh(const VertexIn vertex_in [[stage_in]],
                                     constant matrix_float4x4 &model [[buffer(1)]],
                                     constant CameraParameters &camera [[buffer(2)]]) {
    
    
    // Pro render programmer move
    matrix_float3x3 dimished_model;
    dimished_model[0][0] = model[0][0];
    dimished_model[0][1] = model[0][1];
    dimished_model[0][2] = model[0][2];
    
    dimished_model[1][0] = model[1][0];
    dimished_model[1][1] = model[1][1];
    dimished_model[1][2] = model[1][2];
    
    dimished_model[2][0] = model[2][0];
    dimished_model[2][1] = model[2][1];
    dimished_model[2][2] = model[2][2];
    
    
    Fragment output;
    output.position = camera.projection * camera.view * model * vertex_in.position;
    output.color = float4(0, 1, 0, 1.0);
    output.pointsize = 1;
    output.color = float4(abs(vertex_in.position.x), vertex_in.position.y, abs(vertex_in.position.z), 1);
    output.texcoord = vertex_in.texcoord;
    output.normal = dimished_model * vertex_in.normal;
    output.cameraPosition = camera.position;
    output.fragmentPosition = float3(model * vertex_in.position);
    
    return output;
}

// Vertex Shader
vertex Fragment vertexShader(const device Vertex *vertexArray [[buffer(0)]],
                             unsigned int vid [[vertex_id]],
                             constant matrix_float4x4 &model [[buffer(1)]],
                             constant CameraParameters &camera [[buffer(2)]]) {
    Vertex input = vertexArray[vid];
    
    Fragment output;
    output.position = camera.projection * camera.view * model * float4(input.position.x, input.position.y, 0, 1);
    output.color = input.color;
    
    return output;
}

// Fragment Shader
fragment float4 fragmentShader(Fragment input [[stage_in]],
                               texture2d<float> objectTexture [[ texture(0) ]],
                               sampler samplerObject [[ sampler(0)]],
                               constant DirectionLight &sun [[ buffer(0) ]]) {
    
    //return input.color;
    //return float4(0.0, 1.0, 0.0, 1.0);
    
    float3 baseColor = float3(objectTexture.sample(samplerObject, input.texcoord));
    
    //ambient
    float a_strength = 0.1;
    float4 ambientColor = float4(sun.color, 1.0f) * a_strength;
    
    float diffuseIntensity = 0.3;
    float diffuseFactor = max(dot(normalize(input.normal), normalize(-sun.direction)), 0.0);
    float4 diffuseColor = float4(sun.color, 1.0f) * diffuseIntensity *  diffuseFactor;
    
    float4 specularColor = float4(0, 0, 0, 0);
    
    if (diffuseFactor > 0.0)
    {
        float3 fragToEye = normalize(input.cameraPosition - input.fragmentPosition);
        //float3 reflectedVertex = normalize(-sun.direction + fragToEye);
        float3 reflectedVertex = normalize(reflect(sun.direction, normalize(input.normal)));
        
        float specularFactor = dot(fragToEye, reflectedVertex);
        
        if (specularFactor > 0.0)
        {
            specularFactor = pow(specularFactor, 128);
            specularColor = float4(sun.color * 1.0 * specularFactor, 1.0);
        }
    }
    
    
    float4 finalColor = (ambientColor + diffuseColor + specularColor);
    
    return finalColor;
}
