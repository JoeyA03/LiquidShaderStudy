Shader "Unlit/ScuffLiquidShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)

        _PlanePosition ("PlanePosition", Vector) = (0, 0, 0, 1)
        _PlaneNormal ("PlaneNormal", Vector) = (0, 1, 0, 0)
    }
    SubShader
    {
        Tags 
        { 
            "RenderType"="Opaque"
            // "Queue" = "Geometry" 
        }

        Cull Off

        Pass
        {

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag


            #include "UnityCG.cginc"

            float4 _Color;
            float4 _PlaneMask;
            float3 _PlaneNormal;
            float3 _PlanePosition;
            float4 _Plane;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 worldPos : TEXCOORD1;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                o.uv = v.uv;

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float distance = dot(i.worldPos - _PlanePosition, _PlaneNormal);
                distance = distance + _Plane.w;
                clip(-distance);

                fixed4 col = _Color;

                return _Color;
            }
            ENDCG
        }
    }
}
