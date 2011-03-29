//
//  BoardViewController.m
//  ghbbs
//
//  Created by Chenqun Hang on 9/9/10.
//  Copyright 2010 bufbomb.com. All rights reserved.
//

#import "BoardViewController.h"
#import "NormalPostViewController.h"
#import "ThreadPostViewController.h"
#import "GoodPostViewController.h"
#import "NewPostViewController.h"
#import "BoardViewCell.h"
#import "BoardParser.h"
#import "Post.h"
#import "AuthenticationUtility.h"

@interface BoardViewController ()
- (Post *) getTheIthPost:(int) index;
- (void) fetchFirstPage;
- (void) fetchPageFromStart:(int)start;
- (void) fetchFirstThreadPage;
- (void) fetchThreadPageFromStart:(int)start;
- (void) fetchFirstGoodPage;
- (void) fetchGoodPageFromStart:(int)start;
- (void) fetchFromURL:(NSURL *)url;
@end


@implementation BoardViewController


#pragma mark -
#pragma mark Initialization

- (id) initWithBoard:(Board *)_board
{
    if (self = [super init])
    {
        board = [_board retain];
        self.title = board.name;
        viewMode = ViewModeNormal;
        postStart = 0;
        threadPostStart = 0;
        goodPostStart = 0;
        posts = [NSMutableArray new];
        stickPosts = [NSMutableArray new];
        threadPosts = [NSMutableArray new];
        goodPosts = [NSMutableArray new];
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
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
                                                                                 action:@selector(beginPost)];
        self.navigationItem.rightBarButtonItem = button;
        [button release];
    }
    
    UIBarButtonItem * normalModeButton = [[UIBarButtonItem alloc] initWithTitle:@"一般" style:UIBarButtonItemStylePlain target:self action:@selector(changeToNormalMode)];
    UIBarButtonItem * threadModeButton = [[UIBarButtonItem alloc] initWithTitle:@"主题" style:UIBarButtonItemStylePlain target:self action:@selector(changeToThreadMode)];
    UIBarButtonItem * goodModeButton = [[UIBarButtonItem alloc] initWithTitle:@"文摘" style:UIBarButtonItemStylePlain target:self action:@selector(changeToGoodMode)];
    normalModeButton.width = 100.0f;
    threadModeButton.width = 100.0f;
    goodModeButton.width = 100.0f;
    [self setToolbarItems:[NSArray arrayWithObjects:normalModeButton, threadModeButton, goodModeButton, nil]];
    [normalModeButton release];
    [threadModeButton release];
    [goodModeButton release];
/*    NSArray * buttons = [NSArray arrayWithObjects:@"a",@"b",nil];
    UISegmentedControl * segmentedControl = [[UISegmentedControl alloc] initWithItems:buttons];
    UIBarButtonItem * toolBarButton = [[UIBarButtonItem alloc] initWithCustomView:segmentedControl];
    [self setToolbarItems:[NSArray arrayWithObject:toolBarButton]];*/
    [self setPullToRefreshEnabled:YES];
    self.tableView.rowHeight = 50.0;
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
}



- (void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
    int number = 0;
    switch (viewMode)
    {
        case ViewModeNormal:
            number = [posts count] + [stickPosts count];
            break;
        case ViewModeThread:
            number = [threadPosts count];
            break;
        case ViewModeGood:
            number = [goodPosts count];
            break;
        default:
            assert(NO);
    }
    assert(number >= 0);
    if (number == 0)
    {
        [self fetch];
    }
    [self.navigationController setToolbarHidden:NO];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/

- (void)viewDidDisappear:(BOOL)animated {
    [self.navigationController setToolbarHidden:YES];
}
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void) beginPost
{
    NewPostViewController * newPostViewController = [[NewPostViewController alloc] init];
    [newPostViewController setTarget:self Selector:@selector(endPostWithTitle:Content:)];
    [newPostViewController setBid:board.bid];
    [self.navigationController pushViewController:newPostViewController animated:YES];
}

- (void) endPostWithTitle:(NSString *)title Content:(NSString *)content
{
    //TODO: add post;
}

#pragma mark -
#pragma mark Mode Change
- (void) changeToNormalMode
{
    if (viewMode != ViewModeNormal) 
    {
        viewMode = ViewModeNormal;
        [self modeChanged];
    }
}

- (void) changeToThreadMode
{
    if (viewMode != ViewModeThread)
    {
        viewMode = ViewModeThread;
        [self modeChanged];
    }
}

- (void) changeToGoodMode
{
    if (viewMode != ViewModeGood)
    {
        viewMode = ViewModeGood;
        [self modeChanged];
    }
}

- (void) modeChanged
{
    [self refresh];
}

- (Post *) getTheIthPost:(int) index
{
    Post * post;
    switch (viewMode) {
        case ViewModeNormal:
            if (index < [stickPosts count])
            {
                post = [stickPosts objectAtIndex:index];
            }
            else if (index < [stickPosts count] + [posts count])
            {
                post = [posts objectAtIndex:index - [stickPosts count]];
            }
            else 
            {
                assert(index == [posts count] + [stickPosts count]);
                post = nil;
            }
            break;
        case ViewModeThread:
            if (index < [threadPosts count])
            {
                post = [threadPosts objectAtIndex:index];
            }
            else 
            {
                assert(index == [threadPosts count]);
                post = nil;
            }
            break;
        case ViewModeGood:
            if (index < [goodPosts count])
            {
                post = [goodPosts objectAtIndex:index];
            }
            else 
            {
                assert(index == [goodPosts count]);
                post = nil;
            }
            break;
            
        default:
            assert(NO);
            break;
    }
    return post;
}

- (void) fetchFirstPage
{
    NSString * urlstr = [NSString stringWithFormat:@"http://bbs.fudan.sh.cn/bbs/doc?board=%@", board.name];
    NSURL * url = [NSURL URLWithString:urlstr];
    [self fetchFromURL:url];
}

- (void) fetchPageFromStart:(int)start
{
    NSString * urlstr  = [NSString stringWithFormat:@"http://bbs.fudan.sh.cn/bbs/doc?bid=%@&start=%d", board.bid, start - 20];
    NSURL * url = [NSURL URLWithString:urlstr];
    [self fetchFromURL:url];
}

- (void) fetchFirstThreadPage
{
    NSString * urlstr = [NSString stringWithFormat:@"http://bbs.fudan.sh.cn/bbs/tdoc?board=%@", board.name];
    NSURL * url = [NSURL URLWithString:urlstr];
    [self fetchFromURL:url];
}

- (void) fetchThreadPageFromStart:(int)start
{
    NSString * urlstr  = [NSString stringWithFormat:@"http://bbs.fudan.sh.cn/bbs/tdoc?bid=%@&start=%d", board.bid, start - 20];
    NSURL * url = [NSURL URLWithString:urlstr];
    [self fetchFromURL:url];
}

- (void) fetchFirstGoodPage
{
    NSString * urlstr = [NSString stringWithFormat:@"http://bbs.fudan.sh.cn/bbs/gdoc?board=%@", board.name];
    NSURL * url = [NSURL URLWithString:urlstr];
    [self fetchFromURL:url];    
}

- (void) fetchGoodPageFromStart:(int)start
{
    NSString * urlstr  = [NSString stringWithFormat:@"http://bbs.fudan.sh.cn/bbs/gdoc?bid=%@&start=%d", board.bid, start - 20];
    NSURL * url = [NSURL URLWithString:urlstr];
    [self fetchFromURL:url];    
}

- (void) fetch
{
    switch (viewMode) 
    {
        case ViewModeNormal:
            if (postStart == 0) 
            {
                [self fetchFirstPage];
            }
            else 
            {
                [self fetchPageFromStart:postStart];
            }

            break;
        case ViewModeThread:
            if (threadPostStart == 0)
            {
                [self fetchFirstThreadPage];
            }
            else
            {
                [self fetchThreadPageFromStart:threadPostStart];
            }

            break;
        case ViewModeGood:
            if (goodPostStart == 0) 
            {
                [self fetchFirstGoodPage];
            }
            else 
            {
                [self fetchGoodPageFromStart:goodPostStart];
            }
            
            break;
        default:
            assert(NO);
            break;
    }
}

- (void) fetchFromURL:(NSURL *)url
{
    BoardParser * parser = [[BoardParser alloc] initWithURL:url Mode:viewMode];
    parser.delegate = self;
    NSOperationQueue * queue = [NSOperationQueue new];
    [queue addOperation:parser];
    [parser release];
    [queue release];
}

- (void) refresh
{
    [super refresh];
    if ([self.tableView numberOfRowsInSection:0] == 0) 
    {
        [self fetch];
    }
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    int number = 0; 
    switch (viewMode)
    {
        case ViewModeNormal:
            number = [posts count] + [stickPosts count] + 1;
            break;
        case ViewModeThread:
            number = [threadPosts count] + 1;
            break;
        case ViewModeGood:
            number = [goodPosts count] + 1;
            break;
        default:
            assert(NO);
            return 0;
    }
    if (number <= 1) 
    {
        return 0;
    }
    else
    {
        return number;
    }
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    BoardViewCell *cell = (BoardViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[BoardViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    [cell resetAll];
    
    int row = [indexPath row];
    Post * post = [self getTheIthPost:row];
    if (post != nil)
    {
        [cell setPost:post];
    }
    else 
    {
        [cell setTitle:@"查看更多..."];
        [self fetch];
    }

    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/
#pragma mark BBSParserDelegate
- (void) onParseSuccessful:(NSDictionary *)data
{
    [super onParseSuccessful:data];
    NSArray * _posts = [data objectForKey:kPost];
    NSArray * _stickPosts = [data objectForKey:kStickPost];
    NSNumber * modeNumber = [data objectForKey:kMode];
    NSNumber * startNumber = [data objectForKey:kStart];
    NSString * _bid  = [data objectForKey:kBid];
    assert(_bid);
    assert(startNumber);
    board.bid = _bid;
    ViewMode mode = (ViewMode)[modeNumber intValue];
    if ([stickPosts count] == 0 && _stickPosts != nil)
    {
        [stickPosts addObjectsFromArray:_stickPosts];
    }
    switch (mode) {
        case ViewModeNormal:
            [posts addObjectsFromArray:_posts];
            postStart = [startNumber intValue];
            break;
        case ViewModeThread:
            [threadPosts addObjectsFromArray:_posts];
            threadPostStart = [startNumber intValue];
            break;
        case ViewModeGood:
            [goodPosts addObjectsFromArray:_posts];
            goodPostStart = [startNumber intValue];
            break;
        default:
            assert(NO);
            break;
    }
    [self performSelectorOnMainThread:@selector(refresh) withObject:nil waitUntilDone:NO];
}

- (void) onParseFailed:(ErrorType)error
{
    [super onParseFailed:error];
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    int row = [indexPath row];
    Post * post = [self getTheIthPost:row];
    if(post!=nil)
    {
        UIViewController * controller;
        switch (viewMode) {
            case ViewModeNormal:
                controller = [[NormalPostViewController alloc] initWithBid:board.bid Post:post];
                break;
            case ViewModeThread:
                controller = [[ThreadPostViewController alloc] initWithBoardName:board.name Pid:post.pid];
                break;
            case ViewModeGood:
                controller = [[GoodPostViewController alloc] initWithBid:board.bid Post:post];
                break;
            default:
                assert(NO);
                break;
        }
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
    }
}


#pragma mark -
#pragma mark DataSourceUpdate
- (void) reloadTableViewDataSource
{
    [posts removeAllObjects];
    [stickPosts removeAllObjects];
    [threadPosts removeAllObjects];
    [goodPosts removeAllObjects];
    postStart = 0;
    threadPostStart = 0;
    goodPosts = 0;
    [self refresh];
}

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


- (void)dealloc 
{
    [posts release];
    [threadPosts release];
    [goodPosts release];
    [stickPosts release];
    [board release];
    [super dealloc];
}


@end

