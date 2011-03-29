//
//  PostViewController.m
//  ghbbs
//
//  Created by Chenqun Hang on 9/10/10.
//  Copyright 2010 bufbomb.com. All rights reserved.
//

#import "PostViewController.h"
#import "NewPostViewController.h"
#import "AuthenticationUtility.h"

@implementation PostViewController

#pragma mark -
#pragma mark Initialization

- (id) init
{
    if (self = [super init])
    {
        posts = [[NSMutableArray alloc] init];
        bid = nil;
        pid = nil;
        currentPost = nil;
        currentURL = nil;
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void) loadData:(NSArray *)_posts
{
    ;
}



- (void) fetchFirstPost
{
    ;
}

- (void) fetchPostWithURL:(NSURL *)url
{
    [currentURL release];
    currentURL = [url retain];
    [self fetch];
}

- (void) fetch
{
    NSOperationQueue * queue = [NSOperationQueue new];
    PostParser * parser = [[PostParser alloc] initWithURL:currentURL];
    parser.delegate = self;
    [queue addOperation:parser];
    [parser release];
    [queue release];
}

- (void) dismissInstructView
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelay:0.8];
    [instrView setAlpha:0.0f];
    [UIView commitAnimations];
}

#pragma mark -
#pragma mark View lifecycle

- (void)loadView
{
    [super loadView];
    if ([AuthenticationUtility sharedInstance].status == SignedIn) 
    {
        UIBarButtonItem * button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                 target:self 
                                                                                 action:@selector(showActionSheet)];
        self.navigationItem.rightBarButtonItem = button;
        [button release];
    }
    scrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    postView = [[PostView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 480.0f)];
    postView.delegate = self;
    instrView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"instruction"]];
    scrollView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:postView];
    [scrollView addSubview:instrView];
    self.view = scrollView;
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
    [self dismissInstructView];
    [self fetchFirstPost];
}



#pragma mark -
#pragma mark BBSParserDelegate
- (void) onParseSuccessful:(NSDictionary *)data
{
    //NSArray * _posts = [data objectForKey:kPost];
    //[self loadData:_posts];
    //[self performSelectorOnMainThread:@selector(refresh) withObject:nil waitUntilDone:NO];
    NSArray * _posts = [data objectForKey:kPost];
    NSString * _bid = [data objectForKey:kBid];
    if (_bid != nil) 
    {
        bid = [_bid copy];
    }
    if ([_posts count] > 0) 
    {
        [self loadData:_posts];
        [self performSelectorOnMainThread:@selector(refresh) withObject:nil waitUntilDone:NO];
    }
    else 
    {
        [self popUpConfirmAlertWithTitle:@"发生错误" Message:@"没有新文件"];
    }
}

- (void) onParseFailed:(ErrorType)error
{
    switch (error) 
    {
        case ErrorTypeNetwork:
            [self popUpRetryAlertWithTitle:@"发生错误" Message:@"网络错误"];
            break;
        case ErrorTypeFileNotFound:
            [self popUpConfirmAlertWithTitle:@"发生错误" Message:@"没有新的文件"];
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
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重试", nil];
    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
    [alert release];
}

- (void) popUpConfirmAlertWithTitle:(NSString *)title Message:(NSString *)message
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
    [alert release];
}

- (void) showActionSheet
{
    /*UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil 
                                                              delegate:self
                                                     cancelButtonTitle:@"取消" 
                                                destructiveButtonTitle:nil 
                                                     otherButtonTitles:@"回复本文", @"转载版面", @"转发邮箱", nil];    */
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil 
                                                              delegate:self
                                                     cancelButtonTitle:@"取消" 
                                                destructiveButtonTitle:nil 
                                                     otherButtonTitles:@"回复本文", nil];    
    [actionSheet showInView:self.view];
    [actionSheet release];
}

#pragma mark -
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
            [self beginPost];
            break;
        case 1:
            NSLog(@"zhuanzai");
            break;
        case 2:
            NSLog(@"zhuanfa");
            break;
        default:
            NSLog(@"quxiao");
            break;
    }
}

#pragma mark -
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            break;
        case 1:
            [self fetch];
            break;
        default:
            assert(NO);
            break;
    }
}


#pragma mark -
#pragma mark PostViewDelegate
- (void) onViewNext
{
    [self viewNext];
}

- (void) onViewPrevious
{
    [self viewPrevious];
}

- (void) viewPrevious
{
    ;
}

- (void) viewNext
{
    ;
}

- (void) beginPost
{
    NewPostViewController * newPostViewController = [[NewPostViewController alloc] init];
    [newPostViewController setTarget:self Selector:@selector(endPostWithTitle:Content:)];
    [newPostViewController setBid:bid];
    [newPostViewController setPid:currentPost.pid];
    [self.navigationController pushViewController:newPostViewController animated:YES];
}

- (void) endPostWithTitle:(NSString *)title Content:(NSString *)content
{
    ;
}

- (void) refresh
{
    [postView setText:currentPost.content];
    [scrollView scrollRectToVisible:CGRectMake(0.0f, 0.0f, 320.0f, 100.0f) animated:NO];
    scrollView.contentSize = postView.frame.size;
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/



#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [posts release];
    postView.delegate = nil;
    [bid release];
    [pid release];
    [postView release];
    [instrView release];
    [scrollView release];
    [currentURL release];
    [super dealloc];
}

@end

