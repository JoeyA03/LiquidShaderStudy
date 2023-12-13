Shader "Unlit/BottleShader1"
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
            "RenderType"="Opaque"
            "Queue" = "Geometry"
        }
        Cull Off
        

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
                float3 worldPos : TEXCOORD4;
            };

            // //the surface shader function which sets parameters the lighting function then uses
            // void surf (Input i, inout SurfaceOutputStandard o) {
            //     //calculate signed distance to plane
            //     float distance = dot(i.worldPos, _Plane.xyz);
            //     o.Emission = distance;
            // }

            bool checkVisibility(float3 worldPos)
            {
                float dotProd = dot(worldPos - _PlanePosition, _PlaneNormal);
                // float activityX = clamp(_Inertia.x, 0, 1);
                // float activityZ = clamp(_Inertia.z, 0, 1);
                // dotProd += (.5/_Ruffle * sin(activityX * _Ruffle * (worldPos.x + _Time.x))); 
                // dotProd += (.5/_Ruffle * cos(activityZ * _Ruffle * (worldPos.z + _Time.x)));
                return dotProd > 0;
		    }

            

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
                // float distance = dot(i.worldPos,_Plane.xyz);
                float distance = dot(i.worldPos - _PlanePosition, _PlaneNormal);
                // if(checkVisibility(i.worldPos))
                // {
                //     discard;
                // }


                clip(-distance);
                // return distance > 0;
                distance = distance + _Plane.w;

                float4 col = _Color;
                
                
                // return col;
                return i.uv.xyxy;
            }
            ENDCG
        }

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
                // float3 worldPos : TEXCOORD4;
            };

            struct Interpolators
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float4 scrPos : TEXCOORD2;
                float3 worldPos : TEXCOORD4;
            };

            // //the surface shader function which sets parameters the lighting function then uses
            // void surf (Input i, inout SurfaceOutputStandard o) {
            //     //calculate signed distance to plane
            //     float distance = dot(i.worldPos, _Plane.xyz);
            //     o.Emission = distance;
            // }

            bool checkVisibility(float3 worldPos)
            {
                float dotProd = dot(worldPos - _PlanePosition, _PlaneNormal);
                // float activityX = clamp(_Inertia.x, 0, 1);
                // float activityZ = clamp(_Inertia.z, 0, 1);
                // dotProd += (.5/_Ruffle * sin(activityX * _Ruffle * (worldPos.x + _Time.x))); 
                // dotProd += (.5/_Ruffle * cos(activityZ * _Ruffle * (worldPos.z + _Time.x)));
                return dotProd > 0;
		    }

            

            Interpolators vert (MeshData v)
            {
                Interpolators o;

                o.vertex = UnityObjectToClipPos(v.vertex);
                
                o.worldPos = mul(unity_ObjectToWorld, v.vertex); // get the world position of the model
                // UnityObjectToWorldNormal()
                half3 worldT = mul(unity_ObjectToWorld, v.vertex).x;
                half3 worldB = mul(unity_ObjectToWorld, v.vertex).y;
                half3 worldN = mul(unity_ObjectToWorld, v.vertex).z;
                half3x3 world2Tangent = half3x3(worldT, worldB, worldN);

                o.uv = mul(world2Tangent, _PlaneNormal);

                // o.uv = v;

                // float distance = dot(o.vertex - _PlanePosition, _PlaneNormal);
                return o;
            }

            fixed4 frag (Interpolators i) : SV_Target
            {
                float lineMask = _Plane < i.uv.y;
                // float distance = dot(i.worldPos,_Plane.xyz);
                float distance = dot(i.worldPos - _PlanePosition, _PlaneNormal);
                if(checkVisibility(i.worldPos))
                {
                    discard;
                }

                
                // clip(-distance);
                // return distance > 0;
                distance = distance + _Plane.w;

                float4 col = _Color;
                
                
                return col;
                // return ;
            }
            ENDCG
        }
    }
}
