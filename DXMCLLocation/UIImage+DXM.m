//
//  UIImage+DXM.m
//  DXMCLLocation
//
//  Created by YANGJINMING on 16/4/18.
//  Copyright © 2016年 YANGJINMING. All rights reserved.
//

#import "UIImage+DXM.h"

@implementation UIImage (DXM)

//颜色转图片
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
