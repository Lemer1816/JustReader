//
//  ViewController.m
//  JustReader
//
//  Created by Lemonade on 2017/6/26.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import "ViewController.h"
#import "Network.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[Network sharedNetwork] getBookListWithKeywords:@"红尘" startNumber:0 limitNumber:10 successBlock:^(id responseBody) {
        NSLog(@"responseBody: %@", responseBody);
    } failureBlock:^(NSError *error) {
        NSLog(@"error: %@", error);
    }];
    [[Network sharedNetwork] getBookDetailWithBookId:@"57206c3539a913ad65d35c7b" successBlock:^(id responseBody) {
        NSLog(@"responseBody: %@", responseBody);
    } failureBlock:^(NSError *error) {
        NSLog(@"error: %@", error);
    }];
    [[Network sharedNetwork] getChapterListWithBookId:@"577b477dbd86a4bd3f8bf1b2" successBlock:^(id responseBody) {
        NSLog(@"responseBody: %@", responseBody);
    } failureBlock:^(NSError *error) {
        NSLog(@"error: %@", error);
    }];
    [[Network sharedNetwork] getAutoCompleteWithKeywords:@"红尘" successBlock:^(id responseBody) {
        NSLog(@"responseBody: %@", responseBody);
    } failureBlock:^(NSError *error) {
        NSLog(@"error: %@", error);
    }];
    [[Network sharedNetwork] getChapterDetailWithChapterLink:@"http://www.biquge.la/book/16431/6652065.html" successBlock:^(id responseBody) {
        NSLog(@"responseBody: %@", responseBody);
    } failureBlock:^(NSError *error) {
        NSLog(@"error: %@", error);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
