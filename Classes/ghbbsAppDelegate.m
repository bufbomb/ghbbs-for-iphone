//
//  ghbbsAppDelegate.m
//  ghbbs
//
//  Created by Chenqun Hang on 9/6/10.
//  Copyright bufbomb.com 2010. All rights reserved.
//

#import "ghbbsAppDelegate.h"
#import "AccountViewController.h"
#import "CategoryViewController.h"
#import "Top10ViewController.h"
#import "CategoryDataSource.h"
#import "FavViewController.h"
#import "NetworkTest.h"
#import "AuthenticationUtility.h"

#import "StorageManager.h"


@implementation ghbbsAppDelegate

@synthesize window;
@synthesize tabBarController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    [StorageManager sharedInstance];
    
    window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    tabBarController = [[UITabBarController alloc] init];

    CategoryViewController * categoryViewController = [[CategoryViewController alloc] init];
    UINavigationController * navCategoryViewController = [[UINavigationController alloc] initWithRootViewController:categoryViewController];
    
    Top10ViewController * top10ViewController = [[Top10ViewController alloc] init];
    UINavigationController * navTop10ViewController = [[UINavigationController alloc] initWithRootViewController:top10ViewController];
    NSMutableArray * controllers = [[NSMutableArray alloc] init];

    AccountViewController * accountViewController = [[AccountViewController alloc] init];
    UINavigationController * navAccountController = [[UINavigationController alloc] initWithRootViewController:accountViewController];
    
    
    FavViewController * favViewController = [[FavViewController alloc] init];
    UINavigationController * navFavController = [[UINavigationController alloc] initWithRootViewController:favViewController];
    
    [controllers addObject:navCategoryViewController];
    [controllers addObject:navTop10ViewController];
    [controllers addObject:navFavController];
    [controllers addObject:navAccountController];

    
    
    [categoryViewController release];
    [top10ViewController release];
    [accountViewController release];
    [favViewController release];
    [navAccountController release];
    [navCategoryViewController release];
    [navTop10ViewController release];
    [navFavController release];
    tabBarController.viewControllers = controllers;
    
    [controllers release];
    [window addSubview:tabBarController.view];
    [window makeKeyAndVisible];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;


    [CategoryDataSource sharedInstance];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
    [[AuthenticationUtility sharedInstance] signoutUntilDone:YES];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    if ([self checkNetwork] && [self checkSiteAvailablity:@"bbs.fudan.sh.cn"]) {
        ;
    }
    
    /*NSString * username = [[NSUserDefaults standardUserDefaults] objectForKey:@"name"];
    NSString * password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    if (username && password) 
    {
        [[AuthenticationUtility sharedInstance] signin];
    }*/
    [[AuthenticationUtility sharedInstance] signin];
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
    //[[AuthenticationUtility sharedInstance] signout];
}



#pragma mark -
#pragma mark UITabBarControllerDelegate methods

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
}
*/


- (void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
//    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Receive a notification" delegate:nil cancelButtonTitle:@"OK, I see." otherButtonTitles:nil];
//    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
//    [alert release];
    NSLog(@"received");
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}

- (BOOL)checkNetwork
{
    BOOL connected = [NetworkTest connectedToNetwork];
    if (!connected) 
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"无网络连接" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
        [alert release];
    }
    return connected;
}

- (BOOL)checkSiteAvailablity: (NSString *)theHost
{
    BOOL available = [NetworkTest hostAvailable:theHost];
    if (!available) 
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"网站无法访问" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
        [alert release];
    }
        
    return available;
}

- (void)dealloc {
    [tabBarController release];
    [window release];
    [super dealloc];
}

@end

