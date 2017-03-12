#version 330 core

// Interpolated values from the vertex shaders
in vec2 fragmentUV;

// Values that stay constant
uniform sampler2D myTextureSamplerVolume;
uniform float rotationAngle;
uniform float isoValue;


// Ouput data
out vec3 color;

// Input: z coordinate of the point in the volume, between 0 and 1
// Output: grid coordinates (i,j) of the slice where the point lies, between (0,0) and (9,9)
// Warning: use the fonction "floor" to make sure that the coordinates of the slice are integer. For instance, for z = 0.823, the function should return (i=2,j=8) because the closest slice is the 82nd one.
vec2 slice_coordinate(float z)
{
      //rescale z
      float z2 = z*100.;

      //coordinate of the slice
      float j = floor(z2 / 10.);
      float i = floor(mod(z2, 10.));

      return vec2(i,j);
}

// Input: (x,y,z) coordinates of the point in the volume, between (0,0,0) and (1,1,1)
// Output: (u,v) coordinates of the pixel in the texture
vec2 pixel_coordinate(float x, float y, float z)
{
      vec2 sliceCoord = slice_coordinate(z);

      //coordinate of the pixel in the slice
      float u = x/10.;
      float v = y/10.;

      return vec2(u,v)+slice_coordinate(z)/10.;
}

void main()
{ 
      vec2 pixCoord;
      float x,y,z;

      // //extract one horizontal slice (x and y vary with fragment coordinates, z is fixed)
      // x = fragmentUV.x;
      // y = fragmentUV.y;
      // z = 82./100.; //extract 82nd slice
      // pixCoord = pixel_coordinate(x,y,z);
      // color = texture(myTextureSamplerVolume, pixCoord).rgb;

/*     
      //Accumulate all horizontal slices 
      x = fragmentUV.x;
      y = fragmentUV.y;
      color = vec3(0.,0.,0.);
      for (int zindex = 0; zindex<100; zindex++){
        pixCoord = pixel_coordinate(x,y,zindex/100.);
        color += texture(myTextureSamplerVolume, pixCoord).rgb;
      }
      color /= 100.;
*/


/*
      //extract one vertical slice (x and z vary with fragment coordinates, y is fixed)
      x = fragmentUV.x;
      z = fragmentUV.y;
      pixCoord = pixel_coordinate(x, 82./256.,z);
      color = texture(myTextureSamplerVolume, pixCoord).rgb;
*/
 
/*
      //Accumulate all vertical slices 
      x = fragmentUV.x;
      z = fragmentUV.y;
      color = vec3(0.,0.,0.);
      for (int yindex = 0; yindex<256; yindex++){
        pixCoord = pixel_coordinate(x,yindex/256.,z);
        color += texture(myTextureSamplerVolume, pixCoord).rgb;
      }
      color /= 100.;
*/

      //Accumulate all vertical slices after rotation by rotationAngle around the z axis
      // float rotationAngle = 1.5;
/*
      x = fragmentUV.x;
      z = fragmentUV.y;
      color = vec3(0.,0.,0.);
      float xrot, yrot;
      for (int yindex=0; yindex<256; yindex++) {
        y = yindex/256.;
        // We center the coordinates, then apply the rotation, and finally translate it back
        xrot= (x-0.5)*cos(rotationAngle) - sin(rotationAngle)*(y-0.5)+0.5;
        yrot= (x-0.5)*sin(rotationAngle) + cos(rotationAngle)*(y-0.5)+0.5;
        pixCoord = pixel_coordinate(xrot,yrot,z);
        if ((xrot >= 0.) && (yrot >= 0.) && (xrot <= 1.) && (yrot <= 1.)) {
          color +=  texture(myTextureSamplerVolume, pixCoord).rgb;  
        }
      } 
      color /= 256.;
*/



      //Ray marching until density above a threshold (i.e., extract an iso-surface)
      //float isoValue = 0.7;

      x = fragmentUV.x;
      y = 1.;
      z = fragmentUV.y;
      color = vec3(0.,0.,0.);

      pixCoord = pixel_coordinate(x,y,z);

      while (texture(myTextureSamplerVolume, pixCoord).rgb.x < isoValue && y >= 0)
      {
        y -= 1./256;
        pixCoord = pixel_coordinate(x,y,z);
      }
      if(y>0)
      {
        color = vec3(1.,1.,1.);
      }

/*
     //Ray marching until density above a threshold, display iso-surface normals
     //...
*/

  
/* 
    //Ray marching until density above a threshold, display shaded iso-surface
    //...
*/


}