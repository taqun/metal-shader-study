//
//  Shader.metal
//  MetalShaderStudy
//
//  Created by taqun on 2020/05/02.
//

#include <metal_stdlib>
using namespace metal;

// struct

struct VertexIn {
    float2 position;
    float2 texCoords;
};

struct VertexOut {
    float4 position [[position]];
    float2 texCoords;
};



// functions

float rand(float2 co) {
    //return fract(sin(dot(co.xy, float2(12.9898, 78.233))) * 437.585453);
    return fract(sin(dot(co.xy, float2(0.129898, 0.78233))) * 4.37585453);
}

float4 fill(float value) {
    return float4(float3(value), 1.0);
}



// shader

vertex VertexOut vertex_function(const device VertexIn *vertexArray [[ buffer(0) ]],
                                 uint vertexIndex [[ vertex_id ]])
{
    VertexOut out;
    out.position = float4(vertexArray[vertexIndex].position, 0, 1);
    out.texCoords = vertexArray[vertexIndex].texCoords;
    return out;
}

fragment float4 fragment_function(VertexOut vertexIn [[stage_in]],
                                  texture2d<float> tex [[texture(0)]],
                                  constant float &time [[buffer(0)]],
                                  constant float &aspectRatio [[buffer(1)]],
                                  constant int &shaderIndex [[buffer(2)]])
{
    switch(shaderIndex % 2) {
        case 0:
            return float4(1.0, 0.0, 0.0, 1.0);
            break;
        case 1:
            return float4(0.0, 1.0, 0.0, 1.0);
            break;
        default:
            break;
    }
    
    return float4(0.0, 0.0, 0.0, 1.0);
}
