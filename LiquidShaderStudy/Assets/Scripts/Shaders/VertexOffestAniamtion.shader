Shader "Unlit/VertexOffestAniamtion"
{
    Properties
    {
        [NoScaleOffset] MainTex ("Texture", 2D) = "white" {}
        _colorChange ("Color", Color) = (1,1,1,1)
        _waveAmp ("Wave Amp", Range(0, 0.5)) = 0.2 
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            float _waveAmp;
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

                o.vertex = UnityObjectToClipPos( v.vertex );
                o.normal = UnityObjectToWorldNormal( v.normals );
                
                return o;
            }

            fixed4 frag (Interpolators i) : SV_Target
            {
                // fixed4 col = tex2D(_MainTex, i.uv);
                fixed4 uv = fixed4(i.uv, 0, 1);

                return _colorChange;

                return float4( i.uv, 0, 1 );
            }
            ENDCG
        }
    }
}
