//
//  ShowLocationsVC.h
//  Jwalkin
//
//  Created by Kanika on 11/11/13.
//  Copyright (c) 2013 fox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "annotationCtrl.h"
#import "AppDelegate.h"
#import "CallOutViewForFeed.h"
#import "calloutView.h"

@interface ShowLocationsVC : UIViewController<MKAnnotation,MKMapViewDelegate>
{
    IBOutlet MKMapView *myMapView;
    double newLat;
    double newLong;
	int CountAnnotaionForTitle;
    NSArray *RouteArray;
    AppDelegate *app;
    int countPins;
    CallOutViewForFeed *callViewFeed;
       calloutView *callView;
    
    CGRect popupRect;
    CGRect btnFrameInPopUp;
    BOOL isPopShowing;
    MKAnnotationView *refView1;
    NSInteger currentTag;

    NSDictionary *currentUserLocationDict;
    CLLocationCoordinate2D locationPin;

}
@property(nonatomic,strong)IBOutlet UILabel *lblTitle;
@property(nonatomic,strong)NSString *strTitle;
@property(nonatomic,strong)NSString *locationName;
@property(nonatomic,retain)NSMutableArray *arrMapPoints;
@property(nonatomic ,copy)NSString *saddr;
@property(nonatomic ,copy)NSString *daddr;
- (IBAction)BtnMapBack:(id)sender;
- (IBAction)BtnGetDirection:(id)sender;
- (IBAction)BtnUserFBInfo:(id)sender;

@property(nonatomic,strong)NSString *address;
@property double mapLat;
@property (strong, nonatomic) IBOutlet UIView *ViewOverLay;
@property double mapLong;
@end
