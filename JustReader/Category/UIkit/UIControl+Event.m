//
//  UIControl+Event.m
//  Base
//
//  Created by Lemonade on 2017/5/19.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import "UIControl+Event.h"
#import <objc/runtime.h>

static const void *controlClickBlockKey = &controlClickBlockKey;

@implementation UIControl (Event)

- (void)setControlClickBlock:(ControlClickBlock)controlClickBlock{
    objc_setAssociatedObject(self, controlClickBlockKey, controlClickBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (ControlClickBlock)controlClickBlock{
    return objc_getAssociatedObject(self, controlClickBlockKey);
}
- (void)addControlClickBlock:(ControlClickBlock)controlClickBlock forControlEvents:(UIControlEvents)controlEvents{
    NSParameterAssert(controlClickBlock);
    self.controlClickBlock = controlClickBlock;
    [self addTarget:self action:@selector(clickControl:) forControlEvents:controlEvents];
}
- (void)clickControl:(UIControl *)sender{
    self.controlClickBlock(sender);
}
@end
