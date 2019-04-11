float4 g_MaterialAmbientColor;      
float4 g_MaterialDiffuseColor;      
float3 g_LightPos;
float3 g_LightDir;                  
float4 g_LightDiffuse;              
texture g_MeshTexture;              

float4x4 g_mWorld;                  
float4x4 g_mWorldViewProjection;    


sampler MeshTextureSampler = 
sampler_state
{
    Texture = <g_MeshTexture>;
    MipFilter = LINEAR;
    MinFilter = LINEAR;
    MagFilter = LINEAR;
};

struct VS_OUTPUT
{
    float4 Position   : POSITION;   
    float4 Diffuse    : COLOR0;     
    float2 TextureUV  : TEXCOORD0;  
};

VS_OUTPUT RenderSceneVS( float4 vPos : POSITION, 
                         float3 vNormal : NORMAL,
                         float2 vTexCoord0 : TEXCOORD0 )
{
    VS_OUTPUT Output;
    float3 vNormalWorldSpace;
    float distancia;
    
    Output.Position = mul(vPos, g_mWorldViewProjection);
    
    vNormalWorldSpace = normalize(mul(vNormal, (float3x3)g_mWorld));

    distancia = distance( g_LightPos, mul( vPos, g_mWorld ) );
    Output.Diffuse.rgb = 
		(g_MaterialDiffuseColor * g_LightDiffuse * max(0,dot(vNormalWorldSpace, -g_LightDir)))/distancia + 
		g_MaterialAmbientColor;
    Output.Diffuse.a = g_MaterialDiffuseColor.a; 
    //Output.Diffuse.a = 1.0f;

    Output.TextureUV = vTexCoord0; 
    
    return Output;    
}


struct PS_OUTPUT
{
    float4 RGBColor : COLOR0;
};

PS_OUTPUT RenderScenePS( VS_OUTPUT In ) 
{ 
    PS_OUTPUT Output;

    Output.RGBColor = tex2D(MeshTextureSampler, In.TextureUV) * In.Diffuse;
    return Output;
}


technique RenderScene
{
    pass P0
    {          
        VertexShader = compile vs_1_1 RenderSceneVS();
        PixelShader  = compile ps_1_1 RenderScenePS(); 
    }
}
