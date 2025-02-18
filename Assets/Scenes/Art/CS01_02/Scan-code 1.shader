// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "Unlit/Scan-code"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _RimMin ("RimMin",Range(-1,1)) = 0.0
        _RimMax ("RimMax",Range(0,2)) = 1.0
        _ColorN ("Color",Color) = (1,1,1,1)
        _ColorW ("Color",Color) = (1,1,1,1)
        _RimTntensity ("Float",Float) = 1.0

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
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _RimMin;
            float _RimMax;
            float4 _ColorN;
            float4 _ColorW;
            float _RimTntensity;


            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);             
                float3 normal_world = mul((float3x3)unity_ObjectToWorld, v.normal);
                float3 pos_world = mul(unity_ObjectToWorld,v.vertex).xyz;
                o.normal_world = normalize(normal_world);
                o.pos_world = pos_world;
                o.uv = v.texcoord0;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                half3 normal_world = normalize(i.normal_world);
                half3 view_world = normalize(_WorldSpaceCameraPos.xyz - i.pos_world);
                half NdotV = saturate(dot(normal_world, view_world));
                half fresnel = 1-NdotV;              
                fresnel = smoothstep(_RimMin, _RimMax, fresnel);
                float4 col = lerp(mul(_ColorN, _RimTntensity), _ColorW, fresnel);
                //fixed4 col = tex2D(_MainTex, i.uv);
                return col;
            }
            ENDCG
        }
    }
}
