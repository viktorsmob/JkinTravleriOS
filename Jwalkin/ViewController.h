//
//  ViewController.h
//  Jwalkin
//
//  Created by Kanika on 06/11/13.
//  Copyright (c) 2013 fox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@class AppDelegate;
@interface ViewController : UIViewController<CLLocationManagerDelegate>
{
    AppDelegate *app;
}
@property (nonatomic,strong)CLLocationManager *locationManager;
-(void)startUpdate;
-(void)stopUpdate;

@end
