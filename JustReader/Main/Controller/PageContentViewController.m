//
//  PageContentViewController.m
//  JustReader
//
//  Created by Lemonade on 2017/8/11.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

static NSInteger const kTopInset = 15;
static NSInteger const kLeftInset = 15;
static NSInteger const kBottomInset = 15;
static NSInteger const kRightInset = 15;

#import "PageContentViewController.h"

@interface PageContentViewController ()

@end

@implementation PageContentViewController
#pragma mark - 生命周期 LifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = TEXT_WHITE_COLOR;
    [self contentPartLb];
}
//点击屏幕
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"");
    _clickScreenBlock();
}
#pragma mark - 懒加载 LazyLoad
- (UILabel *)contentPartLb{
    if (_contentPartLb == nil) {
        _contentPartLb = [[UILabel alloc] init];
        [self.view addSubview:_contentPartLb];
        [_contentPartLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(0);
            make.left.equalTo(kLeftInset);
            make.right.equalTo(-kRightInset);
        }];
        _contentPartLb.textColor = TEXT_MID_COLOR;
        _contentPartLb.numberOfLines = 0;
    }
    return _contentPartLb;
}
@end
