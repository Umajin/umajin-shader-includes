#extension GL_ARB_separate_shader_objects : enable

// Common uniform buffers and push constants

layout(std140, set = 0, binding = 0) uniform UniformBufferObject
{
	layout(offset = 0)   mat4 view;
	layout(offset = 64)  mat4 proj;
	layout(offset = 128) vec3 eyePos;
	layout(offset = 144) int  ambient;
	layout(offset = 160) vec3 lightPos[3];
	layout(offset = 208) vec3 lightColor[3];
	layout(offset = 256) vec3 lightDirection[3];
} ubo;

layout(std140, set = 0, binding = 1) uniform DynamicUBO
{
	layout(offset = 0)   mat4 world;
	layout(offset = 64)  vec4 ShaderUniform1;
	layout(offset = 80)  vec4 ShaderUniform2;
	layout(offset = 96)  vec4 ShaderUniform3;
	layout(offset = 112) vec4 ShaderUniform4;
} dynamicUBO;

layout(push_constant) uniform PushConsts
{
	uint textureIndicies;
	uint tintColor;
	uint skinningIndex;
} pushConsts;

// Vertex input data

#define VERTEX_INPUT \
layout(location = 0) in vec3 inPosition;\
layout(location = 1) in vec4 inColor;\
layout(location = 2) in vec2 inTexCoord;\
layout(location = 3) in vec3 inNormal;\
layout(location = 4) in vec3 inTangent;\
layout(location = 5) in vec3 inBinormal;\
layout(location = 6) in vec4 inBoneWeight;\
layout(location = 7) in uint inBoneIndex;\

// Skinning input Data

#define SKINNING_INPUT \
layout(std430, set = 1, binding = 1) readonly buffer SkinningData\
{\
	mat4 skinningData[];\
};\

#define SKINNING_MATRIX \
inBoneWeight.x * skinningData[pushConsts.skinningIndex + uint(inBoneIndex & uint(0x000000FF))] + \
inBoneWeight.y * skinningData[pushConsts.skinningIndex + uint((inBoneIndex & uint(0x0000FF00)) >> 8)] + \
inBoneWeight.z * skinningData[pushConsts.skinningIndex + uint((inBoneIndex & uint(0x00FF0000)) >> 16)] + \
inBoneWeight.w * skinningData[pushConsts.skinningIndex + uint((inBoneIndex & uint(0xFF000000)) >> 24)]; \

// Texture input data

#define TEXTURE_INPUT \
layout(set = 0, binding = 2) uniform sampler samp;\
layout(set = 1, binding = 0) uniform texture2D textures[16];\
layout(set = 2, binding = 1) uniform texture2D other_tex[4];\

#define DIFFUSE_INDEX  (pushConsts.textureIndicies & uint(0x000000FF))

#define AMBIENT_INDEX  ((pushConsts.textureIndicies & uint(0x0000FF00)) >> 8)

#define NORMAL_INDEX   ((pushConsts.textureIndicies & uint(0x00FF0000)) >> 16)

#define SPECULAR_INDEX ((pushConsts.textureIndicies & uint(0xFF000000)) >> 24)

#define TINT unpackUnorm4x8(pushConsts.tintColor)

#define SHADER_UNIFORM1 dynamicUBO.ShaderUniform1

#define SHADER_UNIFORM2 dynamicUBO.ShaderUniform2

#define SHADER_UNIFORM3 dynamicUBO.ShaderUniform3

#define SHADER_UNIFORM4 dynamicUBO.ShaderUniform4

#define LIGHT_POSITION ubo.lightPos

#define LIGHT_COLOR ubo.lightColor

#define LIGHT_DIRECTION ubo.lightDirection