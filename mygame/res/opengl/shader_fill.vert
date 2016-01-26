attribute vec4 a_position;
attribute vec4 a_color;
attribute vec2 a_texCoord0;
varying vec4 v_color;
varying vec2 v_texCoords;
uniform mat4 u_projTrans;


void main(void)
{
	v_color = vec4(0.0, 0.0, 0.0, 1.0 );
	v_texCoords = a_texCoord0;
	gl_Position = u_projTrans * a_position;
	
	//v_texCoords = gl_MultiTexCoord0;
	//gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
}
