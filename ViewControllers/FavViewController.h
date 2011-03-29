//
//  FavViewController.h
//  ghbbs
//
//  Created by Chenqun Hang on 11/1/10.
//  Copyright 2010 bufbomb.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullToRefreshTableViewController.h"
#import "BBSParserDelegate.h"


@interface FavViewController : PullToRefreshTableViewController <BBSParserDelegate>{
    NSMutableArray * favItems;
    BOOL isLoading;
    
    UIImageView * notSignedInView;
    UITableView * favTableView;
    UITabBarItem * tabBarItem;
}

- (void) clearContent;

@end
