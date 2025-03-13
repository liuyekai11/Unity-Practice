Shader "Unlit/LightProbe"
{
    Properties
    {
        _NormalMap("NormalMap",2D) = "bump"{}
        _NormalIndensity("NormalIndensity",Float) = 1
        _Tint("Tint",Color) = (1,1,1,1)
        _Expose("Expose",Float) = 1
        _Rotate("Rotate",Range(0,360)) = 0
        _AOMap("AOMap",2D) = "white"{}
        _AOContrast("AOContrast",Range(0,1)) = 0 

    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            Tags{"LightMode"="ForwardBase"}
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fwdbase
            #include "AutoLight.cginc"
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD0;
                float3 normal:NORMAL; 
                float4 tangent:TANGENT;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 pos : SV_POSITION;
                float3 normal_world:TEXCOORD1;
                float3 pos_world:TEXCOORD2;
                float3 tangent_world:TEXCOORD3;
                float3 binormal_world:TEXCOORD4;
            };
 
            sampler2D _NormalMap;
            float _NormalIndensity;
            float4 _NormalMap_ST;
            sampler2D _AOMap;
            float _AOContrast;
            float4 _Tint;
            float _Expose;
            float _Rotate;


            float3 RotateAround(float degree,float3 target)
            {
                float rad = degree * UNITY_PI/180;//½Ç¶È×ª»¡¶È
                float2x2 m_rotate = float2x2(cos(rad),-sin(rad),
                                             sin(rad),cos(rad));
                float2 dir_rotate = mul(m_rotate,target.xz);
                target = float3(dir_rotate.x,target.y,dir_rotate.y);
                return target;
            }

            inline float3 ACES_Tonemapping(float3 x)
			{
				float a = 2.51f;
				float b = 0.03f;
				float c = 2.43f;
				float d = 0.59f;
				float e = 0.14f;
				float3 encode_color = saturate((x*(a*x + b)) / (x*(c*x + d) + e));
				return encode_color;
			} 

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord * _NormalMap_ST.xy + _NormalMap_ST.zw;
                o.pos_world = mul(unity_ObjectToWorld,v.vertex).xyz;
                o.normal_world = normalize(mul(float4(v.normal,0.0),unity_WorldToObject).xyz);
                o.tangent_world = normalize(mul(unity_ObjectToWorld,float4(v.tangent.xyz,0.0)).xyz);
                o.binormal_world = normalize(cross(o.normal_world,o.tangent_world)) * v.tangent.w;
                //o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                return o;
            }

            half4 frag (v2f i) : SV_Target
            { 
                half3 normal_dir = normalize(i.normal_world);
                half3 normaldata = UnpackNormal(tex2D(_NormalMap,i.uv));
                normaldata.xy = normaldata.xy * _NormalIndensity;
                half3 tangent_dir = normalize(i.tangent_world);
                half3 binormal_dir = normalize(i.binormal_world);

                normal_dir = normalize(tangent_dir * normaldata.x + binormal_dir 
                * normaldata.y + normal_dir * normaldata.z);

                half4 ao_color = tex2D(_AOMap,i.uv);
                ao_color = pow(ao_color,_AOContrast);

                half3 env_color = ShadeSH9(float4(normal_dir,1.0));
                
                half3 final_color = env_color * ao_color * _Tint.rgb * _Tint.rgb * _Expose;
                half3 final_color_linear = pow(final_color,2.2); 
                half3 final_color_ACES = ACES_Tonemapping(final_color_linear);
                half3 final_color_gamma = pow(final_color_ACES,1.0/2.2);

                return float4(final_color_gamma,0.0);
            }
            ENDCG
        }
    }
}
