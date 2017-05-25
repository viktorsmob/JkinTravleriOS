//
//  AppDelegate.h
//  Jwalkin
//
//  Created by Kanika on 06/11/13.
//  Copyright (c) 2013 fox. All rights reserved.
//   com.jwalkin.jwalkin jwalkin alex  ((((((Distribution

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "CoreLocation/CoreLocation.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate>

@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,strong)CLLocation *clLocation;
@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,strong)UINavigationController *navCtrl;
@property (nonatomic, strong) ViewController *viewController;
@property int isFromFav;
@property  int selectedCat;
@property  int selectedState;
@property  int selectedSubCat;
@property (nonatomic,strong) NSString *selectedCatName;
@property (nonatomic,strong) NSString *selectedSubcatName;
@property (nonatomic,strong) NSString *selectedStateName;
@property(nonatomic,strong)CLLocation *CurrentUserLocation,*userNewLocatiion;
@property int imageNo;

-(void)showHUD;
-(void)hideHUD;



//Manish
@property (nonatomic,strong) NSMutableDictionary * dictUserInfoFB;
@property (nonatomic,strong) NSMutableDictionary * dictUserInfoFB1;


@end
