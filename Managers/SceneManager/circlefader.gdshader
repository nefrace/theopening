shader_type canvas_item;

uniform vec2 center = vec2(0.5, 0.5);
uniform float radius;
uniform vec2 resolution = vec2(160.0, 144.0);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 uvres = UV * resolution;
	float dist = distance(uvres, center);
	COLOR.rgb = vec3(0.0);
	COLOR.a = step(radius, dist);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
