//
//  DirectionMapVC.h
//  Jwalkin
//
//  Created by Kanika on 11/11/13.
//  Copyright (c) 2013 fox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "annotationCtrl.h"
#import "AppDelegate.h"

@interface DirectionMapVC : UIViewController<MKAnnotation,MKMapViewDelegate,CLLocationManagerDelegate>
{
    IBOutlet MKMapView *myMapView;
    double newLat;
    double newLong;
    NSArray *RouteArray;
    IBOutlet UIActivityIndicatorView *av;
    AppDelegate *app;
    UIImageView *routeView;
}
@property(nonatomic,strong)NSString *strTitle;
@property(nonatomic,strong)IBOutlet UILabel *lblTitle;
@property(nonatomic,strong)NSString *locationName;
@property(nonatomic,retain)NSMutableArray *arrMapPoints;
@property(nonatomic,strong)NSString *address;
@property double mapLat;
-(NSArray*) calculateRoutesFrom:(CLLocationCoordinate2D) f to: (CLLocationCoordinate2D) t;
@property double mapLong;
@end
