shader_type canvas_item;

void fragment() {
    vec2 q = SCREEN_UV;
    vec2 uv = 0.5 + (q-0.5)*(0.9 + 0.1*sin(0.2*TIME));

    vec3 oricol = texture( SCREEN_TEXTURE, vec2(q.x,q.y) ).xyz;
    vec3 col;

    col.r = texture(SCREEN_TEXTURE,vec2(uv.x+0.003, uv.y)).x;
    col.g = texture(SCREEN_TEXTURE,vec2(uv.x+0.000, uv.y)).y;
    col.b = texture(SCREEN_TEXTURE,vec2(uv.x-0.003, uv.y)).z;

    col = clamp(col*0.5+0.5*col*col*1.2,0.0,1.0);

    col *= 0.5 + 0.5*16.0*uv.x*uv.y*(1.0-uv.x)*(1.0-uv.y);

    col *= vec3(0.95,1.05,0.95);

    col *= 0.9+0.1*sin(10.0*TIME+uv.y*1000.0);

    col *= 0.99+0.01*sin(110.0*TIME);

    float comp = smoothstep( 0.2, 0.7, sin(TIME) );
    col = mix( col, oricol, clamp(-2.0+2.0*q.x+3.0*comp,0.0,1.0) );

    COLOR = vec4(col,1.0);
}