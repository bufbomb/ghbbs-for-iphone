//
//  PullToRefreshTableViewController.h
//  ghbbs
//
//  Created by Chenqun Hang on 10/9/10.
//  Copyright 2010 bufbomb.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshHeaderView.h"
#import "BBSParserDelegate.h"


@interface PullToRefreshTableViewController : UITableViewController  <BBSParserDelegate> {
    RefreshHeaderView * refreshHeaderView;
    BOOL checkForRefresh;
    BOOL reloading;
    
    BOOL pullToRefreshEnabled;
    
    UIActivityIndicatorView * loadingActivity;
}

- (void) dataSourceDidFinishLoadingNewData;
- (void) showReloadAnimationAnimated:(BOOL)animated;
- (void) setPullToRefreshEnabled:(BOOL)enabled;

- (void) fetch;
- (void) refresh;

- (void) popUpRetryAlertWithTitle:(NSString *)title Message:(NSString *)message;
- (void) popUpConfirmAlertWithTitle:(NSString *)title Message:(NSString *)message;
@end
