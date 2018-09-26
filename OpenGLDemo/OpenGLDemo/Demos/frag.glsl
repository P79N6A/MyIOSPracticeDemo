precision mediump float;

varying vec2 v_texcoord;

//yuv type
uniform int yuvType;//0 is i420, 1 is nv12, 2 is pixelbuffer

uniform sampler2D yPlane;
uniform sampler2D uPlane;
uniform sampler2D vPlane;
uniform sampler2D samplerY;
uniform sampler2D samplerUV;

void main()
{
    if (yuvType == 0) {
        highp float y = texture2D(yPlane, v_texcoord).r;
        highp float u = texture2D(uPlane, v_texcoord).r - 0.5;
        highp float v = texture2D(vPlane, v_texcoord).r - 0.5;
        
        highp float r = y + 0.000     + 1.402 * v;
        highp float g = y - 0.344 * u - 0.714 * v;
        highp float b = y + 1.772 * u;
        
        gl_FragColor = vec4(r, g, b, 1.0);
    }
    else if(yuvType == 1)
    {
        //todo:
    }
    else if(yuvType == 2)
    {
        mediump vec3 yuv;
        lowp vec3 rgb;
        vec2 toptexcoord;
        vec2 bottomtexcoord;
        toptexcoord = vec2(v_texcoord.x/2.0,v_texcoord.y);
        bottomtexcoord = vec2((v_texcoord.x/2.0 + 0.5),v_texcoord.y);
        yuv.x = texture2D(samplerY, toptexcoord).r;
        yuv.yz = (texture2D(samplerUV, toptexcoord).rg - vec2(0.5, 0.5));
        rgb = mat3(1.0, 1.0, 1.0,
                   0.0, -0.344, 1.772,
                   1.402, -0.714, 0.0) * yuv;
        gl_FragColor = vec4(rgb,texture2D(samplerY, bottomtexcoord).r);
    }

}
