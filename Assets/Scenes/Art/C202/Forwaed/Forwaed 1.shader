Shader "Unlit/Forward1"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _ParallaxMap("ParallaxMap",2D) = "black"{}
        _AOMap ("AOMap",2D) = "white"{}
        _SpecMask("SpecMask",2D) = "white"{}
        _NormalMap("NormalMap",2D) = "white"{}
        _NormalIntensity ("NormalIntensity",Range(0,5)) = 1.0
        _Shininess ("Shininess",Range(0.01,100)) = 1.0 
        _SpecIntensity("SpecIntensity",Range(0.01,5)) = 1.0
        _Parallax("Parallax",Float) = 2
        //_AmbientColor("AmbientColor",Color) = (0,0,0,0)


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
                SHADOW_COORDS(5)
            };

            sampler2D _MainTex;
            sampler2D _AOMap;
            sampler2D _SpecMask;
            sampler2D _NormalMap;
            float _NormalIntensity;
            float4 _MainTex_ST;
            float3 _LightColor0;
            float _Shininess;
            float4 _AmbientColor;
            float _SpecIntensity;
            sampler2D _ParallaxMap;
            float _Parallax;

            float3 ACESFilm(float3 x)
			{
				float a = 2.51f;
				float b = 0.03f;
				float c = 2.43f;
				float d = 0.59f;
				float e = 0.14f;
				return saturate((x*(a*x + b)) / (x*(c*x + d) + e));
			};

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
                o.normal_dir = normalize(mul(float4(v.normal,0.0),unity_WorldToObject).xyz);
                o.tangent_dir = normalize(mul(unity_ObjectToWorld,float4(v.tangent.xyz,0.0)).xyz);
                o.binormal_dir = normalize(cross(o.normal_dir,o.tangent_dir)) * v.tangent.w;
                o.pos_world = mul(unity_ObjectToWorld,v.vertex).xyz;
                TRANSFER_SHADOW(o)
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                half shadow = SHADOW_ATTENUATION(i);

                float3 view_dir = normalize(_WorldSpaceCameraPos.xyz - i.pos_world);
                float3 normal_dir = normalize(i.normal_dir);
                float3 tangent_dir = normalize(i.tangent_dir);
                float3 binormal_dir = normalize(i.binormal_dir);
                float3x3 TBN = float3x3(tangent_dir,binormal_dir,normal_dir);             
                float3 view_tangentspace = normalize(mul(TBN,view_dir));
                float2 uv_parallax = i.texcoord;
                for(int j = 0; j < 10;j++)
                {
                float height = tex2D(_ParallaxMap, uv_parallax);             
                uv_parallax = uv_parallax - (0.5 - height) * view_tangentspace.xy * _Parallax * 0.01;
                }

                float4 base_color = tex2D(_MainTex,uv_parallax);
                base_color = pow(base_color,2.2);
                float4 ao_color = tex2D(_AOMap,uv_parallax);
                float4 spec_mask = tex2D(_SpecMask,uv_parallax);
                float4 normalmap = tex2D(_NormalMap,uv_parallax);
                float3 normal_data = UnpackNormal(normalmap);
                //normal_data.xy = normalize(normal_data.xy * _NormalIntensity);

                //NormalMap
                normal_dir = normalize(mul(normal_data.xyz,TBN));
                //normal_dir = normalize(tangent_dir * normal_data.x * _NormalIntensity + binormal_dir * normal_data.y * _NormalIntensity + normal_dir * normal_data.z);
             
                float3 light_dir = normalize(_WorldSpaceLightPos0.xyz);
                float diff_term = min(shadow,max(0.0,dot(normal_dir,light_dir)));
                float3 diffuse_color = diff_term * _LightColor0.xyz * base_color.xyz;
                //phong
                float3 reflect_dir = reflect(-light_dir,normal_dir);
                float3 RdotV = dot(reflect_dir,view_dir);

                float3 half_dir = normalize(light_dir + view_dir);
                float NdotH = dot(normal_dir,half_dir);
                float3 spec_color = pow(max(0.0,NdotH),_Shininess) 
                       * diff_term * _LightColor0.xyz * base_color.xyz * _SpecIntensity * spec_mask;

                float3 ambient_color = UNITY_LIGHTMODEL_AMBIENT.rgb * base_color;
                float3 final_color = (spec_color + diffuse_color + ambient_color) * ao_color;
                float3 tone_color = ACESFilm(final_color);
                tone_color = pow(tone_color,1.0/2.2); 
                return float4(tone_color,1.0);
            }
            ENDCG
        }
    }
    Fallback "Diffuse"
}
