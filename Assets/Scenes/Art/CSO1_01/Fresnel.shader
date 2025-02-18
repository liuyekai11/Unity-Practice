Shader "Practise5"
{
    Properties
    {

        [Enum(UnityEngine.Rendering.CullMode)] _CullMode("Cull Mode", float) = 2
    }
    SubShader
    {
        Tags { "Queue" = "Transparent" }
        Pass
        {
            Blend SrcAlpha OneMinusSrcAlpha
            Cull [_CullMode]
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float3 normal_world : TEXCOORD1;
                float3 view_world : TEXCOORD2;
            };


            v2f vert(appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.normal_world = normalize(mul(float4(v.normal,0.0),unity_WorldToObject).xyz);
                float3 pos_world = mul(unity_ObjectToWorld, v.vertex).xyz;
                o.view_world = normalize(_WorldSpaceCameraPos - pos_world);
                return o;
            }

            float4 frag(v2f i) : SV_Target
            {
                float3 normal_world = normalize(i.normal_world);
                float3 view_world = normalize(i.view_world);
                float NDOTV = 1 - dot(normal_world, view_world);
                return NDOTV;
            }
            ENDCG
        }
    }
}
