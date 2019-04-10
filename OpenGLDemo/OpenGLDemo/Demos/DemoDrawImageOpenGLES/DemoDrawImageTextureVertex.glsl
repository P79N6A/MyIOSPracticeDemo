
attribute vec4 Position;
attribute vec2 TextureCoords;
varying vec2 TextureCoordsOut;

//uniform mat3 rotateXMatrix;
//uniform mat3 rotateYMatrix;
//uniform mat3 rotateZMatrix;
//uniform mat3 scaleMatrix;
uniform mat4 projectMatrix;
uniform mat4 viewTransformMatrix;

void main(void)
{
    gl_Position = projectMatrix*viewTransformMatrix*Position;
    //gl_Position = Position;
    TextureCoordsOut = TextureCoords;
}
