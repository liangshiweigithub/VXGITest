// Made with Amplify Shader Editor v1.9.1.7
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "RM/LitMerge"
{
	Properties
	{
		[ASEBegin][Toggle]_AmbientOcclusion("AmbientOcclusion", Float) = 1
		_AlphaCutoff("AlphaCutoff", Range( 0 , 1)) = 0
		_Speed("Speed( 仅传送带效果使用！)", Range( -1 , 1)) = 0
		_BaseMap("AbedoMap", 2D) = "white" {}
		_BaseColor("BaseColor", Color) = (1,1,1,1)
		_BumpMap("BumpMap", 2D) = "black" {}
		_BumpScale("BumpScale", Float) = 1
		_Metallic("Metallic", Range( 0 , 1)) = 1
		_Smoothness("Smoothness", Range( 0 , 1)) = 1
		[Toggle(_DETAIL_ON)] _DETAIL("Detail", Float) = 0
		_VertexColChannel("VertexColChannel", Vector) = (0,0,0,1)
		_DetailMask("DetailMask", 2D) = "black" {}
		_DetailAlbedoMap("DetailAlbedoMap", 2D) = "white" {}
		_DetailColor("DetailColor", Color) = (1,1,1,1)
		_DetailNormalMap("DetailNormalMap", 2D) = "black" {}
		_DetailNormalScale("DetailNormalScale", Float) = 1
		_DetailSmoothness("DetailSmoothness", Range( 0 , 1)) = 0.5
		_DetailMetallic("DetailMetallic", Range( 0 , 1)) = 0
		_BlendFactor("BlendFactor", Range( 1 , 16)) = 1
		_BlendFalloff("BlendFalloff", Range( 1 , 128)) = 1
		[Toggle(_VT_ON)] _VT("VT", Float) = 0
		_VTColor("VTColor", Color) = (1,1,1,1)
		_VTMap("VTMap", 2D) = "white" {}
		_VTBumpScale("VTBumpScale", Range( 0 , 1)) = 1
		_ParticleLayer_BlendFactor("BlendFactor", Range( 1 , 16)) = 1
		_ParticleLayer_BlendFalloff("BlendFalloff", Range( 1 , 128)) = 1
		_EmissionMap("Emission", 2D) = "white" {}
		[HDR]_EmissionColor("EmissionColor", Color) = (0,0,0,0)
		_HighLightSwitch("HighLightSwitch", Range( 0 , 1)) = 0
		_HighLightRate("LightDarkTimeScale", Range( 0 , 1)) = 0.5
		_HighLightSpeed("HighLightSpeed", Range( 0 , 5)) = 0.4
		_StartIntensity("StartIntensity", Range( 0 , 5)) = 0.1
		_HighLightScale("HighLightScale", Range( 0 , 5)) = 1.1
		_HighLightDarkScale("HighLightDarkScale", Range( 0 , 5)) = 1
		[Toggle(_CRR_RENDERING)] _CRR_RENDERING("CRR_RENDERING", Float) = 0
		[Toggle(GPU_DRIVEN_TEST)] _GPU_DRIVEN_TEST("GPU DRIVEN TEST", Float) = 0
		_BaseMapArray("BaseMapArray", 2DArray) = "black" {}
		_BumpMapArray("BumpMapArray", 2DArray) = "black" {}
		[ASEEnd][Toggle]_FogClose("FogClose", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}


		[ToggleOff] _SpecularHighlights("Specular Highlights", Float) = 1.0
		[ToggleOff] _EnvironmentReflections("Environment Reflections", Float) = 1.0
		[HideInInspector][ToggleOff] _ReceiveShadows("Receive Shadows", Float) = 1.0

		[HideInInspector] _QueueOffset("_QueueOffset", Float) = 0
        [HideInInspector] _QueueControl("_QueueControl", Float) = -1

        [HideInInspector][NoScaleOffset] unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset] unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset] unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}

		 // Blending state
        [HideInInspector]_Surface("_Surface", Float) = 0
        [HideInInspector]_Blend("_Blend", Float) = 0
        [HideInInspector]_AlphaClip("_AlphaClip", Float) = 0
        [HideInInspector]_SrcBlend("_SrcBlend", Float) = 1
        [HideInInspector]_DstBlend("_DstBlend", Float) = 0
        [HideInInspector][ToggleUI]_ZWrite("_ZWrite", Float) = 1
        [HideInInspector]_ZWriteControl("_ZWriteControl", Float) = 0
        [HideInInspector]_ZTest("_ZTest", Float) = 4
        [HideInInspector]_Cull("_Cull", Float) = 2
	}

	SubShader
	{
		LOD 0

		

		Tags { "RenderPipeline"="UniversalPipeline" "RenderType"="Opaque" "Queue"="Geometry" "UniversalMaterialType"="Lit" }
		

		HLSLINCLUDE
		#pragma target 4.5
		#pragma prefer_hlslcc gles

		#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
		#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Filtering.hlsl"
		ENDHLSL

		
		Pass
		{
			
			Name "Forward"
			Tags { "LightMode"="UniversalForward" }

		ZTest LEqual
		Offset 0 , 0
		Blend[_SrcBlend][_DstBlend]
        ZWrite[_ZWrite]
        Cull[_Cull]

			

			HLSLPROGRAM

			#define _NORMAL_DROPOFF_TS 1
			#pragma multi_compile_instancing
			#pragma instancing_options renderinglayer
			#pragma multi_compile_fragment _ LOD_FADE_CROSSFADE
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#define _EMISSION
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION -1


			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE
			#pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
			#pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
			#pragma multi_compile_fragment _ _SHADOWS_SOFT
			#pragma multi_compile_fragment _ _SCREEN_SPACE_OCCLUSION
			#pragma multi_compile_fragment _ _LIGHT_LAYERS
			#pragma multi_compile_fragment _ _LIGHT_COOKIES
			#pragma shader_feature_local _RECEIVE_SHADOWS_OFF
			#pragma shader_feature_local_fragment _SPECULARHIGHLIGHTS_OFF
			#pragma shader_feature_local_fragment _ENVIRONMENTREFLECTIONS_OFF

			#pragma shader_feature _ LIGHTMAP_SHADOW_MIXING
			#pragma shader_feature _ SHADOWS_SHADOWMASK
			#pragma shader_feature _ LIGHTMAP_ON
			#pragma shader_feature _ DEBUG_DISPLAY
			#pragma shader_feature _ _WRITE_RENDERING_LAYERS
			#pragma shader_feature_local_fragment _ALPHATEST_ON

			#pragma shader_feature MODIFY_VERTEX_POSTION_USEING_SPLINE

			#pragma vertex vert
			#pragma fragment frag

			#define SHADERPASS SHADERPASS_FORWARD

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Shaders/Soc/ComputeShaders/GPUStaticSceneBuild.hlsl"

			#if defined(UNITY_INSTANCING_ENABLED) && defined(_TERRAIN_INSTANCED_PERPIXEL_NORMAL)
				#define ENABLE_TERRAIN_PERPIXEL_NORMAL
			#endif

			#if defined(MODIFY_VERTEX_POSTION_USEING_SPLINE)
			StructuredBuffer<int> indecesBuffer;
			StructuredBuffer<float> railPropsBuffer;
			#endif

			#define ASE_NEEDS_FRAG_COLOR
			#define ASE_NEEDS_FRAG_WORLD_TANGENT
			#define ASE_NEEDS_FRAG_WORLD_NORMAL
			#define ASE_NEEDS_FRAG_WORLD_BITANGENT
			#pragma multi_compile __ _CRR_RENDERING
			#pragma shader_feature_local GPU_DRIVEN_TEST
			#pragma shader_feature_local _VT_ON
			#pragma shader_feature_local _DETAIL_ON


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_tangent : TANGENT;
				float4 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				uint instanceid : SV_InstanceID;
				float4 ase_color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				float4 lightmapUVOrVertexSH : TEXCOORD0;
				half4 fogFactorAndVertexLight : TEXCOORD1;
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
					float4 shadowCoord : TEXCOORD2;
				#endif
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
				#if defined(ASE_NEEDS_FRAG_SCREEN_POSITION)
					float4 screenPos : TEXCOORD6;
				#endif
				#if defined(DYNAMICLIGHTMAP_ON)
					float2 dynamicLightmapUV : TEXCOORD7;
				#endif
				float4 ase_texcoord8 : TEXCOORD8;
				float4 ase_color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};


			sampler2D _BaseMap;
			TEXTURE2D_ARRAY(_BaseMapArray);
			SAMPLER(sampler_BaseMapArray);
			sampler2D _DetailAlbedoMap;
			sampler2D _DetailMask;
			sampler2D _VTMap;
			sampler2D _BumpMap;
			TEXTURE2D_ARRAY(_BumpMapArray);
			SAMPLER(sampler_BumpMapArray);
			sampler2D _DetailNormalMap;
			sampler2D _EmissionMap;
			
			#ifdef UNITY_DOTS_INSTANCING_ENABLED
			UNITY_DOTS_INSTANCING_START(MaterialPropertyMetadata)
				UNITY_DOTS_INSTANCED_PROP(float, _DetailNormalScale)
			UNITY_DOTS_INSTANCING_END(MaterialPropertyMetadata)
			#define _DetailNormalScale UNITY_ACCESS_DOTS_INSTANCED_PROP_FROM_MACRO(float , Metadata__DetailNormalScale)
			#endif
			CBUFFER_START( UnityPerMaterial )
			float4 _DetailNormalMap_ST;
			float4 _BumpMapArray_ST;
			float4 _BumpMap_ST;
			float4 _VTMap_ST;
			float4 _EmissionMap_ST;
			float4 _VertexColChannel;
			float4 _DetailMask_ST;
			float4 _VTColor;
			float4 _DetailAlbedoMap_ST;
			float4 _BaseMapArray_ST;
			float4 _BaseMap_ST;
			float4 _BaseColor;
			float4 _DetailColor;
			float4 _EmissionColor;
			float _Smoothness;
			float _DetailMetallic;
			float _Metallic;
			float _DetailSmoothness;
			float _StartIntensity;
			float _HighLightRate;
			float _HighLightSpeed;
			float _HighLightSwitch;
			float _HighLightDarkScale;
			float _FogClose;
			float _VTBumpScale;
			float _ParticleLayer_BlendFalloff;
			float _DetailNormalScale;
			float _AmbientOcclusion;
			float _BumpScale;
			float _ParticleLayer_BlendFactor;
			float _BlendFalloff;
			float _BlendFactor;
			float _Speed;
			float _HighLightScale;
			float _AlphaCutoff;
			CBUFFER_END


			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRForwardPass.hlsl"

			//#ifdef HAVE_VFX_MODIFICATION
			//#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
			//#endif

			float3 NormalStrength263( float3 In, float Strength )
			{
				float3 out1 = float3(In.xy * Strength, lerp(1, In.z, saturate(Strength))); 
				return out1;
			}
			
			float3 NormalStrength268( float3 In, float Strength )
			{
				float3 out1 = float3(In.xy * Strength, lerp(1, In.z, saturate(Strength))); 
				return out1;
			}
			
			float3 NormalStrength395( float3 In, float Strength )
			{
				float3 out1 = float3(In.xy * Strength, lerp(1, In.z, saturate(Strength))); 
				return out1;
			}
			

			//_CRR_RENDERING
			#if defined(_CRR_RENDERING)
			float4x4 modelMatrix;
			#endif

			#if defined(_CRR_RENDERING)
			inline float3 CRR_GetViewPosition(float4 positionRS)
			{
    			return float3(dot(positionRS,UNITY_MATRIX_V[0].xyz),dot(positionRS,UNITY_MATRIX_V[1].xyz),dot(positionRS,UNITY_MATRIX_V[2].xyz));
			}
			#endif

#if defined(GPU_DRIVEN_TEST)
			VertexOutput VertexFunction( VertexInput v, uint inst)
#else
			VertexOutput VertexFunction( VertexInput v  )
#endif
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				o.ase_texcoord8.xy = v.texcoord.xy;
				o.ase_color = v.ase_color;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord8.zw = 0;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = defaultVertexValue;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif
				v.ase_normal = v.ase_normal;

#if defined(MODIFY_VERTEX_POSTION_USEING_SPLINE)

				int curRailOffset = indecesBuffer[v.instanceid] * 33;

				float splineStepSize = railPropsBuffer[curRailOffset + 30];
				float startDistance = railPropsBuffer[curRailOffset + 31];
				float endDistance = railPropsBuffer[curRailOffset + 32];

				float nZ = v.vertex.z / 18;
				float df = lerp(startDistance, endDistance, v.vertex.z / 18);
				int di = max(floor(df), floor(startDistance));
				int startIndex = max((di - floor(startDistance)), 0) * 3 + curRailOffset;

				float t = df - di;
				float t2 = t * t;
				float t3 = t * t2;

				float3 p0 = float3(railPropsBuffer[startIndex], railPropsBuffer[startIndex + 1], railPropsBuffer[startIndex + 2]);
				float3 p1 = float3(railPropsBuffer[startIndex + 3], railPropsBuffer[startIndex + 4], railPropsBuffer[startIndex + 5]);
				float3 tan0 = float3(railPropsBuffer[startIndex + 15], railPropsBuffer[startIndex + 16], railPropsBuffer[startIndex + 17]);
				float3 tan1 = float3(railPropsBuffer[startIndex + 18], railPropsBuffer[startIndex + 19], railPropsBuffer[startIndex + 20]);
				float3 m0 = splineStepSize * tan0;
				float3 m1 = splineStepSize * tan1;
				float3 posWS = (2 * t3 - 3 * t2 + 1) * p0 + (t3 - 2 * t2 + t) * m0 + (-2 * t3 + 3 * t2) * p1 + (t3 - t2) * m1;

				//float3 splineDir = normalize(lerp(tan0, tan1, t));
				float3 pathForward = normalize(lerp(tan0, tan1, t));
				pathForward.y = 0;
				pathForward = normalize(pathForward);
				float3 pathSide = normalize(lerp(tan0, tan1, t)).zyx;
				pathSide.x = -pathSide.x;
				pathSide.y = 0;
				pathSide = normalize(pathSide);

				posWS -= pathSide * v.vertex.x;
				posWS.y += v.vertex.y;

				float3 positionWS = posWS;
				positionWS = TransformObjectToWorld(v.vertex.xyz);


#else
				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );
#endif

				float3 positionVS = TransformWorldToView( positionWS );
				float4 positionCS = TransformWorldToHClip( positionWS );

				VertexNormalInputs normalInput = GetVertexNormalInputs( v.ase_normal, v.ase_tangent );

				o.tSpace0 = float4( normalInput.normalWS, positionWS.x);
				o.tSpace1 = float4( normalInput.tangentWS, positionWS.y);
				o.tSpace2 = float4( normalInput.bitangentWS, positionWS.z);

				#if defined(LIGHTMAP_ON)
					OUTPUT_LIGHTMAP_UV( v.texcoord1, unity_LightmapST, o.lightmapUVOrVertexSH.xy );
				#endif

				#if !defined(LIGHTMAP_ON)
					OUTPUT_SH( normalInput.normalWS.xyz, o.lightmapUVOrVertexSH.xyz );
				#endif

				#if defined(DYNAMICLIGHTMAP_ON)
					o.dynamicLightmapUV.xy = v.texcoord2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
				#endif

				#if defined(ENABLE_TERRAIN_PERPIXEL_NORMAL)
					o.lightmapUVOrVertexSH.zw = v.texcoord;
					o.lightmapUVOrVertexSH.xy = v.texcoord * unity_LightmapST.xy + unity_LightmapST.zw;
				#endif

				half3 vertexLight = VertexLighting( positionWS, normalInput.normalWS );

				#ifdef ASE_FOG
					half fogFactor = ComputeFogFactor( positionCS.z );
				#else
					half fogFactor = 0;
				#endif

				o.fogFactorAndVertexLight = half4(fogFactor, vertexLight);
				
				#if defined(_CRR_RENDERING)
    			float4 positionRS = mul(modelMatrix, float4(v.vertex.xyz, 1));
    			positionWS = positionRS.xyz + _WorldSpaceCameraPos;
    			positionVS = CRR_GetViewPosition(positionRS);
    			positionCS = mul(UNITY_MATRIX_P,float4(positionVS,1));
				#endif

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
					VertexPositionInputs vertexInput = (VertexPositionInputs)0;
					vertexInput.positionWS = positionWS;
					vertexInput.positionCS = positionCS;
					o.shadowCoord = GetShadowCoord( vertexInput );
				#endif

				o.clipPos = positionCS;

				#if defined(ASE_NEEDS_FRAG_SCREEN_POSITION)
					o.screenPos = ComputeScreenPos(positionCS);
				#endif

				return o;
			}

#if defined(GPU_DRIVEN_TEST)
			VertexOutput vert(VertexInput v, uint inst : SV_InstanceID)
			{
				return VertexFunction(v, inst);
			}
#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
#endif
			#if defined(ASE_EARLY_Z_DEPTH_OPTIMIZE)
				#define ASE_SV_DEPTH SV_DepthLessEqual
			#else
				#define ASE_SV_DEPTH SV_Depth
			#endif

			half4 frag ( VertexOutput IN
						#ifdef ASE_DEPTH_WRITE_ON
						,out float outputDepth : ASE_SV_DEPTH
						#endif
						#ifdef _WRITE_RENDERING_LAYERS
						, out float4 outRenderingLayers : SV_Target1
						#endif
						 ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(IN);

				#ifdef LOD_FADE_CROSSFADE
					LODFadeCrossFade( IN.clipPos );
				#endif

				#if defined(ENABLE_TERRAIN_PERPIXEL_NORMAL)
					float2 sampleCoords = (IN.lightmapUVOrVertexSH.zw / _TerrainHeightmapRecipSize.zw + 0.5f) * _TerrainHeightmapRecipSize.xy;
					float3 WorldNormal = TransformObjectToWorldNormal(normalize(SAMPLE_TEXTURE2D(_TerrainNormalmapTexture, sampler_TerrainNormalmapTexture, sampleCoords).rgb * 2 - 1));
					float3 WorldTangent = -cross(GetObjectToWorldMatrix()._13_23_33, WorldNormal);
					float3 WorldBiTangent = cross(WorldNormal, -WorldTangent);
				#else
					float3 WorldNormal = normalize( IN.tSpace0.xyz );
					float3 WorldTangent = IN.tSpace1.xyz;
					float3 WorldBiTangent = IN.tSpace2.xyz;
				#endif

				float3 WorldPosition = float3(IN.tSpace0.w,IN.tSpace1.w,IN.tSpace2.w);
				float3 WorldViewDirection = GetWorldSpaceNormalizeViewDir(WorldPosition);
				float4 ShadowCoords = float4( 0, 0, 0, 0 );

				#if defined(ASE_NEEDS_FRAG_SCREEN_POSITION)
					float4 ScreenPos = IN.screenPos;
				#endif

				float2 NormalizedScreenSpaceUV = GetNormalizedScreenSpaceUV(IN.clipPos);

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
					ShadowCoords = IN.shadowCoord;
				#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
					ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
				#endif

				#ifdef GPU_DRIVEN_TEST
				float4 staticSwitch400 = BaseColor_GPU;
				#else
				float4 staticSwitch400 = _BaseColor;
				#endif
				float temp_output_417_0 = ( _TimeParameters.x * _Speed );
				float2 uv_BaseMap = IN.ase_texcoord8.xy * _BaseMap_ST.xy + _BaseMap_ST.zw;
				float2 appendResult421 = (float2(( temp_output_417_0 + uv_BaseMap.x ) , uv_BaseMap.y));
				float2 uv_BaseMapArray = IN.ase_texcoord8.xy;
				#ifdef GPU_DRIVEN_TEST
				float4 staticSwitch298 = SAMPLE_TEXTURE2D_ARRAY( _BaseMapArray, sampler_BaseMapArray, uv_BaseMapArray,AlbedoIndex );
				#else
				float4 staticSwitch298 = tex2D( _BaseMap, appendResult421 );
				#endif
				float4 temp_output_17_0 = ( staticSwitch400 * staticSwitch298 );
				float2 uv_DetailAlbedoMap = IN.ase_texcoord8.xy * _DetailAlbedoMap_ST.xy + _DetailAlbedoMap_ST.zw;
				float2 uv_DetailMask = IN.ase_texcoord8.xy * _DetailMask_ST.xy + _DetailMask_ST.zw;
				float saferPower32 = abs( ( tex2D( _DetailMask, uv_DetailMask ).g * ( ( _VertexColChannel.x * IN.ase_color.r ) + ( _VertexColChannel.y * IN.ase_color.g ) + ( _VertexColChannel.z * IN.ase_color.b ) + ( _VertexColChannel.w * IN.ase_color.a ) ) * _BlendFactor ) );
				float HeightMask64 = saturate( pow( saferPower32 , _BlendFalloff ) );
				float4 lerpResult26 = lerp( temp_output_17_0 , ( tex2D( _DetailAlbedoMap, uv_DetailAlbedoMap ) * _DetailColor ) , HeightMask64);
				#ifdef _DETAIL_ON
				float4 staticSwitch25 = lerpResult26;
				#else
				float4 staticSwitch25 = temp_output_17_0;
				#endif
				float3 BaseAlbedo68 = (staticSwitch25).rgb;
				float2 uv_VTMap = IN.ase_texcoord8.xy * _VTMap_ST.xy + _VTMap_ST.zw;
				float2 uv_BumpMap = IN.ase_texcoord8.xy * _BumpMap_ST.xy + _BumpMap_ST.zw;
				float2 appendResult431 = (float2(( temp_output_417_0 + uv_BumpMap.x ) , uv_BumpMap.y));
				float2 uv_BumpMapArray = IN.ase_texcoord8.xy;
				#ifdef GPU_DRIVEN_TEST
				float4 staticSwitch321 = SAMPLE_TEXTURE2D_ARRAY( _BumpMapArray, sampler_BumpMapArray, uv_BumpMapArray,NormalIndex );
				#else
				float4 staticSwitch321 = tex2D( _BumpMap, appendResult431 );
				#endif
				float4 break339 = staticSwitch321;
				float2 appendResult189 = (float2(break339.r , break339.g));
				float2 temp_output_1_0_g2 = (float2( -1,-1 ) + (appendResult189 - float2( 0,0 )) * (float2( 1,1 ) - float2( -1,-1 )) / (float2( 1,1 ) - float2( 0,0 )));
				float dotResult4_g2 = dot( temp_output_1_0_g2 , temp_output_1_0_g2 );
				float3 appendResult10_g2 = (float3((temp_output_1_0_g2).x , (temp_output_1_0_g2).y , sqrt( ( 1.0 - saturate( dotResult4_g2 ) ) )));
				float3 normalizeResult12_g2 = normalize( appendResult10_g2 );
				float3 In263 = normalizeResult12_g2;
				#ifdef GPU_DRIVEN_TEST
				float staticSwitch403 = BumpScale_GPU;
				#else
				float staticSwitch403 = _BumpScale;
				#endif
				float Strength263 = staticSwitch403;
				float3 localNormalStrength263 = NormalStrength263( In263 , Strength263 );
				float2 uv_DetailNormalMap = IN.ase_texcoord8.xy * _DetailNormalMap_ST.xy + _DetailNormalMap_ST.zw;
				float4 tex2DNode190 = tex2D( _DetailNormalMap, uv_DetailNormalMap );
				float2 appendResult191 = (float2(tex2DNode190.r , tex2DNode190.g));
				float2 temp_output_1_0_g17 = (float2( -1,-1 ) + (appendResult191 - float2( 0,0 )) * (float2( 1,1 ) - float2( -1,-1 )) / (float2( 1,1 ) - float2( 0,0 )));
				float dotResult4_g17 = dot( temp_output_1_0_g17 , temp_output_1_0_g17 );
				float3 appendResult10_g17 = (float3((temp_output_1_0_g17).x , (temp_output_1_0_g17).y , sqrt( ( 1.0 - saturate( dotResult4_g17 ) ) )));
				float3 normalizeResult12_g17 = normalize( appendResult10_g17 );
				float3 In268 = normalizeResult12_g17;
				float Strength268 = _DetailNormalScale;
				float3 localNormalStrength268 = NormalStrength268( In268 , Strength268 );
				float3 lerpResult149 = lerp( localNormalStrength263 , localNormalStrength268 , HeightMask64);
				#ifdef _DETAIL_ON
				float3 staticSwitch79 = lerpResult149;
				#else
				float3 staticSwitch79 = localNormalStrength263;
				#endif
				float3 BaseNormal59 = staticSwitch79;
				float3 tanToWorld0 = float3( WorldTangent.x, WorldBiTangent.x, WorldNormal.x );
				float3 tanToWorld1 = float3( WorldTangent.y, WorldBiTangent.y, WorldNormal.y );
				float3 tanToWorld2 = float3( WorldTangent.z, WorldBiTangent.z, WorldNormal.z );
				float3 tanNormal38 = BaseNormal59;
				float3 worldNormal38 = normalize( float3(dot(tanToWorld0,tanNormal38), dot(tanToWorld1,tanNormal38), dot(tanToWorld2,tanNormal38)) );
				float dotResult39 = dot( float4( worldNormal38 , 0.0 ) , float4(0,1,0,0) );
				float saferPower53 = abs( ( _ParticleLayer_BlendFactor * saturate( dotResult39 ) ) );
				float ParticalLayerMask71 = saturate( pow( saferPower53 , _ParticleLayer_BlendFalloff ) );
				float3 lerpResult42 = lerp( BaseAlbedo68 , (( _VTColor * tex2D( _VTMap, uv_VTMap ) )).rgb , ParticalLayerMask71);
				#ifdef _VT_ON
				float3 staticSwitch41 = lerpResult42;
				#else
				float3 staticSwitch41 = BaseAlbedo68;
				#endif
				float3 SurfaceAlbedo393 = staticSwitch41;
				
				float3 In395 = BaseNormal59;
				float Strength395 = _VTBumpScale;
				float3 localNormalStrength395 = NormalStrength395( In395 , Strength395 );
				float3 lerpResult44 = lerp( BaseNormal59 , localNormalStrength395 , ParticalLayerMask71);
				#ifdef _VT_ON
				float3 staticSwitch46 = lerpResult44;
				#else
				float3 staticSwitch46 = BaseNormal59;
				#endif
				float3 SurfaceNormal394 = staticSwitch46;
				
				float2 uv_EmissionMap = IN.ase_texcoord8.xy * _EmissionMap_ST.xy + _EmissionMap_ST.zw;
				float4 AbedoMap357 = staticSwitch298;
				float clampResult309 = clamp( abs( sin( ( ( _TimeParameters.x ) * _HighLightSpeed ) ) ) , 0.0 , _HighLightRate );
				float3 SurfaceEmission94 = (( ( tex2D( _EmissionMap, uv_EmissionMap ) * _EmissionColor ) + ( _HighLightScale * _HighLightDarkScale * AbedoMap357 * _HighLightSwitch * ( ( clampResult309 * ( 1.0 / _HighLightRate ) ) + _StartIntensity ) ) )).rgb;
				
				float BaseMetallic193 = break339.b;
				#ifdef GPU_DRIVEN_TEST
				float staticSwitch407 = Metallic_GPU;
				#else
				float staticSwitch407 = _Metallic;
				#endif
				float temp_output_110_0 = ( BaseMetallic193 * staticSwitch407 );
				float lerpResult147 = lerp( temp_output_110_0 , _DetailMetallic , HeightMask64);
				#ifdef _DETAIL_ON
				float staticSwitch148 = lerpResult147;
				#else
				float staticSwitch148 = temp_output_110_0;
				#endif
				float SurfaceMetallic92 = staticSwitch148;
				
				float BaseSmoothness194 = break339.a;
				#ifdef GPU_DRIVEN_TEST
				float staticSwitch405 = Smoothness_GPU;
				#else
				float staticSwitch405 = _Smoothness;
				#endif
				float temp_output_139_0 = ( BaseSmoothness194 * staticSwitch405 );
				float lerpResult144 = lerp( temp_output_139_0 , _DetailSmoothness , HeightMask64);
				#ifdef _DETAIL_ON
				float staticSwitch145 = lerpResult144;
				#else
				float staticSwitch145 = temp_output_139_0;
				#endif
				float SmoothnessMerge77 = staticSwitch145;
				
				float BaseAlpha163 = (staticSwitch298).a;
				float2 appendResult207 = (float2(BaseAlpha163 , 1.0));
				#ifdef GPU_DRIVEN_TEST
				float staticSwitch409 = AO_GPU;
				#else
				float staticSwitch409 = _AmbientOcclusion;
				#endif
				float2 lerpResult210 = lerp( (appendResult207).xy , (appendResult207).yx , staticSwitch409);
				float2 break222 = lerpResult210;
				
				#ifdef GPU_DRIVEN_TEST
				float staticSwitch411 = 1.0;
				#else
				float staticSwitch411 = _BaseColor.a;
				#endif
				float ColorAlpha224 = staticSwitch411;
				
				#ifdef GPU_DRIVEN_TEST
				float staticSwitch413 = AlphaCutoff_GPU;
				#else
				float staticSwitch413 = _AlphaCutoff;
				#endif
				

				float3 BaseColor = SurfaceAlbedo393;
				float3 Normal = SurfaceNormal394;
				float3 Emission = SurfaceEmission94;
				float3 Specular = 0.5;
				float Metallic = SurfaceMetallic92;
				float Smoothness = SmoothnessMerge77;
				float Occlusion = break222.y;
				float Alpha = ( ColorAlpha224 * break222.x );
				float AlphaClipThreshold = staticSwitch413;
				float AlphaClipThresholdShadow = 0.5;
				float3 BakedGI = 0;
				float3 RefractionColor = 1;
				float RefractionIndex = 1;

				#ifdef ASE_DEPTH_WRITE_ON
					float DepthValue = 0;
				#endif
				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				InputData inputData = (InputData)0;
				inputData.positionWS = WorldPosition;
				inputData.viewDirectionWS = WorldViewDirection;

				#ifdef _NORMALMAP
						#if _NORMAL_DROPOFF_TS
							inputData.normalWS = TransformTangentToWorld(Normal, half3x3(WorldTangent, WorldBiTangent, WorldNormal));
						#elif _NORMAL_DROPOFF_OS
							inputData.normalWS = TransformObjectToWorldNormal(Normal);
						#elif _NORMAL_DROPOFF_WS
							inputData.normalWS = Normal;
						#endif
					inputData.normalWS = NormalizeNormalPerPixel(inputData.normalWS);
				#else
					inputData.normalWS = WorldNormal;
				#endif

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
					inputData.shadowCoord = ShadowCoords;
				#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
					inputData.shadowCoord = TransformWorldToShadowCoord(inputData.positionWS);
				#else
					inputData.shadowCoord = float4(0, 0, 0, 0);
				#endif

				#ifdef ASE_FOG
					inputData.fogCoord = IN.fogFactorAndVertexLight.x;
				#endif
					inputData.vertexLighting = IN.fogFactorAndVertexLight.yzw;

				#if defined(ENABLE_TERRAIN_PERPIXEL_NORMAL)
					float3 SH = SampleSH(inputData.normalWS.xyz);
				#else
					float3 SH = IN.lightmapUVOrVertexSH.xyz;
				#endif

				#if defined(DYNAMICLIGHTMAP_ON)
					inputData.bakedGI = SAMPLE_GI(IN.lightmapUVOrVertexSH.xy, IN.dynamicLightmapUV.xy, SH, inputData.normalWS);
				#else
					inputData.bakedGI = SAMPLE_GI(IN.lightmapUVOrVertexSH.xy, SH, inputData.normalWS);
				#endif

				#ifdef ASE_BAKEDGI
					inputData.bakedGI = BakedGI;
				#endif

				inputData.normalizedScreenSpaceUV = NormalizedScreenSpaceUV;
				inputData.shadowMask = SAMPLE_SHADOWMASK(IN.lightmapUVOrVertexSH.xy);

				#if defined(DEBUG_DISPLAY)
					#if defined(DYNAMICLIGHTMAP_ON)
						inputData.dynamicLightmapUV = IN.dynamicLightmapUV.xy;
					#endif
					#if defined(LIGHTMAP_ON)
						inputData.staticLightmapUV = IN.lightmapUVOrVertexSH.xy;
					#else
						inputData.vertexSH = SH;
					#endif
				#endif

				SurfaceData surfaceData;
				surfaceData.albedo              = BaseColor;
				surfaceData.metallic            = saturate(Metallic);
				surfaceData.specular            = Specular;
				surfaceData.smoothness          = saturate(Smoothness),
				surfaceData.occlusion           = Occlusion,
				surfaceData.emission            = Emission,
				surfaceData.alpha               = saturate(Alpha);
				surfaceData.normalTS            = Normal;
				surfaceData.clearCoatMask       = 0;
				surfaceData.clearCoatSmoothness = 1;
				#ifdef _DBUFFER
					ApplyDecalToSurfaceData(IN.clipPos, surfaceData, inputData);
				#endif

				half4 color = UniversalFragmentPBR( inputData, surfaceData);
				#ifdef ASE_REFRACTION
					float4 projScreenPos = ScreenPos / ScreenPos.w;
					float3 refractionOffset = ( RefractionIndex - 1.0 ) * mul( UNITY_MATRIX_V, float4( WorldNormal,0 ) ).xyz * ( 1.0 - dot( WorldNormal, WorldViewDirection ) );
					projScreenPos.xy += refractionOffset.xy;
					float3 refraction = SHADERGRAPH_SAMPLE_SCENE_COLOR( projScreenPos.xy ) * RefractionColor;
					color.rgb = lerp( refraction, color.rgb, color.a );
					color.a = 1;
				#endif

				#ifdef ASE_FINAL_COLOR_ALPHA_MULTIPLY
					color.rgb *= color.a;
				#endif

				#ifdef ASE_FOG
					#ifdef TERRAIN_SPLAT_ADDPASS
						color.rgb = MixFogColor(color.rgb, half3( 0, 0, 0 ), IN.fogFactorAndVertexLight.x );
					#else
						color.rgb = MixFog(color.rgb, IN.fogFactorAndVertexLight.x);
					#endif
				#endif

				#ifdef ASE_DEPTH_WRITE_ON
					outputDepth = DepthValue;
				#endif

				#ifdef _WRITE_RENDERING_LAYERS
					uint renderingLayers = GetMeshRenderingLayer();
					outRenderingLayers = float4( EncodeMeshRenderingLayer( renderingLayers ), 0, 0, 0 );
				#endif

				return color;
			}

			ENDHLSL
		}

		
		Pass
		{
			
			Name "ShadowCaster"
			Tags { "LightMode"="ShadowCaster" }

			ZWrite On
			ZTest LEqual
			ColorMask 0

			HLSLPROGRAM

			#define _NORMAL_DROPOFF_TS 1
			#pragma multi_compile_instancing
			#pragma multi_compile_fragment _ LOD_FADE_CROSSFADE
			#define ASE_FOG 1
			#define _EMISSION
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION -1


			#pragma vertex vert
			#pragma fragment frag

			#pragma multi_compile_vertex _ _CASTING_PUNCTUAL_LIGHT_SHADOW
			#pragma shader_feature_local_fragment _ALPHATEST_ON

			#define SHADERPASS SHADERPASS_SHADOWCASTER

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"

			#pragma multi_compile __ _CRR_RENDERING
			#pragma shader_feature_local GPU_DRIVEN_TEST


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					float3 worldPos : TEXCOORD0;
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					float4 shadowCoord : TEXCOORD1;
				#endif
				float4 ase_texcoord2 : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};


			sampler2D _BaseMap;
			TEXTURE2D_ARRAY(_BaseMapArray);
			SAMPLER(sampler_BaseMapArray);
			CBUFFER_START( UnityPerMaterial )
			float4 _DetailNormalMap_ST;
			float4 _BumpMapArray_ST;
			float4 _BumpMap_ST;
			float4 _VTMap_ST;
			float4 _EmissionMap_ST;
			float4 _VertexColChannel;
			float4 _DetailMask_ST;
			float4 _VTColor;
			float4 _DetailAlbedoMap_ST;
			float4 _BaseMapArray_ST;
			float4 _BaseMap_ST;
			float4 _BaseColor;
			float4 _DetailColor;
			float4 _EmissionColor;
			float _Smoothness;
			float _DetailMetallic;
			float _Metallic;
			float _DetailSmoothness;
			float _StartIntensity;
			float _HighLightRate;
			float _HighLightSpeed;
			float _HighLightSwitch;
			float _HighLightDarkScale;
			float _FogClose;
			float _VTBumpScale;
			float _ParticleLayer_BlendFalloff;
			float _DetailNormalScale;
			float _AmbientOcclusion;
			float _BumpScale;
			float _ParticleLayer_BlendFactor;
			float _BlendFalloff;
			float _BlendFactor;
			float _Speed;
			float _HighLightScale;
			float _AlphaCutoff;
			CBUFFER_END


			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"

			//#ifdef HAVE_VFX_MODIFICATION
			//#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
			//#endif

			
			float3 _LightDirection;
			float3 _LightPosition;

			VertexOutput VertexFunction( VertexInput v )
			{
				VertexOutput o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );

				o.ase_texcoord2.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord2.zw = 0;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = defaultVertexValue;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;

				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					o.worldPos = positionWS;
				#endif

				float3 normalWS = TransformObjectToWorldDir(v.ase_normal);

				#if _CASTING_PUNCTUAL_LIGHT_SHADOW
					float3 lightDirectionWS = normalize(_LightPosition - positionWS);
				#else
					float3 lightDirectionWS = _LightDirection;
				#endif

				float4 clipPos = TransformWorldToHClip(ApplyShadowBias(positionWS, normalWS, lightDirectionWS));

				#if UNITY_REVERSED_Z
					clipPos.z = min(clipPos.z, UNITY_NEAR_CLIP_VALUE);
				#else
					clipPos.z = max(clipPos.z, UNITY_NEAR_CLIP_VALUE);
				#endif

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					VertexPositionInputs vertexInput = (VertexPositionInputs)0;
					vertexInput.positionWS = positionWS;
					vertexInput.positionCS = clipPos;
					o.shadowCoord = GetShadowCoord( vertexInput );
				#endif

				o.clipPos = clipPos;

				return o;
			}

			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}

			#if defined(ASE_EARLY_Z_DEPTH_OPTIMIZE)
				#define ASE_SV_DEPTH SV_DepthLessEqual
			#else
				#define ASE_SV_DEPTH SV_Depth
			#endif

			half4 frag(	VertexOutput IN
						#ifdef ASE_DEPTH_WRITE_ON
						,out float outputDepth : ASE_SV_DEPTH
						#endif
						 ) : SV_TARGET
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					float3 WorldPosition = IN.worldPos;
				#endif

				float4 ShadowCoords = float4( 0, 0, 0, 0 );

				#if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
						ShadowCoords = IN.shadowCoord;
					#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
						ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
					#endif
				#endif

				#ifdef GPU_DRIVEN_TEST
				float staticSwitch411 = 1.0;
				#else
				float staticSwitch411 = _BaseColor.a;
				#endif
				float ColorAlpha224 = staticSwitch411;
				float temp_output_417_0 = ( _TimeParameters.x * _Speed );
				float2 uv_BaseMap = IN.ase_texcoord2.xy * _BaseMap_ST.xy + _BaseMap_ST.zw;
				float2 appendResult421 = (float2(( temp_output_417_0 + uv_BaseMap.x ) , uv_BaseMap.y));
				float2 uv_BaseMapArray = IN.ase_texcoord2.xy;
				#ifdef GPU_DRIVEN_TEST
				float4 staticSwitch298 = SAMPLE_TEXTURE2D_ARRAY( _BaseMapArray, sampler_BaseMapArray, uv_BaseMapArray,AlbedoIndex );
				#else
				float4 staticSwitch298 = tex2D( _BaseMap, appendResult421 );
				#endif
				float BaseAlpha163 = (staticSwitch298).a;
				float2 appendResult207 = (float2(BaseAlpha163 , 1.0));
				#ifdef GPU_DRIVEN_TEST
				float staticSwitch409 = AO_GPU;
				#else
				float staticSwitch409 = _AmbientOcclusion;
				#endif
				float2 lerpResult210 = lerp( (appendResult207).xy , (appendResult207).yx , staticSwitch409);
				float2 break222 = lerpResult210;
				
				#ifdef GPU_DRIVEN_TEST
				float staticSwitch413 = AlphaCutoff_GPU;
				#else
				float staticSwitch413 = _AlphaCutoff;
				#endif
				

				float Alpha = ( ColorAlpha224 * break222.x );
				float AlphaClipThreshold = staticSwitch413;
				float AlphaClipThresholdShadow = 0.5;

				#ifdef ASE_DEPTH_WRITE_ON
					float DepthValue = 0;
				#endif

				#ifdef _ALPHATEST_ON
					#ifdef _ALPHATEST_SHADOW_ON
						clip(Alpha - AlphaClipThresholdShadow);
					#else
						clip(Alpha - AlphaClipThreshold);
					#endif
				#endif

				#ifdef LOD_FADE_CROSSFADE
					LODFadeCrossFade( IN.clipPos );
				#endif

				#ifdef ASE_DEPTH_WRITE_ON
					outputDepth = DepthValue;
				#endif

				return 0;
			}
			ENDHLSL
		}

		
		Pass
		{
			
			Name "DepthOnly"
			Tags { "LightMode"="DepthOnly" }

			ZWrite On
			ColorMask R
			AlphaToMask Off

			HLSLPROGRAM

			#define _NORMAL_DROPOFF_TS 1
			#pragma multi_compile_instancing
			#pragma multi_compile_fragment _ LOD_FADE_CROSSFADE
			#define ASE_FOG 1
			#define _EMISSION
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION -1


			#pragma vertex vert
			#pragma fragment frag

			#define SHADERPASS SHADERPASS_DEPTHONLY

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"
			
			#pragma multi_compile __ _CRR_RENDERING
			#pragma shader_feature_local GPU_DRIVEN_TEST


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 worldPos : TEXCOORD0;
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
				float4 shadowCoord : TEXCOORD1;
				#endif
				float4 ase_texcoord2 : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};


			sampler2D _BaseMap;
			TEXTURE2D_ARRAY(_BaseMapArray);
			SAMPLER(sampler_BaseMapArray);
			CBUFFER_START( UnityPerMaterial )
			float4 _DetailNormalMap_ST;
			float4 _BumpMapArray_ST;
			float4 _BumpMap_ST;
			float4 _VTMap_ST;
			float4 _EmissionMap_ST;
			float4 _VertexColChannel;
			float4 _DetailMask_ST;
			float4 _VTColor;
			float4 _DetailAlbedoMap_ST;
			float4 _BaseMapArray_ST;
			float4 _BaseMap_ST;
			float4 _BaseColor;
			float4 _DetailColor;
			float4 _EmissionColor;
			float _Smoothness;
			float _DetailMetallic;
			float _Metallic;
			float _DetailSmoothness;
			float _StartIntensity;
			float _HighLightRate;
			float _HighLightSpeed;
			float _HighLightSwitch;
			float _HighLightDarkScale;
			float _FogClose;
			float _VTBumpScale;
			float _ParticleLayer_BlendFalloff;
			float _DetailNormalScale;
			float _AmbientOcclusion;
			float _BumpScale;
			float _ParticleLayer_BlendFactor;
			float _BlendFalloff;
			float _BlendFactor;
			float _Speed;
			float _HighLightScale;
			float _AlphaCutoff;
			CBUFFER_END


			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"

			//#ifdef HAVE_VFX_MODIFICATION
			//#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
			//#endif

			
			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				o.ase_texcoord2.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord2.zw = 0;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = defaultVertexValue;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;
				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );
				float4 positionCS = TransformWorldToHClip( positionWS );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					o.worldPos = positionWS;
				#endif

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					VertexPositionInputs vertexInput = (VertexPositionInputs)0;
					vertexInput.positionWS = positionWS;
					vertexInput.positionCS = positionCS;
					o.shadowCoord = GetShadowCoord( vertexInput );
				#endif

				o.clipPos = positionCS;

				return o;
			}

			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}


			#if defined(ASE_EARLY_Z_DEPTH_OPTIMIZE)
				#define ASE_SV_DEPTH SV_DepthLessEqual
			#else
				#define ASE_SV_DEPTH SV_Depth
			#endif

			half4 frag(	VertexOutput IN
						#ifdef ASE_DEPTH_WRITE_ON
						,out float outputDepth : ASE_SV_DEPTH
						#endif
						 ) : SV_TARGET
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 WorldPosition = IN.worldPos;
				#endif

				float4 ShadowCoords = float4( 0, 0, 0, 0 );

				#if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
						ShadowCoords = IN.shadowCoord;
					#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
						ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
					#endif
				#endif

				#ifdef GPU_DRIVEN_TEST
				float staticSwitch411 = 1.0;
				#else
				float staticSwitch411 = _BaseColor.a;
				#endif
				float ColorAlpha224 = staticSwitch411;
				float temp_output_417_0 = ( _TimeParameters.x * _Speed );
				float2 uv_BaseMap = IN.ase_texcoord2.xy * _BaseMap_ST.xy + _BaseMap_ST.zw;
				float2 appendResult421 = (float2(( temp_output_417_0 + uv_BaseMap.x ) , uv_BaseMap.y));
				float2 uv_BaseMapArray = IN.ase_texcoord2.xy;
				#ifdef GPU_DRIVEN_TEST
				float4 staticSwitch298 = SAMPLE_TEXTURE2D_ARRAY( _BaseMapArray, sampler_BaseMapArray, uv_BaseMapArray,AlbedoIndex );
				#else
				float4 staticSwitch298 = tex2D( _BaseMap, appendResult421 );
				#endif
				float BaseAlpha163 = (staticSwitch298).a;
				float2 appendResult207 = (float2(BaseAlpha163 , 1.0));
				#ifdef GPU_DRIVEN_TEST
				float staticSwitch409 = AO_GPU;
				#else
				float staticSwitch409 = _AmbientOcclusion;
				#endif
				float2 lerpResult210 = lerp( (appendResult207).xy , (appendResult207).yx , staticSwitch409);
				float2 break222 = lerpResult210;
				
				#ifdef GPU_DRIVEN_TEST
				float staticSwitch413 = AlphaCutoff_GPU;
				#else
				float staticSwitch413 = _AlphaCutoff;
				#endif
				

				float Alpha = ( ColorAlpha224 * break222.x );
				float AlphaClipThreshold = staticSwitch413;
				#ifdef ASE_DEPTH_WRITE_ON
					float DepthValue = 0;
				#endif

				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				#ifdef LOD_FADE_CROSSFADE
					LODFadeCrossFade( IN.clipPos );
				#endif

				#ifdef ASE_DEPTH_WRITE_ON
					outputDepth = DepthValue;
				#endif

				return 0;
			}
			ENDHLSL
		}

		
		Pass
		{
			
			Name "Meta"
			Tags { "LightMode"="Meta" }

			Cull Off

			HLSLPROGRAM

			#define _NORMAL_DROPOFF_TS 1
			#define ASE_FOG 1
			#define _EMISSION
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION -1


			#pragma vertex vert
			#pragma fragment frag

			#pragma shader_feature EDITOR_VISUALIZATION

			#define SHADERPASS SHADERPASS_META

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/MetaInput.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#define ASE_NEEDS_FRAG_COLOR
			#define ASE_NEEDS_VERT_NORMAL
			#pragma multi_compile __ _CRR_RENDERING
			#pragma shader_feature_local GPU_DRIVEN_TEST
			#pragma shader_feature_local _VT_ON
			#pragma shader_feature_local _DETAIL_ON


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 texcoord0 : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				float4 ase_color : COLOR;
				float4 ase_tangent : TANGENT;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					float3 worldPos : TEXCOORD0;
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					float4 shadowCoord : TEXCOORD1;
				#endif
				#ifdef EDITOR_VISUALIZATION
					float4 VizUV : TEXCOORD2;
					float4 LightCoord : TEXCOORD3;
				#endif
				float4 ase_texcoord4 : TEXCOORD4;
				float4 ase_color : COLOR;
				float4 ase_texcoord5 : TEXCOORD5;
				float4 ase_texcoord6 : TEXCOORD6;
				float4 ase_texcoord7 : TEXCOORD7;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};


			sampler2D _BaseMap;
			TEXTURE2D_ARRAY(_BaseMapArray);
			SAMPLER(sampler_BaseMapArray);
			sampler2D _DetailAlbedoMap;
			sampler2D _DetailMask;
			sampler2D _VTMap;
			sampler2D _BumpMap;
			TEXTURE2D_ARRAY(_BumpMapArray);
			SAMPLER(sampler_BumpMapArray);
			sampler2D _DetailNormalMap;
			sampler2D _EmissionMap;
			
			#ifdef UNITY_DOTS_INSTANCING_ENABLED
			UNITY_DOTS_INSTANCING_START(MaterialPropertyMetadata)
				UNITY_DOTS_INSTANCED_PROP(float, _DetailNormalScale)
			UNITY_DOTS_INSTANCING_END(MaterialPropertyMetadata)
			#define _DetailNormalScale UNITY_ACCESS_DOTS_INSTANCED_PROP_FROM_MACRO(float , Metadata__DetailNormalScale)
			#endif
			CBUFFER_START( UnityPerMaterial )
			float4 _DetailNormalMap_ST;
			float4 _BumpMapArray_ST;
			float4 _BumpMap_ST;
			float4 _VTMap_ST;
			float4 _EmissionMap_ST;
			float4 _VertexColChannel;
			float4 _DetailMask_ST;
			float4 _VTColor;
			float4 _DetailAlbedoMap_ST;
			float4 _BaseMapArray_ST;
			float4 _BaseMap_ST;
			float4 _BaseColor;
			float4 _DetailColor;
			float4 _EmissionColor;
			float _Smoothness;
			float _DetailMetallic;
			float _Metallic;
			float _DetailSmoothness;
			float _StartIntensity;
			float _HighLightRate;
			float _HighLightSpeed;
			float _HighLightSwitch;
			float _HighLightDarkScale;
			float _FogClose;
			float _VTBumpScale;
			float _ParticleLayer_BlendFalloff;
			float _DetailNormalScale;
			float _AmbientOcclusion;
			float _BumpScale;
			float _ParticleLayer_BlendFactor;
			float _BlendFalloff;
			float _BlendFactor;
			float _Speed;
			float _HighLightScale;
			float _AlphaCutoff;
			CBUFFER_END


			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/LightingMetaPass.hlsl"

			//#ifdef HAVE_VFX_MODIFICATION
			//#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
			//#endif

			float3 NormalStrength263( float3 In, float Strength )
			{
				float3 out1 = float3(In.xy * Strength, lerp(1, In.z, saturate(Strength))); 
				return out1;
			}
			
			float3 NormalStrength268( float3 In, float Strength )
			{
				float3 out1 = float3(In.xy * Strength, lerp(1, In.z, saturate(Strength))); 
				return out1;
			}
			

			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float3 ase_worldTangent = TransformObjectToWorldDir(v.ase_tangent.xyz);
				o.ase_texcoord5.xyz = ase_worldTangent;
				float3 ase_worldNormal = TransformObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord6.xyz = ase_worldNormal;
				float ase_vertexTangentSign = v.ase_tangent.w * ( unity_WorldTransformParams.w >= 0.0 ? 1.0 : -1.0 );
				float3 ase_worldBitangent = cross( ase_worldNormal, ase_worldTangent ) * ase_vertexTangentSign;
				o.ase_texcoord7.xyz = ase_worldBitangent;
				
				o.ase_texcoord4.xy = v.texcoord0.xy;
				o.ase_color = v.ase_color;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord4.zw = 0;
				o.ase_texcoord5.w = 0;
				o.ase_texcoord6.w = 0;
				o.ase_texcoord7.w = 0;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = defaultVertexValue;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;

				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					o.worldPos = positionWS;
				#endif

				o.clipPos = MetaVertexPosition( v.vertex, v.texcoord1.xy, v.texcoord1.xy, unity_LightmapST, unity_DynamicLightmapST );

				#ifdef EDITOR_VISUALIZATION
					float2 VizUV = 0;
					float4 LightCoord = 0;
					UnityEditorVizData(v.vertex.xyz, v.texcoord0.xy, v.texcoord1.xy, v.texcoord2.xy, VizUV, LightCoord);
					o.VizUV = float4(VizUV, 0, 0);
					o.LightCoord = LightCoord;
				#endif

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					VertexPositionInputs vertexInput = (VertexPositionInputs)0;
					vertexInput.positionWS = positionWS;
					vertexInput.positionCS = o.clipPos;
					o.shadowCoord = GetShadowCoord( vertexInput );
				#endif

				return o;
			}

			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}

			half4 frag(VertexOutput IN  ) : SV_TARGET
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					float3 WorldPosition = IN.worldPos;
				#endif

				float4 ShadowCoords = float4( 0, 0, 0, 0 );

				#if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
						ShadowCoords = IN.shadowCoord;
					#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
						ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
					#endif
				#endif

				#ifdef GPU_DRIVEN_TEST
				float4 staticSwitch400 = BaseColor_GPU;
				#else
				float4 staticSwitch400 = _BaseColor;
				#endif
				float temp_output_417_0 = ( _TimeParameters.x * _Speed );
				float2 uv_BaseMap = IN.ase_texcoord4.xy * _BaseMap_ST.xy + _BaseMap_ST.zw;
				float2 appendResult421 = (float2(( temp_output_417_0 + uv_BaseMap.x ) , uv_BaseMap.y));
				float2 uv_BaseMapArray = IN.ase_texcoord4.xy;
				#ifdef GPU_DRIVEN_TEST
				float4 staticSwitch298 = SAMPLE_TEXTURE2D_ARRAY( _BaseMapArray, sampler_BaseMapArray, uv_BaseMapArray,AlbedoIndex );
				#else
				float4 staticSwitch298 = tex2D( _BaseMap, appendResult421 );
				#endif
				float4 temp_output_17_0 = ( staticSwitch400 * staticSwitch298 );
				float2 uv_DetailAlbedoMap = IN.ase_texcoord4.xy * _DetailAlbedoMap_ST.xy + _DetailAlbedoMap_ST.zw;
				float2 uv_DetailMask = IN.ase_texcoord4.xy * _DetailMask_ST.xy + _DetailMask_ST.zw;
				float saferPower32 = abs( ( tex2D( _DetailMask, uv_DetailMask ).g * ( ( _VertexColChannel.x * IN.ase_color.r ) + ( _VertexColChannel.y * IN.ase_color.g ) + ( _VertexColChannel.z * IN.ase_color.b ) + ( _VertexColChannel.w * IN.ase_color.a ) ) * _BlendFactor ) );
				float HeightMask64 = saturate( pow( saferPower32 , _BlendFalloff ) );
				float4 lerpResult26 = lerp( temp_output_17_0 , ( tex2D( _DetailAlbedoMap, uv_DetailAlbedoMap ) * _DetailColor ) , HeightMask64);
				#ifdef _DETAIL_ON
				float4 staticSwitch25 = lerpResult26;
				#else
				float4 staticSwitch25 = temp_output_17_0;
				#endif
				float3 BaseAlbedo68 = (staticSwitch25).rgb;
				float2 uv_VTMap = IN.ase_texcoord4.xy * _VTMap_ST.xy + _VTMap_ST.zw;
				float2 uv_BumpMap = IN.ase_texcoord4.xy * _BumpMap_ST.xy + _BumpMap_ST.zw;
				float2 appendResult431 = (float2(( temp_output_417_0 + uv_BumpMap.x ) , uv_BumpMap.y));
				float2 uv_BumpMapArray = IN.ase_texcoord4.xy;
				#ifdef GPU_DRIVEN_TEST
				float4 staticSwitch321 = SAMPLE_TEXTURE2D_ARRAY( _BumpMapArray, sampler_BumpMapArray, uv_BumpMapArray,NormalIndex );
				#else
				float4 staticSwitch321 = tex2D( _BumpMap, appendResult431 );
				#endif
				float4 break339 = staticSwitch321;
				float2 appendResult189 = (float2(break339.r , break339.g));
				float2 temp_output_1_0_g2 = (float2( -1,-1 ) + (appendResult189 - float2( 0,0 )) * (float2( 1,1 ) - float2( -1,-1 )) / (float2( 1,1 ) - float2( 0,0 )));
				float dotResult4_g2 = dot( temp_output_1_0_g2 , temp_output_1_0_g2 );
				float3 appendResult10_g2 = (float3((temp_output_1_0_g2).x , (temp_output_1_0_g2).y , sqrt( ( 1.0 - saturate( dotResult4_g2 ) ) )));
				float3 normalizeResult12_g2 = normalize( appendResult10_g2 );
				float3 In263 = normalizeResult12_g2;
				#ifdef GPU_DRIVEN_TEST
				float staticSwitch403 = BumpScale_GPU;
				#else
				float staticSwitch403 = _BumpScale;
				#endif
				float Strength263 = staticSwitch403;
				float3 localNormalStrength263 = NormalStrength263( In263 , Strength263 );
				float2 uv_DetailNormalMap = IN.ase_texcoord4.xy * _DetailNormalMap_ST.xy + _DetailNormalMap_ST.zw;
				float4 tex2DNode190 = tex2D( _DetailNormalMap, uv_DetailNormalMap );
				float2 appendResult191 = (float2(tex2DNode190.r , tex2DNode190.g));
				float2 temp_output_1_0_g17 = (float2( -1,-1 ) + (appendResult191 - float2( 0,0 )) * (float2( 1,1 ) - float2( -1,-1 )) / (float2( 1,1 ) - float2( 0,0 )));
				float dotResult4_g17 = dot( temp_output_1_0_g17 , temp_output_1_0_g17 );
				float3 appendResult10_g17 = (float3((temp_output_1_0_g17).x , (temp_output_1_0_g17).y , sqrt( ( 1.0 - saturate( dotResult4_g17 ) ) )));
				float3 normalizeResult12_g17 = normalize( appendResult10_g17 );
				float3 In268 = normalizeResult12_g17;
				float Strength268 = _DetailNormalScale;
				float3 localNormalStrength268 = NormalStrength268( In268 , Strength268 );
				float3 lerpResult149 = lerp( localNormalStrength263 , localNormalStrength268 , HeightMask64);
				#ifdef _DETAIL_ON
				float3 staticSwitch79 = lerpResult149;
				#else
				float3 staticSwitch79 = localNormalStrength263;
				#endif
				float3 BaseNormal59 = staticSwitch79;
				float3 ase_worldTangent = IN.ase_texcoord5.xyz;
				float3 ase_worldNormal = IN.ase_texcoord6.xyz;
				float3 ase_worldBitangent = IN.ase_texcoord7.xyz;
				float3 tanToWorld0 = float3( ase_worldTangent.x, ase_worldBitangent.x, ase_worldNormal.x );
				float3 tanToWorld1 = float3( ase_worldTangent.y, ase_worldBitangent.y, ase_worldNormal.y );
				float3 tanToWorld2 = float3( ase_worldTangent.z, ase_worldBitangent.z, ase_worldNormal.z );
				float3 tanNormal38 = BaseNormal59;
				float3 worldNormal38 = normalize( float3(dot(tanToWorld0,tanNormal38), dot(tanToWorld1,tanNormal38), dot(tanToWorld2,tanNormal38)) );
				float dotResult39 = dot( float4( worldNormal38 , 0.0 ) , float4(0,1,0,0) );
				float saferPower53 = abs( ( _ParticleLayer_BlendFactor * saturate( dotResult39 ) ) );
				float ParticalLayerMask71 = saturate( pow( saferPower53 , _ParticleLayer_BlendFalloff ) );
				float3 lerpResult42 = lerp( BaseAlbedo68 , (( _VTColor * tex2D( _VTMap, uv_VTMap ) )).rgb , ParticalLayerMask71);
				#ifdef _VT_ON
				float3 staticSwitch41 = lerpResult42;
				#else
				float3 staticSwitch41 = BaseAlbedo68;
				#endif
				float3 SurfaceAlbedo393 = staticSwitch41;
				
				float2 uv_EmissionMap = IN.ase_texcoord4.xy * _EmissionMap_ST.xy + _EmissionMap_ST.zw;
				float4 AbedoMap357 = staticSwitch298;
				float clampResult309 = clamp( abs( sin( ( ( _TimeParameters.x ) * _HighLightSpeed ) ) ) , 0.0 , _HighLightRate );
				float3 SurfaceEmission94 = (( ( tex2D( _EmissionMap, uv_EmissionMap ) * _EmissionColor ) + ( _HighLightScale * _HighLightDarkScale * AbedoMap357 * _HighLightSwitch * ( ( clampResult309 * ( 1.0 / _HighLightRate ) ) + _StartIntensity ) ) )).rgb;
				
				#ifdef GPU_DRIVEN_TEST
				float staticSwitch411 = 1.0;
				#else
				float staticSwitch411 = _BaseColor.a;
				#endif
				float ColorAlpha224 = staticSwitch411;
				float BaseAlpha163 = (staticSwitch298).a;
				float2 appendResult207 = (float2(BaseAlpha163 , 1.0));
				#ifdef GPU_DRIVEN_TEST
				float staticSwitch409 = AO_GPU;
				#else
				float staticSwitch409 = _AmbientOcclusion;
				#endif
				float2 lerpResult210 = lerp( (appendResult207).xy , (appendResult207).yx , staticSwitch409);
				float2 break222 = lerpResult210;
				
				#ifdef GPU_DRIVEN_TEST
				float staticSwitch413 = AlphaCutoff_GPU;
				#else
				float staticSwitch413 = _AlphaCutoff;
				#endif
				

				float3 BaseColor = SurfaceAlbedo393;
				float3 Emission = SurfaceEmission94;
				float Alpha = ( ColorAlpha224 * break222.x );
				float AlphaClipThreshold = staticSwitch413;

				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				MetaInput metaInput = (MetaInput)0;
				metaInput.Albedo = BaseColor;
				metaInput.Emission = Emission;
				#ifdef EDITOR_VISUALIZATION
					metaInput.VizUV = IN.VizUV.xy;
					metaInput.LightCoord = IN.LightCoord;
				#endif

				return UnityMetaFragment(metaInput);
			}
			ENDHLSL
		}

		
		Pass
		{
			
			Name "DepthNormals"
			Tags { "LightMode"="DepthNormals" }

			ZWrite On
			Blend One Zero
			ZTest LEqual
			ZWrite On

			HLSLPROGRAM

			#define _NORMAL_DROPOFF_TS 1
			#pragma multi_compile_instancing
			#pragma multi_compile_fragment _ LOD_FADE_CROSSFADE
			#define ASE_FOG 1
			#define _EMISSION
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION -1


			#pragma vertex vert
			#pragma fragment frag

			#pragma multi_compile_fragment _ _WRITE_RENDERING_LAYERS

			#define SHADERPASS SHADERPASS_DEPTHNORMALSONLY

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"

			#define ASE_NEEDS_FRAG_COLOR
			#define ASE_NEEDS_FRAG_WORLD_TANGENT
			#define ASE_NEEDS_FRAG_WORLD_NORMAL
			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_VERT_TANGENT
			#pragma multi_compile __ _CRR_RENDERING
			#pragma shader_feature_local GPU_DRIVEN_TEST
			#pragma shader_feature_local _VT_ON
			#pragma shader_feature_local _DETAIL_ON


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_tangent : TANGENT;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					float3 worldPos : TEXCOORD0;
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					float4 shadowCoord : TEXCOORD1;
				#endif
				float3 worldNormal : TEXCOORD2;
				float4 worldTangent : TEXCOORD3;
				float4 ase_texcoord4 : TEXCOORD4;
				float4 ase_color : COLOR;
				float4 ase_texcoord5 : TEXCOORD5;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};


			sampler2D _BumpMap;
			TEXTURE2D_ARRAY(_BumpMapArray);
			SAMPLER(sampler_BumpMapArray);
			sampler2D _DetailNormalMap;
			sampler2D _DetailMask;
			sampler2D _BaseMap;
			TEXTURE2D_ARRAY(_BaseMapArray);
			SAMPLER(sampler_BaseMapArray);
			
			#ifdef UNITY_DOTS_INSTANCING_ENABLED
			UNITY_DOTS_INSTANCING_START(MaterialPropertyMetadata)
				UNITY_DOTS_INSTANCED_PROP(float, _DetailNormalScale)
			UNITY_DOTS_INSTANCING_END(MaterialPropertyMetadata)
			#define _DetailNormalScale UNITY_ACCESS_DOTS_INSTANCED_PROP_FROM_MACRO(float , Metadata__DetailNormalScale)
			#endif
			CBUFFER_START( UnityPerMaterial )
			float4 _DetailNormalMap_ST;
			float4 _BumpMapArray_ST;
			float4 _BumpMap_ST;
			float4 _VTMap_ST;
			float4 _EmissionMap_ST;
			float4 _VertexColChannel;
			float4 _DetailMask_ST;
			float4 _VTColor;
			float4 _DetailAlbedoMap_ST;
			float4 _BaseMapArray_ST;
			float4 _BaseMap_ST;
			float4 _BaseColor;
			float4 _DetailColor;
			float4 _EmissionColor;
			float _Smoothness;
			float _DetailMetallic;
			float _Metallic;
			float _DetailSmoothness;
			float _StartIntensity;
			float _HighLightRate;
			float _HighLightSpeed;
			float _HighLightSwitch;
			float _HighLightDarkScale;
			float _FogClose;
			float _VTBumpScale;
			float _ParticleLayer_BlendFalloff;
			float _DetailNormalScale;
			float _AmbientOcclusion;
			float _BumpScale;
			float _ParticleLayer_BlendFactor;
			float _BlendFalloff;
			float _BlendFactor;
			float _Speed;
			float _HighLightScale;
			float _AlphaCutoff;
			CBUFFER_END


			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthNormalsOnlyPass.hlsl"

			//#ifdef HAVE_VFX_MODIFICATION
			//#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
			//#endif

			float3 NormalStrength263( float3 In, float Strength )
			{
				float3 out1 = float3(In.xy * Strength, lerp(1, In.z, saturate(Strength))); 
				return out1;
			}
			
			float3 NormalStrength268( float3 In, float Strength )
			{
				float3 out1 = float3(In.xy * Strength, lerp(1, In.z, saturate(Strength))); 
				return out1;
			}
			
			float3 NormalStrength395( float3 In, float Strength )
			{
				float3 out1 = float3(In.xy * Strength, lerp(1, In.z, saturate(Strength))); 
				return out1;
			}
			

			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float3 ase_worldNormal = TransformObjectToWorldNormal(v.ase_normal);
				float3 ase_worldTangent = TransformObjectToWorldDir(v.ase_tangent.xyz);
				float ase_vertexTangentSign = v.ase_tangent.w * ( unity_WorldTransformParams.w >= 0.0 ? 1.0 : -1.0 );
				float3 ase_worldBitangent = cross( ase_worldNormal, ase_worldTangent ) * ase_vertexTangentSign;
				o.ase_texcoord5.xyz = ase_worldBitangent;
				
				o.ase_texcoord4.xy = v.ase_texcoord.xy;
				o.ase_color = v.ase_color;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord4.zw = 0;
				o.ase_texcoord5.w = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = defaultVertexValue;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;
				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );
				float3 normalWS = TransformObjectToWorldNormal( v.ase_normal );
				float4 tangentWS = float4(TransformObjectToWorldDir( v.ase_tangent.xyz), v.ase_tangent.w);
				float4 positionCS = TransformWorldToHClip( positionWS );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					o.worldPos = positionWS;
				#endif

				o.worldNormal = normalWS;
				o.worldTangent = tangentWS;

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					VertexPositionInputs vertexInput = (VertexPositionInputs)0;
					vertexInput.positionWS = positionWS;
					vertexInput.positionCS = positionCS;
					o.shadowCoord = GetShadowCoord( vertexInput );
				#endif

				o.clipPos = positionCS;

				return o;
			}


			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}


			#if defined(ASE_EARLY_Z_DEPTH_OPTIMIZE)
				#define ASE_SV_DEPTH SV_DepthLessEqual
			#else
				#define ASE_SV_DEPTH SV_Depth
			#endif

			void frag(	VertexOutput IN
						, out half4 outNormalWS : SV_Target0
						#ifdef ASE_DEPTH_WRITE_ON
						,out float outputDepth : ASE_SV_DEPTH
						#endif
						#ifdef _WRITE_RENDERING_LAYERS
						, out float4 outRenderingLayers : SV_Target1
						#endif
						 )
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					float3 WorldPosition = IN.worldPos;
				#endif

				float4 ShadowCoords = float4( 0, 0, 0, 0 );
				float3 WorldNormal = IN.worldNormal;
				float4 WorldTangent = IN.worldTangent;

				#if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
						ShadowCoords = IN.shadowCoord;
					#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
						ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
					#endif
				#endif

				float temp_output_417_0 = ( _TimeParameters.x * _Speed );
				float2 uv_BumpMap = IN.ase_texcoord4.xy * _BumpMap_ST.xy + _BumpMap_ST.zw;
				float2 appendResult431 = (float2(( temp_output_417_0 + uv_BumpMap.x ) , uv_BumpMap.y));
				float2 uv_BumpMapArray = IN.ase_texcoord4.xy;
				#ifdef GPU_DRIVEN_TEST
				float4 staticSwitch321 = SAMPLE_TEXTURE2D_ARRAY( _BumpMapArray, sampler_BumpMapArray, uv_BumpMapArray,NormalIndex );
				#else
				float4 staticSwitch321 = tex2D( _BumpMap, appendResult431 );
				#endif
				float4 break339 = staticSwitch321;
				float2 appendResult189 = (float2(break339.r , break339.g));
				float2 temp_output_1_0_g2 = (float2( -1,-1 ) + (appendResult189 - float2( 0,0 )) * (float2( 1,1 ) - float2( -1,-1 )) / (float2( 1,1 ) - float2( 0,0 )));
				float dotResult4_g2 = dot( temp_output_1_0_g2 , temp_output_1_0_g2 );
				float3 appendResult10_g2 = (float3((temp_output_1_0_g2).x , (temp_output_1_0_g2).y , sqrt( ( 1.0 - saturate( dotResult4_g2 ) ) )));
				float3 normalizeResult12_g2 = normalize( appendResult10_g2 );
				float3 In263 = normalizeResult12_g2;
				#ifdef GPU_DRIVEN_TEST
				float staticSwitch403 = BumpScale_GPU;
				#else
				float staticSwitch403 = _BumpScale;
				#endif
				float Strength263 = staticSwitch403;
				float3 localNormalStrength263 = NormalStrength263( In263 , Strength263 );
				float2 uv_DetailNormalMap = IN.ase_texcoord4.xy * _DetailNormalMap_ST.xy + _DetailNormalMap_ST.zw;
				float4 tex2DNode190 = tex2D( _DetailNormalMap, uv_DetailNormalMap );
				float2 appendResult191 = (float2(tex2DNode190.r , tex2DNode190.g));
				float2 temp_output_1_0_g17 = (float2( -1,-1 ) + (appendResult191 - float2( 0,0 )) * (float2( 1,1 ) - float2( -1,-1 )) / (float2( 1,1 ) - float2( 0,0 )));
				float dotResult4_g17 = dot( temp_output_1_0_g17 , temp_output_1_0_g17 );
				float3 appendResult10_g17 = (float3((temp_output_1_0_g17).x , (temp_output_1_0_g17).y , sqrt( ( 1.0 - saturate( dotResult4_g17 ) ) )));
				float3 normalizeResult12_g17 = normalize( appendResult10_g17 );
				float3 In268 = normalizeResult12_g17;
				float Strength268 = _DetailNormalScale;
				float3 localNormalStrength268 = NormalStrength268( In268 , Strength268 );
				float2 uv_DetailMask = IN.ase_texcoord4.xy * _DetailMask_ST.xy + _DetailMask_ST.zw;
				float saferPower32 = abs( ( tex2D( _DetailMask, uv_DetailMask ).g * ( ( _VertexColChannel.x * IN.ase_color.r ) + ( _VertexColChannel.y * IN.ase_color.g ) + ( _VertexColChannel.z * IN.ase_color.b ) + ( _VertexColChannel.w * IN.ase_color.a ) ) * _BlendFactor ) );
				float HeightMask64 = saturate( pow( saferPower32 , _BlendFalloff ) );
				float3 lerpResult149 = lerp( localNormalStrength263 , localNormalStrength268 , HeightMask64);
				#ifdef _DETAIL_ON
				float3 staticSwitch79 = lerpResult149;
				#else
				float3 staticSwitch79 = localNormalStrength263;
				#endif
				float3 BaseNormal59 = staticSwitch79;
				float3 In395 = BaseNormal59;
				float Strength395 = _VTBumpScale;
				float3 localNormalStrength395 = NormalStrength395( In395 , Strength395 );
				float3 ase_worldBitangent = IN.ase_texcoord5.xyz;
				float3 tanToWorld0 = float3( WorldTangent.xyz.x, ase_worldBitangent.x, WorldNormal.x );
				float3 tanToWorld1 = float3( WorldTangent.xyz.y, ase_worldBitangent.y, WorldNormal.y );
				float3 tanToWorld2 = float3( WorldTangent.xyz.z, ase_worldBitangent.z, WorldNormal.z );
				float3 tanNormal38 = BaseNormal59;
				float3 worldNormal38 = normalize( float3(dot(tanToWorld0,tanNormal38), dot(tanToWorld1,tanNormal38), dot(tanToWorld2,tanNormal38)) );
				float dotResult39 = dot( float4( worldNormal38 , 0.0 ) , float4(0,1,0,0) );
				float saferPower53 = abs( ( _ParticleLayer_BlendFactor * saturate( dotResult39 ) ) );
				float ParticalLayerMask71 = saturate( pow( saferPower53 , _ParticleLayer_BlendFalloff ) );
				float3 lerpResult44 = lerp( BaseNormal59 , localNormalStrength395 , ParticalLayerMask71);
				#ifdef _VT_ON
				float3 staticSwitch46 = lerpResult44;
				#else
				float3 staticSwitch46 = BaseNormal59;
				#endif
				float3 SurfaceNormal394 = staticSwitch46;
				
				#ifdef GPU_DRIVEN_TEST
				float staticSwitch411 = 1.0;
				#else
				float staticSwitch411 = _BaseColor.a;
				#endif
				float ColorAlpha224 = staticSwitch411;
				float2 uv_BaseMap = IN.ase_texcoord4.xy * _BaseMap_ST.xy + _BaseMap_ST.zw;
				float2 appendResult421 = (float2(( temp_output_417_0 + uv_BaseMap.x ) , uv_BaseMap.y));
				float2 uv_BaseMapArray = IN.ase_texcoord4.xy;
				#ifdef GPU_DRIVEN_TEST
				float4 staticSwitch298 = SAMPLE_TEXTURE2D_ARRAY( _BaseMapArray, sampler_BaseMapArray, uv_BaseMapArray,AlbedoIndex );
				#else
				float4 staticSwitch298 = tex2D( _BaseMap, appendResult421 );
				#endif
				float BaseAlpha163 = (staticSwitch298).a;
				float2 appendResult207 = (float2(BaseAlpha163 , 1.0));
				#ifdef GPU_DRIVEN_TEST
				float staticSwitch409 = AO_GPU;
				#else
				float staticSwitch409 = _AmbientOcclusion;
				#endif
				float2 lerpResult210 = lerp( (appendResult207).xy , (appendResult207).yx , staticSwitch409);
				float2 break222 = lerpResult210;
				
				#ifdef GPU_DRIVEN_TEST
				float staticSwitch413 = AlphaCutoff_GPU;
				#else
				float staticSwitch413 = _AlphaCutoff;
				#endif
				

				float3 Normal = SurfaceNormal394;
				float Alpha = ( ColorAlpha224 * break222.x );
				float AlphaClipThreshold = staticSwitch413;
				#ifdef ASE_DEPTH_WRITE_ON
					float DepthValue = 0;
				#endif

				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				#ifdef LOD_FADE_CROSSFADE
					LODFadeCrossFade( IN.clipPos );
				#endif

				#ifdef ASE_DEPTH_WRITE_ON
					outputDepth = DepthValue;
				#endif

				#if defined(_GBUFFER_NORMALS_OCT)
					float2 octNormalWS = PackNormalOctQuadEncode(WorldNormal);
					float2 remappedOctNormalWS = saturate(octNormalWS * 0.5 + 0.5);
					half3 packedNormalWS = PackFloat2To888(remappedOctNormalWS);
					outNormalWS = half4(packedNormalWS, 0.0);
				#else
					#if defined(_NORMALMAP)
						#if _NORMAL_DROPOFF_TS
							float crossSign = (WorldTangent.w > 0.0 ? 1.0 : -1.0) * GetOddNegativeScale();
							float3 bitangent = crossSign * cross(WorldNormal.xyz, WorldTangent.xyz);
							float3 normalWS = TransformTangentToWorld(Normal, half3x3(WorldTangent.xyz, bitangent, WorldNormal.xyz));
						#elif _NORMAL_DROPOFF_OS
							float3 normalWS = TransformObjectToWorldNormal(Normal);
						#elif _NORMAL_DROPOFF_WS
							float3 normalWS = Normal;
						#endif
					#else
						float3 normalWS = WorldNormal;
					#endif
					outNormalWS = half4(NormalizeNormalPerPixel(normalWS), 0.0);
				#endif

				#ifdef _WRITE_RENDERING_LAYERS
					uint renderingLayers = GetMeshRenderingLayer();
					outRenderingLayers = float4( EncodeMeshRenderingLayer( renderingLayers ), 0, 0, 0 );
				#endif
			}
			ENDHLSL
		}
		
		
		Pass
		{
			
			Name "GBuffer"
			Tags { "LightMode"="UniversalGBuffer" }

			Stencil
			{
				Ref 32 //32 = PBR Lit , 64 = Simple  Lit  0 = Unlit
				Comp Always
				Pass Replace
				//PassBack Replace
				ReadMask 0
				WriteMask 96
			}//角色相关shader需要删除这一段Stencil处理

			Blend One Zero
			ZWrite On
			ZTest LEqual
			Offset 0 , 0
			ColorMask RGBA
			Cull[_Cull]
			///////*ase_stencil*/

			HLSLPROGRAM

			#define _NORMAL_DROPOFF_TS 1
			#pragma multi_compile_instancing
			#pragma instancing_options renderinglayer
			#pragma multi_compile_fragment _ LOD_FADE_CROSSFADE
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#define _EMISSION
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION -1


			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
			#pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
			#pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
			#pragma multi_compile_fragment _ _SHADOWS_SOFT
			#pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
			#pragma multi_compile_fragment _ _RENDER_PASS_ENABLED
			#pragma shader_feature_local _RECEIVE_SHADOWS_OFF
			#pragma shader_feature_local_fragment _SPECULARHIGHLIGHTS_OFF
			#pragma shader_feature_local_fragment _ENVIRONMENTREFLECTIONS_OFF

			#pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
			#pragma multi_compile _ SHADOWS_SHADOWMASK
			#pragma multi_compile _ DIRLIGHTMAP_COMBINED
			#pragma multi_compile _ LIGHTMAP_ON
			#pragma multi_compile _ DYNAMICLIGHTMAP_ON
			#pragma multi_compile_fragment _ _GBUFFER_NORMALS_OCT
			#pragma multi_compile_fragment _ _WRITE_RENDERING_LAYERS
			#pragma shader_feature_local_fragment _ALPHATEST_ON

			#pragma shader_feature MODIFY_VERTEX_POSTION_USEING_SPLINE

			#pragma vertex vert
			#pragma fragment frag

			#define SHADERPASS SHADERPASS_GBUFFER

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Shaders/Soc/ComputeShaders/GPUStaticSceneBuild.hlsl"
			
			#if defined(UNITY_INSTANCING_ENABLED) && defined(_TERRAIN_INSTANCED_PERPIXEL_NORMAL)
				#define ENABLE_TERRAIN_PERPIXEL_NORMAL
			#endif

			#if defined(MODIFY_VERTEX_POSTION_USEING_SPLINE)
			StructuredBuffer<int> indecesBuffer;
			StructuredBuffer<float> railPropsBuffer;
			#endif


			#define ASE_NEEDS_FRAG_COLOR
			#define ASE_NEEDS_FRAG_WORLD_TANGENT
			#define ASE_NEEDS_FRAG_WORLD_NORMAL
			#define ASE_NEEDS_FRAG_WORLD_BITANGENT
			#pragma multi_compile __ _CRR_RENDERING
			#pragma shader_feature_local GPU_DRIVEN_TEST
			#pragma shader_feature_local _VT_ON
			#pragma shader_feature_local _DETAIL_ON


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_tangent : TANGENT;
				float4 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				uint instanceid : SV_InstanceID;
				float4 ase_color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				float4 lightmapUVOrVertexSH : TEXCOORD0;
				half4 fogFactorAndVertexLight : TEXCOORD1;
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
				float4 shadowCoord : TEXCOORD2;
				#endif
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
				#if defined(ASE_NEEDS_FRAG_SCREEN_POSITION)
				float4 screenPos : TEXCOORD6;
				#endif
				#if defined(DYNAMICLIGHTMAP_ON)
				float2 dynamicLightmapUV : TEXCOORD7;
				#endif
				float4 ase_texcoord8 : TEXCOORD8;
				float4 ase_color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};


			sampler2D _BaseMap;
			TEXTURE2D_ARRAY(_BaseMapArray);
			SAMPLER(sampler_BaseMapArray);
			sampler2D _DetailAlbedoMap;
			sampler2D _DetailMask;
			sampler2D _VTMap;
			sampler2D _BumpMap;
			TEXTURE2D_ARRAY(_BumpMapArray);
			SAMPLER(sampler_BumpMapArray);
			sampler2D _DetailNormalMap;
			sampler2D _EmissionMap;
			
			#ifdef UNITY_DOTS_INSTANCING_ENABLED
			UNITY_DOTS_INSTANCING_START(MaterialPropertyMetadata)
				UNITY_DOTS_INSTANCED_PROP(float, _DetailNormalScale)
			UNITY_DOTS_INSTANCING_END(MaterialPropertyMetadata)
			#define _DetailNormalScale UNITY_ACCESS_DOTS_INSTANCED_PROP_FROM_MACRO(float , Metadata__DetailNormalScale)
			#endif
			CBUFFER_START( UnityPerMaterial )
			float4 _DetailNormalMap_ST;
			float4 _BumpMapArray_ST;
			float4 _BumpMap_ST;
			float4 _VTMap_ST;
			float4 _EmissionMap_ST;
			float4 _VertexColChannel;
			float4 _DetailMask_ST;
			float4 _VTColor;
			float4 _DetailAlbedoMap_ST;
			float4 _BaseMapArray_ST;
			float4 _BaseMap_ST;
			float4 _BaseColor;
			float4 _DetailColor;
			float4 _EmissionColor;
			float _Smoothness;
			float _DetailMetallic;
			float _Metallic;
			float _DetailSmoothness;
			float _StartIntensity;
			float _HighLightRate;
			float _HighLightSpeed;
			float _HighLightSwitch;
			float _HighLightDarkScale;
			float _FogClose;
			float _VTBumpScale;
			float _ParticleLayer_BlendFalloff;
			float _DetailNormalScale;
			float _AmbientOcclusion;
			float _BumpScale;
			float _ParticleLayer_BlendFactor;
			float _BlendFalloff;
			float _BlendFactor;
			float _Speed;
			float _HighLightScale;
			float _AlphaCutoff;
			CBUFFER_END


			
			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/UnityGBuffer.hlsl"
			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRGBufferPass.hlsl"

			float3 NormalStrength263( float3 In, float Strength )
			{
				float3 out1 = float3(In.xy * Strength, lerp(1, In.z, saturate(Strength))); 
				return out1;
			}
			
			float3 NormalStrength268( float3 In, float Strength )
			{
				float3 out1 = float3(In.xy * Strength, lerp(1, In.z, saturate(Strength))); 
				return out1;
			}
			
			float3 NormalStrength395( float3 In, float Strength )
			{
				float3 out1 = float3(In.xy * Strength, lerp(1, In.z, saturate(Strength))); 
				return out1;
			}
			

			//_CRR_RENDERING
			#if defined(_CRR_RENDERING)
				float4x4 modelMatrix;
			#endif

			#if defined(_CRR_RENDERING)
				inline float3 CRR_GetViewPosition(float4 positionRS)
				{
    				return float3(dot(positionRS,UNITY_MATRIX_V[0].xyz),dot(positionRS,UNITY_MATRIX_V[1].xyz),dot(positionRS,UNITY_MATRIX_V[2].xyz));
				}
			#endif	

#if defined(GPU_DRIVEN_TEST)
			VertexOutput VertexFunction(uint VertexID)
#else
			VertexOutput VertexFunction( VertexInput v  )
#endif
			{
				VertexOutput o = (VertexOutput)0;
	#if defined(GPU_DRIVEN_TEST)

	#else
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
	#endif
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

#if defined(GPU_DRIVEN_TEST)
				uint vertexIndex = GET_PACKED_LO(VertexID, BATCH_VERT_INDEX_MASK);
				uint instIndex = GET_PACKED_HI(VertexID, BATCH_VERT_INDEX_BITS);

				// FIXME 读取的buffer多，考虑将结果数据比如偏移、entityIndex写入一个新的buffer，将三个buffer的读取缩减为一个。
				ProceduralInstanceIndex pii = ProceduralInstanceIndicesRO[instIndex];
				GPUDynamicInstance CurrentInstance = StaticInstancesDynamicBufferRO[pii.instIndex];
				GPUMeshDescriptor meshDesc = MeshDescriptorBuffer[CurrentInstance.meshDescIndex];
				vertexIndex += meshDesc.baseVertex;
				ProceduralVertex CurrentVertex = ProceduralVertexBuffer[vertexIndex];
				GPUStaticEntity CurrentEntity = StaticEntityBuffer[CurrentInstance.entityIndex];

				float4x4 TRSMatrix = float4x4(CurrentEntity.trsRow0,
					CurrentEntity.trsRow1,
					CurrentEntity.trsRow2,
					float4(0, 0, 0, 1));


				o.ase_texcoord8.xy = CurrentVertex.uv01.xy;
				o.ase_texcoord8.zw = CurrentVertex.uv01.zw;
				o.ase_texcoord8.w = GET_LOWORD_16(CurrentInstance.matParamsIndexNBatchIndex) / 255.0;
				o.ase_color = CurrentVertex.color;
#else
				o.ase_texcoord8.xy = v.texcoord.xy;
				o.ase_color = v.ase_color;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord8.zw = 0;
#endif

#if defined(GPU_DRIVEN_TEST)
#else
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = defaultVertexValue;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;
#endif
#if defined(GPU_DRIVEN_TEST)
				unity_ObjectToWorld = TRSMatrix;
				float3 positionWS = TransformObjectToWorld(CurrentVertex.position);
#else
#if defined(MODIFY_VERTEX_POSTION_USEING_SPLINE)

				int curRailOffset = indecesBuffer[v.instanceid] * 33;

				float splineStepSize = railPropsBuffer[curRailOffset + 30];
				float startDistance = railPropsBuffer[curRailOffset + 31];
				float endDistance = railPropsBuffer[curRailOffset + 32];

				float nZ = v.vertex.z / 18;
				float df = lerp(startDistance, endDistance, v.vertex.z / 18);
				int di = max(floor(df), floor(startDistance));
				int startIndex = max((di - floor(startDistance)), 0) * 3 + curRailOffset;

				float t = df - di;
				float t2 = t * t;
				float t3 = t * t2;

				float3 p0 = float3(railPropsBuffer[startIndex], railPropsBuffer[startIndex + 1], railPropsBuffer[startIndex + 2]);
				float3 p1 = float3(railPropsBuffer[startIndex + 3], railPropsBuffer[startIndex + 4], railPropsBuffer[startIndex + 5]);
				float3 tan0 = float3(railPropsBuffer[startIndex + 15], railPropsBuffer[startIndex + 16], railPropsBuffer[startIndex + 17]);
				float3 tan1 = float3(railPropsBuffer[startIndex + 18], railPropsBuffer[startIndex + 19], railPropsBuffer[startIndex + 20]);
				float3 m0 = splineStepSize * tan0;
				float3 m1 = splineStepSize * tan1;
				float3 posWS = (2 * t3 - 3 * t2 + 1) * p0 + (t3 - 2 * t2 + t) * m0 + (-2 * t3 + 3 * t2) * p1 + (t3 - t2) * m1;

				//float3 splineDir = normalize(lerp(tan0, tan1, t));
				float3 pathForward = normalize(lerp(tan0, tan1, t));
				pathForward.y = 0;
				pathForward = normalize(pathForward);
				float3 pathSide = normalize(lerp(tan0, tan1, t)).zyx;
				pathSide.x = -pathSide.x;
				pathSide.y = 0;
				pathSide = normalize(pathSide);

				posWS -= pathSide * v.vertex.x;
				posWS.y += v.vertex.y;

				float3 positionWS = posWS;


#else
				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );
#endif
#endif
				float3 positionVS = TransformWorldToView( positionWS );
				float4 positionCS = TransformWorldToHClip( positionWS );

#if defined(GPU_DRIVEN_TEST)
				//VertexNormalInputs normalInput = GetVertexNormalInputs(CurrentVertex.normal, CurrentVertex.tangent);
				real sign = CurrentVertex.tangent.w * GetOddNegativeScale();
				float3 normalWS = TransformObjectToWorldDir(CurrentVertex.normal.xyz);
				float3 tangentWS = TransformObjectToWorldDir(CurrentVertex.tangent.xyz);
				float3 bittangentWS = cross(normalWS, tangentWS) * sign;
				VertexNormalInputs normalInput = (VertexNormalInputs)0;
				normalInput.normalWS = normalWS;
				normalInput.tangentWS = tangentWS;
				normalInput.bitangentWS = bittangentWS;;
#else
				#if defined(_CRR_RENDERING)
    				float4 positionRS = mul(modelMatrix, float4(v.vertex.xyz, 1));
    				positionWS = positionRS.xyz + _WorldSpaceCameraPos;
    				positionVS = CRR_GetViewPosition(positionRS);
    				positionCS = mul(UNITY_MATRIX_P,float4(positionVS,1));
				#endif	

				VertexNormalInputs normalInput = GetVertexNormalInputs( v.ase_normal, v.ase_tangent );
#endif
				o.tSpace0 = float4( normalInput.normalWS, positionWS.x);
				o.tSpace1 = float4( normalInput.tangentWS, positionWS.y);
				o.tSpace2 = float4( normalInput.bitangentWS, positionWS.z);
#if defined(GPU_DRIVEN_TEST)
#else
				#if defined(LIGHTMAP_ON)
					OUTPUT_LIGHTMAP_UV(v.texcoord1, unity_LightmapST, o.lightmapUVOrVertexSH.xy);
				#endif

				#if defined(DYNAMICLIGHTMAP_ON)
					o.dynamicLightmapUV.xy = v.texcoord2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
				#endif

				#if !defined(LIGHTMAP_ON)
					OUTPUT_SH(normalInput.normalWS.xyz, o.lightmapUVOrVertexSH.xyz);
				#endif

				#if defined(ENABLE_TERRAIN_PERPIXEL_NORMAL)
					o.lightmapUVOrVertexSH.zw = v.texcoord;
					o.lightmapUVOrVertexSH.xy = v.texcoord * unity_LightmapST.xy + unity_LightmapST.zw;
				#endif
#endif
				half3 vertexLight = VertexLighting( positionWS, normalInput.normalWS );

				o.fogFactorAndVertexLight = half4(0, vertexLight);

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
					VertexPositionInputs vertexInput = (VertexPositionInputs)0;
					vertexInput.positionWS = positionWS;
					vertexInput.positionCS = positionCS;
					o.shadowCoord = GetShadowCoord( vertexInput );
				#endif

					o.clipPos = positionCS;

				#if defined(ASE_NEEDS_FRAG_SCREEN_POSITION)
					o.screenPos = ComputeScreenPos(positionCS);
				#endif

				return o;
			}

#if defined(GPU_DRIVEN_TEST)
			VertexOutput vert(uint vertexID : SV_VertexID)
			{
				return VertexFunction(vertexID);
			}
#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
#endif

			#if defined(ASE_EARLY_Z_DEPTH_OPTIMIZE)
				#define ASE_SV_DEPTH SV_DepthLessEqual
			#else
				#define ASE_SV_DEPTH SV_Depth
			#endif

			FragmentOutput frag ( VertexOutput IN
								#ifdef ASE_DEPTH_WRITE_ON
								,out float outputDepth : ASE_SV_DEPTH
								#endif
								 )
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(IN);

#if defined(GPU_DRIVEN_TEST)
				int MaterialParamsIndex = round(IN.ase_texcoord8.w * 255.0);
				GPUMaterialParams CurrentParams = MaterialParamsBuffer[MaterialParamsIndex];

				float AO_GPU = CurrentParams.AOACBS.x;
				float AlphaCutoff_GPU = CurrentParams.AOACBS.y;
				float BumpScale_GPU = CurrentParams.AOACBS.z;

				float4 BaseColor_GPU = float4(0, 0, 0, 0);
				BaseColor_GPU.xyz = CurrentParams.baseColor.xyz;
				float Smoothness_GPU = CurrentParams.baseColor.w;

				float4 EmissionColor_GPU = float4(0, 0, 0, 0);
				EmissionColor_GPU.xyz = CurrentParams.emissionColor.xyz;
				float Metallic_GPU = CurrentParams.emissionColor.w;

				float AlbedoIndex = CurrentParams.texArrIndices.x;
				float NormalIndex = CurrentParams.texArrIndices.y;
				float EmissionIndex = CurrentParams.texArrIndices.z;
#endif

				#ifdef LOD_FADE_CROSSFADE
					LODFadeCrossFade( IN.clipPos );
				#endif

				#if defined(ENABLE_TERRAIN_PERPIXEL_NORMAL)
					float2 sampleCoords = (IN.lightmapUVOrVertexSH.zw / _TerrainHeightmapRecipSize.zw + 0.5f) * _TerrainHeightmapRecipSize.xy;
					float3 WorldNormal = TransformObjectToWorldNormal(normalize(SAMPLE_TEXTURE2D(_TerrainNormalmapTexture, sampler_TerrainNormalmapTexture, sampleCoords).rgb * 2 - 1));
					float3 WorldTangent = -cross(GetObjectToWorldMatrix()._13_23_33, WorldNormal);
					float3 WorldBiTangent = cross(WorldNormal, -WorldTangent);
				#else
#if defined(GPU_DRIVEN_TEST)
					float3 WorldNormal = normalize(IN.tSpace0.xyz);
					float3 WorldTangent = IN.tSpace1.xyz;
					float3 WorldBiTangent = IN.tSpace2.xyz;
#else
					float3 WorldNormal = normalize( IN.tSpace0.xyz );
					float3 WorldTangent = IN.tSpace1.xyz;
					float3 WorldBiTangent = IN.tSpace2.xyz;
#endif
				#endif

				float3 WorldPosition = float3(IN.tSpace0.w,IN.tSpace1.w,IN.tSpace2.w);
				float3 WorldViewDirection = GetWorldSpaceNormalizeViewDir(WorldPosition);
				float4 ShadowCoords = float4( 0, 0, 0, 0 );

				#if defined(ASE_NEEDS_FRAG_SCREEN_POSITION)
					float4 ScreenPos = IN.screenPos;
				#endif

				float2 NormalizedScreenSpaceUV = GetNormalizedScreenSpaceUV(IN.clipPos);

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
					ShadowCoords = IN.shadowCoord;
				#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
					ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
				#else
					ShadowCoords = float4(0, 0, 0, 0);
				#endif

				#ifdef GPU_DRIVEN_TEST
				float4 staticSwitch400 = BaseColor_GPU;
				#else
				float4 staticSwitch400 = _BaseColor;
				#endif
				float temp_output_417_0 = ( _TimeParameters.x * _Speed );
				float2 uv_BaseMap = IN.ase_texcoord8.xy * _BaseMap_ST.xy + _BaseMap_ST.zw;
				float2 appendResult421 = (float2(( temp_output_417_0 + uv_BaseMap.x ) , uv_BaseMap.y));
				float2 uv_BaseMapArray = IN.ase_texcoord8.xy;
				#ifdef GPU_DRIVEN_TEST
				float4 staticSwitch298 = SAMPLE_TEXTURE2D_ARRAY( _BaseMapArray, sampler_BaseMapArray, uv_BaseMapArray,AlbedoIndex );
				#else
				float4 staticSwitch298 = tex2D( _BaseMap, appendResult421 );
				#endif
				float4 temp_output_17_0 = ( staticSwitch400 * staticSwitch298 );
				float2 uv_DetailAlbedoMap = IN.ase_texcoord8.xy * _DetailAlbedoMap_ST.xy + _DetailAlbedoMap_ST.zw;
				float2 uv_DetailMask = IN.ase_texcoord8.xy * _DetailMask_ST.xy + _DetailMask_ST.zw;
				float saferPower32 = abs( ( tex2D( _DetailMask, uv_DetailMask ).g * ( ( _VertexColChannel.x * IN.ase_color.r ) + ( _VertexColChannel.y * IN.ase_color.g ) + ( _VertexColChannel.z * IN.ase_color.b ) + ( _VertexColChannel.w * IN.ase_color.a ) ) * _BlendFactor ) );
				float HeightMask64 = saturate( pow( saferPower32 , _BlendFalloff ) );
				float4 lerpResult26 = lerp( temp_output_17_0 , ( tex2D( _DetailAlbedoMap, uv_DetailAlbedoMap ) * _DetailColor ) , HeightMask64);
				#ifdef _DETAIL_ON
				float4 staticSwitch25 = lerpResult26;
				#else
				float4 staticSwitch25 = temp_output_17_0;
				#endif
				float3 BaseAlbedo68 = (staticSwitch25).rgb;
				float2 uv_VTMap = IN.ase_texcoord8.xy * _VTMap_ST.xy + _VTMap_ST.zw;
				float2 uv_BumpMap = IN.ase_texcoord8.xy * _BumpMap_ST.xy + _BumpMap_ST.zw;
				float2 appendResult431 = (float2(( temp_output_417_0 + uv_BumpMap.x ) , uv_BumpMap.y));
				float2 uv_BumpMapArray = IN.ase_texcoord8.xy;
				#ifdef GPU_DRIVEN_TEST
				float4 staticSwitch321 = SAMPLE_TEXTURE2D_ARRAY( _BumpMapArray, sampler_BumpMapArray, uv_BumpMapArray,NormalIndex );
				#else
				float4 staticSwitch321 = tex2D( _BumpMap, appendResult431 );
				#endif
				float4 break339 = staticSwitch321;
				float2 appendResult189 = (float2(break339.r , break339.g));
				float2 temp_output_1_0_g2 = (float2( -1,-1 ) + (appendResult189 - float2( 0,0 )) * (float2( 1,1 ) - float2( -1,-1 )) / (float2( 1,1 ) - float2( 0,0 )));
				float dotResult4_g2 = dot( temp_output_1_0_g2 , temp_output_1_0_g2 );
				float3 appendResult10_g2 = (float3((temp_output_1_0_g2).x , (temp_output_1_0_g2).y , sqrt( ( 1.0 - saturate( dotResult4_g2 ) ) )));
				float3 normalizeResult12_g2 = normalize( appendResult10_g2 );
				float3 In263 = normalizeResult12_g2;
				#ifdef GPU_DRIVEN_TEST
				float staticSwitch403 = BumpScale_GPU;
				#else
				float staticSwitch403 = _BumpScale;
				#endif
				float Strength263 = staticSwitch403;
				float3 localNormalStrength263 = NormalStrength263( In263 , Strength263 );
				float2 uv_DetailNormalMap = IN.ase_texcoord8.xy * _DetailNormalMap_ST.xy + _DetailNormalMap_ST.zw;
				float4 tex2DNode190 = tex2D( _DetailNormalMap, uv_DetailNormalMap );
				float2 appendResult191 = (float2(tex2DNode190.r , tex2DNode190.g));
				float2 temp_output_1_0_g17 = (float2( -1,-1 ) + (appendResult191 - float2( 0,0 )) * (float2( 1,1 ) - float2( -1,-1 )) / (float2( 1,1 ) - float2( 0,0 )));
				float dotResult4_g17 = dot( temp_output_1_0_g17 , temp_output_1_0_g17 );
				float3 appendResult10_g17 = (float3((temp_output_1_0_g17).x , (temp_output_1_0_g17).y , sqrt( ( 1.0 - saturate( dotResult4_g17 ) ) )));
				float3 normalizeResult12_g17 = normalize( appendResult10_g17 );
				float3 In268 = normalizeResult12_g17;
				float Strength268 = _DetailNormalScale;
				float3 localNormalStrength268 = NormalStrength268( In268 , Strength268 );
				float3 lerpResult149 = lerp( localNormalStrength263 , localNormalStrength268 , HeightMask64);
				#ifdef _DETAIL_ON
				float3 staticSwitch79 = lerpResult149;
				#else
				float3 staticSwitch79 = localNormalStrength263;
				#endif
				float3 BaseNormal59 = staticSwitch79;
				float3 tanToWorld0 = float3( WorldTangent.x, WorldBiTangent.x, WorldNormal.x );
				float3 tanToWorld1 = float3( WorldTangent.y, WorldBiTangent.y, WorldNormal.y );
				float3 tanToWorld2 = float3( WorldTangent.z, WorldBiTangent.z, WorldNormal.z );
				float3 tanNormal38 = BaseNormal59;
				float3 worldNormal38 = normalize( float3(dot(tanToWorld0,tanNormal38), dot(tanToWorld1,tanNormal38), dot(tanToWorld2,tanNormal38)) );
				float dotResult39 = dot( float4( worldNormal38 , 0.0 ) , float4(0,1,0,0) );
				float saferPower53 = abs( ( _ParticleLayer_BlendFactor * saturate( dotResult39 ) ) );
				float ParticalLayerMask71 = saturate( pow( saferPower53 , _ParticleLayer_BlendFalloff ) );
				float3 lerpResult42 = lerp( BaseAlbedo68 , (( _VTColor * tex2D( _VTMap, uv_VTMap ) )).rgb , ParticalLayerMask71);
				#ifdef _VT_ON
				float3 staticSwitch41 = lerpResult42;
				#else
				float3 staticSwitch41 = BaseAlbedo68;
				#endif
				float3 SurfaceAlbedo393 = staticSwitch41;
				
				float3 In395 = BaseNormal59;
				float Strength395 = _VTBumpScale;
				float3 localNormalStrength395 = NormalStrength395( In395 , Strength395 );
				float3 lerpResult44 = lerp( BaseNormal59 , localNormalStrength395 , ParticalLayerMask71);
				#ifdef _VT_ON
				float3 staticSwitch46 = lerpResult44;
				#else
				float3 staticSwitch46 = BaseNormal59;
				#endif
				float3 SurfaceNormal394 = staticSwitch46;
				
				float2 uv_EmissionMap = IN.ase_texcoord8.xy * _EmissionMap_ST.xy + _EmissionMap_ST.zw;
				float4 AbedoMap357 = staticSwitch298;
				float clampResult309 = clamp( abs( sin( ( ( _TimeParameters.x ) * _HighLightSpeed ) ) ) , 0.0 , _HighLightRate );
				float3 SurfaceEmission94 = (( ( tex2D( _EmissionMap, uv_EmissionMap ) * _EmissionColor ) + ( _HighLightScale * _HighLightDarkScale * AbedoMap357 * _HighLightSwitch * ( ( clampResult309 * ( 1.0 / _HighLightRate ) ) + _StartIntensity ) ) )).rgb;
				
				float BaseMetallic193 = break339.b;
				#ifdef GPU_DRIVEN_TEST
				float staticSwitch407 = Metallic_GPU;
				#else
				float staticSwitch407 = _Metallic;
				#endif
				float temp_output_110_0 = ( BaseMetallic193 * staticSwitch407 );
				float lerpResult147 = lerp( temp_output_110_0 , _DetailMetallic , HeightMask64);
				#ifdef _DETAIL_ON
				float staticSwitch148 = lerpResult147;
				#else
				float staticSwitch148 = temp_output_110_0;
				#endif
				float SurfaceMetallic92 = staticSwitch148;
				
				float BaseSmoothness194 = break339.a;
				#ifdef GPU_DRIVEN_TEST
				float staticSwitch405 = Smoothness_GPU;
				#else
				float staticSwitch405 = _Smoothness;
				#endif
				float temp_output_139_0 = ( BaseSmoothness194 * staticSwitch405 );
				float lerpResult144 = lerp( temp_output_139_0 , _DetailSmoothness , HeightMask64);
				#ifdef _DETAIL_ON
				float staticSwitch145 = lerpResult144;
				#else
				float staticSwitch145 = temp_output_139_0;
				#endif
				float SmoothnessMerge77 = staticSwitch145;
				
				float BaseAlpha163 = (staticSwitch298).a;
				float2 appendResult207 = (float2(BaseAlpha163 , 1.0));
				#ifdef GPU_DRIVEN_TEST
				float staticSwitch409 = AO_GPU;
				#else
				float staticSwitch409 = _AmbientOcclusion;
				#endif
				float2 lerpResult210 = lerp( (appendResult207).xy , (appendResult207).yx , staticSwitch409);
				float2 break222 = lerpResult210;
				
				#ifdef GPU_DRIVEN_TEST
				float staticSwitch411 = 1.0;
				#else
				float staticSwitch411 = _BaseColor.a;
				#endif
				float ColorAlpha224 = staticSwitch411;
				
				#ifdef GPU_DRIVEN_TEST
				float staticSwitch413 = AlphaCutoff_GPU;
				#else
				float staticSwitch413 = _AlphaCutoff;
				#endif
				

				float3 BaseColor = SurfaceAlbedo393;
				float3 Normal = SurfaceNormal394;
				float3 Emission = SurfaceEmission94;
				float3 Specular = 0.5;
				float Metallic = SurfaceMetallic92;
				float Smoothness = SmoothnessMerge77;
				float Occlusion = break222.y;
				float Alpha = ( ColorAlpha224 * break222.x );
				float AlphaClipThreshold = staticSwitch413;
				float AlphaClipThresholdShadow = 0.5;
				float3 BakedGI = 0;
				float3 RefractionColor = 1;
				float RefractionIndex = 1;
				float3 Transmission = 1;
				float3 Translucency = 1;

				#ifdef ASE_DEPTH_WRITE_ON
					float DepthValue = 0;
				#endif

				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				InputData inputData = (InputData)0;
				inputData.positionWS = WorldPosition;
				inputData.positionCS = IN.clipPos;
				inputData.shadowCoord = ShadowCoords;

				#ifdef _NORMALMAP
					#if _NORMAL_DROPOFF_TS
						inputData.normalWS = TransformTangentToWorld(Normal, half3x3( WorldTangent, WorldBiTangent, WorldNormal ));
					#elif _NORMAL_DROPOFF_OS
						inputData.normalWS = TransformObjectToWorldNormal(Normal);
					#elif _NORMAL_DROPOFF_WS
						inputData.normalWS = Normal;
					#endif
				#else
					inputData.normalWS = WorldNormal;
				#endif

				inputData.normalWS = NormalizeNormalPerPixel(inputData.normalWS);
				inputData.viewDirectionWS = SafeNormalize( WorldViewDirection );

				inputData.vertexLighting = IN.fogFactorAndVertexLight.yzw;

				#if defined(ENABLE_TERRAIN_PERPIXEL_NORMAL)
					float3 SH = SampleSH(inputData.normalWS.xyz);
				#else
					float3 SH = IN.lightmapUVOrVertexSH.xyz;
				#endif

				#ifdef ASE_BAKEDGI
					inputData.bakedGI = BakedGI;
				#else
					#if defined(DYNAMICLIGHTMAP_ON)
						inputData.bakedGI = SAMPLE_GI( IN.lightmapUVOrVertexSH.xy, IN.dynamicLightmapUV.xy, SH, inputData.normalWS);
					#else
						inputData.bakedGI = SAMPLE_GI( IN.lightmapUVOrVertexSH.xy, SH, inputData.normalWS );
					#endif
				#endif

				inputData.normalizedScreenSpaceUV = NormalizedScreenSpaceUV;
				inputData.shadowMask = SAMPLE_SHADOWMASK(IN.lightmapUVOrVertexSH.xy);

				#if defined(DEBUG_DISPLAY)
					#if defined(DYNAMICLIGHTMAP_ON)
						inputData.dynamicLightmapUV = IN.dynamicLightmapUV.xy;
						#endif
					#if defined(LIGHTMAP_ON)
						inputData.staticLightmapUV = IN.lightmapUVOrVertexSH.xy;
					#else
						inputData.vertexSH = SH;
					#endif
				#endif

				#ifdef _DBUFFER
					ApplyDecal(IN.clipPos,
						BaseColor,
						Specular,
						inputData.normalWS,
						Metallic,
						Occlusion,
						Smoothness);
				#endif

				BRDFData brdfData;
				InitializeBRDFData
				(BaseColor, Metallic, Specular, Smoothness, Alpha, brdfData);

				Light mainLight = GetMainLight(inputData.shadowCoord, inputData.positionWS, inputData.shadowMask);
				half4 color;
				MixRealtimeAndBakedGI(mainLight, inputData.normalWS, inputData.bakedGI, inputData.shadowMask);
				color.rgb = GlobalIllumination(brdfData, inputData.bakedGI, Occlusion, inputData.positionWS, inputData.normalWS, inputData.viewDirectionWS);
				color.a = Alpha;

				#ifdef ASE_FINAL_COLOR_ALPHA_MULTIPLY
					color.rgb *= color.a;
				#endif

				#ifdef ASE_DEPTH_WRITE_ON
					outputDepth = DepthValue;
				#endif

				return BRDFDataToGbuffer(brdfData, inputData, Smoothness, Emission + color.rgb, Occlusion);
			}

			ENDHLSL
		}
		
	}
	
	CustomEditor "UnityEditor.ShaderGraphLitGUI"
	FallBack "Hidden/Shader Graph/FallbackError"
	
	Fallback Off
}
/*ASEBEGIN
Version=19107
Node;AmplifyShaderEditor.CommentaryNode;422;-6095.479,-4503.2;Inherit;False;821;435.2109;;3;416;414;417;UVFlow（仅传送带效果使用）;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;389;-7999.432,-2640.32;Inherit;False;839.8408;733.2947;;7;387;388;383;385;378;381;28;顶点色的通道可切换;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;76;-7031.877,-2812.913;Inherit;False;1471.692;605.9455;Comment;7;27;29;30;33;32;34;64;HeightMask;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-6507.405,-2690.788;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;75;-5197.46,-2901.019;Inherit;False;2502.209;832.4714;Comment;20;189;268;263;59;79;83;150;267;266;191;228;21;229;194;193;190;149;339;402;403;BaseNormal;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;74;-2318.008,-3576.618;Inherit;False;1833.879;515.9104;方向蒙版;11;38;66;35;39;54;51;40;52;53;71;56;ParticalLayerMask;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;91;-2316.056,-2779.165;Inherit;False;1517.58;1014.264;Comment;16;394;62;46;44;395;396;72;41;393;42;73;98;69;43;391;390;VT_faker;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;67;-4478.808,-4134.953;Inherit;False;1656.387;920.076;Comment;17;68;163;25;109;65;26;24;136;137;17;320;357;400;3;411;410;224;BaseColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;104;-4467.899,-1919.568;Inherit;False;1513.308;991.71;Comment;20;111;145;142;5;77;144;143;197;139;141;92;148;146;147;195;110;404;405;406;407;BaseMetallic;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;101;-4474.961,-663.3646;Inherit;False;1541.808;1094.533;Comment;23;166;19;165;97;94;315;299;300;301;302;303;304;305;306;307;308;309;310;311;312;313;314;356;BaseEmission;1,1,1,1;0;0
Node;AmplifyShaderEditor.PowerNode;32;-6182.72,-2667.839;Inherit;False;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;34;-5973.205,-2667.501;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;137;-3989.544,-3527.343;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;145;-3528.736,-1321.081;Inherit;False;Property;_Detail;---------------Detail---------------;9;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Reference;25;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;65;-4027.172,-3356.5;Inherit;False;64;HeightMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;27;-6971.879,-2772.913;Inherit;True;Property;_DetailMask;DetailMask;11;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;30;-6783.817,-2322.968;Inherit;False;Property;_BlendFactor;BlendFactor;18;0;Create;True;0;0;0;False;0;False;1;1;1;16;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-6492.235,-2404.468;Inherit;False;Property;_BlendFalloff;BlendFalloff;19;0;Create;True;0;0;0;False;0;False;1;1;1;128;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;26;-3747.098,-3769.336;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ComponentMaskNode;109;-3272.077,-4003.191;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;165;-4026.753,-425.9582;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;166;-4290.585,-357.8683;Inherit;False;Property;_EmissionColor;EmissionColor;27;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;207;-813.8684,-133.8172;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SwizzleNode;208;-610.8682,-220.8174;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SwizzleNode;209;-607.8682,-69.81719;Inherit;False;FLOAT2;1;0;2;3;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;210;-378.8692,-160.8173;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BreakToComponentsNode;222;-157.3332,-160.9213;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;223;8.367523,-256.3421;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;149;-3382.18,-2693.159;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;229;-4217.736,-2818.878;Inherit;False;Normal Reconstruct Z;-1;;2;63ba85b764ae0c84ab3d698b86364ae9;0;1;1;FLOAT2;0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;191;-4706.649,-2481.162;Inherit;False;FLOAT2;4;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TFHCRemapNode;266;-4475.046,-2480.368;Inherit;False;5;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT2;1,1;False;3;FLOAT2;-1,-1;False;4;FLOAT2;1,1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;150;-3830.393,-2305.274;Inherit;False;64;HeightMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;136;-4421.188,-3413.513;Inherit;False;Property;_DetailColor;DetailColor;13;0;Create;True;0;0;0;False;0;False;1,1,1,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;24;-4422.157,-3630.607;Inherit;True;Property;_DetailAlbedoMap;DetailAlbedoMap;12;0;Create;True;0;0;0;True;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;194;-4734.025,-2591.255;Inherit;False;BaseSmoothness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;189;-4711.976,-2819.072;Inherit;False;FLOAT2;4;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;100;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TFHCRemapNode;228;-4471.337,-2819.126;Inherit;False;5;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT2;1,1;False;3;FLOAT2;-1,-1;False;4;FLOAT2;1,1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;190;-5112.223,-2510.226;Inherit;True;Property;_DetailNormalMap;DetailNormalMap;14;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;77;-3206.339,-1354.489;Inherit;False;SmoothnessMerge;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;148;-3540.64,-1830.39;Inherit;False;Property;_Detail;---------------Detail---------------;9;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Reference;25;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;97;-3133.652,-499.2345;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;315;-3305.651,-543.1072;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;302;-3514.551,-8.737701;Inherit;False;Property;_HighLightSwitch;HighLightSwitch;29;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;303;-4395.751,20.60648;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;304;-4180.849,87.91631;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;305;-4055.494,87.86589;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;306;-3948.494,86.86589;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;309;-3714.799,77.46599;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;310;-3692.305,212.362;Inherit;False;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;311;-3495.407,123.6619;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;312;-3343.312,178.4618;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;313;-3711.92,327.2532;Inherit;False;Property;_StartIntensity;StartIntensity;32;0;Create;True;0;0;0;False;0;False;0.1;0.1;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;314;-3083.686,-116.6585;Inherit;False;5;5;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;316;-5111.096,-3777.907;Inherit;True;Property;_BaseMapArray;BaseMapArray;37;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;black;LockedToTexture2DArray;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;338;-5121.932,-3260.998;Inherit;True;Property;_BumpMapArray;BumpMapArray;38;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;black;LockedToTexture2DArray;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BreakToComponentsNode;339;-4943.652,-2748.144;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.ColorNode;299;-4008.617,-231.7499;Inherit;False;Property;_HighLightColor;HighLightColor;28;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;301;-3474.784,-96.65912;Inherit;False;357;AbedoMap;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;300;-3531.879,-278.6687;Inherit;False;Property;_HighLightScale;HighLightScale;33;0;Create;True;0;0;0;False;0;False;1.1;1.1;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;308;-4061.846,203.2515;Inherit;False;Property;_HighLightRate;LightDarkTimeScale;30;0;Create;False;0;0;0;False;0;False;0.5;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;307;-4431.049,215.8027;Inherit;False;Property;_HighLightSpeed;HighLightSpeed;31;0;Create;True;0;0;0;False;0;False;0.4;0.4;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;356;-3487.51,-192.004;Inherit;False;Property;_HighLightDarkScale;HighLightDarkScale;34;0;Create;True;0;0;0;False;0;False;1;1;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;320;-4318.996,-3740.207;Inherit;False;False;False;False;True;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;357;-4303.494,-3833.009;Inherit;False;AbedoMap;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;163;-4104.238,-3743.473;Inherit;False;BaseAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;370;449.6342,-761.8047;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;16;New Amplify Shader;78949bfc355b0884689af4887989ada7;True;ExtraPrePass;0;0;ExtraPrePass;5;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;False;False;False;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;3;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;False;False;False;True;0;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;371;449.6342,-761.8047;Float;False;True;-1;2;UnityEditor.ShaderGraphLitGUI;0;16;RM/LitMerge;78949bfc355b0884689af4887989ada7;True;Forward;0;1;Forward;16;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;False;False;False;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;5;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;False;True;3;False;;True;True;0;False;;0;False;;True;1;LightMode=UniversalForward;False;False;0;;0;0;Standard;18;Workflow;1;0;  Refraction Model;0;0;Fragment Normal Space,InvertActionOnDeselection;0;0;Forward Only;0;0;Cast Shadows;1;0;  Use Shadow Threshold;0;0;GPU Instancing;1;0;LOD CrossFade;1;0;Built-in Fog;1;0;_FinalColorxAlpha;0;0;Meta Pass;1;0;Override Baked GI;0;0;Extra Pre Pass;0;0;DOTS Instancing;0;0;Write Depth;0;638216172268913512;  Early Z;0;638216172096159998;Vertex Position,InvertActionOnDeselection;1;0;Debug Display;0;0;0;7;False;True;True;True;True;True;True;False;;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;372;449.6342,-761.8047;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;16;New Amplify Shader;78949bfc355b0884689af4887989ada7;True;ShadowCaster;0;2;ShadowCaster;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;False;False;False;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;3;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;0;False;;False;False;False;False;False;False;False;False;False;True;1;False;;True;3;False;;False;True;1;LightMode=ShadowCaster;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;373;449.6342,-761.8047;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;16;New Amplify Shader;78949bfc355b0884689af4887989ada7;True;DepthOnly;0;3;DepthOnly;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;False;False;False;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;3;False;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;False;False;True;True;False;False;False;0;False;;False;False;False;False;False;False;False;False;False;True;1;False;;False;False;True;1;LightMode=DepthOnly;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;374;449.6342,-761.8047;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;16;New Amplify Shader;78949bfc355b0884689af4887989ada7;True;Meta;0;4;Meta;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;False;False;False;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;3;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=Meta;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;375;449.6342,-761.8047;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;16;New Amplify Shader;78949bfc355b0884689af4887989ada7;True;DepthNormals;0;5;DepthNormals;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;False;False;False;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;3;False;0;False;True;1;1;False;;0;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;False;;True;3;False;;False;True;1;LightMode=DepthNormals;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;376;449.6342,-761.8047;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;16;New Amplify Shader;78949bfc355b0884689af4887989ada7;True;GBuffer;0;6;GBuffer;2;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;False;False;False;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Lit;True;3;False;0;False;True;1;1;False;;0;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;True;3;False;;True;True;0;False;;0;False;;True;1;LightMode=UniversalGBuffer;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;68;-3047.3,-4003.388;Inherit;False;BaseAlbedo;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;59;-2918.916,-2826.263;Float;False;BaseNormal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;92;-3206.876,-1830.783;Inherit;False;SurfaceMetallic;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;94;-3145.187,-607.1271;Inherit;False;SurfaceEmission;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;164;-1039.202,-181.7325;Inherit;False;163;BaseAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;25;-3521.549,-4002.785;Inherit;False;Property;_DETAIL;Detail;9;0;Create;False;0;0;0;True;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;19;-4375.998,-568.5163;Inherit;True;Property;_EmissionMap;Emission;26;0;Create;False;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;64;-5784.182,-2672.411;Inherit;False;HeightMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;387;-7312.591,-2371.499;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;383;-7571.012,-2225.423;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;385;-7574.408,-2042.025;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;381;-7571.109,-2416.12;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;378;-7566.014,-2590.32;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;388;-7949.432,-2538.983;Inherit;False;Property;_VertexColChannel;VertexColChannel;10;0;Create;True;0;0;0;False;0;False;0,0,0,1;0,0,0,1;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;28;-7920.397,-2316.765;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;79;-3176.328,-2826.7;Inherit;False;Property;_Detail;Detail;9;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Reference;25;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CustomExpressionNode;268;-3962.546,-2479.427;Inherit;False;float3 out1 = float3(In.xy * Strength, lerp(1, In.z, saturate(Strength)))@ $$return out1@$$$$$$$$;3;Create;2;True;In;FLOAT3;0,0,0;In;;Inherit;False;True;Strength;FLOAT;0;In;;Inherit;False;NormalStrength;True;False;0;;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;267;-4222.237,-2479.372;Inherit;False;Normal Reconstruct Z;-1;;17;63ba85b764ae0c84ab3d698b86364ae9;0;1;1;FLOAT2;0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;83;-4194.105,-2359.861;Inherit;False;Property;_DetailNormalScale;DetailNormalScale;15;0;Create;False;0;0;0;False;0;True;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;53;-1103.455,-3467.153;Inherit;False;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;39;-1756.698,-3314.216;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;56;-910.869,-3466.694;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;71;-710.2772,-3472.23;Inherit;False;ParticalLayerMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;66;-2242.007,-3461.508;Inherit;False;59;BaseNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldNormalVector;38;-2004.243,-3456.319;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SaturateNode;40;-1534.546,-3350.866;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;54;-1755.947,-3531.225;Inherit;False;Property;_ParticleLayer_BlendFactor;BlendFactor;24;0;Create;False;0;0;0;False;0;False;1;1;1;16;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;-1347.417,-3526.618;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;52;-1395.96,-3275.38;Inherit;False;Property;_ParticleLayer_BlendFalloff;BlendFalloff;25;0;Create;False;0;0;0;False;0;False;1;1;1;128;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;390;-1918.702,-2542.202;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;391;-2157.701,-2647.202;Inherit;False;Property;_VTColor;VTColor;21;0;Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;43;-2241.247,-2444.594;Inherit;True;Property;_VTMap;VTMap;22;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;98;-1741.12,-2546.777;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;73;-1754.169,-2413.242;Inherit;False;71;ParticalLayerMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;42;-1466.687,-2566.361;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;358;449.0692,-283.4126;Inherit;False;Property;_FogClose;FogClose;39;1;[Toggle];Create;True;0;0;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;35;-2242.056,-3292.408;Inherit;False;Constant;_DirectionWord;Direction(Word);22;0;Create;True;0;0;0;False;0;False;0,1,0,0;0,1,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;44;-1584.573,-2021.661;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,1;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch;46;-1277.346,-2157.749;Inherit;False;Property;_ParticleAccum;ParticleAccum;20;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Reference;41;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;394;-1015.636,-2158.039;Float;False;SurfaceNormal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;72;-1919.674,-1861.71;Inherit;False;71;ParticalLayerMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;396;-2271.233,-1978.6;Inherit;False;Property;_VTBumpScale;VTBumpScale;23;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;41;-1270.593,-2675.728;Inherit;False;Property;_VT;VT;20;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;393;-1019.251,-2676.026;Inherit;False;SurfaceAlbedo;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;69;-1725.788,-2676.009;Inherit;False;68;BaseAlbedo;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;62;-2138.028,-2164.822;Inherit;False;59;BaseNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CustomExpressionNode;395;-1904.047,-1997.709;Inherit;False;float3 out1 = float3(In.xy * Strength, lerp(1, In.z, saturate(Strength)))@ $$return out1@$$$$$$$$;3;Create;2;True;In;FLOAT3;0,0,0;In;;Inherit;False;True;Strength;FLOAT;0;In;;Inherit;False;NormalStrength;True;False;0;;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CustomExpressionNode;263;-3955.754,-2818.328;Inherit;False;float3 out1 = float3(In.xy * Strength, lerp(1, In.z, saturate(Strength)))@ $$return out1@$$$$$$$$;3;Create;2;True;In;FLOAT3;0,0,0;In;;Inherit;False;True;Strength;FLOAT;0;In;;Inherit;False;NormalStrength;True;False;0;;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;225;-242.8156,-288.4112;Inherit;False;224;ColorAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;269;451.2533,-419.1514;Inherit;False;Property;_CRR_RENDERING;CRR_RENDERING;35;0;Create;True;0;0;0;True;0;False;1;0;0;True;_CRR_RENDERING;Toggle;2;Key0;Key1;Create;False;False;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;88;-33.23073,-853.0256;Inherit;False;393;SurfaceAlbedo;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;86;-32.12979,-743.1432;Inherit;False;394;SurfaceNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;95;-42.51282,-633.6669;Inherit;False;94;SurfaceEmission;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;93;-36.39394,-533.5821;Inherit;False;92;SurfaceMetallic;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;78;-54.80191,-432.8943;Inherit;False;77;SmoothnessMerge;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;397;451.43,-148.3331;Inherit;False;Property;_GPU_DRIVEN_TEST;GPU DRIVEN TEST;36;0;Create;False;0;0;0;True;0;False;0;0;0;True;GPU_DRIVEN_TEST;Toggle;2;Key0;Key1;Create;True;False;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;298;-4780.575,-3834.877;Inherit;False;Property;_MERGE_USE_TEXTURE_ARRAY;MERGE_USE_TEXTURE_ARRAY;36;0;Create;False;0;0;0;True;0;False;0;0;0;True;MERGE_USE_TEXTURE_ARRAY;Toggle;2;Key0;Key1;Reference;397;True;False;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;321;-4776.222,-3267.114;Inherit;False;Property;_Keyword0;Keyword 0;36;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Reference;397;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-3992.495,-4073.172;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;399;-4452.653,-4351.196;Inherit;False;Global;BaseColor_GPU;BaseColor_GPU;39;0;Fetch;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;3;-4458.258,-4088.036;Inherit;False;Property;_BaseColor;BaseColor;4;0;Create;False;1;BaseLayer;0;0;False;0;False;1,1,1,1;0.8490566,0.8236917,0.7729619,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;21;-4175.215,-2713.713;Inherit;False;Property;_BumpScale;BumpScale;6;0;Create;False;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;402;-4205.644,-2613.574;Inherit;False;Global;BumpScale_GPU;BumpScale_GPU;39;0;Fetch;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;403;-3969.644,-2655.574;Inherit;False;Property;_Keyword2;Keyword 2;36;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Reference;397;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;193;-4733.025,-2667.255;Inherit;False;BaseMetallic;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;144;-3711.039,-1188.664;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;143;-3949.561,-1064.029;Inherit;False;64;HeightMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;142;-4040.142,-1156.59;Float;False;Property;_DetailSmoothness;DetailSmoothness;16;0;Create;False;0;0;0;False;0;False;0.5;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;405;-4164.043,-1297.846;Inherit;False;Property;_Keyword3;Keyword 3;36;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Reference;397;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;197;-4400.773,-1377.756;Inherit;False;194;BaseSmoothness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;139;-3898.039,-1375.333;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-4452.984,-1283.764;Float;False;Property;_Smoothness;Smoothness;8;0;Create;False;0;0;0;False;0;False;1;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;404;-4408.043,-1184.846;Inherit;False;Global;Smoothness_GPU;Smoothness_GPU;39;0;Fetch;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;147;-3694.403,-1723.482;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;146;-3987.891,-1472.864;Inherit;False;64;HeightMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;141;-4059.821,-1556.127;Float;False;Property;_DetailMetallic;DetailMetallic;17;0;Create;False;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;110;-3890.737,-1870.074;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;195;-4351.843,-1873.134;Inherit;False;193;BaseMetallic;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;407;-4146.043,-1759.846;Inherit;False;Property;_Keyword4;Keyword 4;36;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Reference;397;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;111;-4442.949,-1763.83;Float;False;Property;_Metallic;Metallic;7;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;406;-4385.043,-1673.846;Inherit;False;Global;Metallic_GPU;Metallic_GPU;39;0;Fetch;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;377;-855.4984,65.2029;Inherit;False;Property;_AmbientOcclusion;AmbientOcclusion;0;1;[Toggle];Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;408;-846.0413,160.1673;Inherit;False;Global;AO_GPU;AO_GPU;39;0;Fetch;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;409;-635.0413,61.1673;Inherit;False;Property;_Keyword5;Keyword 5;36;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Reference;397;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;400;-4212.653,-4086.196;Inherit;False;Property;_Keyword1;Keyword 1;36;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Reference;397;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;411;-4081.39,-3973.523;Inherit;False;Property;_Keyword6;Keyword 6;36;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Reference;397;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;410;-4240.39,-3912.523;Inherit;False;Constant;_Float0;Float 0;39;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;224;-3811.258,-3968.728;Inherit;False;ColorAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-220.0749,16.23151;Inherit;False;Property;_AlphaCutoff;AlphaCutoff;1;0;Create;False;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;412;-140.1711,155.0391;Inherit;False;Global;AlphaCutoff_GPU;AlphaCutoff_GPU;39;0;Fetch;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;413;72.82886,67.03906;Inherit;False;Property;_Keyword7;Keyword 7;36;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Reference;397;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;414;-5946.935,-4453.201;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;417;-5759.479,-4418.99;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;416;-6045.479,-4359.99;Inherit;False;Property;_Speed;Speed( 仅传送带效果使用！);2;0;Create;False;0;0;0;False;0;False;0;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-5099.134,-4013.301;Inherit;True;Property;_BaseMap2;AbedoMap;3;0;Create;False;0;0;0;False;0;False;-1;None;2d8dad19ba3f52048a78f0f2f9731d24;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;181;-5115.813,-3472.043;Inherit;True;Property;_BumpMap1;BumpMap1;5;0;Create;True;0;0;0;False;0;False;-1;None;370d029f9cfcd784faae351ac7b63628;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexCoordVertexDataNode;317;-4674.46,-5062.323;Inherit;False;2;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;318;-4478.46,-5053.323;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;255;False;1;FLOAT;0
Node;AmplifyShaderEditor.RoundOpNode;319;-4345.46,-5052.323;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;398;-5338.692,-3720.127;Inherit;False;Global;AlbedoIndex;AlbedoIndex;39;0;Fetch;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;401;-5336.825,-3211.823;Inherit;False;Global;NormalIndex;NormalIndex;39;0;Fetch;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;428;-6288.251,-3571.919;Inherit;True;Property;_BumpMap;BumpMap;5;0;Create;True;0;0;0;False;0;False;None;None;False;black;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;425;-6269.412,-4026.386;Inherit;True;Property;_BaseMap;AbedoMap;3;0;Create;False;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TextureCoordinatesNode;423;-5944.577,-3928.008;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;421;-5474.596,-3864.002;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;419;-5626.516,-3931.243;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;429;-5980.209,-3440.419;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;430;-5680.593,-3462.331;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;431;-5483.566,-3414.464;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
WireConnection;29;0;27;2
WireConnection;29;1;387;0
WireConnection;29;2;30;0
WireConnection;32;0;29;0
WireConnection;32;1;33;0
WireConnection;34;0;32;0
WireConnection;137;0;24;0
WireConnection;137;1;136;0
WireConnection;145;1;139;0
WireConnection;145;0;144;0
WireConnection;26;0;17;0
WireConnection;26;1;137;0
WireConnection;26;2;65;0
WireConnection;109;0;25;0
WireConnection;165;0;19;0
WireConnection;165;1;166;0
WireConnection;207;0;164;0
WireConnection;208;0;207;0
WireConnection;209;0;207;0
WireConnection;210;0;208;0
WireConnection;210;1;209;0
WireConnection;210;2;409;0
WireConnection;222;0;210;0
WireConnection;223;0;225;0
WireConnection;223;1;222;0
WireConnection;149;0;263;0
WireConnection;149;1;268;0
WireConnection;149;2;150;0
WireConnection;229;1;228;0
WireConnection;191;0;190;1
WireConnection;191;1;190;2
WireConnection;266;0;191;0
WireConnection;194;0;339;3
WireConnection;189;0;339;0
WireConnection;189;1;339;1
WireConnection;228;0;189;0
WireConnection;77;0;145;0
WireConnection;148;1;110;0
WireConnection;148;0;147;0
WireConnection;97;0;315;0
WireConnection;315;0;165;0
WireConnection;315;1;314;0
WireConnection;304;0;303;2
WireConnection;304;1;307;0
WireConnection;305;0;304;0
WireConnection;306;0;305;0
WireConnection;309;0;306;0
WireConnection;309;2;308;0
WireConnection;310;1;308;0
WireConnection;311;0;309;0
WireConnection;311;1;310;0
WireConnection;312;0;311;0
WireConnection;312;1;313;0
WireConnection;314;0;300;0
WireConnection;314;1;356;0
WireConnection;314;2;301;0
WireConnection;314;3;302;0
WireConnection;314;4;312;0
WireConnection;316;6;398;0
WireConnection;338;6;401;0
WireConnection;339;0;321;0
WireConnection;320;0;298;0
WireConnection;357;0;298;0
WireConnection;163;0;320;0
WireConnection;371;0;88;0
WireConnection;371;1;86;0
WireConnection;371;2;95;0
WireConnection;371;3;93;0
WireConnection;371;4;78;0
WireConnection;371;5;222;1
WireConnection;371;6;223;0
WireConnection;371;7;413;0
WireConnection;68;0;109;0
WireConnection;59;0;79;0
WireConnection;92;0;148;0
WireConnection;94;0;97;0
WireConnection;25;1;17;0
WireConnection;25;0;26;0
WireConnection;64;0;34;0
WireConnection;387;0;378;0
WireConnection;387;1;381;0
WireConnection;387;2;383;0
WireConnection;387;3;385;0
WireConnection;383;0;388;3
WireConnection;383;1;28;3
WireConnection;385;0;388;4
WireConnection;385;1;28;4
WireConnection;381;0;388;2
WireConnection;381;1;28;2
WireConnection;378;0;388;1
WireConnection;378;1;28;1
WireConnection;79;1;263;0
WireConnection;79;0;149;0
WireConnection;268;0;267;0
WireConnection;268;1;83;0
WireConnection;267;1;266;0
WireConnection;53;0;51;0
WireConnection;53;1;52;0
WireConnection;39;0;38;0
WireConnection;39;1;35;0
WireConnection;56;0;53;0
WireConnection;71;0;56;0
WireConnection;38;0;66;0
WireConnection;40;0;39;0
WireConnection;51;0;54;0
WireConnection;51;1;40;0
WireConnection;390;0;391;0
WireConnection;390;1;43;0
WireConnection;98;0;390;0
WireConnection;42;0;69;0
WireConnection;42;1;98;0
WireConnection;42;2;73;0
WireConnection;44;0;62;0
WireConnection;44;1;395;0
WireConnection;44;2;72;0
WireConnection;46;1;62;0
WireConnection;46;0;44;0
WireConnection;394;0;46;0
WireConnection;41;1;69;0
WireConnection;41;0;42;0
WireConnection;393;0;41;0
WireConnection;395;0;62;0
WireConnection;395;1;396;0
WireConnection;263;0;229;0
WireConnection;263;1;403;0
WireConnection;298;1;2;0
WireConnection;298;0;316;0
WireConnection;321;1;181;0
WireConnection;321;0;338;0
WireConnection;17;0;400;0
WireConnection;17;1;298;0
WireConnection;403;1;21;0
WireConnection;403;0;402;0
WireConnection;193;0;339;2
WireConnection;144;0;139;0
WireConnection;144;1;142;0
WireConnection;144;2;143;0
WireConnection;405;1;5;0
WireConnection;405;0;404;0
WireConnection;139;0;197;0
WireConnection;139;1;405;0
WireConnection;147;0;110;0
WireConnection;147;1;141;0
WireConnection;147;2;146;0
WireConnection;110;0;195;0
WireConnection;110;1;407;0
WireConnection;407;1;111;0
WireConnection;407;0;406;0
WireConnection;409;1;377;0
WireConnection;409;0;408;0
WireConnection;400;1;3;0
WireConnection;400;0;399;0
WireConnection;411;1;3;4
WireConnection;411;0;410;0
WireConnection;224;0;411;0
WireConnection;413;1;4;0
WireConnection;413;0;412;0
WireConnection;417;0;414;0
WireConnection;417;1;416;0
WireConnection;2;0;425;0
WireConnection;2;1;421;0
WireConnection;181;0;428;0
WireConnection;181;1;431;0
WireConnection;318;0;317;1
WireConnection;319;0;318;0
WireConnection;423;2;425;0
WireConnection;421;0;419;0
WireConnection;421;1;423;2
WireConnection;419;0;417;0
WireConnection;419;1;423;1
WireConnection;429;2;428;0
WireConnection;430;0;417;0
WireConnection;430;1;429;1
WireConnection;431;0;430;0
WireConnection;431;1;429;2
ASEEND*/
//CHKSM=BB9B5C2FC8A89FC656E1AF34F4EB2AEED6922E7C