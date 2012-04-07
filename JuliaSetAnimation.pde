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

	3. This notice may not be remosuved or altered from any
	   source distribution.
*/

import javax.media.opengl.GL;
import javax.media.opengl.glu.GLU;
import com.sun.opengl.util.BufferUtil;
import java.nio.*;
import processing.opengl.PGraphicsOpenGL;
import processing.video.*;

final float COMPLEX_ORIGIN_REAL = -0.5;
final float COMPLEX_ORIGIN_IMAGINARY = -0.5;

final int INNER_SPIRAL_DETAIL = 1000;
final int OUTER_SPIRAL_DETAIL = 500;

final float INNER_SPIRAL_RADIUS = 0.5f;
final float OUTER_SPIRAL_RADIUS = 1.25f;

SpiralIterator outerSpiral;
SpiralIterator innerSpiral;

JuliaFractalShader JuliaFractalShader;

void setup() { 
  size(860, 752, OPENGL);  
  colorMode(1, 1, 1, RGB);
  
  outerSpiral = new SpiralIterator(OUTER_SPIRAL_DETAIL, OUTER_SPIRAL_RADIUS);
  innerSpiral = new SpiralIterator(INNER_SPIRAL_DETAIL, INNER_SPIRAL_RADIUS);
  
  JuliaFractalShader = new JuliaFractalShader();   

}

void update() {
  
  PVector innerVector = innerSpiral.next();
  
  PVector outerVector = outerSpiral.next();  
  
  float real = innerVector.x + outerVector.x + COMPLEX_ORIGIN_REAL; 
  float imaginary = innerVector.y + outerVector.y + COMPLEX_ORIGIN_IMAGINARY;
  
  JuliaFractalShader.setC(real, imaginary);
}

void draw() {
  background(0);
  update();
  JuliaFractalShader.draw();
}
