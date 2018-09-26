
attribute vec4 Position;
attribute vec2 TextureCoords;
varying vec2 TextureCoordsOut;

//uniform mat3 rotateXMatrix;
//uniform mat3 rotateYMatrix;
//uniform mat3 rotateZMatrix;
//uniform mat3 scaleMatrix;

void main(void)
{
    gl_Position = Position;
    //gl_Position = Position;
    TextureCoordsOut = TextureCoords;
}
