Shader "Unlit/Matcap"
{
    Properties
    {
        _MainTex ("Diffuse", 2D) = "white" {}
        _Matcap ("Matcap", 2D) = "white" {}
        _MatcapIntensity("MatcapIntencity", Float) = 1.0
        _MatcapAdd ("Matcap Add", 2D) = "white" {}
        _MatcapAddIntensity ("MatcapAdd Intencity", Float) = 1.0
        //_NormalMap ("NormalMap", 2D) = "white" {}
        _RampTex ("RampTex",2D) = "white"{}

    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f
            {               
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 normal_world : TEXCOORD1;
                float3 pos_world : TEXCOORD2;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _Matcap;
            sampler2D _MatcapAdd;
            float _MatcapIntensity;
            float _MatcapAddIntensity;
            sampler2D _RampTex;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.pos_world = mul(unity_ObjectToWorld,v.vertex).xyz;
                float3 normal_world = normalize(mul(float4(v.normal,0.0),unity_WorldToObject));
                o.normal_world = normal_world;
                return o;
            }
            
            fixed4 frag (v2f i) : SV_Target
            {
                half3 normal_world = normalize(i.normal_world);
                half3 normal_viewspace = mul(UNITY_MATRIX_V, float4(normal_world,0.0)).xyz;
                half2 uv_matcap = (normal_viewspace.xy + float2(1.0,1.0)) * 0.5;
                half4 matcap_color = tex2D(_Matcap, uv_matcap) * _MatcapIntensity;

                half4 matcap_add_color = tex2D(_MatcapAdd, uv_matcap) * _MatcapAddIntensity;

                half4 diffues_color = tex2D(_MainTex, i.uv);

                half3 view_dir = normalize(_WorldSpaceCameraPos - i.pos_world);
                half NdotV = saturate(dot(normal_world,view_dir));
                half fresnel = 1 - NdotV;
                half2 uv_ramp = half2(fresnel,0.5);
                half4 ramp_color = tex2D(_RampTex,uv_ramp);

                half4 col = matcap_color * diffues_color * ramp_color + matcap_add_color;
                return col;
            }
            ENDCG
        }
    }
}
