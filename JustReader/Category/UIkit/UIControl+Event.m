//
//  UIControl+Event.m
//  Base
//
//  Created by Lemonade on 2017/5/19.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import "UIControl+Event.h"
#import <objc/runtime.h>

static const void *controlClickKey = &controlClickKey;

@implementation UIControl (Event)

- (void)setControlClick:(ControlClick)controlClick{
    objc_setAssociatedObject(self, controlClickKey, controlClick, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (ControlClick)controlClick{
    return objc_getAssociatedObject(self, controlClickKey);
}
- (void)addControlClick:(ControlClick)controlClick forControlEvents:(UIControlEvents)controlEvents{
    NSParameterAssert(controlClick);
    self.controlClick = controlClick;
    [self addTarget:self action:@selector(clickControl:) forControlEvents:controlEvents];
}
- (void)clickControl:(UIControl *)sender{
    self.controlClick(sender);
}
@end
