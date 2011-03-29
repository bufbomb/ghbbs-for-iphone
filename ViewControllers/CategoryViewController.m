//
//  CategoryViewController.m
//  ghbbs
//
//  Created by Chenqun Hang on 9/6/10.
//  Copyright 2010 bufbomb.com. All rights reserved.
//

#import "CategoryViewController.h"
#import "SectionViewController.h"
#import "CategoryParser.h"
#import "CategoryDataSource.h"
#import "Category.h"
#import "CategoryViewCell.h"

@implementation CategoryViewController


#pragma mark -
#pragma mark Initialization

- (id) init {
    if(self = [super initWithStyle:UITableViewStyleGrouped])
    {
        self.title = @"分类讨论";
        isLoading = NO;
        [self setPullToRefreshEnabled:NO];
        tabBarItem = [[UITabBarItem alloc] initWithTitle:self.title image:[UIImage imageNamed:@"cabinet.png"] tag:1];
        self.tabBarItem = tabBarItem;
    }
    return self;
}


#pragma mark -
#pragma mark View lifecycle
- (void)loadView
{
    [super loadView];
    //UIBarButtonItem * button = [[UIBarButtonItem alloc] initWithTitle:@"Refresh" style:UIBarButtonItemStylePlain target:self action:@selector(refresh)];
    //self.navigationItem.rightBarButtonItem = button;
    //[button release];
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
    self.tableView.rowHeight = 50;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([self.tableView numberOfRowsInSection:0] == 0) 
    {
        [self fetch];
    }
}

- (void) doClick
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"title" message:@"msg" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
    [alert release];
}

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
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    int number = [[CategoryDataSource sharedInstance] numberOfCategories];
    return number;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    CategoryViewCell *cell = (CategoryViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[CategoryViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    Category * category = [[CategoryDataSource sharedInstance] categoryAtIndex:[indexPath row]];
    assert(category != nil);
    [cell setCategoryName:category.name];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Category * category = [[[CategoryDataSource sharedInstance] categoryAtIndex:[indexPath row]] retain];
    SectionViewController * sectionViewController = [[SectionViewController alloc] initWithCategory:category];
    [self.navigationController pushViewController:sectionViewController animated:YES];
    [category release];
    [sectionViewController release];
}

#pragma mark -
#pragma mark BBSParserDelegate
- (void) onParseSuccessful:(NSDictionary *)data
{
    isLoading = NO;
    [super onParseSuccessful:data];
    NSArray * categories = [data objectForKey:kCategory];
    [[CategoryDataSource sharedInstance] addCategories:categories];
    [self performSelectorOnMainThread:@selector(refresh) withObject:nil waitUntilDone:NO];
}

- (void) onParseFailed:(ErrorType)error
{
    isLoading = NO;
    [super onParseFailed:error];
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
    [super dealloc];
}


@end

