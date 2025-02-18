Shader "Unlit/Forward"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _AOMap ("AOMap",2D) = "white"{}
        _SpecMask("SpecMask",2D) = "white"{}
        _NormalMap("NormalMap",2D) = "white"{}
        _Shininess ("Shininess",Range(0.01,100)) = 1.0 
        _SpecIntensity("SpecIntensity",Range(0.01,5)) = 1.0
        _AmbientColor("AmbientColor",Color) = (0,0,0,0)


    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            Tags {"LightMode" = "ForwardBase"}
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fwdbase
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD0;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
            };

            struct v2f
            {
                float2 texcoord : TEXCOORD0;
                float4 pos : SV_POSITION;
                float3 normal_dir : TEXCOORD1;
                float3 pos_world : TEXCOORD2;
                float3 tangent_dir : TEXCOORD3;
                float3 binormal_dir : TEXCOORD4;
            };

            sampler2D _MainTex;
            sampler2D _AOMap;
            sampler2D _SpecMask;
            sampler2D _NormalMap;
            float4 _MainTex_ST;
            float3 _LightColor0;
            float _Shininess;
            float4 _AmbientColor;
            float _SpecIntensity;
            

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
                o.normal_dir = normalize(mul(float4(v.normal,0.0),unity_WorldToObject).xyz);
                o.tangent_dir = normalize(mul(unity_ObjectToWorld,float4(v.tangent.xyz,0.0)).xyz);
                o.binormal_dir = normalize(cross(o.normal_dir,o.tangent_dir)) * v.tangent.w;
                o.pos_world = mul(unity_ObjectToWorld,v.vertex).xyz;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float4 base_color = tex2D(_MainTex,i.texcoord);
                float4 ao_color = tex2D(_AOMap,i.texcoord);
                float4 spec_mask = tex2D(_SpecMask,i.texcoord);
                float4 normalmap = tex2D(_NormalMap,i.texcoord);
                float3 normal_data = UnpackNormal(normalmap);

                //NormalMap
                float3 normal_dir = normalize(i.normal_dir);
                float3 tangent_dir = normalize(i.tangent_dir);
                float3 binormal_dir = normalize(i.binormal_dir);

                float3 view_dir = normalize(_WorldSpaceCameraPos.xyz - i.pos_world);
                float3 light_dir = normalize(_WorldSpaceLightPos0.xyz);
                float NdotL = dot(normal_dir,light_dir);
                float3 diffuse_color = max(0.0,NdotL) * _LightColor0.xyz * base_color.xyz;

                normal_dir = normalize(tangent_dir * normal_data.x + binormal_dir * normal_data.y + normal_dir * normal_data.z);

                float3 reflect_dir = reflect(-light_dir,normal_dir);
                float3 RdotV = dot(reflect_dir,view_dir);
                float3 spec_color = pow(max(0.0,RdotV),_Shininess) * _LightColor0.xyz * base_color.xyz * _SpecIntensity * spec_mask;
                float3 final_color = (spec_color + diffuse_color + _AmbientColor) * ao_color;
                return float4(final_color,1.0);
            }
            ENDCG
        }
    }
}
