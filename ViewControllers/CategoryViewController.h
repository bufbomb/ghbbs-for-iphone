//
//  CategoryViewController.h
//  ghbbs
//
//  Created by Chenqun Hang on 9/6/10.
//  Copyright 2010 bufbomb.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBSParserDelegate.h"
#import "PullToRefreshTableViewController.h"

@interface CategoryViewController : PullToRefreshTableViewController
{
    BOOL isLoading;
    UITabBarItem * tabBarItem;
}

- (void)fetch;

@end
