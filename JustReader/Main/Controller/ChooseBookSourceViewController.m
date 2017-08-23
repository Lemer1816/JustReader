//
//  ChooseBookSourceViewController.m
//  JustReader
//
//  Created by Lemonade on 2017/8/23.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import "ChooseBookSourceViewController.h"

@interface ChooseBookSourceViewController () <UITableViewDataSource, UITableViewDelegate>
/** 书源列表 */
@property (nonatomic, readwrite, strong) UITableView *bookSourceTableView;
@property (nonatomic, readwrite, copy) ChooseBookSourceBlock chooseBookSourceBlock;

@end

@implementation ChooseBookSourceViewController
#pragma mark - 生命周期 LifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    [self bookSourceTableView];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
#pragma mark - 方法 Methods
- (void)chooseSourceBlock:(ChooseBookSourceBlock)chooseBookSourceBlock{
    self.chooseBookSourceBlock = chooseBookSourceBlock;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 协议方法 UITableViewDelegate/DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.bookSourceList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    cell.textLabel.text = [self.bookSourceList objectAtIndex:row].name;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //左侧分割线留白
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.chooseBookSourceBlock) {
        self.chooseBookSourceBlock([self.bookSourceList objectAtIndex:indexPath.row]);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 懒加载 LazyLoad
- (UITableView *)bookSourceTableView{
    if (_bookSourceTableView == nil) {
        _bookSourceTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self.view addSubview:_bookSourceTableView];
        [_bookSourceTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(0);
            make.width.equalTo(SCREEN_WIDTH/3*2);
            make.height.equalTo(self.bookSourceList.count*44);
            
        }];
        _bookSourceTableView.dataSource = self;
        _bookSourceTableView.delegate = self;
    }
    return _bookSourceTableView;
}

@end
