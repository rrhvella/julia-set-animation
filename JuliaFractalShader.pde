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
Class: JuliaFractalShader

Manages and stores the julia fractal shader program.
*/
public class JuliaFractalShader {
  private FragmentShader fragmentShader;

  private float cReal;
  private float cImaginary;
  
  /*
  Constructor: JuliaFractalShader
  */
  public JuliaFractalShader() {
    PGraphicsOpenGL pgl = (PGraphicsOpenGL) g;
    GL gl = pgl.beginGL();
      fragmentShader = new FragmentShader(gl, "fragmentshader.glsl");  
    pgl.endGL();
  }
  
  /*
  Constructor: setC
  
  Sets the value of the complex number c, in the complex iterative formula z(n + 1) = z(n)*z(n) + c.
  
  cReal - The value of the real part of c.
  cImaginary - The value of the imaginary part of c.
  */
  public void setC(float cReal, float cImaginary) {
    this.cReal = cReal;
    this.cImaginary = cImaginary;
  }
  
  public void draw() {    
    PGraphicsOpenGL pgl = (PGraphicsOpenGL) g;
    GL gl = pgl.beginGL();
      fragmentShader.loadShader(gl);
      fragmentShader.setUniformValue2f(gl, "c", cReal, cImaginary);
      fragmentShader.output(gl, 0, 0, width, height);
    pgl.endGL();
  }
}

