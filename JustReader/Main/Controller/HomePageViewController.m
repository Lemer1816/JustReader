//
//  HomePageViewController.m
//  JustReader
//
//  Created by Lemonade on 2017/7/20.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import "HomePageViewController.h"
#import "BookListViewController.h"
#import "BookDetailViewController.h"

#import "AutoCompleteModel.h"

@interface HomePageViewController () <PYSearchViewControllerDataSource, PYSearchViewControllerDelegate>

@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *testBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:testBtn];
    [testBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(0);
    }];
    [testBtn setTitle:@"搜索测试" forState:UIControlStateNormal];
    [testBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    testBtn.backgroundColor = [UIColor blueColor];
    [testBtn addTarget:self action:@selector(searchTest:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)searchTest:(UIButton *)sender{
    PYSearchViewController *searchVC = [PYSearchViewController searchViewControllerWithHotSearches:@[@"dewdwe", @"ferfe", @"werw", @"wewer", @"rtjojbro", @"wononewow", @"xc", @"de"] searchBarPlaceholder:@"搜索测试"];

    searchVC.hotSearchStyle = PYHotSearchStyleRankTag;
    searchVC.searchHistoryStyle = PYSearchHistoryStyleDefault;
    searchVC.delegate = self;

    BasicNavigationController *navi = [[BasicNavigationController alloc] initWithRootViewController:searchVC];
    [self presentViewController:navi animated:YES completion:nil];
}
#pragma mark - PYSearchViewControllerDelegate
- (void)searchViewController:(PYSearchViewController *)searchViewController searchTextDidChange:(UISearchBar *)seachBar searchText:(NSString *)searchText {
    if (searchText.length) {
        [[Network sharedNetwork] getAutoCompleteWithKeywords:searchText successBlock:^(id responseBody) {
            NSLog(@"responseBody: %@", responseBody);
            AutoCompleteModel *model = [AutoCompleteModel parse:responseBody];
            searchViewController.searchSuggestions = model.keywords;
        } failureBlock:^(NSError *error) {
            NSLog(@"error: %@", error);
        }];
    }
}
//普通搜索点击
- (void)searchViewController:(PYSearchViewController *)searchViewController didSearchWithSearchBar:(UISearchBar *)searchBar searchText:(NSString *)searchText{
    if (searchText.length) {
        BookListViewController *bookListVC = [[BookListViewController alloc] init];
        bookListVC.keywords = searchText;
        [searchViewController.navigationController pushViewController:bookListVC animated:YES];
    }
}

@end
