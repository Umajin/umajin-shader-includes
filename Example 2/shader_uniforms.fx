Texture2D DiffuseMap;
Texture2D extra_texture;

SamplerState samLinear
{
   Filter = MIN_MAG_MIP_LINEAR;
   AddressU = WRAP;
   AddressV = WRAP;
   MaxLOD = 1000.0;
};
cbuffer cbChangesOnResize
{
   matrix View;
   matrix Projection;
};
cbuffer cbChangesEveryObject
{
   matrix World;
};
cbuffer cbChangesSometimes
{
   float uv_scale;
   float2 uv_offset;
   float3 pos_shift;
   float4 color_shift;
};
struct VS_OUTPUT
{
   float4 Pos  : SV_POSITION;
   float2 Tex  : TEXCOORD0;
};
struct VS_INPUT
{
   float3 Pos         : POSITION;
   uint4  Color       : COLOR;
   float2 TexCoord    : TEXCOORD;
   float3 Normal      : NORMAL;
   float3 Tangent     : TANGENT;
   float3 Binormal    : BINORMAL;
   uint4  boneWeights : BONEWEIGHTS;
   uint4  boneIndices : BONEINDICES;
};
VS_OUTPUT VS( VS_INPUT In )
{
   VS_OUTPUT output = (VS_OUTPUT)0;

   float4 model_pos = float4(In.Pos,1);
   model_pos.xyz += pos_shift;

   output.Pos = mul( model_pos, World );
   output.Pos = mul( output.Pos, View );
   output.Pos = mul( output.Pos, Projection );

   output.Tex = In.TexCoord;
   return output;
}

float4 PS( VS_OUTPUT input, bool isFrontFace : SV_IsFrontFace  ) : SV_Target
{
   float4 output = DiffuseMap.Sample(samLinear, (input.Tex + uv_offset) * uv_scale.xx );
   output += extra_texture.Sample(samLinear, input.Tex) * 0.25;
   output += color_shift;
   return output;
}

technique10 Render10
{
   pass P0
   {
      SetVertexShader(CompileShader(vs_4_0, VS()));
      SetGeometryShader(0);
      SetPixelShader(CompileShader(ps_4_0, PS()));
   }
}
technique11 Render11
{
   pass P0
   {
      SetVertexShader(CompileShader(vs_5_0, VS()));
      SetHullShader(0);
      SetDomainShader(0);
      SetGeometryShader(0);
      SetPixelShader(CompileShader(ps_5_0, PS()));
   }
}
