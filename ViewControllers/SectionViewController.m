//
//  SectionViewController.m
//  ghbbs
//
//  Created by Chenqun Hang on 9/9/10.
//  Copyright 2010 bufbomb.com. All rights reserved.
//

#import "SectionViewController.h"
#import "BoardViewController.h"
#import "SectionParser.h"
#import "SectionViewCell.h"
#import "UserPreference.h"

@implementation SectionViewController


#pragma mark -
#pragma mark Initialization
- (id) initWithCategory:(Category *)_category
{
    if (self = [super init])
    {
        category = [_category retain];
        self.title = category.name;
        isCategory = YES;
        isLoading = NO;
    }
    return self;
}
- (id) initWithBoard:(Board *)_board
{
    if (self = [super init])
    {
        board = [_board retain];
        self.title = board.desc;
        isCategory = NO;
        isLoading = NO;
    }
    return self;;
}

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad 
{
    [super viewDidLoad];
    self.tableView.rowHeight = 50;
}


- (void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:YES];
    if(isCategory)
    {
        if ([category numberOfBoards] == 0)
        {
            [self fetch];
        }
        else 
        {
            [loadingActivity performSelectorOnMainThread:@selector(stopAnimating) withObject:nil waitUntilDone:NO];
            [self refresh];
        }
        
    }
    else
    {
        if ([board numberOfSubBoards] == 0) 
        {
            [self fetch];
        }
        else 
        {
            [loadingActivity performSelectorOnMainThread:@selector(stopAnimating) withObject:nil waitUntilDone:NO];
            [self refresh];
        }
    }
}

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
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(isCategory)
    {
        return [category numberOfBoards];
    }
    else
    {
        return [board numberOfSubBoards];
    }
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    SectionViewCell *cell = (SectionViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[SectionViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    [cell resetAll];
    
    Board * subBoard;
    if(isCategory)
    {
        subBoard = [category boardAtIndex:[indexPath row]];
    }
    else
    {
        subBoard = [board subBoardAtIndex:[indexPath row]];
    }
    assert(subBoard != nil);
	[cell setBoard:subBoard];
    //cell.isZone = subBoard.isZone;
    //cell.count = subBoard.total;
    //cell.BMs = [subBoard getBMs];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [cell setNeedsDisplay];
    return cell;
}

- (void) fetch
{
    if (!isLoading) 
    {
        [loadingActivity startAnimating];
        isLoading = YES;
        SectionParser * parser;
        if(isCategory)
        {
            NSString * urlstr = [[NSString alloc] initWithFormat:@"http://bbs.fudan.sh.cn/bbs/boa?s=%@", category.cid];
            NSURL * url = [[NSURL alloc] initWithString:urlstr];
            parser = [[SectionParser alloc] initWithURL: url];
            [urlstr release];
            [url release];
        }
        else
        {
            NSString * urlstr = [[NSString alloc] initWithFormat:@"http://bbs.fudan.sh.cn/bbs/boa?board=%@", board.name];
            NSURL * url = [[NSURL alloc] initWithString:urlstr];
            parser = [[SectionParser alloc] initWithURL: url];
            [urlstr release];
            [url release];
        }
        parser.delegate = self;
        NSOperationQueue * queue = [NSOperationQueue new];
        [queue addOperation:parser];
        [parser release];
        [queue release];
    }
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
#pragma mark BBSParserDelegate
- (void) onParseSuccessful:(NSDictionary *)data
{
    isLoading = NO;
    [super onParseSuccessful:data];
    NSMutableArray * boards = [data objectForKey:kSection];
    [boards sortUsingSelector:@selector(compare:)];
    if (isCategory) 
    {
        [category addBoards:boards];
    }
    else 
    {
        [board addSubBoards:boards];
    }
    [self performSelectorOnMainThread:@selector(refresh) withObject:nil waitUntilDone:NO];
}

- (void) onParseFailed:(ErrorType)error
{
    isLoading = NO;
    [super onParseFailed:error];
    assert(NO);
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Board * selectedBoard = nil;
    if(isCategory)
    {
        selectedBoard = [[category boardAtIndex:[indexPath row]] retain];
    }
    else
    {
        selectedBoard = [[board subBoardAtIndex:[indexPath row]] retain];
    }
    UIViewController * viewController = nil;
    if(selectedBoard.isZone)
    {
        viewController = [[SectionViewController alloc] initWithBoard:selectedBoard];
        
    } else 
    {
        viewController = [[BoardViewController alloc] initWithBoard:selectedBoard];
    }
    [selectedBoard release];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];                  
         
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
    [category release];
    [board release];
    [super dealloc];
}


@end

