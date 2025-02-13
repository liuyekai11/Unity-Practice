// Made with Amplify Shader Editor v1.9.8.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASE/Practice"
{
	Properties
	{
		_SmoothMin("SmoothMin", Range( -1 , 0)) = 0
		_SmoothMax("SmoothMax", Range( 0 , 5)) = 0
		_ColorW("ColorW", Color) = (0,0,0,0)
		_RimTntensity("RimTntensity", Float) = 0
		_ColorN("ColorN", Color) = (0,0,0,0)
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_Speed("Speed", Vector) = (0,0,0,0)
		_Color3("Color3", Color) = (0,0,0,0)
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Custom"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		Blend SrcAlpha One
		
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.5
		#define ASE_VERSION 19801
		struct Input
		{
			float3 worldNormal;
			float3 worldPos;
		};

		uniform float4 _ColorW;
		uniform float4 _ColorN;
		uniform float _RimTntensity;
		uniform float _SmoothMin;
		uniform float _SmoothMax;
		uniform sampler2D _TextureSample0;
		uniform float2 _Speed;
		uniform float4 _Color3;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float3 ase_normalWS = i.worldNormal;
			float3 ase_positionWS = i.worldPos;
			float3 ase_viewVectorWS = ( _WorldSpaceCameraPos.xyz - ase_positionWS );
			float3 ase_viewDirWS = normalize( ase_viewVectorWS );
			float dotResult65 = dot( ase_normalWS , ase_viewDirWS );
			float clampResult66 = clamp( dotResult65 , 0.0 , 1.0 );
			float smoothstepResult74 = smoothstep( _SmoothMin , _SmoothMax , ( 1.0 - clampResult66 ));
			float3 lerpResult77 = lerp( _ColorW.rgb , ( _ColorN.rgb * _RimTntensity ) , smoothstepResult74);
			float3 Fresnel105 = lerpResult77;
			float2 appendResult91 = (float2(ase_positionWS.x , ase_positionWS.y));
			float3 objToWorld92 = mul( unity_ObjectToWorld, float4( float3(0,0,0), 1 ) ).xyz;
			float2 appendResult94 = (float2(objToWorld92.x , objToWorld92.y));
			float mulTime89 = _Time.y * 1.27;
			float4 tex2DNode82 = tex2D( _TextureSample0, ( ( appendResult91 - appendResult94 ) + ( _Speed * mulTime89 ) ) );
			float4 Move108 = ( tex2DNode82 * float4( _Color3.rgb , 0.0 ) );
			o.Emission = ( float4( Fresnel105 , 0.0 ) + Move108 ).rgb;
			float FresnelAlpha115 = smoothstepResult74;
			float MoveAlpha113 = tex2DNode82.a;
			float clampResult103 = clamp( ( FresnelAlpha115 + MoveAlpha113 ) , 0.0 , 1.0 );
			o.Alpha = clampResult103;
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
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float3 worldPos : TEXCOORD1;
				float3 worldNormal : TEXCOORD2;
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
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
				o.worldPos = worldPos;
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
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
				SurfaceOutput o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutput, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
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
Node;AmplifyShaderEditor.CommentaryNode;107;-3472,160;Inherit;False;1982.807;663.4648;Move;15;108;101;98;87;89;86;85;82;95;94;91;92;90;93;113;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;106;-3072,-1040;Inherit;False;1524;1027;Fresnel;15;62;63;65;66;67;75;79;81;80;78;76;74;77;105;115;;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector3Node;93;-3424,384;Inherit;False;Constant;_Vector0;Vector 0;10;0;Create;True;0;0;0;False;0;False;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;62;-3008,-560;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;63;-3008,-368;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;90;-3200,208;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TransformPositionNode;92;-3232,384;Inherit;False;Object;World;False;Fast;True;1;0;FLOAT3;0,0,0;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DotProductOpNode;65;-2736,-448;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;91;-2960,256;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;94;-2960,384;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;86;-3024,512;Inherit;False;Property;_Speed;Speed;7;0;Create;True;0;0;0;False;0;False;0,0;0,0.5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleTimeNode;89;-3024,656;Inherit;False;1;0;FLOAT;1.27;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;66;-2592,-448;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;95;-2736,384;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;87;-2720,528;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;67;-2448,-448;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;75;-2544,-224;Inherit;False;Property;_SmoothMin;SmoothMin;1;0;Create;True;0;0;0;False;0;False;0;0;-1;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;79;-2800,-784;Inherit;False;Property;_ColorN;ColorN;5;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0.5999999,1,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode;81;-2784,-560;Inherit;False;Property;_RimTntensity;RimTntensity;4;0;Create;True;0;0;0;False;0;False;0;21.19;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;76;-2544,-128;Inherit;False;Property;_SmoothMax;SmoothMax;2;0;Create;True;0;0;0;False;0;False;0;4.91;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;85;-2464,416;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;80;-2512,-656;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;78;-2800,-992;Inherit;False;Property;_ColorW;ColorW;3;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,1;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SmoothstepOpNode;74;-2192,-368;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;82;-2320,384;Inherit;True;Property;_TextureSample0;Texture Sample 0;6;0;Create;True;0;0;0;False;0;False;-1;None;e0da4aef70a640044bfdb34a228dac96;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode;101;-2256,592;Inherit;False;Property;_Color3;Color3;8;0;Create;True;0;0;0;False;0;False;0,0,0,0;1,1,1,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.LerpOp;77;-1952,-480;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;98;-1952,416;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;113;-1792,560;Inherit;False;MoveAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;115;-1776,-320;Inherit;False;FresnelAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;105;-1776,-480;Inherit;False;Fresnel;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;108;-1792,416;Inherit;False;Move;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;114;-1392,64;Inherit;False;113;MoveAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;116;-1392,-64;Inherit;False;115;FresnelAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;109;-1424,-512;Inherit;True;105;Fresnel;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;102;-1184,-96;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;110;-1408,-288;Inherit;False;108;Move;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;103;-928,-80;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;97;-1088,-336;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;112;-624,-336;Float;False;True;-1;3;AmplifyShaderEditor.MaterialInspector;0;0;Unlit;ASE/Practice;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Custom;0.5;True;True;0;True;Custom;;Transparent;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;8;5;False;;1;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;92;0;93;0
WireConnection;65;0;62;0
WireConnection;65;1;63;0
WireConnection;91;0;90;1
WireConnection;91;1;90;2
WireConnection;94;0;92;1
WireConnection;94;1;92;2
WireConnection;66;0;65;0
WireConnection;95;0;91;0
WireConnection;95;1;94;0
WireConnection;87;0;86;0
WireConnection;87;1;89;0
WireConnection;67;0;66;0
WireConnection;85;0;95;0
WireConnection;85;1;87;0
WireConnection;80;0;79;5
WireConnection;80;1;81;0
WireConnection;74;0;67;0
WireConnection;74;1;75;0
WireConnection;74;2;76;0
WireConnection;82;1;85;0
WireConnection;77;0;78;5
WireConnection;77;1;80;0
WireConnection;77;2;74;0
WireConnection;98;0;82;0
WireConnection;98;1;101;5
WireConnection;113;0;82;4
WireConnection;115;0;74;0
WireConnection;105;0;77;0
WireConnection;108;0;98;0
WireConnection;102;0;116;0
WireConnection;102;1;114;0
WireConnection;103;0;102;0
WireConnection;97;0;109;0
WireConnection;97;1;110;0
WireConnection;112;2;97;0
WireConnection;112;9;103;0
ASEEND*/
//CHKSM=11D590E6BDCA21C145FFF420F14A2AA6EF2C6F65