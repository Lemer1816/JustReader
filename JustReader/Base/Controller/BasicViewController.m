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
/** 返回按钮(导航) */
@property (nonatomic, strong) UIBarButtonItem *backBarBtn;
/** 返回按钮(无数据) */
@property (nonatomic, readwrite, strong) UIButton *noDataBackBtn;
@end

@implementation BasicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self noDataBackBtn];
}
- (void)addBackButton{
    self.navigationItem.leftBarButtonItem = self.backBarBtn;
}
- (UIBarButtonItem *)backBarBtn{
    if (_backBarBtn == nil) {
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.bounds = CGRectMake(0, 0, 20, 20);
        [backBtn setImage:[UIImage imageNamed:@"nav_back_white"] forState:UIControlStateNormal];
        [backBtn addControlClickBlock:^(UIControl *sender) {
            [self.navigationController popViewControllerAnimated:YES];
        } forControlEvents:UIControlEventTouchUpInside];
        _backBarBtn = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
     }
    return _backBarBtn;
}
- (UIButton *)noDataBackBtn{
    if (_noDataBackBtn == nil) {
        _noDataBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:_noDataBackBtn];
        [_noDataBackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(0);
            make.width.equalTo(200);
            make.height.equalTo(100);
        }];
        [_noDataBackBtn setTitle:@"暂无数据,点击返回" forState:UIControlStateNormal];
        [_noDataBackBtn setTitleColor:TEXT_LIGHT_COLOR forState:UIControlStateNormal];
        __block __weak __typeof(&*self)weakSelf = self;
        [_noDataBackBtn addControlClickBlock:^(UIControl *sender) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _noDataBackBtn;
}
@end
