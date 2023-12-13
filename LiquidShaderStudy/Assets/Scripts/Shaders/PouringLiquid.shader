Shader "Unlit/PouringLiquid"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _NoiseTex ("Extra Wave Noise", 2D) = "white" {}
        
        _ColorA ("Tint A", Color) = (1,1,1,1)
        _ColorB ("Tint B", Color) = (1,1,1,1)
        _RimColor ("Rim Color", Color) = (1,1,1,1)

        _Speed("Wave Speed", Range(0, 1)) = 0.5
        _Amount("Wave Amount", Range(0, 1)) = 0.5
        _Height("Wave Height", Range(0, 1)) = 0.1
    }
    SubShader
    {
        Tags 
        { 
            "RenderType"="Transparent"
            "Queue" = "Transparent"
        }

        Blend SrcAlpha OneMinusSrcAlpha 
        Cull Off

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            sampler2D _MainTex, _NoiseTex;
            float4 _ColorA;
            float4 _ColorB;
            float4 _RimColor;

            float _Speed, _Amount, _Height;

            struct MeshData
            {
                float4 vertex : POSITION;
                float2 uv0 : TEXCOORD0;
                float3 normals : NORMAL;
            };

            struct Interpolators
            {
                float2 uv : TEXCOORD1;
                float4 vertex : SV_POSITION;
                float3 normal : TEXCOORD0;
            };

            

            Interpolators vert (MeshData v)
            {
                Interpolators o;

                float4 tex = tex2Dlod(_NoiseTex, float4(v.uv0.xy, 0, 0));

                // v.vertex += sin(_Time.y * 1 + (v.vertex.x * v.vertex.z * 1 )) * 1;  //Setting the vertex animation for wave sim
                v.vertex.x += sin(_Time.y * _Speed + (v.vertex.y * v.vertex.x * _Amount * tex)) * _Height;  //Setting the vertex animation for wave sim

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = UnityObjectToWorldNormal(v.normals);


                o.uv = v.uv0;
                return o;
            }

            fixed4 frag (Interpolators i, fixed facing : VFACE) : SV_Target
            {

                float3 worldNormal = mul( unity_ObjectToWorld, float4( i.normal, 0.0 ) ).xyz;
                // rim light              
                float fresnel = pow(1 - saturate(worldNormal), 5);          
                float4 RimResult = fresnel * _RimColor;
                RimResult *= _RimColor;
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);

                col *= _ColorA;

                float xOffset = cos(i.uv.y * 2) * 0.01;
                float t = cos( (i.uv.x + xOffset) * 1 - _Time.y * 10) * 0.5 + 0.5;
                float j = cos( (i.uv.x + col) * 5 - _Time.y * 5) * 0.5 + 0.5;
                
                j  = saturate(j) * col.a;

                // t += saturate(_Color);

                return lerp(_ColorA, _ColorB, t);
            }
            ENDCG
        }
    }
}
