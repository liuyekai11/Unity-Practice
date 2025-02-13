Shader"Fresnel"
{
	Properties
	{
		_Color("Color",Color) = (1,1,1,1)
	}
	SubShader
	{
		Tags {"Queue" = "Transparent"}
		Pass
		{
			Blend SrcAlpha OneMinusSrcAlpha
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			float4 _Color;

			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float3 world_normal : TEXCOORD1;
				float3 view_normal : TEXCOORD2;
			};

			v2f vert(appdata v)
			{
			  v2f o;
			  o.pos = UnityObjectToClipPos(v.vertex);
			  o.world_normal = normalize(mul(v.normal, (float3x3)unity_ObjectToWorld));
			  float3 pos_world = mul(unity_ObjectToWorld,v.vertex).xyz;
			  o.view_normal = normalize(_WorldSpaceCameraPos - pos_world);
			  return o;
			}

			float4 frag(v2f i) : SV_Target
			{
			float3 world_normal = normalize(i.world_normal);
			float3 view_normal = normalize(i.view_normal);
			float NDOTV = 1 - dot(world_normal,view_normal);
			return NDOTV;
			}
			ENDCG
		}
	}
}