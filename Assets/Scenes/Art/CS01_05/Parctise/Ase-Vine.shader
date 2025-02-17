// Made with Amplify Shader Editor v1.9.8.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Vine"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Expand("Expand", Float) = 0
		_Grow("Grow", Range( -2 , 2)) = 0.6056201
		_SmothMin("SmothMin", Range( 0 , 1)) = 0
		_SmothMax("SmothMax", Range( 0 , 1.5)) = 0
		_EndMin("EndMin", Range( 0 , 1)) = 0
		_EndMax("EndMax", Range( 0 , 1.5)) = 0
		_Scale("Scale", Float) = 0
		_Diffuse("Diffuse", 2D) = "white" {}
		_Normal("Normal", 2D) = "white" {}
		_Roughness("Roughness", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "AlphaTest+0" }
		Cull Off
		CGPROGRAM
		#pragma target 3.5
		#define ASE_VERSION 19801
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _SmothMin;
		uniform float _SmothMax;
		uniform float _Grow;
		uniform float _EndMin;
		uniform float _EndMax;
		uniform float _Expand;
		uniform float _Scale;
		uniform sampler2D _Normal;
		uniform float4 _Normal_ST;
		uniform sampler2D _Diffuse;
		uniform float4 _Diffuse_ST;
		uniform sampler2D _Roughness;
		uniform float4 _Roughness_ST;
		uniform float _Cutoff = 0.5;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float temp_output_8_0 = ( v.texcoord.xy.y - _Grow );
			float smoothstepResult10 = smoothstep( _SmothMin , _SmothMax , temp_output_8_0);
			float smoothstepResult16 = smoothstep( _EndMin , _EndMax , v.texcoord.xy.y);
			float3 ase_normalOS = v.normal.xyz;
			float3 temp_output_20_0 = ( ( max( smoothstepResult10 , smoothstepResult16 ) * ase_normalOS * _Expand * 0.01 ) + ( ase_normalOS * _Scale * 0.01 ) );
			v.vertex.xyz += temp_output_20_0;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Normal = i.uv_texcoord * _Normal_ST.xy + _Normal_ST.zw;
			o.Normal = UnpackNormal( tex2D( _Normal, uv_Normal ) );
			float2 uv_Diffuse = i.uv_texcoord * _Diffuse_ST.xy + _Diffuse_ST.zw;
			o.Albedo = tex2D( _Diffuse, uv_Diffuse ).rgb;
			float2 uv_Roughness = i.uv_texcoord * _Roughness_ST.xy + _Roughness_ST.zw;
			o.Smoothness = ( 1.0 - tex2D( _Roughness, uv_Roughness ).r );
			o.Alpha = 1;
			float temp_output_8_0 = ( i.uv_texcoord.y - _Grow );
			clip( ( 1.0 - temp_output_8_0 ) - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "AmplifyShaderEditor.MaterialInspector"
}
/*ASEBEGIN
Version=19801
Node;AmplifyShaderEditor.RangedFloatNode;7;-1488,80;Inherit;False;Property;_Grow;Grow;2;0;Create;True;0;0;0;False;0;False;0.6056201;0;-2;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;6;-1472,-48;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;17;-1312,688;Inherit;False;Property;_EndMin;EndMin;5;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-1312,784;Inherit;False;Property;_EndMax;EndMax;6;0;Create;True;0;0;0;False;0;False;0;0;0;1.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;15;-1296,560;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;11;-1312,160;Inherit;False;Property;_SmothMin;SmothMin;3;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-1312,256;Inherit;False;Property;_SmothMax;SmothMax;4;0;Create;True;0;0;0;False;0;False;0;0;0;1.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;8;-1152,48;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;16;-928,688;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;10;-944,144;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;19;-640,352;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-496,704;Inherit;False;Constant;_Float1;Float 1;0;0;Create;True;0;0;0;False;0;False;0.01;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-496,624;Inherit;False;Property;_Expand;Expand;1;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;21;-496,832;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;23;-480,976;Inherit;False;Property;_Scale;Scale;7;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-480,1056;Inherit;False;Constant;_Float2;Float 2;7;0;Create;True;0;0;0;False;0;False;0.01;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;1;-608,464;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2;-272,544;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-256,912;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;27;-320,96;Inherit;True;Property;_Roughness;Roughness;10;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleAddOpNode;20;-16,656;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PosVertexDataNode;29;-192,352;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;25;-320,-352;Inherit;True;Property;_Diffuse;Diffuse;8;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.OneMinusNode;28;-16,96;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;26;-320,-128;Inherit;True;Property;_Normal;Normal;9;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.OneMinusNode;9;-944,0;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;30;96,400;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;368,-96;Float;False;True;-1;3;AmplifyShaderEditor.MaterialInspector;0;0;Standard;Vine;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;;0;False;;False;0;False;;0;False;;False;0;Custom;0.5;True;True;0;False;Opaque;;AlphaTest;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;8;0;6;2
WireConnection;8;1;7;0
WireConnection;16;0;15;2
WireConnection;16;1;17;0
WireConnection;16;2;18;0
WireConnection;10;0;8;0
WireConnection;10;1;11;0
WireConnection;10;2;13;0
WireConnection;19;0;10;0
WireConnection;19;1;16;0
WireConnection;2;0;19;0
WireConnection;2;1;1;0
WireConnection;2;2;3;0
WireConnection;2;3;4;0
WireConnection;22;0;21;0
WireConnection;22;1;23;0
WireConnection;22;2;24;0
WireConnection;20;0;2;0
WireConnection;20;1;22;0
WireConnection;28;0;27;1
WireConnection;9;0;8;0
WireConnection;30;0;29;0
WireConnection;30;1;20;0
WireConnection;0;0;25;5
WireConnection;0;1;26;0
WireConnection;0;4;28;0
WireConnection;0;10;9;0
WireConnection;0;11;20;0
ASEEND*/
//CHKSM=55BCDE1AF90A3FF119B1E8D1A3C5F78710AFE674