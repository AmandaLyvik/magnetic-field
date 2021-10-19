Shader "Unlit/Field"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _dipolePosition ("Dipole Position", Vector) = (0, 0, 0, 0)
        _dipoleMoment ("Dipole Moment", Vector) = (1, 0, 0, 0)
        _strength ("Strength", Float) = 1
    }
    SubShader
    {
        Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
        ZWrite Off
        Blend SrcAlpha OneMinusSrcAlpha
        Cull front 
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
            };

            struct v2f
            {
                float4 world : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            float4 _dipoleMoment;
            float4 _dipolePosition;
            float _strength;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.world = mul (unity_ObjectToWorld, v.vertex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float3 r = i.world - _dipolePosition.xyz;
                float3 b = _strength * (r * (dot(r, _dipoleMoment)) / pow(length(r), 5) - _dipoleMoment / pow(length(r), 3));
                // sample the texture
                fixed4 col = float4(b.x, b.y, b.z, 0.5);
                col = float4(1, 0, 0, 1);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
