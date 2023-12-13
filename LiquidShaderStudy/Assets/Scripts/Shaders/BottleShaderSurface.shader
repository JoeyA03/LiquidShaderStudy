Shader "Custom/BottleShaderSurface"
{
    Properties
    {
        _MainTex ("Main Texture", 2D) = "white" {}
        _Color ("Color", Color) = (1,0,0,1)
        _TopColor ("topColor", Color) = (0,0,1,1)
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
        

        Cull Back

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
        float4 _Plane;
        float4 _PlaneNormal;

        fixed4 _Color;

        struct Input
        {
            float2 uv_MainTex;
            float3 worldPos;
            float facing : VFACE;
        };

        

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            float distance = dot(IN.worldPos, _Plane.xyz);
            float facing = IN.facing * 0.5 + 0.5;

            distance = distance + _Plane.w;
            clip(-distance);

            
             o.Albedo = tex2D(_MainTex, IN.uv_MainTex) * _Color;
             o.Alpha =  _Color.a;
            //  o.Albedo = _Color.rgb * facing;
            // o.Albedo = lerp(_CutColor, _Color, facing);
            // o.Emission = lerp(_CutColor, _Color, facing);
            // o.Emission = distance;
        }
        ENDCG

        Cull Front

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
        float4 _Plane;
        float4 _PlaneNormal;

        fixed4 _Color;
        fixed4 _TopColor;

        struct Input
        {
            float2 uv_MainTex;
            float3 worldPos;
            float facing : VFACE;
            INTERNAL_DATA
        };

        

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            float distance = dot(IN.worldPos, _Plane.xyz);
            float facing = IN.facing * 0.5 + 0.5;

            distance = distance + _Plane.w;
            clip(-distance);

            
            o.Albedo = _TopColor.rgb;
            // o.Albedo = lerp(_CutColor, _Color, facing);
            // o.Emission = lerp(_TopColor, _Color, facing);
            // o.Emission = distance;

            half3 worldT = WorldNormalVector(IN, half3(1,0,0));
            half3 worldB = WorldNormalVector(IN, half3(0,1,0));
            half3 worldN = WorldNormalVector(IN, half3(0,0,1));
            half3x3 world2Tangent = half3x3(worldT,worldB,worldN);

            float3 n = _TopColor;
            // n = mul(world2Tangent, n);

            o.Normal = mul(world2Tangent, _PlaneNormal) + n;

        }
        ENDCG
    }
    FallBack "Diffuse"
}
