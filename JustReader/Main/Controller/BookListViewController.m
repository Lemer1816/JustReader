//
//  BookListViewController.m
//  JustReader
//
//  Created by Lemonade on 2017/7/20.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import "BookListViewController.h"
#import "BookDetailViewController.h"

#import "BookListModel.h"
#import "BookListCell.h"
#import "BookListCollectionViewCell.h"

#import "UIControl+Event.h"
#import "UIScrollView+Refresh.h"


@interface BookListViewController () <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
/** 列表 */
@property (nonatomic, strong) UITableView *myTableView;
/** 网格 */
@property (nonatomic, strong) UICollectionView *myCollectionView;
/** 列表/网格切换按钮 */
@property (nonatomic, strong) UIButton *selectBtn;
/** 书籍列表数据 */
@property (nonatomic, strong) NSMutableArray<BookListModel *> *bookList;
/** 起始页码 */
@property (nonatomic, assign) NSInteger startNumber;
@end

@implementation BookListViewController
#pragma mark - 生命周期 LifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self addBackButton];
    self.navigationItem.title = @"书籍列表";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.selectBtn];
    self.navigationController.navigationBar.barTintColor = NAVIGATION_BACKGROUNDCOLOR;
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.bounds = CGRectMake(0, 0, 20, 20);
    [backBtn setImage:[UIImage imageNamed:@"nav_back_white"] forState:UIControlStateNormal];
    [backBtn addControlClickBlock:^(UIControl *sender) {
        [self.navigationController popViewControllerAnimated:YES];
        self.navigationController.navigationBar.barTintColor = RGB(249, 249, 249);
    } forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [self loadData];
}

#pragma mark - 方法 Methods
- (void)loadData{
    __block __weak __typeof(&*self)weakSelf = self;
    //tableView添加头部刷新
    [self.myTableView addHeaderRefresh:^{
        [weakSelf requestDataWithRequestType:RequestTypeRefresh completionHandler:^(NSError *error) {
            if (!error) {
                [weakSelf.myTableView reloadData];
            } else {
                NSLog(@"error: %@", error);
            }
            [weakSelf.myTableView endHeaderRefresh];
        }];
    }];
    //tableView添加脚步刷新
    [self.myTableView addBackFooterRefresh:^{
        [weakSelf requestDataWithRequestType:RequestTypeLoadMore completionHandler:^(NSError *error) {
            if (!error) {
                [weakSelf.myTableView reloadData];
            } else {
                NSLog(@"error: %@", error);
            }
            [weakSelf.myTableView endFooterRefresh];
        }];
    }];
    //collectionView添加头部刷新
    [self.myCollectionView addHeaderRefresh:^{
        [weakSelf requestDataWithRequestType:RequestTypeRefresh completionHandler:^(NSError *error) {
            if (!error) {
                [weakSelf.myCollectionView reloadData];
            } else {
                NSLog(@"error: %@", error);
            }
            [weakSelf.myCollectionView endHeaderRefresh];
        }];
    }];
    //collectionView添加脚部刷新
    [self.myCollectionView addBackFooterRefresh:^{
        [weakSelf requestDataWithRequestType:RequestTypeLoadMore completionHandler:^(NSError *error) {
            if (!error) {
                [weakSelf.myCollectionView reloadData];
            } else {
                NSLog(@"error: %@", error);
            }
            [weakSelf.myCollectionView endFooterRefresh];
        }];
    }];
    [self.myTableView beginHeaderRefresh];
}
- (void)requestDataWithRequestType:(RequestType)requestType completionHandler:(void (^)(NSError *error))handler{
    self.startNumber = requestType == RequestTypeRefresh ? 0 : self.startNumber+1;
    [[Network sharedNetwork] getBookListWithKeywords:self.keywords startNumber:self.startNumber limitNumber:10 successBlock:^(id responseBody) {
//        NSLog(@"responseBody: %@", responseBody);
        if (requestType == RequestTypeRefresh) {
            [self.bookList removeAllObjects];
        }
        NSArray *bookArr = [responseBody objectForKey:@"books"];
        if (bookArr.count) {
            for (NSDictionary *dic in bookArr) {
                BookListModel *model = [BookListModel parse:dic];
                NSString *img = [model.cover stringByRemovingPercentEncoding];
                NSLog(@"%@", img);
                [self.bookList addObject:model];
            }
            handler(nil);
        } else {
            //无数据处理
            handler(responseBody);
        }
    } failureBlock:^(NSError *error) {
        handler(error);
    }];
}
#pragma mark - 协议方法 UITableViewDelegate/DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.bookList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    BookListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BookListCell class])];
    BookListModel *model = [self.bookList objectAtIndex:row];
    [cell.coverIV sd_setImageWithURL:[NSURL URLWithString:[model.cover isEqualToString:@""] ? @"" : [[model.cover stringByRemovingPercentEncoding] substringFromIndex:7]] placeholderImage:[UIImage imageNamed:@"NoCover"]];
    NSLog(@"%@", [model.cover stringByRemovingPercentEncoding]);
    cell.bookNameLb.text = model.title;
    cell.authorLb.text = [NSString stringWithFormat:@"作者: %@", model.author];
    cell.shortIntroductionLb.text = model.shortIntro;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
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
    BookListModel *model = [self.bookList objectAtIndex:row];
    BookDetailViewController *bookDetailVC = [[BookDetailViewController alloc] init];
    bookDetailVC.bookId = model._id;
    [self.navigationController pushViewController:bookDetailVC animated:YES];
    
}
#pragma mark - 协议方法 UITableViewDelegate/DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.bookList.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    BookListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([BookListCollectionViewCell class]) forIndexPath:indexPath];
    BookListModel *model = [self.bookList objectAtIndex:row];
    [cell.coverIV sd_setImageWithURL:[NSURL URLWithString:[model.cover isEqualToString:@""] ? @"" : [[model.cover stringByRemovingPercentEncoding] substringFromIndex:7]] placeholderImage:[UIImage imageNamed:@"NoCover"]];
    NSLog(@"%@", [model.cover stringByRemovingPercentEncoding]);
    cell.bookNameLb.text = model.title;
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    BookListModel *model = [self.bookList objectAtIndex:row];
    BookDetailViewController *bookDetailVC = [[BookDetailViewController alloc] init];
    bookDetailVC.bookId = model._id;
    [self.navigationController pushViewController:bookDetailVC animated:YES];
    
}
#pragma mark - 懒加载 LazyLoad
- (UITableView *)myTableView{
    if (_myTableView == nil) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_AND_NAVIGATION_HEIGHT)];
        [self.view addSubview:_myTableView];
        _myTableView.backgroundColor = DEFAULT_BACKGROUND_COLOR;
        _myTableView.dataSource = self;
        _myTableView.delegate = self;
        
        [_myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([BookListCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([BookListCell class])];
    }
    return _myTableView;
}
- (UICollectionView *)myCollectionView{
    if (_myCollectionView == nil) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.sectionInset = UIEdgeInsetsMake(1, 1, 1, 1);
        flowLayout.minimumLineSpacing = 1;
        flowLayout.minimumInteritemSpacing = 1;
        flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH - 1*2 - 1*2) / 3, 195);
        _myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_AND_NAVIGATION_HEIGHT) collectionViewLayout:flowLayout];
        _myCollectionView.backgroundColor = DEFAULT_BACKGROUND_COLOR;
        _myCollectionView.dataSource = self;
        _myCollectionView.delegate = self;
        
        [_myCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([BookListCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([BookListCollectionViewCell class])];
    }
    return _myCollectionView;
}
- (UIButton *)selectBtn{
    if (_selectBtn == nil) {
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectBtn.frame = CGRectMake(0, 0, 100, 30);
        [_selectBtn setTitle:@"列表显示" forState:UIControlStateNormal];
        [_selectBtn setTitle:@"网格显示" forState:UIControlStateSelected];
//        _selectBtn.backgroundColor = [UIColor redColor];
        _selectBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        __block __weak __typeof(&*self)weakSelf = self;
        [_selectBtn addControlClickBlock:^(UIControl *sender) {
            sender.selected = !sender.selected;
            if (sender.selected) {
                [weakSelf.myTableView removeFromSuperview];
                [weakSelf.view addSubview:weakSelf.myCollectionView];
                [weakSelf.myCollectionView reloadData];
            } else {
                [weakSelf.myCollectionView removeFromSuperview];
                [weakSelf.view addSubview:weakSelf.myTableView];
                [weakSelf.myTableView reloadData];
            }
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectBtn;
}
- (NSMutableArray *)bookList{
    if (_bookList == nil) {
        _bookList = [NSMutableArray array];
    }
    return _bookList;
}
@end
