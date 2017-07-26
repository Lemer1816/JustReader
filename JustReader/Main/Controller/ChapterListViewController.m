//
//  ChapterListViewController.m
//  JustReader
//
//  Created by Lemonade on 2017/7/24.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import "ChapterListViewController.h"

#import "ChapterListModel.h"

#import "ChapterListTableViewCell.h"

#import "UIScrollView+Refresh.h"

@interface ChapterListViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *myTableView;

@property (nonatomic, strong) ChapterListModel *chapterListModel;
/** 章节列表 */
@property (nonatomic, strong) NSArray<ChapterListInfoModel *> *chapterList;
@end

@implementation ChapterListViewController
#pragma mark - 生命周期 LifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackButton];
    [self loadData];
}
#pragma mark - 方法 Methods
- (void)loadData{
    [[Network sharedNetwork] getChapterListWithBookId:@"577b477dbd86a4bd3f8bf1b2" successBlock:^(id responseBody) {
        NSLog(@"responseBody: %@", responseBody);
        self.chapterListModel = [ChapterListModel parse:responseBody];
        self.chapterList = self.chapterListModel.chapters;
        [self.myTableView reloadData];
    } failureBlock:^(NSError *error) {
        NSLog(@"error: %@", error);
    }];
}
- (void)requestDataWithRequestType:(RequestType)requestType completionHandler:(void (^)(NSError *error))handler{
    
    
}
#pragma mark - 协议方法 UITableViewDelegate/DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.chapterList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChapterListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ChapterListTableViewCell class])];
    ChapterListInfoModel *model = [self.chapterList objectAtIndex:indexPath.row];
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
}
#pragma mark - 懒加载 LazyLoad
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
@end
