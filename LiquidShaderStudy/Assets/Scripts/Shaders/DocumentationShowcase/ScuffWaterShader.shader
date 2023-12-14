Shader "Unlit/ScuffWaterShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _NoiseTex ("Extra Wave Noise", 2D) = "white" {}

        _Color("Tint", Color) = (1,1,1, .5)

        _Speed("Wave Speed", Range(0, 1)) = 0.5
        _Amount("Wave Amount", Range(0, 1)) = 0.5
        _Scale("Scale", Range(0, 1)) = 0.5
        _Height("Wave Height", Range(0, 1)) = 0.1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

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

            sampler2D _MainTex, _NoiseTex;
            float4 _Color; 
            float4 _MainTex_ST;
            float _Speed, _Amount, _Height, _Scale; 

            v2f vert (appdata v)
            {
                v2f o;
                float4 tex = tex2Dlod(_NoiseTex, float4(v.uv.xy, 0, 0));
                float wave = _Height * sin(_Time.y * _Speed + ( v.vertex.x * v.vertex.z * _Amount * tex));
                v.vertex.y = wave ;


                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                // o.uv = TRANSFORM_TEX(v.uv, _MainTex);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture

                return tex2D(_MainTex, i.uv);
            }
            ENDCG
        }
    }
}
