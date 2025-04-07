#ifndef RGBCOLOR_H
#define RGBCOLOR_H

typedef struct {
    int r;
    int g;
    int b;
} RGBColor;

RGBColor hsvToRgb(float h, float s, float v);
float colorDistance(RGBColor a, RGBColor b);
RGBColor* generateColors(int count, RGBColor forbidden1, RGBColor forbidden2);

#endif // RGBCOLOR_H