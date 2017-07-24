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
    self.navigationBar.translucent = NO;
    self.navigationBar.barTintColor = NAVIGATION_BACKGROUNDCOLOR;
    //隐藏导航底部分割线
    [self.navigationBar setShadowImage:[UIImage new]];
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    
}


@end
