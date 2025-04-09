#include "rgbColor.h"
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

RGBColor hsvToRgb(float h, float s, float v) {
    float c = v * s;
    float x = c * (1 - fabsf(fmodf(h / 60.0f, 2) - 1));
    float m = v - c;

    float r_, g_, b_;
    if (h < 60)       { r_ = c; g_ = x; b_ = 0; }
    else if (h < 120) { r_ = x; g_ = c; b_ = 0; }
    else if (h < 180) { r_ = 0; g_ = c; b_ = x; }
    else if (h < 240) { r_ = 0; g_ = x; b_ = c; }
    else if (h < 300) { r_ = x; g_ = 0; b_ = c; }
    else              { r_ = c; g_ = 0; b_ = x; }

    RGBColor color;
    color.r = r_ + m;
    color.g = g_ + m;
    color.b = b_ + m;
    return color;
}

float colorDistance(RGBColor a, RGBColor b) {
    return sqrtf(
        (a.r - b.r) * (a.r - b.r) +
        (a.g - b.g) * (a.g - b.g) +
        (a.b - b.b) * (a.b - b.b)
    );
}

RGBColor* generateColors(int count, RGBColor forbidden1, RGBColor forbidden2) {
    RGBColor* colors = malloc(count * sizeof(RGBColor));
    if (!colors) return NULL;

    int i = 0, attempt = 0;
    while (i < count && attempt < count * 10) {
        float hue = fmodf((360.0f / count) * i + attempt * 13, 360.0f);
        RGBColor c = hsvToRgb(hue, 0.9f, 0.95f);
        if (colorDistance(c, forbidden1) > 0.2f && colorDistance(c, forbidden2) > 0.2f) {
            colors[i++] = c;
        }
        attempt++;
    }

    return colors;
}
