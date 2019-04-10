attribute vec3 position;
attribute vec3 color;
attribute vec2 texcoord;

varying vec2 v_texcoord;

uniform mat3 rotateXMatrix;
uniform mat3 rotateYMatrix;
uniform mat3 rotateZMatrix;
uniform mat3 scaleMatrix;
void main()
{
    gl_Position = vec4(rotateXMatrix*rotateYMatrix*rotateZMatrix*position,1.0);
    v_texcoord = texcoord;
}
