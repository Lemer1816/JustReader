//
//  BookDetailViewController.m
//  JustReader
//
//  Created by Lemonade on 2017/7/20.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import "BookDetailViewController.h"
#import "BookDetailView.h"

@interface BookDetailViewController ()
/** 详情页视图 */
@property (nonatomic, strong) BookDetailView *bookDetailView;

@property (nonatomic, strong) BookDetailModel *bookDetailModel;

@end

@implementation BookDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[Network sharedNetwork] getBookDetailWithBookId:self.bookId successBlock:^(id responseBody) {
        NSLog(@"responseBody: %@", responseBody);
        self.bookDetailModel = [BookDetailModel parse:responseBody];
        [self bookDetailView];
    } failureBlock:^(NSError *error) {
        NSLog(@"error: %@", error);
    }];
    [self addBackButton];
}
#pragma mark - 懒加载 LazyLoad
- (BookDetailView *)bookDetailView{
    if (_bookDetailView == nil) {
        _bookDetailView = [[BookDetailView alloc] initWithModel:self.bookDetailModel];
        [self.view addSubview:_bookDetailView];
        [_bookDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
        _bookDetailView.backgroundColor = [UIColor whiteColor];
    }
    return _bookDetailView;
}

@end
