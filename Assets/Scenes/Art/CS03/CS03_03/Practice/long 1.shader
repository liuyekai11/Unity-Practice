Shader "Unlit/long"
{
    Properties
    {
        _DiffuseColor ("Texture", Color) = (0,0,0,0)
        _Addcolor("AddColor",Color) = (0,0,0,0)
        _Opacity("Opaccity",Range(0,1)) = 0
        _Distort("Distort",Float) = 0.0
        _Power("Power",Float) = 1.0
        _Scale("Scale",Float) = 1.0
        _BacklightColor("backlightColor",Color) = (0,0,0,0)
        _ThicknessMap("ThicknessMap",2D) = "white"{}
        _CubeMap("CubeMap",Cube) = "white"{}
        _EnvRotate("EncRotate",Range(0,360)) = 0
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
                float2 texcoord : TEXCOORD0;
                float3 normal: NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 pos : SV_POSITION;
                float3 normal_world : TEXCOORD1;
                float3 pos_world :TEXCOORD2;
            };

            float4 _DiffuseColor;
            sampler2D _ThicknessMap;
            samplerCUBE _CubeMap;
            float4 _CubeMap_HDR;
            float4 _MainTex_ST;
            float4 _LightColor0;
            float _Distort;
            float _Power;
            float _Scale;
            float _EnvRotate;
            float4 _Addcolor;
            float _Opacity;
            float4 _BacklightColor;

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.normal_world = normalize(mul(float4(v.normal,0.0),unity_WorldToObject).xyz);
                o.pos_world = mul(unity_ObjectToWorld,v.vertex).xyz;
                o.uv = v.texcoord;                                                                     return o;
            }

            half4 frag (v2f i) : SV_Target
            {
                float3 normal_dir = normalize(i.normal_world);
                float3 view_dir = normalize(_WorldSpaceCameraPos - i.pos_world);
                float3 light_dir = normalize(_WorldSpaceLightPos0.xyz);

                //color
                float3 diffuse_color = _DiffuseColor.xyz;
                float diffuse_term = max(0.0,dot(normal_dir,light_dir));
                float3 diffuselight = diffuse_term * diffuse_color * _LightColor0.xyz;

                float sky_light = (dot(normal_dir,float3(0,1,0)) + 1.0) * 0.5;
                float3 sky_lightcolor = sky_light * diffuse_color;

                float3 final_diffuse = _Addcolor.xyz + diffuselight + sky_lightcolor * _Opacity;

                //投射;
                float3 back_dir = -normalize(light_dir + normal_dir * _Distort);
                float VdotB = max(0.0,dot(view_dir,back_dir));
                float backlight_term = max(0.0,pow(VdotB,_Power)) * _Scale;
                float thicness = 1 - tex2D(_ThicknessMap,i.uv).r;
                float3 backlight = backlight_term * _LightColor0.xyz; //* thicness * _BacklightColor;

                //光泽反射
                float3 reflect_dir = reflect(-view_dir,normal_dir);

                //旋转矩阵
                float rad = _EnvRotate * UNITY_PI/180;
                float2x2 m_rotate = float2x2(cos(rad),-sin(rad),sin(rad),cos(rad));
                float2 dir_rotate = mul(m_rotate,reflect_dir.xz);
                reflect_dir = float3(dir_rotate.x,reflect_dir.y,dir_rotate.y);

                float4 hdr_color = texCUBE(_CubeMap,reflect_dir);

                float3 fresnel = 1.0 - max(0.0,dot(normal_dir,view_dir));
                float3 env_color = DecodeHDR(hdr_color,_CubeMap_HDR);
                float3 final_env = env_color * fresnel;

                float3 fin_color = final_env + backlight + final_diffuse;
                return float4(backlight,0.0);
            }
            ENDCG
        }
    }
}
