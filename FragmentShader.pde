/*
	Julia Set Animation
	-------------------

	Julia Set Animation - Copyright (c) 2010 Robert Vella - robert.r.h.vella@gmail.com

	This software is provided 'as-is', without any express or
	implied warranty. In no event will the authors be held
	liable for any damages arising from the use of this software.

	Permission is granted to anyone to use this software for any purpose,
	including commercial applications, and to alter it and redistribute
	it freely, subject to the following restrictions:

	1. The origin of this software must not be misrepresented;
	   you must not claim that you wrote the original software.
	   If you use this software in a product, an acknowledgment
	   in the product documentation would be appreciated but
	   is not required.

	2. Altered source versions must be plainly marked as such,
	   and must not be misrepresented as being the original software.

	3. This notice may not be removed or altered from any
	   source distribution.
*/

/*
Class: FragmentShader

Takes care of compiling, loading and managing fragment shader code.
*/
class FragmentShader {  
  private int programObject;  
  private int fs;


  /*
  Private Method: loadFragmentShader
  
  Loads and compiles a fragment shader from a file.
  
  gl - Pointer to the open gl object which is being used to render the scene.
  fragmentShaderFile - Location of the file containing the fragment shader code.
  
  Note: In case of an error, log information is dumped to the console.
  
  */
  private void loadFragmentShader(GL gl, String fragmentShaderFile)  {
    String shaderSource=join(loadStrings(fragmentShaderFile),"\n");

    fs = gl.glCreateShaderObjectARB(GL.GL_FRAGMENT_SHADER_ARB);
  
    gl.glShaderSourceARB(fs, 1, new String[]{shaderSource}, (int[]) null, 0);
    gl.glCompileShaderARB(fs);

    
    IntBuffer iVal = BufferUtil.newIntBuffer(1);
    gl.glGetObjectParameterivARB(fs, GL.GL_OBJECT_INFO_LOG_LENGTH_ARB, iVal);

    int length = iVal.get();

    if (length <= 1) {
      return;
    }

    ByteBuffer infoLog = BufferUtil.newByteBuffer(length);
    iVal.flip();
    
    gl.glGetInfoLogARB(fs, length, iVal, infoLog);
    byte[] infoBytes = new byte[length];
    
    infoLog.get(infoBytes);
    println("GLSL Validation >> " + new String(infoBytes));

    gl.glAttachObjectARB(programObject, fs);  
  }
  
  

  /*
  Constructor: FragmentShader
  
  gl - Pointer to the open gl object which is being used to render the scene.
  fragmentShaderFile - Location of the file containing the fragment shader code.
  */
  public FragmentShader(GL gl, String fragmentShaderFile) {  
    programObject = gl.glCreateProgramObjectARB();  
  
    loadFragmentShader(gl, fragmentShaderFile);
    
    gl.glLinkProgramARB(programObject);
    gl.glValidateProgramARB(programObject);
  }

  /*
  Method: setUniformValue[x][y] where [x] is the number of variables and [y] is the variable type (i for integer, f for float)
  
  Writes one or more (in the case of an array) values to a variable in the shader. 
  
  gl - Pointer to the open gl object which is being used to render the scene.
  variableName - The name of the shader variable you wish to set.
  ... - The values you wish to write to the variable.
  
  Note: the shader should be loaded before any variables are set.
  
  */
  public void setUniformValue1i(GL gl, String variableName, int v0) {
    gl.glUniform1i(gl.glGetUniformLocationARB(programObject, variableName), v0);
  }

  public void setUniformValue2f(GL gl, String variableName, float v0, float v1) {
    gl.glUniform2f(gl.glGetUniformLocationARB(programObject, variableName), v0, v1);
  }

  public void setUniformValue4f(GL gl, String variableName, float v0, float v1, 
      float v2, float v3) {
    gl.glUniform4f(gl.glGetUniformLocationARB(programObject, variableName), v0, v1, v2, v3);
  }
  
  /*
  Method: loadShader

  Initiates the shader for variable assignment.
    
  gl - Pointer to the open gl object which is being used to render the scene.
  
  */
  void loadShader(GL gl)  {
    gl.glUseProgramObjectARB(programObject);  
  }
   
   
  /*
  Method: output

  Renders the shader onto a rectangular surface.
  
  gl - Pointer to the open gl object which is being used to render the scene.
  
  The following dimensions refer to the rectangular surface where the shader is rendered.

  x - The x position of the top left corner.
  y - The y position of the top left corner.
  
  pWidth - The width of the rectangular surface.
  pHeight - The height of the rectangular surface.
  
  */
  public void output(GL gl, float x, float y, float pWidth, float pHeight) {    
    gl.glClear(GL.GL_COLOR_BUFFER_BIT | GL.GL_DEPTH_BUFFER_BIT);
    
    gl.glBegin(GL.GL_QUADS);
      gl.glTexCoord2f(0, 0); gl.glVertex2f(0, pHeight); 
      gl.glTexCoord2f(1, 0); gl.glVertex2f(pWidth, pHeight); 
      gl.glTexCoord2f(1, 1); gl.glVertex2f(pWidth, 0); 
      gl.glTexCoord2f(0, 1); gl.glVertex2f(0, 0); 
    gl.glEnd();  
    gl.glUseProgramObjectARB(0);     
  }
} 




