//
//  ChapterListViewController.m
//  JustReader
//
//  Created by Lemonade on 2017/7/24.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import "ChapterListViewController.h"
#import "ChapterDetailViewController.h"
#import "ChooseBookSourceViewController.h"

#import "ChapterListModel.h"
#import "BookSourceModel.h"

#import "ChapterListTableViewCell.h"

#import "UIScrollView+Refresh.h"
#import "UIControl+Event.h"

@interface ChapterListViewController () <UITableViewDataSource, UITableViewDelegate>
/** 书源列表 */
@property (nonatomic, strong) NSMutableArray<BookSourceModel *> *bookSourceList;
/** 被选中的书源 */
@property (nonatomic, strong) BookSourceModel *selectedBookSourceModel;
/** 章节列表(顺序) */
@property (nonatomic, strong) NSArray<ChapterListInfoModel *> *chapterIncreasedList;
/** 章节列表(倒序) */
@property (nonatomic, strong) NSArray<ChapterListInfoModel *> *chapterDecreasedList;
/** 列表 */
@property (nonatomic, strong) UITableView *myTableView;
/** 顺序/倒序按钮 */
@property (nonatomic, readwrite, strong) UIBarButtonItem *selectOrderBtn;
/** 选择书源按钮 */
@property (nonatomic, readwrite, strong) UIBarButtonItem *chooseBookSourceBtn;
/** 列表顺序状态 */
@property (nonatomic, readwrite, assign, getter=isOrderState) BOOL orderState;
@end

@implementation ChapterListViewController
#pragma mark - 生命周期 LifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackButton];
    self.navigationItem.title = @"章节列表";
    [self loadData];
    self.orderState = YES;
    self.navigationItem.rightBarButtonItems = @[self.chooseBookSourceBtn, self.selectOrderBtn];
    
}
#pragma mark - 方法 Methods
- (void)loadData{
    //获取书源列表
    [[Network sharedNetwork] getBookSourceListWithBookId:self.bookId successBlock:^(id responseBody) {
        if ([responseBody isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dict in (NSArray *)responseBody) {
                BookSourceModel *model = [BookSourceModel parse:dict];
                if ([model.name isEqualToString:@"优质书源"]) {
                    continue;
                }
                [self.bookSourceList addObject:model];
            }
            self.selectedBookSourceModel = [self.bookSourceList objectAtIndex:0];
            [self requestChapterList];
        }
    } failureBlock:^(NSError *error) {
        NSLog(@"error: %@", error);
    }];
}
- (void)requestChapterList{
    [[Network sharedNetwork] getChapterListWithBookSourceId:self.selectedBookSourceModel._id successBlock:^(id responseBody) {
        ChapterListModel *model = [ChapterListModel parse:responseBody];
        self.chapterIncreasedList = model.chapters;
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [queue addOperationWithBlock:^{
//            NSLog(@"循环开始");
            NSMutableArray *tmpArr = [NSMutableArray array];
            for (int i = (int)self.chapterIncreasedList.count-1; i >= 0; i--) {
                [tmpArr addObject:[self.chapterIncreasedList objectAtIndex:i]];
            }
            self.chapterDecreasedList = [tmpArr copy];
//            NSLog(@"循环结束");
        }];
        [self.myTableView reloadData];
    } failureBlock:^(NSError *error) {
        NSLog(@"error: %@", error);
    }];
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
//选择书源
- (void)chooseBookSource:sender{
    ChooseBookSourceViewController *chooseVC = [[ChooseBookSourceViewController alloc] init];
    chooseVC.bookSourceList = self.bookSourceList;
    [chooseVC chooseSourceBlock:^(BookSourceModel *model) {
        self.selectedBookSourceModel = model;
        [self requestChapterList];
    }];
    //对于背景透明的视图,不设置会使背景呈现黑色
    chooseVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    //界面显示方式(淡入)
    chooseVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:chooseVC animated:YES completion:nil];
    
}
#pragma mark - 协议方法 UITableViewDelegate/DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.chapterIncreasedList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChapterListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ChapterListTableViewCell class])];
    ChapterListInfoModel *model = self.isOrderState ? [self.chapterIncreasedList objectAtIndex:indexPath.row] : [self.chapterDecreasedList objectAtIndex:indexPath.row];
    
    cell.chapterNameLb.text = model.title;
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
    NSInteger row = indexPath.row;
    ChapterDetailViewController *chapterDetailVC = [[ChapterDetailViewController alloc] init];
    chapterDetailVC.chapterList = self.chapterIncreasedList;
    chapterDetailVC.selectedChapterIndex = self.isOrderState ? row : self.chapterDecreasedList.count-1-row;
    chapterDetailVC.selectedChapterInfoModel = self.isOrderState ? [self.chapterIncreasedList objectAtIndex:row] : [self.chapterDecreasedList objectAtIndex:row];
    
    [self.navigationController pushViewController:chapterDetailVC animated:YES];
//    [self presentViewController:chapterDetailVC animated:YES completion:nil];
}
#pragma mark - 懒加载 LazyLoad
- (NSMutableArray<BookSourceModel *> *)bookSourceList{
    if (_bookSourceList == nil) {
        _bookSourceList = [NSMutableArray array];
    }
    return _bookSourceList;
}
- (BookSourceModel *)selectedBookSourceModel{
    if (_selectedBookSourceModel == nil) {
        _selectedBookSourceModel = [[BookSourceModel alloc] init];
    }
    return _selectedBookSourceModel;
}
- (UITableView *)myTableView{
    if (_myTableView == nil) {
        _myTableView = [[UITableView alloc] init];
        [self.view addSubview:_myTableView];
        [_myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
        _myTableView.estimatedRowHeight = 44;
        _myTableView.rowHeight = UITableViewAutomaticDimension;
        _myTableView.backgroundColor = DEFAULT_BACKGROUND_COLOR;
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myTableView.dataSource = self;
        _myTableView.delegate = self;
        
        [_myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([ChapterListTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ChapterListTableViewCell class])];
        
    }
    return _myTableView;
}
- (UIBarButtonItem *)selectOrderBtn{
    if (_selectOrderBtn == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.bounds = CGRectMake(0, 0, 50, 30);
        [btn setTitle:@"顺序" forState:UIControlStateNormal];
        [btn setTitle:@"倒序" forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        __block __weak __typeof(&*self)weakSelf = self;
        [btn addControlClickBlock:^(UIControl *sender) {
            sender.selected = !sender.selected;
            weakSelf.orderState = !weakSelf.orderState;
            [weakSelf.myTableView reloadData];
        } forControlEvents:UIControlEventTouchUpInside];
        _selectOrderBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    }
    return _selectOrderBtn;
}
- (UIBarButtonItem *)chooseBookSourceBtn{
    if (_chooseBookSourceBtn == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.bounds = CGRectMake(0, 0, 80, 30);
        [btn setTitle:@"选择书源" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn addTarget:self action:@selector(chooseBookSource:) forControlEvents:UIControlEventTouchUpInside];
        _chooseBookSourceBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
        
    }
    return _chooseBookSourceBtn;
}
@end
