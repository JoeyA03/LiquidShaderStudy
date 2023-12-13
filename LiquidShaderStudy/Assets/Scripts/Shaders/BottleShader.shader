Shader "Unlit/BottleShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color ("Color", Color) = (1,1,1, .5)
        _PlaneMask ("planeMask",Range(0, 1)) = 1
        _PlanePosition ("PlanePosition", Vector) = (0, 0, 0, 1)
        _PlaneNormal ("PlaneNormal", Vector) = (0, 1, 0, 0)
    }
    SubShader
    {
        Tags 
        { 
            "Queue" = "Geometry"
        }
        Cull Front

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            
            // #pragma surface surf Standard fullforwardshadows alpha:blend
		    // #pragma target 3.0

            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _Color;
            float4 _PlaneMask;
            float3 _PlaneNormal;
            float3 _PlanePosition;
            float4 _Plane;
            

            struct MeshData
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct Interpolators
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float4 scrPos : TEXCOORD2;
                float4 worldPos : TEXCOORD4;
            };

            // //the surface shader function which sets parameters the lighting function then uses
            // void surf (Input i, inout SurfaceOutputStandard o) {
            //     //calculate signed distance to plane
            //     float distance = dot(i.worldPos, _Plane.xyz);
            //     o.Emission = distance;
            // }

            

            Interpolators vert (MeshData v)
            {
                Interpolators o;

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex); // get the world position of the model

                o.uv = v.uv;

                // float distance = dot(o.vertex - _PlanePosition, _PlaneNormal);
                return o;
            }

            fixed4 frag (Interpolators i) : SV_Target
            {
                float lineMask = _Plane < i.uv.y;
                float distance = dot(i.worldPos, _Plane.xyz);
                distance = distance + _Plane.w;

                float4 col = _Color;
                clip(-distance);
                
                // return col;
                return i.uv.y;
            }
            ENDCG
        }

        Cull Back
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // #pragma surface surf Standard fullforwardshadows alpha:blend
		    // #pragma target 3.0

            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _Color;
            float4 _PlaneMask;
            float3 _PlaneNormal;
            float3 _PlanePosition;
            float4 _Plane;
            

            struct MeshData
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct Interpolators
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float4 scrPos : TEXCOORD2;
                float4 worldPos : TEXCOORD4;
            };

            // //the surface shader function which sets parameters the lighting function then uses
            // void surf (Input i, inout SurfaceOutputStandard o) {
            //     //calculate signed distance to plane
            //     float distance = dot(i.worldPos, _Plane.xyz);
            //     o.Emission = distance;
            // }

            

            Interpolators vert (MeshData v)
            {
                Interpolators o;

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex); // get the world position of the model

                o.uv = v.uv;

                // float distance = dot(o.vertex - _PlanePosition, _PlaneNormal);
                return o;
            }

            fixed4 frag (Interpolators i) : SV_Target
            {
                float lineMask = _Plane < i.uv.y;
                float distance = dot(i.worldPos, _Plane.xyz);
                distance = distance + _Plane.w;

                float4 col = _Color;
                clip(-distance);
                
                return col;
                // return i.uv.y;
            }
            ENDCG
        }
    }
}
