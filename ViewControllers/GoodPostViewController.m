    //
//  GoodPostViewController.m
//  ghbbs
//
//  Created by Chenqun Hang on 12/4/10.
//  Copyright 2010 bufbomb.com. All rights reserved.
//

#import "GoodPostViewController.h"

@interface GoodPostViewController ()
- (void) fetchNextPostFrom:(Post *)post;
- (void) fetchPreviousPostFrom:(Post *)post;
@end


@implementation GoodPostViewController

- (id) initWithBid:(NSString *)_bid Post:(Post *)_post
{
    if (self = [super init])
    {
        assert(_post != nil);
        assert(_bid != nil);
        bid = [_bid copy];
        pid = [_post.pid copy];
        forward = YES;
    }
    return self;
}

#pragma mark -
#pragma mark Override
- (void) loadData:(NSArray *)_posts
{
    assert([_posts count] < 2);
    
    int index;
    if (forward) 
    {
        index = [posts count];
        [posts addObjectsFromArray:_posts];
    }
    else {
        for(id obj in _posts)
        {
            [posts insertObject:obj atIndex:0];
        }
        index = 0;
    }
    assert(_posts != nil);
    currentPost = [posts objectAtIndex:index];
}

- (void) fetchFirstPost
{
    assert(bid != nil);
    assert(pid != nil);
    NSMutableString * feedURLString;
    feedURLString = [NSString stringWithFormat:@"http://bbs.fudan.sh.cn/bbs/gcon?bid=%@&f=%@", bid, pid];
    
    NSURL * url = [NSURL URLWithString:feedURLString];
    [self fetchPostWithURL:url];
}

- (void) fetchNextPostFrom:(Post *)post
{
    assert(forward);
    assert(post != nil);
    NSMutableString * feedURLString = [NSString stringWithFormat:@"http://bbs.fudan.sh.cn/bbs/gcon?bid=%@&f=%@&a=n", bid, currentPost.pid];
    NSURL * url = [NSURL URLWithString:feedURLString];
    [self fetchPostWithURL:url];
}

- (void) fetchPreviousPostFrom:(Post *)post
{
    assert(!forward);
    assert(post != nil);
    NSMutableString * feedURLString = [NSString stringWithFormat:@"http://bbs.fudan.sh.cn/bbs/gcon?bid=%@&f=%@&a=p", bid, currentPost.pid];
    NSURL * url = [NSURL URLWithString:feedURLString];
    [self fetchPostWithURL:url];
}

- (void) viewPrevious
{
    [super viewPrevious];
    //TODO: Uncomment the following line when g post previous and next works
    /*forward = NO;
    uint index = [posts indexOfObject:currentPost];
    assert(index != NSNotFound);
    if(index > 0)
    {
        currentPost = [posts objectAtIndex:index - 1];
        [self refresh];
    }
    else
    {
        [self fetchPreviousPostFrom:currentPost];
    }*/
}

- (void) viewNext
{
    [super viewNext];
    //TODO: Uncomment the following line when g post previous and next works
    /*forward = YES;
    uint index = [posts indexOfObject:currentPost];
    assert(index != NSNotFound);
    if(index < [posts count] - 1)
    {
        currentPost = [posts objectAtIndex:index + 1];
        [self refresh];
    }
    else 
    {
        [self fetchNextPostFrom:currentPost];
    }*/
}


#pragma mark -
#pragma mark View lifecycle
- (void) loadView
{
    [super loadView];
    //TODO: Uncomment the following line when g post previous and next works
    [instrView removeFromSuperview];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
}




- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}



- (void)dealloc {
    [super dealloc];
}


@end
