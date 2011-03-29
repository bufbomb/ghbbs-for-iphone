//
//  PullToRefreshTableViewController.m
//  ghbbs
//
//  Created by Chenqun Hang on 10/9/10.
//  Copyright 2010 bufbomb.com. All rights reserved.
//

#import "PullToRefreshTableViewController.h"


@implementation PullToRefreshTableViewController

- (void) loadView
{
    [super loadView];
    refreshHeaderView = [[RefreshHeaderView alloc] initWithFrame: CGRectMake(0.0f, 0.0f, 320.0f, 0.0f)];
    
    loadingActivity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    loadingActivity.hidesWhenStopped = YES;
    loadingActivity.frame = CGRectMake(150.0f, self.view.frame.size.height / 2 - 10.0f, 20.0f, 20.0f);
    pullToRefreshEnabled = NO;
    self.tableView.showsVerticalScrollIndicator = YES;
    [self.view addSubview:loadingActivity];
}

    

- (void) setPullToRefreshEnabled:(BOOL)enabled
{
    if (pullToRefreshEnabled != enabled) {
        if (enabled == YES) 
        {
            [self.view addSubview:refreshHeaderView];
        }
        else 
        {
            [refreshHeaderView removeFromSuperview];
        }
        pullToRefreshEnabled = enabled;
    }

}

#pragma mark -
#pragma mark Status Changes
- (void) showReloadAnimationAnimated:(BOOL)animated
{
    reloading = YES;
    [refreshHeaderView toggleActivityView:YES];
    
    if (animated)
    {
        [UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		self.tableView.contentInset = UIEdgeInsetsMake(50.0f, 0.0f, 0.0f, 0.0f);
		[UIView commitAnimations];
    }
    else 
    {
        self.tableView.contentInset = UIEdgeInsetsMake(50.0f, 0.0f, 0.0f, 0.0f);
    }
    
}

- (void) reloadTableViewDataSource
{
	//[self dataSourceDidFinishLoadingNewData];
}

- (void) dataSourceDidFinishLoadingNewData
{
    reloading = NO;
    [refreshHeaderView flipImageAnimated:NO];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
	[self.tableView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
    [UIView commitAnimations];
	[refreshHeaderView setStatus:kPullToReloadStatus];
    [refreshHeaderView setLastUpdatedDate:[NSDate date]];
	[refreshHeaderView toggleActivityView:NO];

}

- (void) refresh
{
    [self.tableView reloadData];
}

- (void) fetch
{
    NSLog(@"Override is needed.");
    NSAssert(NO, @"Override fetch method is needed.");
}

#pragma mark -
#pragma mark Scrolling Overrides
- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (!pullToRefreshEnabled) 
    {
        return;
    }
    
    if (!reloading) 
    {
        checkForRefresh = YES;
    }
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!pullToRefreshEnabled) 
    {
        return;
    }
    
    if (reloading) 
    {
        return;
    }
    
    if (checkForRefresh)
    {
        if (refreshHeaderView.isFlipped && scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f && !reloading)
        {
            [refreshHeaderView flipImageAnimated:YES];
            [refreshHeaderView setStatus:kPullToReloadStatus];
        }
        else if (!refreshHeaderView.isFlipped && scrollView.contentOffset.y < -65.0f)
        {
            [refreshHeaderView flipImageAnimated:YES];
            [refreshHeaderView setStatus:kReleaseToReloadStatus];
        }
    }
}

- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!pullToRefreshEnabled) 
    {
        return;
    }
    
    if (reloading) 
    {
        return;
    }
    
    if (scrollView.contentOffset.y <= -65.0f) 
    {
        if([self.tableView.dataSource respondsToSelector:
            @selector(reloadTableViewDataSource)]){
			[self showReloadAnimationAnimated:YES];
			[self reloadTableViewDataSource];
		}
    }
    checkForRefresh = NO;
}

#pragma mark -
#pragma mark BBSParserDelegate
- (void) onParseSuccessful:(NSDictionary *)data
{
    [loadingActivity performSelectorOnMainThread:@selector(stopAnimating) withObject:nil waitUntilDone:NO];
    [self performSelectorOnMainThread:@selector(dataSourceDidFinishLoadingNewData) withObject:nil waitUntilDone:NO];
}

- (void) onParseFailed:(ErrorType)error
{
    switch (error) 
    {
        case ErrorTypeNetwork:
            [self popUpRetryAlertWithTitle:@"发生错误" Message:@"网络错误"];
            break;
        case ErrorTypeParse:
            [self popUpConfirmAlertWithTitle:@"发生错误" Message:@"解析文档时发生错误"];
            break;
        case ErrorTypeEncoding:
            [self popUpConfirmAlertWithTitle:@"发生错误" Message:@"由于文档编码错误，该页无法显示"];
            break;
        default:
            assert(NO);
    }
}

- (void) popUpRetryAlertWithTitle:(NSString *)title Message:(NSString *)message
{
    UINavigationController * navController = [self navigationController];
    UITabBarController * tabController = [self tabBarController];
    if ([tabController selectedViewController] != navController ||
        self != [navController visibleViewController]) 
    {
        //If this is not the visible view controller, ignore the alert
        return;
    }
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重试", nil];
    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
    [alert release];
}

- (void) popUpConfirmAlertWithTitle:(NSString *)title Message:(NSString *)message;
{
    UINavigationController * navController = [self navigationController];
    UITabBarController * tabController = [self tabBarController];
    if ([tabController selectedViewController] != navController ||
        self != [navController visibleViewController]) 
    {
        //If this is not the visible view controller, ignore the alert
        return;
    }
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
    [alert release];
}

#pragma mark -
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [loadingActivity performSelectorOnMainThread:@selector(stopAnimating) withObject:nil waitUntilDone:NO];
            [self performSelectorOnMainThread:@selector(dataSourceDidFinishLoadingNewData) withObject:nil waitUntilDone:NO];
            break;
        case 1:
            [self fetch];
            break;
        default:
            assert(NO);
            break;
    }
}

- (void)dealloc {
    [refreshHeaderView release];
    [super dealloc];
}


@end

