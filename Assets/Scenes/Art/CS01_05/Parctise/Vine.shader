Shader "Unlit/Vine 1"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Grow ("Grow",Range(-1,1.5)) = 0.0
        _GrowMin ("GrowMin",range(0.0,1.0)) = 0.6
        _GrowMax ("GrowMax",range(0.0,1.5)) = 1.35
        _EndMin ("EndMin",Range(0.0,1.0)) = 0.0
        _EndMax ("EndMax",Range(0.0,1.0)) = 0.0
        _Expand ("Expand",Float) = 0.0
        _Scale ("Scale",Float) = 0.0
        

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
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 pos : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Grow;
            float _GrowMin;
            float _GrowMax;
            float _EndMin;
            float _EndMax;
            float _Expand;
            float _Scale;

            v2f vert (appdata v)
            {
                v2f o;    
                float weight_expand = smoothstep(_GrowMin,_GrowMax,(v.texcoord.y - _Grow));
                float weight_end = smoothstep(_EndMin,_EndMax,(v.texcoord.y));
                float weight_combined = max(weight_expand,weight_end);
                float3 vertex_offset = weight_combined * v.normal * 0.01f * _Expand;
                float3 vertex_cale = v.normal * _Scale * 0.01;
                float3 final_offset = vertex_offset + vertex_cale; 
                v.vertex.xyz = v.vertex.xyz + final_offset;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                clip(1.0 - (i.uv.y - _Grow));
                fixed4 col = tex2D(_MainTex, i.uv);
                return col;
            }
            ENDCG
        }
    }
}
