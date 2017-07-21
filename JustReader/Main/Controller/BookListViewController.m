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



@interface BookListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *myTableView;

@property (nonatomic, strong) NSMutableArray *bookList;
@end

@implementation BookListViewController
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
    [cell.coverIV sd_setImageWithURL:[NSURL URLWithString:[[model.cover stringByRemovingPercentEncoding] substringFromIndex:7]] placeholderImage:[UIImage imageNamed:@""]];
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
- (void)viewDidLoad {
    [super viewDidLoad];
    [[Network sharedNetwork] getBookListWithKeywords:self.keywords startNumber:0 limitNumber:10 successBlock:^(id responseBody) {
        NSLog(@"responseBody: %@", responseBody);
        NSArray *bookArr = [responseBody objectForKey:@"books"];
        if (bookArr.count) {
            for (NSDictionary *dic in bookArr) {
                BookListModel *model = [BookListModel parse:dic];
                NSString *img = [model.cover stringByRemovingPercentEncoding];
                NSLog(@"%@", img);
                [self.bookList addObject:model];
            }
            [self.myTableView reloadData];
        } else {
            //无数据处理
        }
        
        
    } failureBlock:^(NSError *error) {
        NSLog(@"error: %@", error);
    }];
}
#pragma mark - 懒加载 LazyLoad

- (NSMutableArray *)bookList{
    if (_bookList == nil) {
        _bookList = [NSMutableArray array];
    }
    return _bookList;
}
- (UITableView *)myTableView{
    if (_myTableView == nil) {
        _myTableView = [[UITableView alloc] init];
        [self.view addSubview:_myTableView];
        [_myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
        _myTableView.backgroundColor = DEFAULT_BACKGROUND_COLOR;
        _myTableView.dataSource = self;
        _myTableView.delegate = self;
        
        [_myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([BookListCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([BookListCell class])];
    }
    return _myTableView;
}

@end
