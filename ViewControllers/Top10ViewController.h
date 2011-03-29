//
//  Top10ViewController.h
//  ghbbs
//
//  Created by Chenqun Hang on 9/28/10.
//  Copyright 2010 bufbomb.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBSParserDelegate.h"
#import "PullToRefreshTableViewController.h"

@interface Top10ViewController : PullToRefreshTableViewController {
    NSMutableArray * top10Items;
    BOOL isLoading;
    UITabBarItem * tabBarItem;
}

@end
