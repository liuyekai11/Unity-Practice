// Made with Amplify Shader Editor v1.9.8.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASE-Fowaed"
{
	Properties
	{
		_BaseColor("BaseColor", Color) = (0,0,0,0)
		_BaseTex("BaseTex", 2D) = "white" {}
		_ReflectTex("ReflectTex", 2D) = "white" {}
		_ReflectColor("ReflectColor", Color) = (0,0,0,0)
		_AmbientTex("AmbientTex", 2D) = "white" {}
		_AmbientColor("AmbientColor", Color) = (0,0,0,0)
		_NormalTex("NormalTex", 2D) = "white" {}
		_EdgeLength ( "Edge length", Range( 2, 50 ) ) = 15
		_Power("Power", Range( 0 , 100)) = 0
		_NormalIntensity("NormalIntensity", Range( 0 , 1)) = 0
		_x("x", Range( -90 , 90)) = 21.52174
		_y("y", Range( -90 , 90)) = 21.52174
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "Tessellation.cginc"
		#include "Lighting.cginc"
		#pragma target 4.6
		#define ASE_VERSION 19801
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float3 worldNormal;
			INTERNAL_DATA
			float3 worldPos;
		};

		struct SurfaceOutputCustomLightingCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		uniform sampler2D _BaseTex;
		uniform float4 _BaseTex_ST;
		uniform float _x;
		uniform float _y;
		uniform sampler2D _NormalTex;
		uniform float4 _NormalTex_ST;
		uniform float _NormalIntensity;
		uniform float4 _BaseColor;
		uniform sampler2D _ReflectTex;
		uniform float4 _ReflectTex_ST;
		uniform float _Power;
		uniform float4 _ReflectColor;
		uniform float4 _AmbientColor;
		uniform sampler2D _AmbientTex;
		uniform float4 _AmbientTex_ST;
		uniform float _EdgeLength;

		void vertexDataFunc( inout appdata_full v )
		{
		}

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			c.rgb = 0;
			c.a = 1;
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
			o.Normal = float3(0,0,1);
			float2 uv_BaseTex = i.uv_texcoord * _BaseTex_ST.xy + _BaseTex_ST.zw;
			float3 appendResult43 = (float3(1.0 , 0.0 , 0.0));
			float temp_output_40_0 = cos( ( ( -_x / 180.0 ) * UNITY_PI ) );
			float temp_output_41_0 = sin( ( ( -_x / 180.0 ) * UNITY_PI ) );
			float3 appendResult46 = (float3(0.0 , temp_output_40_0 , ( temp_output_41_0 * 1.0 )));
			float3 appendResult47 = (float3(0.0 , temp_output_41_0 , temp_output_40_0));
			float temp_output_52_0 = cos( ( ( -_y / 180.0 ) * UNITY_PI ) );
			float temp_output_53_0 = sin( ( ( -_y / 180.0 ) * UNITY_PI ) );
			float3 appendResult55 = (float3(temp_output_52_0 , 0.0 , temp_output_53_0));
			float3 appendResult57 = (float3(0.0 , 1.0 , 0.0));
			float3 appendResult58 = (float3(( temp_output_53_0 * 1.0 ) , 0.0 , temp_output_52_0));
			float3x3 light60 = mul( float3x3(appendResult43, appendResult46, appendResult47), float3x3(appendResult55, appendResult57, appendResult58) );
			float2 uv_NormalTex = i.uv_texcoord * _NormalTex_ST.xy + _NormalTex_ST.zw;
			float3 tex2DNode5 = UnpackNormal( tex2D( _NormalTex, uv_NormalTex ) );
			float3 ase_tangentWS = WorldNormalVector( i, float3( 1, 0, 0 ) );
			float4 ase_tangentOS = mul( unity_WorldToObject, float4( ase_tangentWS, 0 ) );
			ase_tangentOS = normalize( ase_tangentOS );
			float3 ase_bitangentWS = WorldNormalVector( i, float3( 0, 1, 0 ) );
			float3 ase_bitangentOS = mul( unity_WorldToObject, float4( ase_bitangentWS, 0 ) );
			ase_bitangentOS = normalize( ase_bitangentOS );
			float3 ase_normalWS = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_normalOS = mul( unity_WorldToObject, float4( ase_normalWS, 0 ) );
			ase_normalOS = normalize( ase_normalOS );
			float3 temp_output_9_0 = ( ( ( tex2DNode5.r * ase_tangentOS.xyz ) * _NormalIntensity ) + ( ( tex2DNode5.g * ase_bitangentOS ) * _NormalIntensity ) + ( tex2DNode5.b * ase_normalOS ) );
			float dotResult73 = dot( mul( light60, float3(1,1,1) ) , temp_output_9_0 );
			float2 uv_ReflectTex = i.uv_texcoord * _ReflectTex_ST.xy + _ReflectTex_ST.zw;
			float3 ase_positionWS = i.worldPos;
			float3 ase_viewVectorWS = ( _WorldSpaceCameraPos.xyz - ase_positionWS );
			float3 ase_viewDirWS = normalize( ase_viewVectorWS );
			float dotResult14 = dot( reflect( mul( light60, float3(-1,-1,-1) ) , temp_output_9_0 ) , ase_viewDirWS );
			float temp_output_63_0 = max( 0.0 , dotResult14 );
			float2 uv_AmbientTex = i.uv_texcoord * _AmbientTex_ST.xy + _AmbientTex_ST.zw;
			o.Emission = ( ( float4( ( tex2D( _BaseTex, uv_BaseTex ).rgb * max( 0.0 , dotResult73 ) * _BaseColor.rgb ) , 0.0 ) + ( tex2D( _ReflectTex, uv_ReflectTex ) * pow( temp_output_63_0 , _Power ) * float4( _ReflectColor.rgb , 0.0 ) ) + float4( _AmbientColor.rgb , 0.0 ) ) * float4( tex2D( _AmbientTex, uv_AmbientTex ).rgb , 0.0 ) ).rgb + 1E-5;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardCustomLighting keepalpha fullforwardshadows noforwardadd vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 4.6
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputCustomLightingCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputCustomLightingCustom, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "AmplifyShaderEditor.MaterialInspector"
}
/*ASEBEGIN
Version=19801
Node;AmplifyShaderEditor.RangedFloatNode;35;-3024,-1952;Inherit;False;Property;_x;x;16;0;Create;True;0;0;0;False;0;False;21.52174;0;-90;90;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;48;-2976,-1472;Inherit;False;Property;_y;y;17;0;Create;True;0;0;0;False;0;False;21.52174;0;-90;90;0;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;36;-2704,-1968;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;49;-2656,-1488;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;37;-2432,-1936;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;180;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;50;-2384,-1456;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;180;False;1;FLOAT;0
Node;AmplifyShaderEditor.PiNode;39;-2192,-1936;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PiNode;51;-2144,-1456;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;41;-1952,-1792;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;53;-1904,-1328;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CosOpNode;40;-1952,-1920;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;-1712,-1968;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CosOpNode;52;-1904,-1456;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;54;-1712,-1248;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;43;-1520,-2112;Inherit;False;FLOAT3;4;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;46;-1520,-1952;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;47;-1520,-1808;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;55;-1504,-1616;Inherit;False;FLOAT3;4;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;57;-1504,-1456;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;58;-1504,-1312;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.MatrixFromVectors;45;-1264,-1968;Inherit;False;FLOAT3x3;True;4;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3x3;0
Node;AmplifyShaderEditor.MatrixFromVectors;56;-1248,-1472;Inherit;False;FLOAT3x3;True;4;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3x3;0
Node;AmplifyShaderEditor.SamplerNode;5;-2576,192;Inherit;True;Property;_NormalTex;NormalTex;6;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.TangentVertexDataNode;2;-2464,384;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BitangentVertexDataNode;3;-2496,544;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;-896,-1680;Inherit;True;2;2;0;FLOAT3x3;1,0,0,0,1,0,0,0,1;False;1;FLOAT3x3;1,0,0,0,1,0,0,0,1;False;1;FLOAT3x3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-2064,528;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-2064,400;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalVertexDataNode;4;-2464,704;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;60;-528,-1680;Inherit;False;light;-1;True;1;0;FLOAT3x3;1,0,0,0,1,0,0,0,1;False;1;FLOAT3x3;0
Node;AmplifyShaderEditor.RangedFloatNode;92;-2080,848;Inherit;False;Property;_NormalIntensity;NormalIntensity;14;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-2064,656;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;61;-2016,-16;Inherit;True;60;light;1;0;OBJECT;;False;1;FLOAT3x3;0
Node;AmplifyShaderEditor.Vector3Node;62;-2000,176;Inherit;False;Constant;_Vector0;Vector 0;3;0;Create;True;0;0;0;False;0;False;-1,-1,-1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;91;-1824,464;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;93;-1824,624;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-1680,80;Inherit;False;2;2;0;FLOAT3x3;1,0,0,0,1,0,0,0,1;False;1;FLOAT3;1,1,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;9;-1616,480;Inherit;True;3;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;15;-1344,576;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ReflectOpNode;10;-1392,320;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;76;-2000,-160;Inherit;False;Constant;_Vector1;Vector 0;3;0;Create;True;0;0;0;False;0;False;1,1,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;75;-2016,-352;Inherit;True;60;light;1;0;OBJECT;;False;1;FLOAT3x3;0
Node;AmplifyShaderEditor.DotProductOpNode;14;-1056,352;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;77;-1680,-240;Inherit;False;2;2;0;FLOAT3x3;1,0,0,1,0,0,1,0,1;False;1;FLOAT3;1,1,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DotProductOpNode;73;-1392,-96;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;89;-912,784;Inherit;False;Property;_Power;Power;13;0;Create;True;0;0;0;False;0;False;0;0;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;63;-752,368;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;85;-464,576;Inherit;False;Property;_ReflectColor;ReflectColor;3;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.PowerNode;88;-592,368;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;78;-1056,-128;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;81;-1136,-368;Inherit;True;Property;_BaseTex;BaseTex;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode;82;-1072,16;Inherit;False;Property;_BaseColor;BaseColor;0;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode;83;-560,144;Inherit;True;Property;_ReflectTex;ReflectTex;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;80;-736,-208;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;84;-192,352;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;90;-176,592;Inherit;False;Property;_AmbientColor;AmbientColor;5;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode;86;-128,880;Inherit;True;Property;_AmbientTex;AmbientTex;4;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleAddOpNode;79;128,176;Inherit;True;3;3;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;65;-432,400;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;67;-912,672;Inherit;False;Property;_ReflectMax;ReflectMax;15;0;Create;True;0;0;0;False;0;False;0;0;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;66;-912,576;Inherit;False;Property;_ReflectMin;ReflectMin;12;0;Create;True;0;0;0;False;0;False;0;0;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;87;352,720;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;592,16;Float;False;True;-1;6;AmplifyShaderEditor.MaterialInspector;0;0;Unlit;ASE-Fowaed;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;True;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;7;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;36;0;35;0
WireConnection;49;0;48;0
WireConnection;37;0;36;0
WireConnection;50;0;49;0
WireConnection;39;0;37;0
WireConnection;51;0;50;0
WireConnection;41;0;39;0
WireConnection;53;0;51;0
WireConnection;40;0;39;0
WireConnection;42;0;41;0
WireConnection;52;0;51;0
WireConnection;54;0;53;0
WireConnection;46;1;40;0
WireConnection;46;2;42;0
WireConnection;47;1;41;0
WireConnection;47;2;40;0
WireConnection;55;0;52;0
WireConnection;55;2;53;0
WireConnection;58;0;54;0
WireConnection;58;2;52;0
WireConnection;45;0;43;0
WireConnection;45;1;46;0
WireConnection;45;2;47;0
WireConnection;56;0;55;0
WireConnection;56;1;57;0
WireConnection;56;2;58;0
WireConnection;59;0;45;0
WireConnection;59;1;56;0
WireConnection;7;0;5;2
WireConnection;7;1;3;0
WireConnection;6;0;5;1
WireConnection;6;1;2;0
WireConnection;60;0;59;0
WireConnection;8;0;5;3
WireConnection;8;1;4;0
WireConnection;91;0;6;0
WireConnection;91;1;92;0
WireConnection;93;0;7;0
WireConnection;93;1;92;0
WireConnection;11;0;61;0
WireConnection;11;1;62;0
WireConnection;9;0;91;0
WireConnection;9;1;93;0
WireConnection;9;2;8;0
WireConnection;10;0;11;0
WireConnection;10;1;9;0
WireConnection;14;0;10;0
WireConnection;14;1;15;0
WireConnection;77;0;75;0
WireConnection;77;1;76;0
WireConnection;73;0;77;0
WireConnection;73;1;9;0
WireConnection;63;1;14;0
WireConnection;88;0;63;0
WireConnection;88;1;89;0
WireConnection;78;1;73;0
WireConnection;80;0;81;5
WireConnection;80;1;78;0
WireConnection;80;2;82;5
WireConnection;84;0;83;0
WireConnection;84;1;88;0
WireConnection;84;2;85;5
WireConnection;79;0;80;0
WireConnection;79;1;84;0
WireConnection;79;2;90;5
WireConnection;65;0;63;0
WireConnection;65;1;66;0
WireConnection;65;2;67;0
WireConnection;87;0;79;0
WireConnection;87;1;86;5
WireConnection;0;15;87;0
ASEEND*/
//CHKSM=2007EA3ED64530A58AFE05399FF9C130E688C0C7