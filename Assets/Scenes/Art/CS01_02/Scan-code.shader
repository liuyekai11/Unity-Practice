Shader "Unlit/Scan-code"
{
    Properties
    {
        _RimMin("RimMin",Range(-1,1)) = 0.0
        _RimMax("RimMax",Range(0,2)) = 1.0
        _ColorN("ColorN",Color) = (1,1,1,1)
        _ColorW("ColorW",Color) = (1,1,1,1)
        _RimTntensity("RimTntensity",Float) = 1.0
        _FlowSpeed("Flow Speed", Vector) = (1,1,0,0)
        _FlowTilling("Flow Tilling", Vector) = (1,1,0,0)
        _FlowTex("Flow Tex", 2D) = "white"{}
        _FlowIntensity("FlowIntensity",Float) = 1.0

    }
    SubShader
    {
        Tags { "Queue"="Transparent" }
        LOD 100

        Pass
        {
            Blend SrcAlpha One
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 pos_world : TEXCOORD1;                      
                float3 normal_world : TEXCOORD2;
                float3 pivot_world : TEXCOORD3;
            };

            sampler2D _FlowTex;
            float4 _FlowTex_ST;
            float _RimMin;
            float _RimMax;
            float4 _ColorN;
            float4 _ColorW;
            float _RimTntensity;
            float4 _FlowSpeed;
            float4 _FlowTilling;
            float _FlowIntensity;


            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);             
                float3 normal_world = mul((float3x3)unity_ObjectToWorld, v.normal);
                float3 pos_world = mul(unity_ObjectToWorld,v.vertex).xyz;
                o.normal_world = normalize(normal_world);
                o.pivot_world = mul(unity_ObjectToWorld, float4(0.0, 0.0, 0.0,1.0));
                o.pos_world = pos_world;
                o.uv = v.texcoord0;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                //±ßÔµ¹â
                half3 normal_world = normalize(i.normal_world);
                half3 view_world = normalize(_WorldSpaceCameraPos.xyz - i.pos_world);
                half NdotV = saturate(dot(normal_world, view_world));
                half fresnel = 1-NdotV;              
                fresnel = smoothstep(_RimMin, _RimMax, fresnel);

                half3 col= lerp(_ColorW.xyz, _ColorN.xyz * _RimTntensity, fresnel);
                half Alpha = fresnel;
                //Á÷¹â
                half2 uv_flow = (i.pos_world.xy -i.pivot_world.xy) * _FlowTilling;
                uv_flow = uv_flow + _Time.y * _FlowSpeed.xy;
                float4 flow_texture = tex2D(_FlowTex, uv_flow) * _FlowIntensity;

                float3 final_col = col + flow_texture.xyz;
                float final_Alpha = saturate(Alpha + flow_texture.a); 

                return float4(final_col, final_Alpha);
                //return flow_rgba;
            }
            ENDCG
        }
    }
}
