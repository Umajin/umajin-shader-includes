Texture2D DiffuseMap;

SamplerState samLinear
{
   Filter = MIN_MAG_MIP_LINEAR;
   AddressU = CLAMP;
   AddressV = CLAMP;
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
   float4 Tint;
};

struct VS_OUTPUT
{
   float4 Pos      : SV_POSITION;
   float2 Tex      : TEXCOORD0;
   float4 Color    : COLOR;
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

   output.Pos = mul( float4(In.Pos,1), World );
   output.Pos = mul( output.Pos, View );
   output.Pos = mul( output.Pos, Projection );

   output.Tex = In.TexCoord;
   output.Color = In.Color / 255.0 * Tint;
   return output;
}

float4 PS( VS_OUTPUT input, bool isFrontFace : SV_IsFrontFace  ) : SV_Target
{
   float4 outColor = DiffuseMap.Sample(samLinear, input.Tex ) * input.Color;
   outColor.rgb = float3(1,1,1) - outColor.rgb;
   return outColor;
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
