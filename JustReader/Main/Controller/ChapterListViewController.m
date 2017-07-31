//
//  ChapterListViewController.m
//  JustReader
//
//  Created by Lemonade on 2017/7/24.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import "ChapterListViewController.h"
#import "ChapterDetailViewController.h"

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
@property (nonatomic, strong) UIButton *selectOrderBtn;

@end

@implementation ChapterListViewController
#pragma mark - 生命周期 LifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackButton];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.selectOrderBtn];
    self.navigationItem.title = @"章节列表";
    [self loadData];
}
#pragma mark - 方法 Methods
- (void)loadData{
    [[Network sharedNetwork] getBookSourceListWithBookId:self.bookId successBlock:^(id responseBody) {
        if ([responseBody isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dict in (NSArray *)responseBody) {
                BookSourceModel *model = [BookSourceModel parse:dict];
                if ([model.name isEqualToString:@"优质书源"]) {
                    continue;
                }
                [self.bookSourceList addObject:model];
            }
            self.selectedBookSourceModel = [self.bookSourceList objectAtIndex:1];
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
            NSLog(@"循环开始");
            NSMutableArray *tmpArr = [NSMutableArray array];
            for (int i = (int)self.chapterIncreasedList.count-1; i >= 0; i--) {
                [tmpArr addObject:[self.chapterIncreasedList objectAtIndex:i]];
            }
            self.chapterDecreasedList = [tmpArr copy];
            NSLog(@"循环结束");
        }];
        [self.myTableView reloadData];
    } failureBlock:^(NSError *error) {
        NSLog(@"error: %@", error);
    }];
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
    ChapterListInfoModel *model = self.selectOrderBtn.selected ? [self.chapterDecreasedList objectAtIndex:indexPath.row] : [self.chapterIncreasedList objectAtIndex:indexPath.row];
    
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
    ChapterListInfoModel *model = self.selectOrderBtn.selected ? [self.chapterDecreasedList objectAtIndex:indexPath.row] : [self.chapterIncreasedList objectAtIndex:indexPath.row];
    ChapterDetailViewController *chapterDetailVC = [[ChapterDetailViewController alloc] init];
    chapterDetailVC.chapterLink = model.link;
    [self.navigationController pushViewController:chapterDetailVC animated:YES];
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
- (UIButton *)selectOrderBtn{
    if (_selectOrderBtn == nil) {
        _selectOrderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectOrderBtn.bounds = CGRectMake(0, 0, 50, 30);
        [_selectOrderBtn setTitle:@"顺序" forState:UIControlStateNormal];
        [_selectOrderBtn setTitle:@"倒序" forState:UIControlStateSelected];
        
        [_selectOrderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_selectOrderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        _selectOrderBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        __block __weak __typeof(&*self)weakSelf = self;
        [_selectOrderBtn addControlClickBlock:^(UIControl *sender) {
            sender.selected = !sender.selected;
            [weakSelf.myTableView reloadData];
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectOrderBtn;
}
@end
