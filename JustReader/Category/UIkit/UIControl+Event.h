//
//  UIControl+Event.h
//  Base
//
//  Created by Lemonade on 2017/5/19.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ControlClickBlock)(UIControl *sender);

@interface UIControl (Event)

@property (nonatomic, copy) ControlClickBlock controlClickBlock;
/** UIControl及其子类点击事件block */
- (void)addControlClickBlock:(ControlClickBlock)controlClickBlock forControlEvents:(UIControlEvents)controlEvents;

@end
