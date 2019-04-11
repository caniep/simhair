float3 g_LightPos;
float3 g_LightDir;                  
float4 g_LightDiffuse;
float4 g_LightSpecular;
float  g_SpecularPower;
float3 g_H;

float4x4 g_mWorld;
float4x4 g_mViewProjection;    


struct VS_OUTPUT
{
    float4 Position   : POSITION;
    float4 Diffuse    : COLOR0;  
};


VS_OUTPUT RenderSceneVS( float4 vPos : POSITION, float3 tangente: NORMAL, float4 diffuse : COLOR0 )
{
    VS_OUTPUT Output;
    float distancia;
    float kDifuso;
    float kEspecular;
    float dotD;
    float dotS;
    float3 H;
  
    Output.Position = mul(vPos, g_mViewProjection);

	// Diffuse intensity:   L·N = sqrt(1-(L·T)^2)
	// Specular intensity:  V·R = sqrt(1-(L·T)^2) · sqrt(1-(V·T)^2) - (L·T)(V·T)
	// Specular intensity para Blinn:  H·N = sqrt(1-(H·T)^2)
        
    // Componente difusa: parecido a dot, pero ahora la seminormal esta "tendida" sobre el plano
    dotD = dot( tangente, g_LightDir );
    kDifuso = sqrt( 1 - dotD*dotD );
    
    // Componente especular
    dotS = dot( tangente, g_H ); // Blinn
    //kEspecular = sqrt( 1 - dotS*dotS )*kDifuso - dotS*dotD;  // Phong: se sustituye 'g_H' por 'eyePos'
    kEspecular = sqrt( 1 - dotS*dotS ); // Blinn
    kEspecular = pow( kEspecular, g_SpecularPower );
    
    // Distancia al foco de luz
    //distancia = distance( g_LightPos, vPos);
    
    // Modelo iluminacion Phong "retocado"
    //Output.Diffuse.rgb = (kDifuso*g_LightDiffuse + 3.5*kEspecular*g_LightSpecular)/distancia + (0.3,0.3,0.3);
    //Output.Diffuse.rgb = (kEspecular*g_LightSpecular);
	Output.Diffuse.rgb = kDifuso*g_LightDiffuse + 2*kEspecular*g_LightSpecular + (0.2,0.2,0.2);
    Output.Diffuse.rgb *= diffuse;
    Output.Diffuse.a = diffuse.a*0.5f; 
    
    return Output;    
}

struct PS_OUTPUT
{
    float4 RGBColor : COLOR0; 
};


PS_OUTPUT RenderScenePS( VS_OUTPUT In ) 
{ 
    PS_OUTPUT Output;

	Output.RGBColor = In.Diffuse;
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













//VS_OUTPUT RenderSceneVS( float4 vPos : POSITION, float3 seminormal : NORMAL, float4 diffuse : COLOR0 )
//{
//    VS_OUTPUT Output;
//    float distancia;
//    float kDifuso;
//    float kEspecular;
//    float3 H;
    
//    Output.Position = mul(vPos, g_mViewProjection);
    
    // Componente difusa: parecido a dot, pero ahora la seminormal esta "tendida" sobre el plano
//    kDifuso = 1.0f - abs( dot( seminormal, g_LightPos ) );
    
    // Componente especular
//    kEspecular = 1.0f - abs( dot( seminormal, g_H ) );
//    kEspecular = pow( kEspecular, g_SpecularPower );
    
    // Distancia al foco de luz
//    distancia = distance( g_LightPos, vPos);
    
    // Modelo iluminacion Phong "retocado"
//    Output.Diffuse.rgb = (kDifuso*g_LightDiffuse + 3.5*kEspecular*g_LightSpecular)/distancia + (0.3,0.3,0.3);
//    Output.Diffuse.rgb *= diffuse;
    //Output.Diffuse.a = diffuse.a*0.5f; FIXME
 //   Output.Diffuse.a = diffuse.a; 
    
//    return Output;    
//}
