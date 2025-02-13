
Shader "cs1"
{
	Properties
	{
		_Float("Float", Float) = 0.0
		_Cutout("Cutout",Range(-0.1,1.1)) = 0.0
		_Speed("Speed", Vector) = (1,1,0,0)
		// _Range("Range", Range(0.0,1.0)) = 0.0
		// _Vector("Vector", Vector) = (1,1,1,1)
		// _Color("Color", Color) = (0.5,0.5,0.5,0.5)
		_MainTex("MainTex", 2D) = "white"{}
		[Enum(UnityEngine.Rendering.CullMode)]_CullMode("CullMode", float) = 2
	}
	SubShader
	{
		Pass
		{
			Cull [_CullMode]
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				//float3 normal : NORMAL;
				//float4 color : COLOR;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float2 uv :TEXCOORD0;
				//float2 pos_uv : TEXCOORD1;
			};
			//float4 _Color;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _Cutout;
			float4 _Speed;

			v2f vert(appdata v)
			{
				v2f o;
				// float4 pos_world = mul(unity_ObjectToWorld, v.vertex);
				// float4 pos_view = mul(UNITY_MATRIX_V, pos_world);
				// float4 pos_clip = mul(UNITY_MATRIX_P, pos_view);
				o.pos = UnityObjectToClipPos(v.vertex);
				//o.pos = pos_clip;
				o.uv = v.uv * _MainTex_ST.xy + _MainTex_ST.zw;
				//o.pos_uv = v.vertex.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				return o;
			}

			float4 frag(v2f i) : SV_Target
			{
				float4 gradient = tex2D(_MainTex,i.uv + _Time.y * _Speed.xy).r;
				clip(gradient - _Cutout);
				return gradient;
			}

			ENDCG
		}
	}
}