/*─────────────────────────────────────────────────────────────────────────
 *  cursor_synesthaxia.glsl  —  Ghostty custom-shader
 *
 *  Original author: Crackerfracks
 *  Source: https://github.com/Crackerfracks/Synesthaxia.glsl
 *
 *  Animated ghost cursor that tweens from origin to destination,
 *  sampling syntax highlight colors from the terminal framebuffer
 *  so the trail color matches whatever you're typing on.
 *
 *  Note: for full color inheritance, configure smear-cursor.nvim with
 *    require('smear_cursor').setup({ cursor_color = 'none' })
 *
 *  Tunables:
 *    DURATION      — tween time in seconds
 *    TRAIL_OPACITY — global alpha of trail (buggy, see source repo)
 *    EDGE_SOFT     — AA crispness (keep very low)
 *    GLOW_RADIUS   — halo thickness around tween cursor
 *    GLOW_INTENSITY— halo alpha multiplier
 *────────────────────────────────────────────────────────────────────────*/

const float DURATION      = 0.30;
const float TRAIL_OPACITY = 1.00;
const float CURVE_STRENGTH= 0.00;
const float EDGE_SOFT     = 0.001;
const float GLOW_RADIUS   = 0.002;
const float GLOW_INTENSITY= 0.90;
const float CURSOR_HIDE_AT= 1.00;

vec2 ndc(vec2 px, float isPos) {
    return (px * 2.0 - iResolution.xy * isPos) / iResolution.y;
}

float cover(float sd) {
    return clamp(0.5 - sd / EDGE_SOFT, 0.0, 1.0);
}

float ease(float t) {
    return 1.0 - pow(1.0 - t, 3.0);
}

float sdBox(vec2 p, vec2 c, vec2 b) {
    vec2 d = abs(p - c) - b;
    return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
}

float sdPara(vec2 p, vec2 v0, vec2 v1, vec2 v2, vec2 v3) {
    float w = 1.0;
    float d2 = dot(p - v0, p - v0);
    #define EDGE(A,B)                                                                  \
    {                                                                                  \
        vec2 e = B - A, wv = p - A;                                                   \
        vec2 proj = A + e * clamp(dot(wv, e) / dot(e, e), 0.0, 1.0);                 \
        d2 = min(d2, dot(p - proj, p - proj));                                        \
        float c0 = step(0.0, p.y - A.y);                                              \
        float c1 = 1.0 - step(0.0, p.y - B.y);                                       \
        float c2 = 1.0 - step(0.0, e.x * wv.y - e.y * wv.x);                        \
        float flip = mix(1.0, -1.0, step(0.5, c0 * c1 * c2 +                         \
                         (1.0 - c0) * (1.0 - c1) * (1.0 - c2)));                     \
        w *= flip;                                                                     \
    }
    EDGE(v0, v1) EDGE(v1, v2) EDGE(v2, v3) EDGE(v3, v0)
    #undef EDGE
    return w * sqrt(d2);
}

vec3 sampleFB(vec2 px) {
    return texture(iChannel0,
        clamp((px + 0.5) / iResolution.xy, vec2(0.0), vec2(1.0))).rgb;
}

void pickEdge(vec4 r, vec2 dir, bool origin, out vec2 aPx, out vec2 bPx) {
    vec2 N[4] = vec2[4](vec2(-1,0), vec2(1,0), vec2(0,-1), vec2(0,1));
    float best = origin ? -1e9 : 1e9;
    int idx = 0;
    for (int i = 0; i < 4; ++i) {
        float d = dot(dir, N[i]);
        if (origin ? d > best : d < best) { best = d; idx = i; }
    }
    vec2 TL = r.xy, TR = TL + vec2(r.z, 0.0);
    vec2 BL = TL - vec2(0.0, r.w), BR = TL + vec2(r.z, -r.w);
    if      (idx == 0) { aPx = TL; bPx = BL; }
    else if (idx == 1) { aPx = TR; bPx = BR; }
    else if (idx == 2) { aPx = TL; bPx = TR; }
    else               { aPx = BL; bPx = BR; }
}

float vividScore(vec3 c) {
    float vmax = max(max(c.r, c.g), c.b);
    float vmin = min(min(c.r, c.g), c.b);
    float sat  = vmax > 0.0 ? (vmax - vmin) / vmax : 0.0;
    return sat * vmax;
}

vec3 rectColor(vec4 r) {
    vec2 TL = r.xy, TR = TL + vec2(r.z, 0.0);
    vec2 BL = TL - vec2(0.0, r.w), BR = TL + vec2(r.z, -r.w);
    vec3 c0 = sampleFB(TL + vec2( 0.5, -0.5));
    vec3 c1 = sampleFB(TR + vec2(-0.5, -0.5));
    vec3 c2 = sampleFB(BL + vec2( 0.5,  0.5));
    vec3 c3 = sampleFB(BR + vec2(-0.5,  0.5));
    vec3 best = c0; float scr = vividScore(c0);
    float s1 = vividScore(c1); if (s1 > scr) { best = c1; scr = s1; }
    float s2 = vividScore(c2); if (s2 > scr) { best = c2; scr = s2; }
    float s3 = vividScore(c3); if (s3 > scr) { best = c3; }
    return best;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    fragColor = texture(iChannel0, fragCoord / iResolution.xy);

    vec4 cur = iCurrentCursor;
    vec4 prv = iPreviousCursor;
    vec2 dirPx = cur.xy - prv.xy;

    vec2 p0, p1, q0, q1;
    pickEdge(prv, dirPx,  true, p0, p1);
    pickEdge(cur, dirPx, false, q0, q1);

    vec2 v0 = ndc(p0, 1.0), v1 = ndc(p1, 1.0);
    vec2 v2 = ndc(q1, 1.0), v3 = ndc(q0, 1.0);
    vec2 P  = ndc(fragCoord, 1.0);

    float sdTrail = sdPara(P, v0, v1, v2, v3);
    float len     = length(v3 - v0);
    float tAlong  = clamp(dot(P - v0, (v3 - v0) / len), 0.0, 1.0);
    sdTrail /= (1.0 + CURVE_STRENGTH * (tAlong - 0.5) * 2.0);

    float rawProg = clamp((iTime - iTimeCursorChange) / DURATION, 0.0, 1.0);
    float prog    = ease(rawProg);
    float moving  = 1.0 - step(CURSOR_HIDE_AT, prog);

    vec2 tweenPx  = mix(prv.xy, cur.xy, prog);
    vec2 halfPx   = cur.zw * 0.5;
    vec2 centrePx = tweenPx + vec2(halfPx.x, -halfPx.y);
    vec2 centreN  = ndc(centrePx, 1.0);
    vec2 halfN    = ndc(halfPx, 0.0);
    float sdCursor = sdBox(P, centreN, halfN);

    vec3 colStart = rectColor(prv);
    vec3 colEnd   = rectColor(cur);
    vec3 colTrail = mix(colStart, colEnd, tAlong);
    vec3 colTween = mix(colStart, colEnd, prog);

    float trailVis = 1.0 - abs(1.0 - 2.0 * prog);
    float covTrail  = cover(sdTrail)  * TRAIL_OPACITY * trailVis;
    float covCursor = cover(sdCursor) * moving;
    float covGlow   = cover(sdCursor - GLOW_RADIUS) *
                      (1.0 - cover(sdCursor)) * GLOW_INTENSITY * moving;

    vec3 outRGB = fragColor.rgb;
    outRGB = mix(outRGB, colTrail, covTrail);
    outRGB = mix(outRGB, colTween, covGlow);
    outRGB = mix(outRGB, colTween, covCursor);
    fragColor.rgb = outRGB;
}
