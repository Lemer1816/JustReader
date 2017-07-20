//
//  BookDetailViewController.m
//  JustReader
//
//  Created by Lemonade on 2017/7/20.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import "BookDetailViewController.h"

@interface BookDetailViewController ()

@end

@implementation BookDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[Network sharedNetwork] getBookDetailWithBookId:self.bookId successBlock:^(id responseBody) {
        NSLog(@"responseBody: %@", responseBody);
    } failureBlock:^(NSError *error) {
        NSLog(@"error: %@", error);
    }];
}


@end
