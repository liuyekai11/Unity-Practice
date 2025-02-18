// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'
Shader "Practise3"
{
	Properties
	{
		// _Float("Float",Float) = 0.0
		// _Range("Range",Range(0.0,1.0) = 0.0
		// _Vector("Vector",Vector) = (1,1,1,1)
		//_Color("Color",Color) = (0.5,0.5,0.5,0.5)
		_Maintex("Texture",2D) = "White"{}
		_Cutout("Cutout",Range(-0.1,1.1)) =0.0
		_Speed("Speed",Vector) = (1,1,0,0)
		_NoisoTex("_NoisoTex",2D) = "White"{}
		_MainColor("MainColor",Color) = (0,0,0,0)
		[Enum(UnityEngine.Rendering.CullMode)]_CullMode ("CullMode", float) = 2
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
				// float3 normal : NORMAL;
				// float4 color : COLOR;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
				//float2 pos_uv : TEXCOORD1;
			};
			float4 _Color;
			sampler2D _Maintex;
			float4 _Maintex_ST;
			float _Cutout;
			float4 _Speed;
			sampler2D _NoisoTex;
			float4 _NoisoTex_ST;
			float4 _MainColor;

			v2f vert(appdata v)
			{
				v2f o;
				//float4 pos_world = mul(unity_ObjectToWorld, v.vertex);
				//float4 pos_view = mul(UNITY_MATRIX_V, pos_world);
				//float4 pos_clip = mul(UNITY_MATRIX_P, pos_view);
				//o.pos = pos_clip;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv * _Maintex_ST.xy + _Maintex_ST.zw;
				//o.pos_uv = v.vertex * _Maintex_ST.xy + _Maintex_ST.zw;
				return o;
			}

			half4 frag(v2f i) : SV_Target
			{
				half gradient = tex2D(_Maintex,i.uv + _Time.y * _Speed.xy).r;
				half noiso = tex2D(_NoisoTex,i.uv + _Time.y * _Speed.zw).r;
				clip(gradient - noiso - _Cutout);
				return _MainColor;
				//return float4(i.uv,0,0);
			}

			ENDCG
		}
	}
}