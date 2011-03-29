//
//  Top10ViewController.m
//  ghbbs
//
//  Created by Chenqun Hang on 9/28/10.
//  Copyright 2010 bufbomb.com. All rights reserved.
//

#import "Top10ViewController.h"
#import "ThreadPostViewController.h"
#import "Top10Parser.h"
#import "Top10Item.h"
#import "Top10ViewCell.h"

@implementation Top10ViewController


#pragma mark -
#pragma mark Initialization

- (id) init
{
    if (self = [super init])
    {
        self.title = @"本日十大";
        top10Items = [[NSMutableArray alloc] init];
        isLoading = NO;
        tabBarItem = [[UITabBarItem alloc] initWithTitle:self.title image:[UIImage imageNamed:@"heart.png"] tag:2];
        self.tabBarItem = tabBarItem;
    }
    return self;
}

- (void) fetch
{
    if (!isLoading) 
    {
        isLoading = YES;
        [loadingActivity startAnimating];
        NSString * urlstr = [[NSString alloc] initWithFormat:@"http://bbs.fudan.sh.cn/bbs/top10"];
        NSURL * url = [[NSURL alloc] initWithString:urlstr];
        Top10Parser * parser = [[Top10Parser alloc] initWithURL:url];
        [urlstr release];
        [url release];
        parser.delegate = self;
        NSOperationQueue * queue = [NSOperationQueue new];
        [queue addOperation:parser];
        [parser release];
    }
}

#pragma mark -
#pragma mark View lifecycle
- (void) loadView
{
    [super loadView];
    [self setPullToRefreshEnabled:YES];
    self.tableView.rowHeight = 50;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:YES];
    if ([self.tableView numberOfRowsInSection:0] == 0)
    {
        [self fetch];
    }
}
/*
- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/

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
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [top10Items count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    Top10ViewCell *cell = (Top10ViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[Top10ViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    [cell resetAll];

    Top10Item * item = [top10Items objectAtIndex:[indexPath row]];
	[cell setItem:item];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [cell setNeedsDisplay];
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



#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    int row = [indexPath row];
    assert(row < [top10Items count]);
    Top10Item * item = [top10Items objectAtIndex:row];
    if(item != nil)
    {
        UIViewController * controller = [[ThreadPostViewController alloc] initWithBoardName:item.boardName Pid:item.pid];
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
    }
    
}


#pragma mark -
#pragma mark BBSParserDelegate
- (void) onParseSuccessful:(NSDictionary *)data
{
    isLoading = NO;
    [super onParseSuccessful:data];
    NSArray * items = [data objectForKey:kTop10];
    [top10Items removeAllObjects];
    [top10Items addObjectsFromArray:items];
    [self performSelectorOnMainThread:@selector(refresh) withObject:nil waitUntilDone:NO];
}

- (void) onParseFailed:(ErrorType)error
{
    isLoading = NO;
    [super onParseFailed:error];
}

#pragma mark -
#pragma mark DataSourceUpdate
- (void) reloadTableViewDataSource
{
    [self fetch];
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


- (void)dealloc {
    [tabBarItem release];
    [top10Items release];
    [super dealloc];
}


@end

