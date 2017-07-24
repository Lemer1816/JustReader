//
//  BasicViewController.m
//  JustReader
//
//  Created by Lemonade on 2017/7/20.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import "BasicViewController.h"
#import "BasicNavigationController.h"

#import "UIControl+Event.h"

@interface BasicViewController ()

@property (nonatomic, strong) UIBarButtonItem *backBarBtn;
@end

@implementation BasicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}
- (void)addBackButton{
    self.navigationItem.leftBarButtonItem = self.backBarBtn;
}
- (UIBarButtonItem *)backBarBtn{
    if (_backBarBtn == nil) {
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.bounds = CGRectMake(0, 0, 20, 20);
        [backBtn setImage:[UIImage imageNamed:@"nav_back_white"] forState:UIControlStateNormal];
        [backBtn addControlClick:^(UIControl *sender) {
            [self.navigationController popViewControllerAnimated:YES];
        } forControlEvents:UIControlEventTouchUpInside];
        _backBarBtn = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    }
    return _backBarBtn;
}

@end
