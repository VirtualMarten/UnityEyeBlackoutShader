Shader "Custom/Eye Blackout" {
    Properties {
        _LeftEyeOpacity ("Left Eye Opacity", Range(0, 1)) = 0
        _RightEyeOpacity ("Right Eye Opacity", Range(0, 1)) = 0
    }

    SubShader {
        Tags {"RenderQueue" = "Overlay" "RenderType" = "Transparent" "IgnoreProjector" = "True"}
        Blend SrcAlpha OneMinusSrcAlpha
        Cull Off
        ZWrite Off
	    ZTest Off

        Pass {
            CGPROGRAM

            #pragma target 3.0
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            float _LeftEyeOpacity;
            float _RightEyeOpacity;

            v2f vert(appdata v) {
                v2f o;
            
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target {

                if (unity_CameraProjection[2][0] != 0 || unity_CameraProjection[2][1] != 0)
                    return float4(0, 0, 0, 0);

                if (unity_StereoEyeIndex == 0)
                    return float4(0, 0, 0, _LeftEyeOpacity);

                if (unity_StereoEyeIndex == 1)
                    return float4(0, 0, 0, _RightEyeOpacity);
            
                return float4(0, 0, 0, 0);
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
