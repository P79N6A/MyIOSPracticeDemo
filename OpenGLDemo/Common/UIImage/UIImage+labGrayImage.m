//
//  UIImage+labGrayImage.m
//  QZCommonLib
//
//  Created by huiping on 16/7/25.
//  Copyright © 2016年 enigmaliang. All rights reserved.
//

#import "UIImage+labGrayImage.h"

#pragma pack (1)
struct qzoneRgbaPixel
{
    uint8_t Alpha;
    uint8_t Blue;
    uint8_t Green;
    uint8_t Red;
};
#pragma pack ()

static void mixRgbColor(struct qzoneRgbaPixel* foregroundColor, struct qzoneRgbaPixel* backgroundColor, struct qzoneRgbaPixel* resultColor)
{
    if (foregroundColor == NULL || backgroundColor == NULL || resultColor == NULL)
    {
        return;
    }
    
    CGFloat foregroundAlpha = foregroundColor->Alpha / 255.0, backgroundAlpha = (backgroundColor->Alpha / 255.0);
    
    CGFloat tmpAlpha = 1.0 - (1.0 - foregroundAlpha) * (1.0 - (backgroundAlpha));
    CGFloat tmpRed = foregroundColor->Red * foregroundAlpha + backgroundColor->Red * (backgroundAlpha) * (1 - foregroundAlpha);
    CGFloat tmpGreen = foregroundColor->Green * foregroundAlpha + backgroundColor->Green * (backgroundAlpha) * (1 - foregroundAlpha);
    CGFloat tmpBlue = foregroundColor->Blue * foregroundAlpha + backgroundColor->Blue * (backgroundAlpha) * (1 - foregroundAlpha);
    
    resultColor->Alpha = round(tmpAlpha * 255.0);
    resultColor->Red = round(tmpRed / tmpAlpha);
    resultColor->Green = round(tmpGreen / tmpAlpha);
    resultColor->Blue = round(tmpBlue / tmpAlpha);
}

/** rgb2lab
 *  RGB颜色转换为LAB颜色
 *
 *  RGB to XYZ - using http://www.easyrgb.com/index.php?X=MATH&H=02#text2
 *  XYZ to LAB - using http://www.easyrgb.com/index.php?X=MATH&H=07#text7
 **/
void rgb2lab( CGFloat R, CGFloat G, CGFloat B, CGFloat *l_s, CGFloat *a_s, CGFloat *b_s )
{
    float var_R = R/255.0;
    float var_G = G/255.0;
    float var_B = B/255.0;
    
    
    if ( var_R > 0.04045 ) var_R = pow( (( var_R + 0.055 ) / 1.055 ), 2.4 );
    else                   var_R = var_R / 12.92;
    if ( var_G > 0.04045 ) var_G = pow( ( ( var_G + 0.055 ) / 1.055 ), 2.4);
    else                   var_G = var_G / 12.92;
    if ( var_B > 0.04045 ) var_B = pow( ( ( var_B + 0.055 ) / 1.055 ), 2.4);
    else                   var_B = var_B / 12.92;
    
    var_R = var_R * 100.;
    var_G = var_G * 100.;
    var_B = var_B * 100.;
    
    //Observer. = 2°, Illuminant = D65
    float X = var_R * 0.4124 + var_G * 0.3576 + var_B * 0.1805;
    float Y = var_R * 0.2126 + var_G * 0.7152 + var_B * 0.0722;
    float Z = var_R * 0.0193 + var_G * 0.1192 + var_B * 0.9505;
    
    
    float var_X = X / 95.047 ;         //ref_X =  95.047   Observer= 2°, Illuminant= D65
    float var_Y = Y / 100.000;          //ref_Y = 100.000
    float var_Z = Z / 108.883;          //ref_Z = 108.883
    
    if ( var_X > 0.008856 ) var_X = pow(var_X , ( 1./3. ) );
    else                    var_X = ( 7.787 * var_X ) + ( 16. / 116. );
    if ( var_Y > 0.008856 ) var_Y = pow(var_Y , ( 1./3. ));
    else                    var_Y = ( 7.787 * var_Y ) + ( 16. / 116. );
    if ( var_Z > 0.008856 ) var_Z = pow(var_Z , ( 1./3. ));
    else                    var_Z = ( 7.787 * var_Z ) + ( 16. / 116. );
    
    *l_s = ( 116. * var_Y ) - 16.;
    *a_s = 500. * ( var_X - var_Y );
    *b_s = 200. * ( var_Y - var_Z );
}

/** lab2rgb
 *  LAB颜色转换为RGB颜色
 *
 *  LAB to XYZ - using http://www.easyrgb.com/index.php?X=MATH&H=08#text8
 *  XYZ to LAB - using http://www.easyrgb.com/index.php?X=MATH&H=01#text1
 **/
void lab2rgb( CGFloat l_s, CGFloat a_s, CGFloat b_s, CGFloat *R, CGFloat *G, CGFloat *B )
{
    float var_Y = ( l_s + 16. ) / 116.;
    float var_X = a_s / 500. + var_Y;
    float var_Z = var_Y - b_s / 200.;
    
    if ( pow(var_Y,3) > 0.008856 ) var_Y = pow(var_Y,3);
    else                      var_Y = ( var_Y - 16. / 116. ) / 7.787;
    if ( pow(var_X,3) > 0.008856 ) var_X = pow(var_X,3);
    else                      var_X = ( var_X - 16. / 116. ) / 7.787;
    if ( pow(var_Z,3) > 0.008856 ) var_Z = pow(var_Z,3);
    else                      var_Z = ( var_Z - 16. / 116. ) / 7.787;
    
    float X = 95.047 * var_X ;    //ref_X =  95.047     Observer= 2°, Illuminant= D65
    float Y = 100.000 * var_Y  ;   //ref_Y = 100.000
    float Z = 108.883 * var_Z ;    //ref_Z = 108.883
    
    
    var_X = X / 100. ;       //X from 0 to  95.047      (Observer = 2°, Illuminant = D65)
    var_Y = Y / 100. ;       //Y from 0 to 100.000
    var_Z = Z / 100. ;      //Z from 0 to 108.883
    
    float var_R = var_X *  3.2406 + var_Y * -1.5372 + var_Z * -0.4986;
    float var_G = var_X * -0.9689 + var_Y *  1.8758 + var_Z *  0.0415;
    float var_B = var_X *  0.0557 + var_Y * -0.2040 + var_Z *  1.0570;
    
    if ( var_R > 0.0031308 ) var_R = 1.055 * pow(var_R , ( 1 / 2.4 ))  - 0.055;
    else                     var_R = 12.92 * var_R;
    if ( var_G > 0.0031308 ) var_G = 1.055 * pow(var_G , ( 1 / 2.4 ) )  - 0.055;
    else                     var_G = 12.92 * var_G;
    if ( var_B > 0.0031308 ) var_B = 1.055 * pow( var_B , ( 1 / 2.4 ) ) - 0.055;
    else                     var_B = 12.92 * var_B;
    
    *R = var_R * 255.;
    *G = var_G * 255.;
    *B = var_B * 255.;
}

@implementation UIImage (labGrayImage)

- (UIImage*)labGrayImage
{
    size_t width = CGImageGetWidth(self.CGImage);
    size_t height = CGImageGetHeight(self.CGImage);
    
    struct qzoneRgbaPixel* imageData = (struct qzoneRgbaPixel*)malloc(width * height * sizeof(imageData[0]));
    if (imageData == NULL)
    {
        //QZCOMMON_LOG_ERROR(NULL, "QZCreateCGImageWithLightnessChannelWithAlpha: malloc imageData failed.");
        return NULL;
    }
    memset(imageData, 0, width * height * sizeof(imageData[0]));//必须清空，这样可以保留alpha信息
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    if (colorSpace == NULL)
    {
        //QZCOMMON_LOG_ERROR(NULL, "QZCreateCGImageWithLightnessChannelWithAlpha: CGColorSpaceCreateDeviceRGB() failed.");
        free(imageData);
        return NULL;
    }
    
    CGContextRef context = CGBitmapContextCreate(imageData, width, height, 8, width * sizeof(imageData[0]), colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
    if (context == NULL)
    {
        //QZCOMMON_LOG_ERROR(NULL, "QZCreateCGImageWithLightnessChannelWithAlpha: CGBitmapContextCreate() failed.");
        free(imageData);
        CGColorSpaceRelease(colorSpace);
        return NULL;
    }
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), [self CGImage]);
    
    for(int y = 0; y < height; y++)
    {
        for(int x = 0; x < width; x++)
        {
            struct qzoneRgbaPixel *pixel = &imageData[y * width + x];
            
            if (pixel->Red != 0 || pixel->Green != 0 || pixel->Blue != 0 || pixel->Alpha != 0)
            {
                //--- 图层1：取原图Lab颜色模式的明度通道（L通道）作为颜色数据，原图Alpha通道的ratio倍（目前是90%）作为Alpha通道数据，数据放入layerLightnessPixel ---
                struct qzoneRgbaPixel layerLightnessPixel;
                
                //rgb模式的颜色转lab模式的颜色
                CGFloat L = 0, a = 0, b = 0;
                rgb2lab(pixel->Red, pixel->Green, pixel->Blue, &L, &a, &b);
                
                //取lab模式明度通道（L通道）颜色，转回rgb模式的颜色
                CGFloat fRed, fGreen, fBlue;
                lab2rgb(L, 0, 0, &fRed, &fGreen, &fBlue);
                
                layerLightnessPixel.Red = round(fRed);
                layerLightnessPixel.Green = round(fGreen);
                layerLightnessPixel.Blue = round(fBlue);
                layerLightnessPixel.Alpha = round(pixel->Alpha * 0.9);
                
                //--- 合并图层1和原图（图层1在上面） ---
                mixRgbColor(&layerLightnessPixel, pixel, pixel);
            }
        }
    }
    
    CGImageRef image = CGBitmapContextCreateImage(context);
    
    free(imageData);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
    UIImage* result = nil;
    if (image)
    {
        result = [UIImage imageWithCGImage:image scale:self.scale orientation:self.imageOrientation];
        CGImageRelease(image);
    }
    
    return result;
}
@end
