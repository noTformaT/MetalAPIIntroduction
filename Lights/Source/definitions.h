//
//  definitions.h
//  HelloTriangleIOS
//
//  Created by Eugene Karpenko on 27.01.2023.
//

#ifndef definitions_h
#define definitions_h

#include <simd/simd.h>

// Basic Vertex description class
struct Vertex {
    vector_float3 position;
    vector_float4 color;
};

struct CameraParameters {
    matrix_float4x4 view;
    matrix_float4x4 projection;
};

#endif /* definitions_h */
