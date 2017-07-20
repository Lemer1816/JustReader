//
//  UIView+Frame.m
//  Base
//
//  Created by Lemonade on 2017/5/17.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)
- (void)setX:(CGFloat)x{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}
- (CGFloat)x{
    return self.frame.origin.x;
}
- (void)setY:(CGFloat)y{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}
- (CGFloat)y{
   return self.frame.origin.y;
}
- (void)setWidth:(CGFloat)width{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}
- (CGFloat)width{
    return self.frame.size.width;
}
- (void)setHeight:(CGFloat)height{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}
- (CGFloat)height{
    return self.frame.size.height;
}
- (void)setMinX:(CGFloat)minX{}
- (CGFloat)minX{
    return CGRectGetMinX(self.frame);
}
- (void)setMinY:(CGFloat)minY{}
- (CGFloat)minY{
    return CGRectGetMinY(self.frame);
}
- (void)setMidX:(CGFloat)midX{}
- (CGFloat)midX{
    return CGRectGetMidX(self.frame);
}
- (void)setMidY:(CGFloat)midY{}
- (CGFloat)midY{
    return CGRectGetMidY(self.frame);
}
- (void)setMaxX:(CGFloat)maxX{}
- (CGFloat)maxX{
    return CGRectGetMidX(self.frame);
}
- (void)setMaxY:(CGFloat)maxY{}
- (CGFloat)maxY{
    return CGRectGetMaxY(self.frame);
}
@end
