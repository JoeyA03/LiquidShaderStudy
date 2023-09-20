Shader "Unlit/VertexOffestAniamtion"
{
    Properties
    {
        [NoScaleeOffset] MainTex ("Texture", 2D) = "white" {}
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

            struct MeshData
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct Interpolators
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };


            Interpolators vert (MeshData v)
            {
                Interpolators o;

                o.vertex = UnityObjectToClipPos(v.vertex);
                
                return o;
            }

            fixed4 frag (Interpolators i) : SV_Target
            {
                // fixed4 col = tex2D(_MainTex, i.uv);
                fixed4 uv = fixed4(i.uv, 0,1);

                return uv;
            }
            ENDCG
        }
    }
}
