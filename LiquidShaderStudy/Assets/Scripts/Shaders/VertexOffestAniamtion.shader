Shader "Unlit/VertexOffestAniamtion"
{
    Properties
    {
        // [NoScaleOffset] MainTex ("Texture", 2D) = "white" {}
        _colorChange ("Color", Color) = (1,1,1,1)
        _WaveAmp ("Wave Amp", Range(0, 0.5)) = 0.2 
    }
    SubShader
    {
        Tags 
        { 
            "RenderType"="Opaque"
        }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #define TAU 6.283185307 

            #include "UnityCG.cginc"

            float _WaveAmp;
            sampler2D _MainTex;
            float4 _colorChange;

            struct MeshData
            {
                float4 vertex : POSITION;
                float3 normals : NORMAL;
                float4 uv0 : TEXCOORD0;
            };

            struct Interpolators
            {
                float4 vertex : SV_POSITION;
                float3 normal : TEXCOORD0;
                float2 uv : TEXCOORD1;
            };


            Interpolators vert ( MeshData v )
            {
                Interpolators o;

                //Vertex offsets
                float wave = cos( ( v.uv0.y + _Time.y * 0.1 ) * TAU * 5) - 0.5;
                v.vertex.y = wave * _WaveAmp;


                o.vertex = UnityObjectToClipPos( v.vertex );
                o.normal = UnityObjectToWorldNormal( v.normals );
                o.uv = v.uv0;
                
                return o;
            }

            fixed4 frag (Interpolators i) : SV_Target
            {
                // fixed4 col = tex2D(_MainTex, i.uv);
                float t = float4( cos( ( i.uv.y + cos( i.uv.y * TAU * 8) * 0.01 +_Time.y * 0.1 ) * TAU * 5) *0.5 + 0.5, 0, 0, 1 );
                t *= 1-i.uv.y; 

                return t;
            }


            ENDCG
        }
    }
}
