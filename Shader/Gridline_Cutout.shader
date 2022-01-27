//================================================================================================
// GridlineShader        Var 1.0.0
// 
// Copyright (C) 2022 ayaha401
// Twitter : @ayaha__401
// 
// This software is released under the MIT License.
// see https://github.com/ayaha401/GridlineShader/blob/main/LICENSE
//================================================================================================
Shader "Gridline/Gridline_Cutoff"
{
    Properties
    {
        _LineColor ("LineColor", Color) = (0.5, 0.5, 0.5, 1.0)
        _Squares ("Squares", float) = 5.0
        _Size ("Size", Range(0.01, 0.5)) = 0.45
    }
    SubShader
    {
        Tags 
        {
            "RenderType" = "TransparentCutout"
            "Queue" = "AlphaTest"
            "IgnoreProjector" = "True"
            "PreviewType" = "Plane"
            "CanUseSpriteAtlas" = "True"
        }
        LOD 100
        Cull Off
        Lighting Off
        ZWrite Off

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

            float4 _LineColor; 
            float _Squares;
            float _Size;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            float Box(float2 p, float s)
            {
                p = abs(p)-s;
                return step(max(p.x, p.y), .01);
            }

            float4 frag (v2f i) : SV_Target
            {
                float2 uv = i.uv;
                float2 gv = uv * floor(_Squares);
                float2 ip = floor(gv);
                float2 fp = frac(gv) - .5;
                float4 col = 0.0;
                
                col += Box(fp, _Size);
                col = (col == .0) ? _LineColor : 0.0;
                clip(col.a - .5);
                return float4(col);
            }
            ENDCG
        }
    }
}
