//
//  BasicNavigationController.m
//  JustReader
//
//  Created by Lemonade on 2017/7/20.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import "BasicNavigationController.h"

@interface BasicNavigationController ()

@end

@implementation BasicNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置透明度
    self.navigationBar.translucent = NO;
    //设置背景色
    self.navigationBar.barTintColor = NAVIGATION_BACKGROUNDCOLOR;
//    self.navigationBar.dk_barTintColorPicker = DKColorPickerWithKey(BG);
    //设置标题文字的颜色和大小
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: TEXT_WHITE_COLOR, NSFontAttributeName: [UIFont systemFontOfSize:17]}];
    //隐藏导航底部分割线
    [self.navigationBar setShadowImage:[UIImage new]];
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    
}
- (UIViewController *)childViewControllerForStatusBarStyle{
    return self.topViewController;
}

@end
