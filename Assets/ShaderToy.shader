Shader "ShaderToy/ShaderToy"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_HalfScreenVertical ("Half ScreenVertical", Float) = 0.0
		_HalfScreenHorizontal ("Half ScreenHorizontal", Float) = 0.0
		_CameraPos ("Camera Pos", Vector) = (0,0,0)
		_CameraDir ("Camera Dir", Vector) = (0,0,0)
		_CameraRight ("Camera Right", Vector) = (0,0,0)
		_CameraUp  ("Camera Up", Vector) = (0,0,0)
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float  _HalfScreenVertical;
			float  _HalfScreenHorizontal;
			float3 _CameraPos;
			float3 _CameraDir;
			float3 _CameraRight;
			float3 _CameraUp;

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}

			float sphere(float3 rayPos, float3 center, float radius)
			{
				return length(rayPos - center) - radius;
			}

			fixed4 frag (v2f i) : SV_Target
			{
				float4 color = fixed4(0,0,0,1);

				float2 coords = float2(i.uv.x - 0.5, i.uv.y - 0.5);
				float3 ray = normalize(_CameraDir + _CameraRight * _HalfScreenHorizontal * coords.x + _CameraUp * _HalfScreenVertical * coords.y);

				float a = _CameraPos.y / ray.y;
				if (a < 0)
				{
					float3 p = _CameraPos - a * ray;
					float c = fmod(p.x, 1) + fmod(p.z, 1);
					color = fixed4(c, c, c, 1);
				}

				float d = 0.0;
				float dd = 0.0;
				float3 rPos = _CameraPos;
				for (int i = 0; i < 16; ++i)
				{
					d = sphere(rPos, float3(0, 0, 3), 1);
					dd += d;
					rPos = _CameraPos + ray * dd;
				}
				if (abs(d) < 0.001)
				{
					color = fixed4(1, 0, 0, 1);
				}
				return color;
			}
			ENDCG
		}
	}
}
