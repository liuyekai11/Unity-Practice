Shader "Unlit/CubeMap2"
{
    Properties
    {
        //_MainTex ("Texture", 2D) = "white" {}
        _CubeMap("CubeMap",Cube) = "white"{}
        _NormalMap("NormalMap",2D) = "bump"{}
        _NormalIntensity("NormalIntensity",Float) = 1
        _Rotate("Rotate",Range(0,360)) = 0
        _AoMap("AoMap",2D) = "white"{}
        _AoColor("AoColor",Color) = (1,1,1,1)
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
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float2 texcoord : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float3 normal_world : TEXCOORD1;
                float3 tangent_world : TEXCOORD2;
                float3 bitangent_world : TEXCOORD3;
                float3 pos_world : TEXCOORD4;
                float4 pos : SV_POSITION;
            };

            //sampler2D _MainTex;
            samplerCUBE _CubeMap;
            sampler2D _NormalMap;
            float4 _NormalMap_ST;
            float _NormalIntensity;
            sampler2D _AoMap;
            float4 _AoColor;
            //float4 _MainTex_ST;
            float4 _CubeMap_HDR;
            float _Rotate;
           

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.pos_world = mul(unity_ObjectToWorld,v.vertex);
                o.uv = v.texcoord * _NormalMap_ST.xy + _NormalMap_ST.zw;
                o.normal_world = normalize(mul(float4(v.normal,0.0),unity_WorldToObject).xyz);
                o.tangent_world = normalize(mul(unity_ObjectToWorld,float4(v.tangent.xyz,0.0)).xyz);
                o.bitangent_world = normalize(cross(o.normal_world,o.tangent_world) * v.tangent.w);
                //o.uv = TRANSFORM_TEX(v.texcoord,_NormalMap);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                //fixed4 col = tex2D(_MainTex, i.uv);
                float3 normal_dir = normalize(i.normal_world);
                float3 normaldata = UnpackNormal(tex2D(_NormalMap,i.uv));
                normaldata.xy = normaldata.xy * _NormalIntensity;
                float3 tangent_dir = normalize(i.tangent_world);
                float3 bitangent_dir = normalize(i.bitangent_world);
                normal_dir = tangent_dir * normaldata.x + bitangent_dir 
                             * normaldata.y + normal_dir * normaldata.z;
               
                float4 aocolor = tex2D(_AoMap,i.uv);
                float3 view_dir = normalize(_WorldSpaceCameraPos.xyz - i.pos_world);
                float3 reflect_dir = reflect(-view_dir,normal_dir);

                float rad = _Rotate * UNITY_PI/180;
                float2x2 m_rotate = float2x2(cos(rad),-sin(rad),sin(rad),cos(rad));
                float2 dir_rotate = mul(m_rotate,reflect_dir.xz);
                reflect_dir = float3(dir_rotate.x,reflect_dir.y,dir_rotate.y);

                float4 cubemap_color = texCUBE(_CubeMap,reflect_dir);
                float3 evn_color = DecodeHDR(cubemap_color,_CubeMap_HDR);
                float3 finel_color = evn_color * aocolor * _AoColor;
                return float4(finel_color,0.0);
            }
            ENDCG
        }
    }
}
