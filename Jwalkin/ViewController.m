
//  ViewController.m
//  Jwalkin
//
//  Created by Kanika on 06/11/13.
//  Copyright (c) 2013 fox. All rights reserved.
//

#import "ViewController.h"
#import "HomeVC.h"
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"
#import "TutorialVC.h"

@interface ViewController ()
{
    int count;
}
@end

@implementation ViewController
@synthesize locationManager;

- (void)viewDidLoad
{
    [super viewDidLoad];
    app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    count = 0;
    [[UINavigationBar appearance]setFrame:CGRectMake(0, 0, 320, 64)];

   // [self startUpdate];
 //   [self GoToNxt];
    
	// Do any additional setup after loading the view, typically from a nib.
}


-(void)viewWillAppear:(BOOL)animated
{
    [self startUpdate];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
   NSLog(@"Error: %@", [error description]);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation * currentlocation=[locations lastObject];
    app.clLocation = currentlocation;
    app.userNewLocatiion=currentlocation;
    [self stopUpdate];

    //NSLog(@"%f  %f",newLocation.coordinate.latitude,newLocation.coordinate.longitude);
    //NSLog(@"1:-  %f  %f",app.clLocation.coordinate.latitude,app.clLocation.coordinate.longitude);
    if (app.clLocation.coordinate.latitude == 0.00000 && app.clLocation.coordinate.longitude == 0.00000)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"JwalkIn" message:@"You have not allow to use your current location, you couldn't preoceed further." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag = 1;
        [alert show];
    }
    else
    {
        if (count == 0)
        {
            [self performSelector:@selector(GoToNxt) withObject:nil afterDelay:2.0];
            count++;
        }
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation
          fromLocation:(CLLocation *)oldLocation
{
    app.clLocation = newLocation;
    app.userNewLocatiion=newLocation;

    [self stopUpdate];
    
    //NSLog(@"%f  %f",newLocation.coordinate.latitude,newLocation.coordinate.longitude);
    //NSLog(@"2:  %f  %f",app.clLocation.coordinate.latitude,app.clLocation.coordinate.longitude);
    
    if (app.clLocation.coordinate.latitude == 0.00000 && app.clLocation.coordinate.longitude == 0.00000)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"JwalkIn" message:@"You have not allow to use your current location, you couldn't preoceed further." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag = 1;
        [alert show];
    }
    else
    {
        if (count == 0)
        {
            [self performSelector:@selector(GoToNxt) withObject:nil afterDelay:2.0];
            count++;
        }
    }
}

-(void)startUpdate
{
    locationManager=[[CLLocationManager alloc] init];
    locationManager.delegate=self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [self.locationManager requestWhenInUseAuthorization];
    }
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
    {
        [self.locationManager requestAlwaysAuthorization];
    }
    [locationManager startUpdatingLocation];

}

-(void)stopUpdate
{
    [locationManager stopUpdatingLocation];
    locationManager=nil;
}



-(void)GoToNxt
{
    //Dp (23Dec)
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"hasIntroShown"])
    {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            TutorialVC *introVC = [[TutorialVC alloc] initWithNibName:@"TutorialVC" bundle:nil];
            [self.navigationController presentViewController:introVC animated:YES completion:nil];
            
           [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasIntroShown"];
          [[NSUserDefaults standardUserDefaults] synchronize];
        });
    }//Dp (23Dec)
    HomeVC *home = [[HomeVC alloc] initWithNibName:@"HomeVC" bundle:nil];
    [self.navigationController pushViewController:home animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
