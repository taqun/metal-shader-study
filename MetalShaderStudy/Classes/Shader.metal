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
    return fract(sin(dot(co.xy, float2(0.129898, 0.78233))) * 4.37585453);
}

float4 fill(float value) {
    return float4(float3(value), 1.0);
}



// shader

/* ref:
 * http://r-ngtm.hatenablog.com/entry/2019/01/23/081547
 */
float4 noise2(VertexOut vertexIn, float time, float aspectRatio) {
    float2 uv = vertexIn.texCoords;
    
    float x = rand(float2(fract(time)));
    
    float v = rand(float2(x, uv.y/2));
    v = step(0.6, v);
    
    float4 color = fill(v);
    return color;
}


float4 noise1(VertexOut vertexIn, float time, float aspectRatio) {
    float2 pos = vertexIn.position.xy;
    float v = rand(float2(0, pos.y));
    float4 color = fill(v);
    return color;
}


// fragment shader

fragment float4 fragment_function(VertexOut vertexIn [[stage_in]],
                                  constant float &time [[buffer(0)]],
                                  constant float &aspectRatio [[buffer(1)]],
                                  constant int &shaderIndex [[buffer(2)]])
{
    switch(shaderIndex % 2) {
        case 0:
            return noise2(vertexIn, time, aspectRatio);
        case 1:
            return noise1(vertexIn, time, aspectRatio);
            break;
        default:
            break;
    }
    
    return float4(0.0, 0.0, 0.0, 1.0);
}

// vertex shader

vertex VertexOut vertex_function(const device VertexIn *vertexArray [[ buffer(0) ]],
                                 uint vertexIndex [[ vertex_id ]])
{
    VertexOut out;
    out.position = float4(vertexArray[vertexIndex].position, 0, 1);
    out.texCoords = vertexArray[vertexIndex].texCoords;
    return out;
}
