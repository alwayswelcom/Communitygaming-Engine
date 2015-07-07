#version 330 core

struct			light
{
	vec3		position;
	vec3		ambient;
	vec3		diffuse;
	vec3		specular;
	float		shininess;
};

struct			material
{
	vec4		ambiant;
};

in vec3			vertexPos;
in vec3			vertexNormal;
in vec4			vertexColor;

out vec4		color;

#define MAX_LIGHTS 64
uniform	int		numLights;
uniform	vec3	eyePos;
uniform	light	lights[MAX_LIGHTS];

void main()
{
	vec4 sceneColor = vec4( 0, 0, 0, 1 );
	vec4 matAmbient = vec4( 1, 1, 1, 1 );
	vec4 matDiffuse = vec4( 1, 1, 1, 1 );
	vec4 matSpecular = vec4( 1, 1, 1, 1 );
	float matShininess = 1;

	vec3 N = normalize( vertexNormal );

	vec4 final_color = vec4( 0, 0, 0, 1 );

	for ( int i = 0; i < numLights; i++ )
	{
		final_color += sceneColor * matAmbient + vec4( lights[i].ambient, 1 ) * matAmbient;

		vec3 L = normalize( lights[i].position - vertexPos );

		float lambertTerm = dot( N, L );

		if ( lambertTerm > 0.0 )
		{
			final_color += vec4( lights[i].diffuse, 1 ) * matDiffuse * lambertTerm;

			vec3 E = normalize( eyePos - vertexPos );
			vec3 R = reflect( -L, N );
			float specular = pow( max( dot( R, E ), 0.0 ), matShininess * lights[i].shininess );
			final_color += vec4( lights[i].specular, 1 ) * matSpecular * specular;
		}
	}
	color = final_color;
}

//void main()
//{
//	vec3 N = normalize( vertexNormal );
//	vec3 finalColor = vec3( 0.0, 0.0, 0.0 );
//
//	for ( int i = 0; i < numLights; i++ )
//	{
//		vec3 L = normalize( lights[i].position - vertexPos );
//		vec3 E = normalize( eyePos - vertexPos );
//		vec3 R = normalize( reflect( -L, N ) );
//
//		//calculate Ambient Term:
//		vec3 Iamb = lights[i].ambient; //ambient
//
//		//calculate Diffuse Term:
//		float diffuseFactor = max( dot( L, N ), 0.0 );
//		vec3 Idiff = lights[i].diffuse * diffuseFactor; //difuse
//
//		// calculate Specular Term:
//		vec3 Ispec = vec3( 0, 0, 0 );
//		if ( diffuseFactor > 0.0 )
//		{
//			vec3 halfDir = normalize( L + E );
//			float specAngle = max( dot( halfDir, N ), 0.0 );
//			float specularFactor = pow( specAngle, lights[i].shininess );
//			Ispec = lights[i].specular * specularFactor; //specular
//		}
////		float r = 5.0;
////		float cutoff = 0.00;
//		L = lights[i].position - vertexPos;
//		float distance = length( L );
////		float d = max( distance - r, 0.0 );
////		L /= distance;
////
////		// calculate basic attenuation
////		float denom = d / r + 1;
////		float attenuation = 1 / ( denom * denom );
////
////		// scale and bias attenuation such that:
////		//	attenuation == 0 at extent of max influence
////		//	attenuation == 1 when d == 0
////		attenuation = ( attenuation - cutoff ) / ( 1 - cutoff );
////		attenuation = max(attenuation, 0 );
//
////		float dot = max( dot( L, N ), 0 );
////		finalColor += ( Iamb + Idiff + Ispec ) * ( 10 / distance );// * attenuation;
//	}
//	color = vec4( finalColor, 1 ) * vertexColor;
////	color = vec4( ambiantColor, 1 ) * vertexColor;
//}
