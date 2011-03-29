//
//  PostViewController.m
//  ghbbs
//
//  Created by Chenqun Hang on 9/10/10.
//  Copyright 2010 bufbomb.com. All rights reserved.
//

#import "ThreadPostViewController.h"
#import "AuthenticationUtility.h"
#import "NewPostViewController.h"

@interface ThreadPostViewController()
- (void) fetchThreadPostFrom:(Post *)post;
@end


@implementation ThreadPostViewController

#pragma mark -
#pragma mark Initialization

- (id) initWithBoardName:(NSString *)_name Pid:(NSString *)_pid;
{
    if (self = [super init])
    {
        assert(_pid != nil);
        assert(_name != nil);
        boardName = [_name copy];
        pid = [_pid copy];
    }
    return self;
}


#pragma mark -
#pragma mark Override
- (void) loadData:(NSArray *)_posts
{
    assert(_posts != nil);
    if ([_posts count] == 0) 
    {
        return;
    }
    else 
    {
        int index = [posts count];
        [posts addObjectsFromArray:_posts];        
        currentPost = [posts objectAtIndex:index];
    }
}

- (void) fetchFirstPost
{
    assert(boardName != nil);
    assert(pid != nil);
    NSMutableString * feedURLString = [NSString stringWithFormat:@"http://bbs.fudan.sh.cn/bbs/tcon?board=%@&f=%@", boardName, pid];
    NSURL * url = [NSURL URLWithString:feedURLString];
    [self fetchPostWithURL:url];
}

- (void) fetchThreadPostFrom:(Post *)post
{
    assert(bid != nil);
    assert(pid != nil);
    NSString * feedURLString = [NSString stringWithFormat:@"http://bbs.fudan.sh.cn/bbs/tcon?bid=%@&g=%@&f=%@&a=n", bid, pid, post.pid];
    NSURL * url = [NSURL URLWithString:feedURLString];
    [self fetchPostWithURL:url];
}

- (void) viewPrevious
{
    [super viewPrevious];
    uint index = [posts indexOfObject:currentPost];
    assert(index != NSNotFound);
    if(index > 0)
    {
        currentPost = [posts objectAtIndex:index - 1];
        [self refresh];
    }
    else 
    {
        //It happens when use view previous from the first post of the thread
        [self popUpConfirmAlertWithTitle:@"发生错误" Message:@"已经是第一篇"];
    }

}

- (void) viewNext
{
    [super viewNext];
    uint index = [posts indexOfObject:currentPost];
    assert(index != NSNotFound);
    if(index < [posts count] - 1)
    {
        currentPost = [posts objectAtIndex:index + 1];
        [self refresh];
    }
    else 
    {
        [self fetchThreadPostFrom:currentPost];
    }
}

#pragma mark -
#pragma mark View lifecycle

- (void)loadView
{
    [super loadView];
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
}

- (void) viewDidUnload
{
    [super viewDidUnload];
}



#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)dealloc {
    [boardName release];
    [super dealloc];
}

@end

