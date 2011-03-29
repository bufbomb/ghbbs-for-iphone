//
//  FavViewController.m
//  ghbbs
//
//  Created by Chenqun Hang on 11/1/10.
//  Copyright 2010 bufbomb.com. All rights reserved.
//

#import "FavViewController.h"
#import "CategoryDataSource.h"
#import "CategoryParser.h"
#import "BoardViewController.h"
#import "AuthenticationUtility.h"
#import "FavViewCell.h"

@implementation FavViewController


#pragma mark -
#pragma mark Initialization
- (id) init
{
    if (self = [super init])
    {
        self.title = @"我的收藏";
        favItems = nil;
        isLoading = NO;
        [self setPullToRefreshEnabled:NO];
        tabBarItem = [[UITabBarItem alloc] initWithTitle:self.title image:[UIImage imageNamed:@"star.png"] tag:3];
        self.tabBarItem = tabBarItem;
    }
    return self;
}


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad 
{
    [super viewDidLoad];
    notSignedInView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"notsignedin.png"]];
    self.tableView.rowHeight = 50;
    favTableView = [self.tableView retain];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearContent) name:kUserStatusUpdate object:nil];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:YES];
    if ([[AuthenticationUtility sharedInstance] status] != SignedIn) 
    {
        self.view = notSignedInView;
    }
    else 
    {
        self.view = favTableView;
        if ([favTableView numberOfRowsInSection:0] == 0 && [[AuthenticationUtility sharedInstance] status] == SignedIn) 
        {
            [self fetch];
        }
    }
    
    /*if ([self.tableView numberOfRowsInSection:0] == 0 && [[AuthenticationUtility sharedInstance] status] == SignedIn) 
    {
        [self fetch];
    }*/
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

- (void) fetch
{
    if (!isLoading) 
    {
        isLoading = YES;
        [loadingActivity startAnimating];
        CategoryParser * parser = [[CategoryParser alloc] init];
        parser.delegate = self;
        NSOperationQueue * queue = [NSOperationQueue new];
        [queue addOperation:parser];
        [parser release];
    }
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    int number = [[CategoryDataSource sharedInstance] numberOfFavs];
    return number;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    FavViewCell *cell = (FavViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[FavViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    NSString * str = [[CategoryDataSource sharedInstance] favAtIndex:[indexPath row]];
    cell.title = str;
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
    NSString * boardName = [[CategoryDataSource sharedInstance] favAtIndex:[indexPath row]];
    assert(boardName);
    Board * board = [[Board alloc] initWithName:boardName Desc:nil Dir:0];
    UIViewController * viewController = [[BoardViewController alloc] initWithBoard:board];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];          
}

#pragma mark -
#pragma mark BBSParserDelegate
- (void) onParseSuccessful:(NSDictionary *)data
{
    isLoading = NO;
    [super onParseSuccessful:data];
    if ([[CategoryDataSource sharedInstance] numberOfCategories] == 0) 
    {
        NSArray * categories = [data objectForKey:kCategory];
        [[CategoryDataSource sharedInstance] addCategories:categories];
    }
    NSArray * favs = [data objectForKey:kFav];
    NSArray * uniqueFavs = [[NSSet setWithArray:favs] allObjects];
    NSArray * sortedFavs = [[NSMutableArray arrayWithArray:uniqueFavs] sortedArrayUsingSelector:@selector(compare:)];
    [[CategoryDataSource sharedInstance] addFavs:sortedFavs];
    [self performSelectorOnMainThread:@selector(refresh) withObject:nil waitUntilDone:NO];
}

- (void) onParseFailed:(ErrorType)error
{
    isLoading = NO;
    [super onParseFailed:error];
}

- (void) clearContent
{
    [[CategoryDataSource sharedInstance] removeFavs];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kUserStatusUpdate object:nil];
    [favTableView release];
    [notSignedInView release];
    [super viewDidUnload];
}


- (void)dealloc {
    [tabBarItem release];
    [super dealloc];
}


@end

