// this shader is applied to spatial nodes
shader_type spatial;

// specifies the field of view angle in degrees
uniform float FOV : hint_range(0.0, 180.0) = 70.0;

// sets the base color of the material
uniform vec4 albedo : source_color = vec4(1.0);
// specifies the albedo texture used for the material
uniform sampler2D texture_albedo : source_color, filter_nearest, repeat_enable;

// transforms vertex positions and sets up projection matrix
void vertex() {
    // calculate tangent of half the FOV angle
    float onetanfov = 1.0f / tan(.5f * (FOV * PI / 180.0f));
    // calculate aspect ratio based on viewport size
    float aspect = VIEWPORT_SIZE.x / VIEWPORT_SIZE.y;
    // modify the projection matrix to adjust FOV
    PROJECTION_MATRIX[1][1] = -onetanfov;
    PROJECTION_MATRIX[0][0] = onetanfov / aspect;

    // transform vertex position into clip space
    POSITION = PROJECTION_MATRIX * MODELVIEW_MATRIX * vec4(VERTEX.xyz, 1.0);
    // adjust z-coordinate to prevent clipping
    POSITION.z = mix(POSITION.z, 0.0, 0.999);
}

// calculates final color using albedo texture and color
void fragment() {
    // sample albedo texture at the current UV coordinate
    vec4 albedo_tex = texture(texture_albedo, UV);
    // multiply albedo color with texture color to get final color
    ALBEDO = albedo.rgb * albedo_tex.rgb;
}


