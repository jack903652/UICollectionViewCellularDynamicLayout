//
//  UICollectionViewCellularCell.m
//  UICollectionViewCellularDynamicLayout
//
//  Created by bamq on 16/4/14.
//  Copyright © 2016年 bamq. All rights reserved.
//

#import "UICollectionViewCellularCell.h"

@implementation UICollectionViewCellularCell
-(instancetype)initWithFrame:(CGRect)frame{
    self =[super initWithFrame:frame];
    if (self) {
        self.backgroundColor =[UIColor clearColor];
        _label =[[UILabel alloc] initWithFrame:self.bounds];
        _label.textAlignment =NSTextAlignmentCenter;
        [self addSubview:_label];
    }
    return self;
}
-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    CGFloat radius =rect.size.width/2;
    CGFloat radiusX =radius;
    CGFloat radiusY =radius*cos(M_PI/6);
    // Drawing code.
    //获得处理的上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置线条样式
//    CGContextSetLineCap(context, kCGLineCapSquare);
//    //设置线条粗细宽度
//    CGContextSetLineWidth(context, 1.0);
    
    //设置颜色
    CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0);
    CGContextSetFillColorWithColor(context, [UIColor orangeColor].CGColor);
    //开始一个起始路径
    CGContextBeginPath(context);

    //起始点设置为(0,0):注意这是上下文对应区域中的相对坐标，
    CGContextMoveToPoint(context, radiusX/2, 0);
    //设置下一个坐标点
    CGContextAddLineToPoint(context, 1.5*radiusX, 0);
    //设置下一个坐标点
    CGContextAddLineToPoint(context, 2*radiusX, radiusY);
    //设置下一个坐标点
    CGContextAddLineToPoint(context, 1.5*radiusX, 2*radiusY);
////
    CGContextAddLineToPoint(context, radiusX/2, 2*radiusY);
////
    CGContextAddLineToPoint(context, 0, radiusY);
    
    CGContextClosePath(context);
//    CGContextStrokePath(context);
    CGContextFillPath(context);
//    CGContextClip(context);
//    CGContextFillRect(context, rect);
//    CGContextDrawPath(context, kCGPathFillStroke);
//    CGContextClosePath(context);
    
//    //连接上面定义的坐标点
////    CGContextStrokePath(context);
//
    
//    CGContextClip(context);
//    CGContextClipToRect(context, rect);
//    CGContextEOClip(context);
}
@end
