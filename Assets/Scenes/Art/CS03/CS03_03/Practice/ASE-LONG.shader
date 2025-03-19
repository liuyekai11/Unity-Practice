// Made with Amplify Shader Editor v1.9.8.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASE-LONG"
{
	Properties
	{
		_EdgeLength ( "Edge length", Range( 2, 50 ) ) = 15
		_RotateX1("RotateX", Range( 0 , 360)) = 0
		_RotateY("RotateY", Range( 0 , 360)) = 0
		_LightColor("LightColor", Color) = (0,0,0,0)
		_LightBack("LightBack", Color) = (0,0,0,0)
		_LightReflict("LightReflict", Float) = 0
		_CubeRotateY("CubeRotateY", Range( 0 , 360)) = 0
		_thicness("thicness", 2D) = "white" {}
		_Distort("Distort", Float) = 0
		_Power("Power", Float) = 1
		_Scale("Scale", Float) = 1
		_CubeTex("CubeTex", CUBE) = "white" {}
		_CubeIntensity("CubeIntensity", Float) = 0
		_BacklightColor("BacklightColor", Color) = (1,0,0,0)
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
			float3 worldNormal;
			INTERNAL_DATA
			float3 worldPos;
			float2 uv_texcoord;
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

		uniform float _RotateX1;
		uniform float _RotateY;
		uniform float _Distort;
		uniform float _Power;
		uniform float _Scale;
		uniform sampler2D _thicness;
		uniform float4 _thicness_ST;
		uniform float4 _BacklightColor;
		uniform float _LightReflict;
		uniform float4 _LightBack;
		uniform float4 _LightColor;
		uniform samplerCUBE _CubeTex;
		uniform float _CubeRotateY;
		uniform float _CubeIntensity;
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
			float3 appendResult55 = (float3(1.0 , 0.0 , 0.0));
			float temp_output_51_0 = ( ( _RotateX1 * UNITY_PI ) / 180.0 );
			float temp_output_53_0 = cos( temp_output_51_0 );
			float temp_output_52_0 = sin( temp_output_51_0 );
			float3 appendResult56 = (float3(0.0 , temp_output_53_0 , -temp_output_52_0));
			float3 appendResult57 = (float3(0.0 , temp_output_53_0 , temp_output_52_0));
			float3 appendResult67 = (float3(0.0 , 1.0 , 0.0));
			float temp_output_61_0 = ( ( _RotateY * UNITY_PI ) / 180.0 );
			float temp_output_63_0 = cos( temp_output_61_0 );
			float temp_output_62_0 = sin( temp_output_61_0 );
			float3 appendResult65 = (float3(temp_output_63_0 , 0.0 , -temp_output_62_0));
			float3 appendResult66 = (float3(temp_output_63_0 , 0.0 , temp_output_62_0));
			float3 Light_Dir75 = mul( mul( float3x3(appendResult55, appendResult56, appendResult57), float3x3(appendResult67, appendResult65, appendResult66) ), float3(1,1,1) );
			float3 ase_normalWS = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_positionWS = i.worldPos;
			float3 ase_viewVectorWS = ( _WorldSpaceCameraPos.xyz - ase_positionWS );
			float3 ase_viewDirWS = normalize( ase_viewVectorWS );
			float dotResult115 = dot( -( Light_Dir75 + ( ase_normalWS * _Distort ) ) , ase_viewDirWS );
			float2 uv_thicness = i.uv_texcoord * _thicness_ST.xy + _thicness_ST.zw;
			float dotResult85 = dot( ase_normalWS , Light_Dir75 );
			float3 LightColor132 = ( ( _LightReflict * max( ( 1.0 - dotResult85 ) , 0.0 ) * _LightBack.rgb ) + ( _LightColor.rgb * max( dotResult85 , 0.0 ) ) );
			float3 BackLight195 = ( ( max( pow( max( dotResult115 , 0.0 ) , _Power ) , 0.0 ) * _Scale ) * ( 1.0 - tex2D( _thicness, uv_thicness ).rgb ) * _BacklightColor.rgb * LightColor132 );
			float3 appendResult184 = (float3(0.0 , 1.0 , 0.0));
			float temp_output_171_0 = ( ( _CubeRotateY * UNITY_PI ) / 180.0 );
			float temp_output_179_0 = cos( temp_output_171_0 );
			float temp_output_177_0 = sin( temp_output_171_0 );
			float3 appendResult183 = (float3(temp_output_179_0 , 0.0 , -temp_output_177_0));
			float3 appendResult182 = (float3(temp_output_179_0 , 0.0 , temp_output_177_0));
			float3 CubeRotate191 = mul( float3x3(appendResult184, appendResult183, appendResult182), float3(1,1,1) );
			float dotResult162 = dot( ase_viewDirWS , ase_normalWS );
			float4 CubeMap193 = ( texCUBE( _CubeTex, reflect( -ase_viewDirWS , ( CubeRotate191 * ase_normalWS ) ) ) * ( 1.0 - dotResult162 ) * _CubeIntensity );
			o.Emission = ( float4( BackLight195 , 0.0 ) + CubeMap193 + float4( LightColor132 , 0.0 ) ).rgb + 1E-5;
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
Node;AmplifyShaderEditor.CommentaryNode;32;-4976,-2848;Inherit;False;2274.399;1090.516;Light-dir;24;72;73;69;58;68;67;65;66;55;57;56;64;63;54;53;62;52;61;51;60;50;59;49;75;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;49;-4928,-2544;Inherit;False;Property;_RotateX1;RotateX;6;0;Create;True;0;0;0;False;0;False;0;0;0;360;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;59;-4928,-2000;Inherit;False;Property;_RotateY;RotateY;7;0;Create;True;0;0;0;False;0;False;0;0;0;360;0;1;FLOAT;0
Node;AmplifyShaderEditor.PiNode;50;-4656,-2544;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PiNode;60;-4656,-2000;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;51;-4464,-2544;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;180;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;61;-4464,-2000;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;180;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;52;-4288,-2464;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;62;-4288,-1920;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CosOpNode;53;-4288,-2576;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;54;-4128,-2416;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CosOpNode;63;-4288,-2032;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;64;-4128,-1888;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;190;-4768,-1632;Inherit;False;2014.852;567.0408;Comment;13;188;187;185;191;184;183;182;180;179;177;171;169;167;;1,1,1,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;56;-3840,-2608;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;55;-3840,-2768;Inherit;False;FLOAT3;4;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;57;-3840,-2448;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;66;-3840,-1920;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;65;-3840,-2080;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;67;-3840,-2224;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;167;-4720,-1328;Inherit;False;Property;_CubeRotateY;CubeRotateY;11;0;Create;True;0;0;0;False;0;False;0;0;0;360;0;1;FLOAT;0
Node;AmplifyShaderEditor.MatrixFromVectors;58;-3584,-2624;Inherit;False;FLOAT3x3;True;4;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3x3;0
Node;AmplifyShaderEditor.MatrixFromVectors;68;-3584,-2096;Inherit;False;FLOAT3x3;True;4;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3x3;0
Node;AmplifyShaderEditor.PiNode;169;-4448,-1328;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;69;-3312,-2432;Inherit;False;2;2;0;FLOAT3x3;1,0,0,1,0,0,1,0,1;False;1;FLOAT3x3;1,0,0,1,0,0,1,0,1;False;1;FLOAT3x3;0
Node;AmplifyShaderEditor.Vector3Node;73;-3312,-2288;Inherit;False;Constant;_Vector0;Vector 0;2;0;Create;True;0;0;0;False;0;False;1,1,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleDivideOpNode;171;-4256,-1328;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;180;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;72;-3152,-2336;Inherit;False;2;2;0;FLOAT3x3;1,0,0,1,0,0,1,0,1;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;196;-4768,736;Inherit;False;2116;659;Comment;20;106;107;108;111;109;114;113;115;116;118;117;119;121;125;124;120;129;136;128;195;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SinOpNode;177;-4080,-1248;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;97;-4640,-272;Inherit;False;1924;715;Skt_LightColor;15;89;88;92;96;91;81;80;85;86;84;87;94;98;99;145;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;75;-2976,-2336;Inherit;False;Light_Dir;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldNormalVector;106;-4720,960;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;107;-4704,1104;Inherit;False;Property;_Distort;Distort;13;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CosOpNode;179;-4080,-1360;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;180;-3920,-1216;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;86;-4176,-176;Inherit;False;75;Light_Dir;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldNormalVector;81;-4512,-112;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;108;-4496,1040;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;111;-4544,800;Inherit;False;75;Light_Dir;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;182;-3632,-1248;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;183;-3632,-1408;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;184;-3632,-1552;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DotProductOpNode;85;-3936,-176;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;109;-4288,816;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.MatrixFromVectors;185;-3440,-1424;Inherit;False;FLOAT3x3;True;4;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3x3;0
Node;AmplifyShaderEditor.Vector3Node;187;-3376,-1248;Inherit;False;Constant;_Vector2;Vector 0;2;0;Create;True;0;0;0;False;0;False;1,1,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;114;-4176,896;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.OneMinusNode;147;-3920,-464;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;113;-4144,816;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;188;-3168,-1392;Inherit;False;2;2;0;FLOAT3x3;1,0,0,0,0,1,1,0,1;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DotProductOpNode;115;-3952,832;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;145;-3712,-240;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;139;-3728,-656;Inherit;False;Property;_LightReflict;LightReflict;10;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;144;-3616,-576;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;131;-3760,-480;Inherit;False;Property;_LightColor;LightColor;8;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode;143;-3728,-848;Inherit;False;Property;_LightBack;LightBack;9;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.CommentaryNode;192;-4464,1664;Inherit;False;1744.837;762.0054;Comment;12;154;156;164;148;163;159;162;161;157;158;193;202;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;191;-3008,-1408;Inherit;False;CubeRotate;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;116;-3728,832;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;118;-3744,928;Inherit;False;Property;_Power;Power;14;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;130;-3488,-496;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;138;-3456,-624;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;158;-4192,1712;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;156;-4400,2112;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;154;-4400,1872;Inherit;False;191;CubeRotate;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PowerNode;117;-3600,848;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;137;-3280,-624;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;157;-4176,1872;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NegateNode;161;-3952,1808;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;119;-3456,848;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;121;-3552,960;Inherit;False;Property;_Scale;Scale;15;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;132;-3120,-496;Inherit;False;LightColor;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;125;-3696,1040;Inherit;True;Property;_thicness;thicness;12;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ReflectOpNode;159;-3792,1856;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DotProductOpNode;162;-3792,2096;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;124;-3328,1008;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;120;-3328,896;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;136;-3360,1280;Inherit;False;132;LightColor;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;129;-3392,1072;Inherit;False;Property;_BacklightColor;BacklightColor;18;0;Create;True;0;0;0;False;0;False;1,0,0,0;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.OneMinusNode;163;-3520,2096;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;202;-3392,2192;Inherit;False;Property;_CubeIntensity;CubeIntensity;17;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;148;-3488,1840;Inherit;True;Property;_CubeTex;CubeTex;16;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;LockedToCube;False;Object;-1;Auto;Cube;8;0;SAMPLERCUBE;;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;128;-3120,928;Inherit;True;4;4;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;164;-3168,2048;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;193;-2992,2048;Inherit;False;CubeMap;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;195;-2896,928;Inherit;False;BackLight;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;198;-256,256;Inherit;False;195;BackLight;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;200;-256,416;Inherit;False;132;LightColor;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;199;-256,336;Inherit;False;193;CubeMap;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;98;-3888,-16;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;99;-3664,0;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;87;-3872,208;Inherit;False;Property;_DiffuseColor;DiffuseColor;0;0;Create;True;0;0;0;False;0;False;1,1,1,0;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleMaxOpNode;94;-3664,-144;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;89;-3440,-224;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;88;-3440,0;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;92;-3120,208;Inherit;False;Property;_Opaccity;Opaccity;19;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;96;-3184,-80;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;91;-2896,80;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NegateNode;142;-3936,-560;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;80;-4512,32;Inherit;False;Constant;_Vector1;Vector 1;2;0;Create;True;0;0;0;False;0;False;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DotProductOpNode;84;-4240,-32;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;197;112,288;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;512,-96;Float;False;True;-1;6;AmplifyShaderEditor.MaterialInspector;0;0;Unlit;ASE-LONG;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;True;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;50;0;49;0
WireConnection;60;0;59;0
WireConnection;51;0;50;0
WireConnection;61;0;60;0
WireConnection;52;0;51;0
WireConnection;62;0;61;0
WireConnection;53;0;51;0
WireConnection;54;0;52;0
WireConnection;63;0;61;0
WireConnection;64;0;62;0
WireConnection;56;1;53;0
WireConnection;56;2;54;0
WireConnection;57;1;53;0
WireConnection;57;2;52;0
WireConnection;66;0;63;0
WireConnection;66;2;62;0
WireConnection;65;0;63;0
WireConnection;65;2;64;0
WireConnection;58;0;55;0
WireConnection;58;1;56;0
WireConnection;58;2;57;0
WireConnection;68;0;67;0
WireConnection;68;1;65;0
WireConnection;68;2;66;0
WireConnection;169;0;167;0
WireConnection;69;0;58;0
WireConnection;69;1;68;0
WireConnection;171;0;169;0
WireConnection;72;0;69;0
WireConnection;72;1;73;0
WireConnection;177;0;171;0
WireConnection;75;0;72;0
WireConnection;179;0;171;0
WireConnection;180;0;177;0
WireConnection;108;0;106;0
WireConnection;108;1;107;0
WireConnection;182;0;179;0
WireConnection;182;2;177;0
WireConnection;183;0;179;0
WireConnection;183;2;180;0
WireConnection;85;0;81;0
WireConnection;85;1;86;0
WireConnection;109;0;111;0
WireConnection;109;1;108;0
WireConnection;185;0;184;0
WireConnection;185;1;183;0
WireConnection;185;2;182;0
WireConnection;147;0;85;0
WireConnection;113;0;109;0
WireConnection;188;0;185;0
WireConnection;188;1;187;0
WireConnection;115;0;113;0
WireConnection;115;1;114;0
WireConnection;145;0;85;0
WireConnection;144;0;147;0
WireConnection;191;0;188;0
WireConnection;116;0;115;0
WireConnection;130;0;131;5
WireConnection;130;1;145;0
WireConnection;138;0;139;0
WireConnection;138;1;144;0
WireConnection;138;2;143;5
WireConnection;117;0;116;0
WireConnection;117;1;118;0
WireConnection;137;0;138;0
WireConnection;137;1;130;0
WireConnection;157;0;154;0
WireConnection;157;1;156;0
WireConnection;161;0;158;0
WireConnection;119;0;117;0
WireConnection;132;0;137;0
WireConnection;159;0;161;0
WireConnection;159;1;157;0
WireConnection;162;0;158;0
WireConnection;162;1;156;0
WireConnection;124;0;125;5
WireConnection;120;0;119;0
WireConnection;120;1;121;0
WireConnection;163;0;162;0
WireConnection;148;1;159;0
WireConnection;128;0;120;0
WireConnection;128;1;124;0
WireConnection;128;2;129;5
WireConnection;128;3;136;0
WireConnection;164;0;148;0
WireConnection;164;1;163;0
WireConnection;164;2;202;0
WireConnection;193;0;164;0
WireConnection;195;0;128;0
WireConnection;98;0;84;0
WireConnection;99;0;98;0
WireConnection;94;0;85;0
WireConnection;89;0;99;0
WireConnection;89;1;87;5
WireConnection;88;0;94;0
WireConnection;88;1;87;5
WireConnection;96;0;89;0
WireConnection;96;1;88;0
WireConnection;91;0;96;0
WireConnection;91;1;92;0
WireConnection;142;0;85;0
WireConnection;84;0;81;0
WireConnection;84;1;80;0
WireConnection;197;0;198;0
WireConnection;197;1;199;0
WireConnection;197;2;200;0
WireConnection;0;15;197;0
ASEEND*/
//CHKSM=735152AE193194F2A26C313DDADACA53126A7AA7