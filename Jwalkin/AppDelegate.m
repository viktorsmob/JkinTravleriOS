//
//  AppDelegate.m
//  Jwalkin
//
//  Created by Kanika on 06/11/13.
//  Copyright (c) 2013 fox. All rights reserved.
//

#import "AppDelegate.h"
#import "UIDevice+IdentifierAddition.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "MBProgressHUD.h"
#import "Crittercism.h"
#import "WrapperClass.h"
#import <TwitterKit/TwitterKit.h>

@implementation AppDelegate
@synthesize viewController,navCtrl,clLocation,locationManager,isFromFav;
@synthesize selectedCat;
@synthesize selectedState;
@synthesize selectedSubCat;
@synthesize selectedCatName;
@synthesize selectedStateName;
@synthesize selectedSubcatName;
@synthesize imageNo;
NSString *const kTwitterConsumerKey = @"sAht3uY2ncZ2OPt1wuD6zcWz9";
NSString *const kTwitterCOnsumerSecret = @"your consumer secret";
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
   [Crittercism enableWithAppID:@"0fcf0d96f733472d8d48f57cb4f5395400555300"];
    [Fabric with:@[[Crashlytics class]]];

    
    viewController=[[ViewController alloc]init];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    self.navCtrl=[[UINavigationController alloc] initWithRootViewController:viewController];
    
    selectedStateName = [[NSString alloc] init];
    selectedCatName = [[NSString alloc]init];
    selectedSubcatName = [[NSString alloc]init];
    
    selectedSubcatName = @"";
    selectedStateName =@"";
    selectedCatName = @"";
    
    //cp
   // NSString *Udid=[[UIDevice currentDevice] uniqueGlobalDeviceIdentifier];
    //NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
//    [d setObject:Udid forKey:@"userid"];
//    [d synchronize];
    //cp
    self.navCtrl.navigationBarHidden=YES;
    [self copyDatabaseIfNeeded];
    self.window.rootViewController = self.navCtrl;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"ImageCount"])
    {
        imageNo =[ [[NSUserDefaults standardUserDefaults] objectForKey:@"ImageCount"] intValue];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"ImageCount"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        imageNo = 0;
    }
    
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    //NSLog(@"UIScreen height : %f",[UIScreen mainScreen].bounds.size.height);
    //Twitter secrect Key
    
    [[Twitter sharedInstance] startWithConsumerKey:kTwitterConsumerKey consumerSecret:kTwitterCOnsumerSecret];
    [Fabric with:@[[Twitter class]]];
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];
}

-(void)showHUD
{
    [MBProgressHUD showHUDAddedTo:self.window animated:YES];
}

-(void)hideHUD
{
    [MBProgressHUD hideHUDForView:self.window animated:YES];
}

// Database
-(void)copyDatabaseIfNeeded
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	NSString *dbPath = [self getDBPath];
	BOOL success = [fileManager fileExistsAtPath:dbPath];
	if(!success)
	{
		NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"JwalkinDB.sqlite"];
		success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
		if (!success)
			NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
	}
}

-(NSString *)getDBPath
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *documentsDir = [paths objectAtIndex:0];
	return [documentsDir stringByAppendingPathComponent:@"JwalkinDB.sqlite"];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [FBSDKAppEvents activateApp];
}
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
@end
