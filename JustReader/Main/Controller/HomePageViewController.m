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

#import "UIControl+Event.h"

@interface HomePageViewController () <PYSearchViewControllerDataSource, PYSearchViewControllerDelegate>
/** 取消按钮 */
@property (nonatomic, readwrite, strong) UIButton *cancelBtn;
@end

@implementation HomePageViewController
#pragma mark - 生命周期 LifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *displayName = [infoDict objectForKey:(NSString *)kCFBundleExecutableKey];
    
    UIButton *testBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:testBtn];
    [testBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(0);
    }];
    [testBtn setTitle:displayName forState:UIControlStateNormal];
    [testBtn setTitleColor:FRESH_RED_COLOR forState:UIControlStateNormal];
    testBtn.titleLabel.font = [UIFont systemFontOfSize:40];
    [testBtn addTarget:self action:@selector(searchTest:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 方法 Methods
- (void)searchTest:(UIButton *)sender{
    PYSearchViewController *searchVC = [PYSearchViewController searchViewControllerWithHotSearches:@[@"玄幻", @"武侠", @"都市", @"校园", @"军事", @"科幻", @"女生", @"二次元"] searchBarPlaceholder:@"想看点什么"];
    __block __weak __typeof(&*self)weakSelf = self;
    searchVC.hotSearchStyle = PYHotSearchStyleRankTag;
    searchVC.searchHistoryStyle = PYSearchHistoryStyleDefault;
    [self.cancelBtn addControlClickBlock:^(UIControl *sender) {
        [searchVC resignFirstResponder];
        [searchVC dismissViewControllerAnimated:YES completion:nil];
    } forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithCustomView:weakSelf.cancelBtn];
    searchVC.cancelButton = rightBarBtn;
    searchVC.delegate = self;

    BasicNavigationController *navi = [[BasicNavigationController alloc] initWithRootViewController:searchVC];
    searchVC.navigationController.navigationBar.barTintColor = RGB(249, 249, 249);
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
#pragma mark - 懒加载 LazyLoad
- (UIButton *)cancelBtn{
    if (_cancelBtn == nil) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.bounds = CGRectMake(0, 0, 50, 30);
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:RGB(113, 113, 113) forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _cancelBtn;
}
@end
