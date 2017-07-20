//
//  UIControl+Event.h
//  Base
//
//  Created by Lemonade on 2017/5/19.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ControlClick)(UIControl *sender);

@interface UIControl (Event)

@property (nonatomic, copy) ControlClick controlClick;
/** UIControl及其子类点击事件block */
- (void)addControlClick:(ControlClick)controlClick forControlEvents:(UIControlEvents)controlEvents;

@end
