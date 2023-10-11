Shader "Unlit/StyalizedWater"
{
    Properties
    {
        _MainTex ("Main Texture", 2D) = "white" {}
        _NoiseTex ("Extra Wave Noise", 2D) = "white" {}
        _MaskInt ("RenderTexture Mask", 2D) = "white" {}
        _TextureDistort("Texture Wobble", range(0,1)) = 0.1
        _Color("Tint", Color) = (1,1,1, .5)
        _FoamC("Foam", Color) = (1, 1, 1, .5)
        _Speed("Wave Speed", Range(0, 1)) = 0.5
        _Amount("Wave Amount", Range(0, 1)) = 0.5
        _Scale("Scale", Range(0, 1)) = 0.5
        _Height("Wave Height", Range(0, 1)) = 0.1
        _Foam("Foamline Thickness", Range(0, 10)) = 8 

    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "Queue" = "Transparent"}
        LOD 100
        Blend OneMinusDstColor One
        Cull Off

        GrabPass{
            Name "BASE"
            Tags{ "LightMode" = "Always" }
                }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            sampler2D _CameraDepthTexture; 
            sampler2D _MaskInt; 
            sampler2D _MainTex, _NoiseTex;
            float4 _MainTex_ST;
            float _TextureDistort;
            float4 _Color;
            float _Speed, _Amount, _Height, _Foam, _Scale;
            float4 _FoamC;  

            uniform float3 _Position;
            uniform sampler2D _GlobalEffectRT;
            uniform float _OrthographicCamSize;

            struct MeshData
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct Interpolators
            {
                float2 uv : TEXCOORD3;
                float4 vertex : SV_POSITION;
                float4 scrPos : TEXCOORD2;
                float4 worldPos : TEXCOORD4;
            };

            Interpolators vert (MeshData v)
            {
                Interpolators o;
                UNITY_INITIALIZE_OUTPUT(Interpolators, o);
                float4 tex = tex2Dlod(_NoiseTex, float4(v.uv.xy, 0, 0));
                v.vertex.y += sin(_Time.y * _Speed + (v.vertex.x * v.vertex.z * _Amount * tex)) * _Height; 

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);

                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.scrPos = ComputeScreenPos(o.vertex);  
                return o;
            }

            fixed4 frag (Interpolators i) : SV_Target
            {
                
                //renderTexture UV
                float2 uv = i.worldPos.xz - _Position.xz;
                uv = uv/(_OrthographicCamSize * 2) + 0.5;
                uv += 0.5;

                // Ripples
                float ripples = tex2D(_GlobalEffectRT, uv).b;

                // mask to prevent bleeding
                float4 mask = tex2D(_MaskInt, uv);              
                ripples *= mask.a;

                //fixed distortx = tex2D(_NoiseTex, (i.worldPos.xz * _Scale)  + (_Time.z * 2)).r;// distortion 
                fixed distortx = tex2D(_NoiseTex, (i.worldPos.xz * _Scale)  + (_Time.x * 2)).r;// distortion 
                distortx +=  (ripples * 2);

                //half4 col = tex2D(_MainTex, (i.worldPos.xz * _Scale) - (distortx * _TextureDistort));// texture times tint;   
                //half4 col = tex2D(_MainTex, (i.worldPos.xz * _Scale));// texture times tint;   
                //half4 col = tex2D( _MainTex, (i.uv* _Scale) - (distortx * _TextureDistort));
                half4 col = tex2D( _MainTex, (i.worldPos.xz * _Scale) - (distortx * _TextureDistort) );


                half depth = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, UNITY_PROJ_COORD(i.scrPos))); // depth
                half4 foamLine = 1 - saturate(_Foam * (depth - i.scrPos.w ) ); // foam line by comparing depth and screenposition

                col *= _Color;
                col += (step(0.2 * distortx,foamLine) * _FoamC); // add the foam line and tint to the texture
                col = saturate(col) * col.a;

                ripples = step(0.99, ripples * 3);
                float4 ripplesColored = ripples * _FoamC;
                    
                //return saturate(col);
                return saturate(col + ripplesColored);

            }
            ENDCG                   
        }
    }
}
