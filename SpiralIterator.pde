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
Class: SpiralIterator

Generates a series of values which make up the points on a spiral which revolves inward;y and outwardly ad infinitum.
*/
class SpiralIterator {
  int spiralDetail;
  
  int angularIndex;
  int radialIndex;
  
  int radialIncrement;
  
  float radialMultiplier;
  float angleMultiplier;
  
  float maxRadius;
 
  /*
    Constructor: SpiralIterator
  
    spiralDetail - The number of calls it takes for the spiral to perform a complete revolution.
    maxRadius - The maximum radius, which also corresponds to the initial radius of the spiral.
  */
  SpiralIterator(int spiralDetail, float maxRadius) {
    this.spiralDetail = spiralDetail;
    
    this.radialIndex = spiralDetail;
    this.angularIndex = spiralDetail;
  
    this.radialIncrement = 1;
  
    this.radialMultiplier = maxRadius / spiralDetail;
    this.angleMultiplier = TWO_PI / spiralDetail;
    
    this.maxRadius = maxRadius;
  }
  
  /*
    Method: next
  
    Returns the next coordinate in the spiral.
  */
  PVector next() {
    float angle = angularIndex * angleMultiplier;
    float radius = radialIndex * radialMultiplier;
    
    float x = sin(angle) * radius;
    float y = cos(angle) * radius;
       
    radialIndex += radialIncrement;
    angularIndex++;
    
    if(angularIndex > spiralDetail) {
      angularIndex = 0;
    }
    
    
    if(radialIndex >= spiralDetail) {
      radialIndex = spiralDetail;
      radialIncrement *= -1;    
      
    } if(radialIndex <= 0)  {
      radialIndex = 0;
      radialIncrement *= -1;
      //Complement angular index
      angularIndex = spiralDetail / 2;  
    }
 
    return new PVector(x, y);      
  }
}
