//
//  BookDetailViewController.m
//  JustReader
//
//  Created by Lemonade on 2017/7/20.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import "BookDetailViewController.h"
#import "ChapterListViewController.h"

#import "BookDetailView.h"

@interface BookDetailViewController ()
/** 详情页滚动视图 */
@property (nonatomic, strong) UIScrollView *myScrollView;

@property (nonatomic, strong) BookDetailView *bookDetailView;

@property (nonatomic, strong) BookDetailModel *bookDetailModel;

@end

@implementation BookDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[Network sharedNetwork] getBookDetailWithBookId:self.bookId successBlock:^(id responseBody) {
        NSLog(@"responseBody: %@", responseBody);
        self.bookDetailModel = [BookDetailModel parse:responseBody];
        [self myScrollView];
    } failureBlock:^(NSError *error) {
        NSLog(@"error: %@", error);
    }];
    [self addBackButton];
}
#pragma mark - 懒加载 LazyLoad
- (UIScrollView *)myScrollView{
    if (_myScrollView == nil) {
        _myScrollView = [[UIScrollView alloc] init];
        [self.view addSubview:_myScrollView];
        [_myScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
        BookDetailView *bookDetailView = [[BookDetailView alloc] initWithModel:self.bookDetailModel];
        CGFloat totalHeight = bookDetailView.totalHeight;
        [_myScrollView addSubview:bookDetailView];
        [bookDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(0);
            make.width.equalTo(SCREEN_WIDTH);
            make.height.equalTo(totalHeight);
        }];
        bookDetailView.backgroundColor = [UIColor whiteColor];
        bookDetailView.starReadingBlock = ^{
            NSLog(@"开始阅读");
            ChapterListViewController *chapterListVC = [[ChapterListViewController alloc] init];
            chapterListVC.bookId = self.bookDetailModel._id;
            [self.navigationController pushViewController:chapterListVC animated:YES];
        };
        bookDetailView.addMyBookBlock = ^{
            NSLog(@"加入书单");
        };
        _myScrollView.bounces = NO;
        _myScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, totalHeight);
    }
    return _myScrollView;
}


@end
