//
//  PageContentViewController.h
//  JustReader
//
//  Created by Lemonade on 2017/8/11.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickScreenBlock)();

@interface PageContentViewController : UIViewController
/** 分页内容 */
@property (nonatomic, readwrite, strong) UILabel *contentPartLb;
/** 点击屏幕block */
@property (nonatomic, readwrite, copy) ClickScreenBlock clickScreenBlock;
@end
