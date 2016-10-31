//
//  DrawView.m
//  DXMCLLocation
//
//  Created by YANGJINMING on 16/4/18.
//  Copyright © 2016年 YANGJINMING. All rights reserved.
//

#import "LocationTitleBtn.h"
#define triangleHight 8
#define triangleWithScale 3/32.0
@implementation LocationTitleBtn

- (void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    /**
     1
     */
    UIBezierPath *trianglePath = [UIBezierPath bezierPath];
    trianglePath.lineWidth = 1;
    //通过使用UIBezierPath可以自定义绘制线条的粗细，是否圆角等
    trianglePath.lineCapStyle = kCGLineCapRound;
    trianglePath.lineJoinStyle = kCGLineJoinRound;
    //设置路径
    [trianglePath moveToPoint:CGPointMake((self.frame.size.width*(1-triangleWithScale))/2.0, self.frame.size.height-triangleHight)];
    [trianglePath addLineToPoint:CGPointMake(self.frame.size.width/2.0, self.frame.size.height)];
    [trianglePath addLineToPoint:CGPointMake((self.frame.size.width*(1+triangleWithScale))/2.0, self.frame.size.height-triangleHight)];
    
    //设置颜色
    if (self.state == UIControlStateNormal) {
        [[UIColor whiteColor] set];
    }else [[[UIColor darkGrayColor] colorWithAlphaComponent:0.8] set];
    [trianglePath closePath];
    [trianglePath fill];
    /**
     2
     */
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-triangleHight)];
    path.lineWidth = 0.5;
    //通过使用UIBezierPath可以自定义绘制线条的粗细，是否圆角等
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineJoinRound;

    [path closePath];
    [path fill];
    /**
     3
     */
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    linePath.lineWidth = 0.5;
    linePath.lineCapStyle = kCGLineCapRound;
    linePath.lineJoinStyle = kCGLineJoinRound;
    //设置路径
    [linePath moveToPoint:CGPointMake(0, self.frame.size.height-triangleHight)];
    [linePath addLineToPoint:CGPointMake(0, 0)];
    [linePath addLineToPoint:CGPointMake(self.frame.size.width, 0)];
    [linePath addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height-triangleHight)];
    //1.通过使用UIBezierPath可以自定义绘制线条的粗细，是否圆角等
    [[[UIColor blackColor] colorWithAlphaComponent:0.5] set];//设置线条颜色
    [linePath stroke];
                                        
}
//记得调用以下这个方法，使其view变化后(例如横屏了)重新调用drawRect：
- (void)awakeFromNib {
    // Comment this line to see default behavior
    self.contentMode = UIViewContentModeRedraw;
}
- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    [self setNeedsDisplay];
}
- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    [self setNeedsDisplay];
}
@end
