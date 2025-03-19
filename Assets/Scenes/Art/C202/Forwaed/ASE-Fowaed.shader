// Made with Amplify Shader Editor v1.9.8.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASE-Fowaed"
{
	Properties
	{
		_BaseColor("BaseColor", Color) = (0,0,0,0)
		_BasePower("BasePower", Range( 0 , 100)) = 0
		_BaseColor2("BaseColor2", Color) = (0,0,0,0)
		_ReflectPower2("ReflectPower2", Range( 0 , 100)) = 0
		_BaseTex("BaseTex", 2D) = "white" {}
		_ReflectTex("ReflectTex", 2D) = "white" {}
		_ReflectColor("ReflectColor", Color) = (0,0,0,0)
		_ReflectPower("ReflectPower", Range( 0 , 150)) = 0
		_AmbientTex("AmbientTex", 2D) = "white" {}
		_AmbientColor("AmbientColor", Color) = (0,0,0,0)
		_NormalTex("NormalTex", 2D) = "white" {}
		_NormalIntensity("NormalIntensity", Range( 0 , 1)) = 0
		_Matcap("Matcap", 2D) = "white" {}
		_MapcapMask("MapcapMask", 2D) = "white" {}
		_MapcapIntensity("MapcapIntensity", Range( 0 , 5)) = 0
		_x("x", Range( -90 , 90)) = 21.52174
		_y("y", Range( -90 , 90)) = 21.52174
		_UV("UV", Vector) = (1,1,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.5
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

		uniform sampler2D _BaseTex;
		uniform float2 _UV;
		uniform float _x;
		uniform float _y;
		uniform sampler2D _NormalTex;
		uniform float _NormalIntensity;
		uniform float _ReflectPower2;
		uniform float4 _BaseColor2;
		uniform float _BasePower;
		uniform float4 _BaseColor;
		uniform sampler2D _ReflectTex;
		uniform float _ReflectPower;
		uniform float4 _ReflectColor;
		uniform float4 _AmbientColor;
		uniform sampler2D _Matcap;
		uniform float _MapcapIntensity;
		uniform sampler2D _MapcapMask;
		uniform float4 _MapcapMask_ST;
		uniform sampler2D _AmbientTex;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			o.Normal = float3(0,0,1);
			float2 uv_TexCoord137 = i.uv_texcoord * _UV;
			float2 UVtitle141 = uv_TexCoord137;
			float4 tex2DNode81 = tex2D( _BaseTex, UVtitle141 );
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
			float3 tex2DNode5 = UnpackNormal( tex2D( _NormalTex, UVtitle141 ) );
			float3 ase_tangentWS = WorldNormalVector( i, float3( 1, 0, 0 ) );
			float4 ase_tangentOS = mul( unity_WorldToObject, float4( ase_tangentWS, 0 ) );
			ase_tangentOS = normalize( ase_tangentOS );
			float3 ase_bitangentWS = WorldNormalVector( i, float3( 0, 1, 0 ) );
			float3 ase_bitangentOS = mul( unity_WorldToObject, float4( ase_bitangentWS, 0 ) );
			ase_bitangentOS = normalize( ase_bitangentOS );
			float3 ase_normalWS = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_normalOS = mul( unity_WorldToObject, float4( ase_normalWS, 0 ) );
			ase_normalOS = normalize( ase_normalOS );
			float3 NormalTBN132 = ( ( ( tex2DNode5.r * ase_tangentOS.xyz ) * _NormalIntensity ) + ( ( tex2DNode5.g * ase_bitangentOS ) * _NormalIntensity ) + ( tex2DNode5.b * ase_normalOS ) );
			float dotResult106 = dot( mul( light60, float3(-1,-1,-1) ) , NormalTBN132 );
			float dotResult73 = dot( mul( light60, float3(1,1,1) ) , NormalTBN132 );
			float3 ase_positionWS = i.worldPos;
			float3 ase_viewVectorWS = ( _WorldSpaceCameraPos.xyz - ase_positionWS );
			float3 ase_viewDirWS = normalize( ase_viewVectorWS );
			float dotResult14 = dot( reflect( mul( light60, float3(-1,-1,-1) ) , NormalTBN132 ) , ase_viewDirWS );
			float3 NormalMap124 = tex2DNode5;
			float2 uv_MapcapMask = i.uv_texcoord * _MapcapMask_ST.xy + _MapcapMask_ST.zw;
			float3 Mactap122 = ( tex2D( _Matcap, ( ( (mul( UNITY_MATRIX_V, float4( (WorldNormalVector( i , NormalMap124 )) , 0.0 ) ).xyz).xy + 1.0 ) * 0.5 ) ).rgb * _MapcapIntensity * tex2D( _MapcapMask, uv_MapcapMask ).rgb );
			float3 temp_output_87_0 = ( ( ( tex2DNode81.rgb * pow( max( 0.0 , dotResult106 ) , _ReflectPower2 ) * _BaseColor2.rgb ) + ( tex2DNode81.rgb * pow( max( 0.0 , dotResult73 ) , _BasePower ) * _BaseColor.rgb ) + ( tex2D( _ReflectTex, UVtitle141 ).rgb * pow( max( 0.0 , dotResult14 ) , _ReflectPower ) * _ReflectColor.rgb ) + _AmbientColor.rgb + Mactap122 ) * tex2D( _AmbientTex, UVtitle141 ).rgb );
			o.Emission = temp_output_87_0;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.5
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
				SurfaceOutput o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutput, o )
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
Node;AmplifyShaderEditor.CommentaryNode;133;-6192,-1872;Inherit;False;2788;1051;LightDirection;24;35;48;36;49;37;50;39;51;41;53;40;42;52;54;43;46;47;55;57;58;45;56;59;60;LightDirection;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;140;-3282,-1762;Inherit;False;772.25;284.3721;Comment;3;139;137;141;UV缩放;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-6144,-1664;Inherit;False;Property;_x;x;15;0;Create;True;0;0;0;False;0;False;21.52174;0;-90;90;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;48;-6096,-1184;Inherit;False;Property;_y;y;16;0;Create;True;0;0;0;False;0;False;21.52174;0;-90;90;0;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;36;-5824,-1680;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;49;-5776,-1200;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;139;-3248,-1696;Inherit;False;Property;_UV;UV;17;0;Create;True;0;0;0;False;0;False;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleDivideOpNode;37;-5552,-1648;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;180;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;50;-5504,-1168;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;180;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;137;-3040,-1712;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;130;-5869.205,-176;Inherit;False;2440.95;667.1062;NormalTBN;14;132;9;93;91;8;92;4;6;7;3;2;124;5;142;NormalTBN;1,1,1,1;0;0
Node;AmplifyShaderEditor.PiNode;39;-5312,-1648;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PiNode;51;-5264,-1168;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;141;-2768,-1712;Inherit;False;UVtitle;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SinOpNode;41;-5072,-1504;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;53;-5024,-1040;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;142;-5744,32;Inherit;False;141;UVtitle;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;5;-5488,16;Inherit;True;Property;_NormalTex;NormalTex;10;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.CosOpNode;40;-5072,-1632;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CosOpNode;52;-5024,-1168;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;54;-4832,-960;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;-4832,-1680;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;120;-5616,-768;Inherit;False;2207.649;535.544;Matcap;14;122;127;128;121;118;116;117;115;119;114;113;112;125;135;Matcap;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;124;-5136,-80;Inherit;False;NormalMap;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TangentVertexDataNode;2;-4912,-128;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BitangentVertexDataNode;3;-4944,32;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;55;-4624,-1328;Inherit;False;FLOAT3;4;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;57;-4624,-1168;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;58;-4624,-1024;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;43;-4640,-1824;Inherit;False;FLOAT3;4;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;46;-4640,-1664;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;47;-4640,-1520;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;125;-5504,-608;Inherit;False;124;NormalMap;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-4512,16;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-4512,-112;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalVertexDataNode;4;-4912,192;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;92;-4640,256;Inherit;False;Property;_NormalIntensity;NormalIntensity;11;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.MatrixFromVectors;45;-4384,-1680;Inherit;False;FLOAT3x3;True;4;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3x3;0
Node;AmplifyShaderEditor.MatrixFromVectors;56;-4368,-1184;Inherit;False;FLOAT3x3;True;4;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3x3;0
Node;AmplifyShaderEditor.WorldNormalVector;112;-5264,-640;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ViewMatrixNode;113;-5216,-720;Inherit;False;0;1;FLOAT4x4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-4512,144;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;91;-4272,-48;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;93;-4272,112;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;-4016,-1392;Inherit;True;2;2;0;FLOAT3x3;1,0,0,1,1,1,1,0,1;False;1;FLOAT3x3;1,0,0,1,1,1,1,0,1;False;1;FLOAT3x3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;114;-5040,-672;Inherit;False;2;2;0;FLOAT4x4;1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;9;-4064,-32;Inherit;True;3;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;60;-3648,-1392;Inherit;False;light;-1;True;1;0;FLOAT3x3;1,0,0,1,1,1,1,0,1;False;1;FLOAT3x3;0
Node;AmplifyShaderEditor.SwizzleNode;119;-4864,-672;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;132;-3744,48;Inherit;False;NormalTBN;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;115;-4912,-544;Inherit;False;Constant;_Float0;Float 0;1;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;62;-2800,512;Inherit;False;Constant;_Vector0;Vector 0;3;0;Create;True;0;0;0;False;0;False;-1,-1,-1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;61;-2816,320;Inherit;True;60;light;1;0;OBJECT;;False;1;FLOAT3x3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;117;-4688,-672;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;116;-4720,-544;Inherit;False;Constant;_Float1;Float 1;1;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-2480,416;Inherit;False;2;2;0;FLOAT3x3;1,0,0,1,1,1,1,0,1;False;1;FLOAT3;1,1,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;76;-2800,176;Inherit;False;Constant;_Vector1;Vector 0;3;0;Create;True;0;0;0;False;0;False;1,1,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;75;-2816,-16;Inherit;True;60;light;1;0;OBJECT;;False;1;FLOAT3x3;0
Node;AmplifyShaderEditor.GetLocalVarNode;131;-2784,752;Inherit;False;132;NormalTBN;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;103;-2832,-256;Inherit;False;Constant;_BaseColorpoint;BaseColorpoint;4;0;Create;True;0;0;0;False;0;False;-1,-1,-1;-1,-1,-1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;104;-2832,-448;Inherit;True;60;light;1;0;OBJECT;;False;1;FLOAT3x3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;118;-4544,-672;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ReflectOpNode;10;-2080,688;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;77;-2480,96;Inherit;False;2;2;0;FLOAT3x3;1,0,0,1,1,1,1,0,1;False;1;FLOAT3;1,1,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;105;-2512,-336;Inherit;False;2;2;0;FLOAT3x3;1,0,0,1,1,1,1,0,1;False;1;FLOAT3;1,1,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;15;-2016,912;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DotProductOpNode;73;-2112,256;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;106;-2144,-336;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;128;-4368,-512;Inherit;False;Property;_MapcapIntensity;MapcapIntensity;14;0;Create;True;0;0;0;False;0;False;0;0;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;135;-4368,-432;Inherit;True;Property;_MapcapMask;MapcapMask;13;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode;121;-4368,-720;Inherit;True;Property;_Matcap;Matcap;12;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.DotProductOpNode;14;-1744,656;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;107;-1840,-320;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;78;-1776,192;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;96;-1840,320;Inherit;False;Property;_BasePower;BasePower;1;0;Create;True;0;0;0;False;0;False;0;0;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;98;-2000,-496;Inherit;False;Property;_ReflectPower2;ReflectPower2;3;0;Create;True;0;0;0;False;0;False;0;0;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;127;-4064,-544;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;143;-1504,544;Inherit;False;141;UVtitle;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;145;-1920,-64;Inherit;False;141;UVtitle;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;63;-1456,640;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;89;-1536,816;Inherit;False;Property;_ReflectPower;ReflectPower;7;0;Create;True;0;0;0;False;0;False;0;0;0;150;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;83;-1248,336;Inherit;True;Property;_ReflectTex;ReflectTex;5;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode;82;-1536,320;Inherit;False;Property;_BaseColor;BaseColor;0;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode;85;-1200,720;Inherit;False;Property;_ReflectColor;ReflectColor;6;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.PowerNode;88;-1184,608;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;81;-1648,-96;Inherit;True;Property;_BaseTex;BaseTex;4;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.PowerNode;95;-1504,192;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;102;-1632,-384;Inherit;False;Property;_BaseColor2;BaseColor2;2;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.PowerNode;99;-1600,-512;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;122;-3744,-560;Inherit;False;Mactap;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;80;-1216,96;Inherit;True;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;101;-1264,-432;Inherit;True;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;84;-848,416;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;90;-864,560;Inherit;False;Property;_AmbientColor;AmbientColor;9;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.GetLocalVarNode;126;-832,768;Inherit;False;122;Mactap;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;144;-832,848;Inherit;False;141;UVtitle;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;79;-544,400;Inherit;True;5;5;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;86;-560,672;Inherit;True;Property;_AmbientTex;AmbientTex;8;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;87;-128,624;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SmoothstepOpNode;157;-288,1232;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.13;False;2;FLOAT;0.55;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;150;-480,1232;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;146;-768,1232;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;149;-960,1392;Inherit;False;Property;_Power;Power;20;0;Create;True;0;0;0;False;0;False;6.59;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;147;-960,1232;Inherit;False;Property;_Bisa;Bisa;18;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;148;-960,1312;Inherit;False;Property;_Scale;Scale;19;0;Create;True;0;0;0;False;0;False;0.4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;156;-256,960;Inherit;False;Property;_Color0;Color 0;21;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.LerpOp;154;112,944;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;109;352,592;Float;False;True;-1;3;AmplifyShaderEditor.MaterialInspector;0;0;Unlit;ASE-Fowaed;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;5;False;;10;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;36;0;35;0
WireConnection;49;0;48;0
WireConnection;37;0;36;0
WireConnection;50;0;49;0
WireConnection;137;0;139;0
WireConnection;39;0;37;0
WireConnection;51;0;50;0
WireConnection;141;0;137;0
WireConnection;41;0;39;0
WireConnection;53;0;51;0
WireConnection;5;1;142;0
WireConnection;40;0;39;0
WireConnection;52;0;51;0
WireConnection;54;0;53;0
WireConnection;42;0;41;0
WireConnection;124;0;5;0
WireConnection;55;0;52;0
WireConnection;55;2;53;0
WireConnection;58;0;54;0
WireConnection;58;2;52;0
WireConnection;46;1;40;0
WireConnection;46;2;42;0
WireConnection;47;1;41;0
WireConnection;47;2;40;0
WireConnection;7;0;5;2
WireConnection;7;1;3;0
WireConnection;6;0;5;1
WireConnection;6;1;2;0
WireConnection;45;0;43;0
WireConnection;45;1;46;0
WireConnection;45;2;47;0
WireConnection;56;0;55;0
WireConnection;56;1;57;0
WireConnection;56;2;58;0
WireConnection;112;0;125;0
WireConnection;8;0;5;3
WireConnection;8;1;4;0
WireConnection;91;0;6;0
WireConnection;91;1;92;0
WireConnection;93;0;7;0
WireConnection;93;1;92;0
WireConnection;59;0;45;0
WireConnection;59;1;56;0
WireConnection;114;0;113;0
WireConnection;114;1;112;0
WireConnection;9;0;91;0
WireConnection;9;1;93;0
WireConnection;9;2;8;0
WireConnection;60;0;59;0
WireConnection;119;0;114;0
WireConnection;132;0;9;0
WireConnection;117;0;119;0
WireConnection;117;1;115;0
WireConnection;11;0;61;0
WireConnection;11;1;62;0
WireConnection;118;0;117;0
WireConnection;118;1;116;0
WireConnection;10;0;11;0
WireConnection;10;1;131;0
WireConnection;77;0;75;0
WireConnection;77;1;76;0
WireConnection;105;0;104;0
WireConnection;105;1;103;0
WireConnection;73;0;77;0
WireConnection;73;1;131;0
WireConnection;106;0;105;0
WireConnection;106;1;131;0
WireConnection;121;1;118;0
WireConnection;14;0;10;0
WireConnection;14;1;15;0
WireConnection;107;1;106;0
WireConnection;78;1;73;0
WireConnection;127;0;121;5
WireConnection;127;1;128;0
WireConnection;127;2;135;5
WireConnection;63;1;14;0
WireConnection;83;1;143;0
WireConnection;88;0;63;0
WireConnection;88;1;89;0
WireConnection;81;1;145;0
WireConnection;95;0;78;0
WireConnection;95;1;96;0
WireConnection;99;0;107;0
WireConnection;99;1;98;0
WireConnection;122;0;127;0
WireConnection;80;0;81;5
WireConnection;80;1;95;0
WireConnection;80;2;82;5
WireConnection;101;0;81;5
WireConnection;101;1;99;0
WireConnection;101;2;102;5
WireConnection;84;0;83;5
WireConnection;84;1;88;0
WireConnection;84;2;85;5
WireConnection;79;0;101;0
WireConnection;79;1;80;0
WireConnection;79;2;84;0
WireConnection;79;3;90;5
WireConnection;79;4;126;0
WireConnection;86;1;144;0
WireConnection;87;0;79;0
WireConnection;87;1;86;5
WireConnection;157;0;150;0
WireConnection;150;0;146;0
WireConnection;146;1;147;0
WireConnection;146;2;148;0
WireConnection;146;3;149;0
WireConnection;154;0;87;0
WireConnection;154;1;156;5
WireConnection;154;2;157;0
WireConnection;109;2;87;0
ASEEND*/
//CHKSM=548133A5BF2EAEAB3BE8A23563DBD6DB54A792DF