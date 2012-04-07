#version 130

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

uniform vec2 c;

vec4 COMPLEX_PLANE_BOUNDARIES = vec4(-2.0, 2.0, -2.0, 2.0);

int MAX_ESCAPE_TIME = 500;

float HUE_FROM = 0;
float HUE_TO = 75;

float ESCAPE_TRESHOLD = 4.0;

float CURVE_EXP = 14;
float CURVE_MULTIPLIER = 2;

float SATURATION = 1;
/*
Function: iterativeFunction

Returns z(n)*z(n) + c
*/
vec2 iterativeFunction(vec2 z, vec2 c) {
	//x = z*z
	vec2 x;
	
	x[0] = z[0] * z[0] - z[1] * z[1];
	x[1] = z[0] * z[1] + z[0] * z[1];
	
	//result = x + c
	vec2 result;
	
	result[0] = x[0] + c[0];
	result[1] = x[1] + c[1];
	
	return result;
}


/*
Function: Converts an HSB value to RGB.

h - The hue (from 0 to 360).
s - The saturation level.
b - The brightness level. 

Returns the color in rgb.
*/

vec4 hsbToRGB(float h, float s, float b) {
	float hOver60 = (mod(h, 360) / 60);

	int sector = int(hOver60);
	float chromacity = b * s;

	float x = chromacity * (1 - abs(mod(hOver60, 2.0) - 1));

	vec4 result = vec4(0,0,0,1);


	switch(sector) {
		case 0:
			result[0] = chromacity;
			result[1] = x;
			break;
		case 1:
			result[0] = x;
			result[1] = chromacity;
			break;
		case 2:
			result[1] = chromacity;
			result[2] = x;
			break;
		case 3:
			result[1] = x;
			result[2] = chromacity;
			break;
		case 4:
			result[0] = x;
			result[2] = chromacity;
			break;
		case 5:
			result[0] = chromacity;
			result[2] = x;
				break;
	}


	return result + (b - chromacity);
}


/*
Function: curve

Gives the height of an exponential curve at position x.

x - The position which will be tested.
xOffset - The x offset of the curve.
yOffset - The y offset of the curve.
exponent - The exponent of the curve.
multiplier - The multiplier applied to the curve.

Note: 
	The exponent is also applied to the multiplier.
*/
float curve(float x, float xOffset, float yOffset,
	       	float exponent, float multiplier) {
	return -pow(multiplier, exponent)*pow(x - xOffset, exponent) + yOffset;
}

/*
Function: getColor

z - The initial value of z(n) in the iterative formula z(n)*z(n) + c.

Returns the color which corresponds to this value of z.
*/
vec4 getColor(vec2 z) {
	//Get number of iterations
	z = iterativeFunction(z, c);
	
	int iterations = 0;
	for(; iterations < MAX_ESCAPE_TIME; iterations++) {
		if(z[0]*z[0] + z[1]*z[1] > ESCAPE_TRESHOLD) {
			break;
		}
		
		z = iterativeFunction(z, c);
	}
	
	int escapeTime = MAX_ESCAPE_TIME;
	
	if(iterations < MAX_ESCAPE_TIME) {
		escapeTime = iterations;
	}

	//Convert escape time to color and shade.
	float shadeAdjustment = log2(log(z[0]*z[0] + z[1]*z[1]));
	float power = curve(float(escapeTime - shadeAdjustment) 
					/ MAX_ESCAPE_TIME, 0.5, 1, 
				CURVE_EXP, CURVE_MULTIPLIER);

	float hue = HUE_FROM + (HUE_TO - HUE_FROM) * power;

	return hsbToRGB(hue, SATURATION, power);
}


/*
Function: convertToComplex

texCoord - Texture coordinate you wish to convert to complex number.

Returns the complex number which corresponds to [texCoord].  */
vec2 convertToComplex(vec4 texCoord) {
	return vec2(COMPLEX_PLANE_BOUNDARIES[0] + texCoord.x * 
		(COMPLEX_PLANE_BOUNDARIES[1] - COMPLEX_PLANE_BOUNDARIES[0]),
		COMPLEX_PLANE_BOUNDARIES[2] + texCoord.y * 
		(COMPLEX_PLANE_BOUNDARIES[3] - COMPLEX_PLANE_BOUNDARIES[2]));
}


void main() {	
 	gl_FragColor = getColor(convertToComplex(gl_TexCoord[0]));
} 
