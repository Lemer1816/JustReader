//
//  UIView+Frame.h
//  Base
//
//  Created by Lemonade on 2017/5/17.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) CGFloat minX;
@property (nonatomic, assign) CGFloat midX;
@property (nonatomic, assign) CGFloat maxX;

@property (nonatomic, assign) CGFloat minY;
@property (nonatomic, assign) CGFloat midY;
@property (nonatomic, assign) CGFloat maxY;

@end
