//
//  ShowLocationsVC.m
//  Jwalkin
//
//  Created by Kanika on 11/11/13.
//  Copyright (c) 2013 fox. All rights reserved.
//

#import "ShowLocationsVC.h"
#import "RegexKitLite.h"
#import "MapAnnotation.h"
#import "CouponVC.h"

@interface ShowLocationsVC ()

@end

@implementation ShowLocationsVC
@synthesize mapLat,mapLong,address,arrMapPoints,locationName;
@synthesize strTitle,lblTitle;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    lblTitle.text = self.strTitle;
    app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    for (int i =0; i<arrMapPoints.count; i++)
    {
        NSMutableDictionary *dic = [arrMapPoints objectAtIndex:i];
        CLLocationCoordinate2D location = CLLocationCoordinate2DMake([[dic valueForKey:@"lat"] doubleValue],[[dic valueForKey:@"long"] doubleValue]);
        myMapView.mapType = MKMapTypeStandard;
        myMapView.delegate = self;
        //Add the annotation to our map view
        annotationCtrl *newAnnotation = [[annotationCtrl alloc] initWithTitle:@"" andCoordinate:location];
        newAnnotation.myCustomTag=i;
        [myMapView addAnnotation:newAnnotation];
    }
    [self zoomToFitMapAnnotations:myMapView];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewDidAppear:(BOOL)animated
{
//    [self showOnMap:myMapView cord:App_Delegate.CurrentUserLocation.coordinate];
    
}

-(void)CallPinDrop
{
    
    for (int i =0; i<arrMapPoints.count; i++)
    {
        if (countPins < [arrMapPoints count])
        {
            NSMutableDictionary *dic = [arrMapPoints objectAtIndex:countPins];
            NSString *Address=[dic valueForKey:@"merchant_address"];
            NSString *Location=[dic valueForKey:@"merchant_name"];
            //NSLog(@"Locationname++===%@",Location);
//            [self FindLocation:Address location:Location];
            
            countPins++;
        }
    }
}

-(void)FindLocation:(NSString*)add_annSubtitle location:(NSString*)loc_annTitle
{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:add_annSubtitle
                 completionHandler:^(NSArray *placemarks, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(),^ {
             // do stuff with placemarks on the main thread
             if (placemarks.count == 0)
             {
                 
                 [self dismissViewControllerAnimated:YES completion:nil];
             }
             else
             {
                 CLPlacemark *placemark = [placemarks objectAtIndex:0];
                 CLLocation *location = placemark.location;
                 CLLocationCoordinate2D coordinate = location.coordinate;
                 CountAnnotaionForTitle++;
                 NSNumber *lat = [NSNumber numberWithDouble:coordinate.latitude];
                 NSNumber *lon = [NSNumber numberWithDouble:coordinate.longitude];
                 NSDictionary *userLocation=@{@"lat":lat,@"long":lon,@"title":loc_annTitle,@"subTitle":add_annSubtitle};
                 [self performSelectorOnMainThread:@selector(Called:) withObject:userLocation waitUntilDone:YES];
                 currentUserLocationDict=userLocation;
             }
         });
     }];
}

-(void)Called:(NSMutableDictionary *)locationdict
{
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake([[locationdict valueForKey:@"lat"] doubleValue],[[locationdict valueForKey:@"long"] doubleValue]);
    myMapView.mapType = MKMapTypeStandard;
    myMapView.delegate = self;
    MKCoordinateSpan span;
    span.latitudeDelta=0.2;
    span.longitudeDelta=0.2;
    //Add the annotation to our map view
	annotationCtrl *newAnnotation = [[annotationCtrl alloc] initWithTitle:@"" andCoordinate:location];
    //annotationCtrl *newAnnotation = [[annotationCtrl alloc] init];
    
 	MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location, 1000000, 1000000);
	[myMapView setRegion:region animated:YES];
//	newAnnotation.title = [locationdict valueForKey:@"title"];
//	newAnnotation.subtitle = [locationdict valueForKey:@"subTitle"];
    
    newAnnotation.myCustomTag=CountAnnotaionForTitle;
	[myMapView addAnnotation:newAnnotation];
    [self zoomToFitMapAnnotations:myMapView];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 6.1)
    {
        [self CallPinDrop];
    }
}

-(MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKPinAnnotationView *pinAnotation=nil;
    if (annotation != myMapView.userLocation)
    {
        static NSString *pinId=@"com.invasivecode.pin";
        pinAnotation = (MKPinAnnotationView *)[myMapView dequeueReusableAnnotationViewWithIdentifier:pinId];
        if(pinAnotation==nil)
        {
            pinAnotation=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pinId];
            pinAnotation.pinColor=MKPinAnnotationColorRed;
            pinAnotation.calloutOffset = CGPointMake(-5, 5);
            pinAnotation.canShowCallout = NO;
            pinAnotation.animatesDrop = YES;
        }
    }
    
    pinAnotation.canShowCallout = NO;
    
    
    
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        //map overlay
        int rad = [[[NSUserDefaults standardUserDefaults]valueForKey:@"radius"]intValue];
        MKCircle *circle = [MKCircle circleWithCenterCoordinate:myMapView.userLocation.coordinate radius:rad*1000];
        [myMapView addOverlay:circle];
        return pinAnotation;
    }
    else
    {
        return nil;
    }
}

-(void)LocationFound:(CLLocationCoordinate2D)location
{
}
- (void)mapView:(MKMapView *)mapView1 didSelectAnnotationView:(MKAnnotationView *)mapView2
{
        if (mapView2.annotation == mapView1.userLocation)
            return;
    annotationCtrl *ann=(annotationCtrl*)mapView2.annotation;
    
    CLLocationCoordinate2D toLoc;
    toLoc.latitude = mapView2.annotation.coordinate.latitude;
    toLoc.longitude = mapView2.annotation.coordinate.longitude;
    CLLocationCoordinate2D CurrentLoc;
	//CurrentLoc.latitude= app.clLocation.coordinate.latitude;
	//CurrentLoc.longitude= app.clLocation.coordinate.longitude;
    CurrentLoc.latitude= 26.2389469;
    CurrentLoc.longitude= 73.0243094;
   // NSInteger indexOfTheObject = [mapView2.annotation indexOfObject:view.annotation];
   // NSInteger indexOfTheObject = [mapView2.annotation indexOfObject:self.ViewOverLay];
    
    
    
    
    
    //temp to change
    
//    MapAnnotation *annotation=(MapAnnotation*)mapView2.annotation;
//    
//    callViewFeed=[CallOutViewForFeed ViewWithFrame:CGRectMake(-50,-70, 187, 68)];
//    //
//    //    //for shadow and border
//    callViewFeed.imgBg.layer.shadowColor = [UIColor grayColor].CGColor;
//    callViewFeed.imgBg.layer.shadowOffset = CGSizeMake(-1, -1);
//    callViewFeed.imgBg.layer.shadowOpacity = 1;
//    callViewFeed.imgBg.layer.shadowRadius = 1.0;
//    callViewFeed.imgBg.clipsToBounds = NO;
//    
//    callViewFeed.imgBg.layer.borderWidth=1.0;
//    callViewFeed.imgBg.layer.borderColor=[UIColor grayColor].CGColor;
//   // --------------------
//    
////    if ([mapView2.annotation isKindOfClass:[MKUserLocation class]])
////    {
////        return;
////    }
//   // [myMapView setUserInteractionEnabled:NO];
//    callViewFeed.btnBack = [[UIButton alloc]init];
//    [callViewFeed.btnBack addTarget:self action:@selector(BackAction:) forControlEvents:UIControlEventTouchUpInside];
//    [mapView2 addSubview:callViewFeed];
//    [mapView2 bringSubviewToFront:callViewFeed];
    
 
    
    CLLocationCoordinate2D locationPin=ann.coordinate;
    
    
    NSMutableDictionary *dic = [arrMapPoints objectAtIndex:ann.myCustomTag];
    currentTag = ann.myCustomTag;
    NSString *Address=[dic valueForKey:@"merchant_address"];
    NSString *Location=[dic valueForKey:@"merchant_name"];

    
    
    callView=[calloutView ViewWithFrame:CGRectMake(-90,-100, 218, 103)];
    
     callView.lblHeader.text=Location;
    callView.lblAdd.text= Address;
    
     callView.lblHeader.textColor=[UIColor blackColor];
     callView.lblAdd.textColor=[UIColor blackColor];
    
    callView.userInteractionEnabled=YES;
     isPopShowing=YES;

    [mapView2 addSubview:callView];
    refView1 = mapView2;
    [mapView1 setCenterCoordinate:mapView2.annotation.coordinate animated:YES];
    

}
-(IBAction)BackAction:(id)sender
{
   
   [self.navigationController popViewControllerAnimated:YES];

}

#pragma mark - Drawing Path between to locaitons

- (NSMutableArray *)decodePolyLine: (NSMutableString *)encoded
{
    [encoded replaceOccurrencesOfString:@"\\\\" withString:@"\\" options:NSLiteralSearch range:NSMakeRange(0, [encoded length])];
    NSInteger len = [encoded length];
    NSInteger index = 0;
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSInteger lat=0;
    NSInteger lng=0;
    while (index < len)
    {
        NSInteger b;
        NSInteger shift = 0;
        NSInteger result = 0;
        do
        {
            b = [encoded characterAtIndex:index++] - 63;
            result |= (b & 0x1f) << shift;
            shift += 5;
        } while (b >= 0x20);
        NSInteger dlat = ((result & 1) ? ~(result >> 1) : (result >> 1));
        lat += dlat;
        shift = 0;
        result = 0;
        do
        {
            b = [encoded characterAtIndex:index++] - 63;
            result |= (b & 0x1f) << shift;
            shift += 5;
        } while (b >= 0x20);
        NSInteger dlng = ((result & 1) ? ~(result >> 1) : (result >> 1));
        lng += dlng;
        NSNumber *latitude = [[NSNumber alloc] initWithFloat:lat * 1e-5];
        NSNumber *longitude = [[NSNumber alloc] initWithFloat:lng * 1e-5];
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:[latitude floatValue] longitude:[longitude floatValue]];
        [array addObject:loc];
    }
    return array;
}

-(NSArray*) calculateRoutesFrom:(CLLocationCoordinate2D) f to: (CLLocationCoordinate2D) t
{
    self.saddr = [[NSString stringWithFormat:@"%f,%f", f.latitude, f.longitude]mutableCopy];
    self.daddr = [[NSString stringWithFormat:@"%f,%f", t.latitude, t.longitude]mutableCopy];
    NSString* apiUrlStr = [NSString stringWithFormat:@"http://maps.google.com/maps?output=dragdir&saddr=%@&daddr=%@", _saddr, _daddr];
    NSURL* apiUrl = [NSURL URLWithString:apiUrlStr];
    NSError* error = nil;
    NSString *apiResponse = [NSString stringWithContentsOfURL:apiUrl encoding:NSASCIIStringEncoding error:&error];
    NSString *encodedPoints = [apiResponse stringByMatching:@"points:\\\"([^\\\"]*)\\\"" capture:1L];
    return [self decodePolyLine:[encodedPoints mutableCopy]];
}

-(void) centerMap
{
    MKCoordinateRegion region;
    CLLocationDegrees maxLat = -90.0;
    CLLocationDegrees maxLon = -180.0;
    CLLocationDegrees minLat = 90.0;
    CLLocationDegrees minLon = 180.0;
    for(int idx = 0; idx < RouteArray.count; idx++)
    {
        CLLocation* currentLocation = [RouteArray objectAtIndex:idx];
        if(currentLocation.coordinate.latitude > maxLat)
            maxLat = currentLocation.coordinate.latitude;
        if(currentLocation.coordinate.latitude < minLat)
            minLat = currentLocation.coordinate.latitude;
        if(currentLocation.coordinate.longitude > maxLon)
            maxLon = currentLocation.coordinate.longitude;
        if(currentLocation.coordinate.longitude < minLon)
            minLon = currentLocation.coordinate.longitude;
    }
    region.center.latitude     = (maxLat + minLat) / 2.0;
    region.center.longitude    = (maxLon + minLon) / 2.0;
    region.span.latitudeDelta = 0.01;
    region.span.longitudeDelta = 0.01;
    region.span.latitudeDelta  = ((maxLat - minLat)<0.0)?100.0:(maxLat - minLat);
    region.span.longitudeDelta = ((maxLon - minLon)<0.0)?100.0:(maxLon - minLon);
    [myMapView setRegion:region animated:YES];
}

-(void)showRouteFrom: (CLLocationCoordinate2D)f to:(CLLocationCoordinate2D)t
{
    if(RouteArray)
    {
    }
	annotationCtrl *newAnnotation = [[annotationCtrl alloc] initWithTitle:@"A" andCoordinate:f];
	MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(f, 1000000, 1000000);
	[myMapView setRegion:region animated:YES];
	[myMapView addAnnotation:newAnnotation];
	annotationCtrl *newAnnotation2 = [[annotationCtrl alloc] initWithTitle:@"B" andCoordinate:t];
	MKCoordinateRegion region2 = MKCoordinateRegionMakeWithDistance(t, 1000000, 1000000);
	[myMapView setRegion:region2 animated:YES];
	[myMapView addAnnotation:newAnnotation2];
	RouteArray = [self calculateRoutesFrom:f to:t];
	if(RouteArray.count>0)
    {
		NSInteger numberOfSteps = RouteArray.count;
 		CLLocationCoordinate2D coordinates[numberOfSteps];
		for (NSInteger index = 0; index < numberOfSteps; index++)
        {
			CLLocation *location = [RouteArray objectAtIndex:index];
			CLLocationCoordinate2D coordinate = location.coordinate;
			coordinates[index] = coordinate;
        }
		MKPolyline *polyLine = [MKPolyline polylineWithCoordinates:coordinates count:numberOfSteps];
		[myMapView addOverlay:polyLine];
		[self centerMap];
    }
}

#pragma mark - END

-(IBAction)BackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
        MKCoordinateRegion region;
        MKCoordinateSpan span;
        span.latitudeDelta = 0.05;
        span.longitudeDelta = 0.05;
        CLLocationCoordinate2D location;
        location.latitude = userLocation.coordinate.latitude;
        location.longitude = userLocation.coordinate.longitude;
        region.span = span;
        region.center = location;
        [mapView setRegion:region animated:YES];
}

- (MKOverlayView *)mapView:(MKMapView *)map viewForOverlay:(id <MKOverlay>)overlay
{
    MKCircleView *circleView = [[MKCircleView alloc] initWithOverlay:overlay];
    circleView.lineWidth=2.0;
    circleView.strokeColor =[UIColor colorWithRed:70.0/255 green:140.0/255 blue:215.0/255 alpha:1.0];
    //[UIColor colorWithRed:237.0/255 green:75.0/255 blue:26.0/255 alpha:1.0];
    circleView.fillColor = [UIColor colorWithRed:70.0/255 green:140.0/255 blue:215.0/255 alpha:0.4];
    return circleView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    // here we illustrate how to detect which annotation type was clicked on for its callout
    id <MKAnnotation> annotation = [view annotation];
    if ([annotation isKindOfClass:[MapAnnotation class]])
    {
    }
    
    
  
    
}

-(void)zoomToFitMapAnnotations:(MKMapView*)mapView
{
    if([mapView.annotations count] == 0)
        return;
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;
    
    for(MapAnnotation* annotation in mapView.annotations)
    {
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
    }
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.7; // Add a little extra space on the sides
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.7; // Add a little extra space on the sides
    region = [mapView regionThatFits:region];
    [mapView setRegion:region animated:NO];
}

//For show Anotation on map
-(void)showOnMap:(MKMapView*)myMap cord:(CLLocationCoordinate2D)Coordinates
{
    MKCoordinateRegion viewRegion;
    viewRegion = MKCoordinateRegionMakeWithDistance(Coordinates, 10000, 10000);
    @try
    {
        [myMap setRegion:viewRegion animated:YES];
    }
    @catch (NSException *E)
    {
        //NSLog(@"execption>>>> %@",E.description);
    }
}



- (IBAction)BtnMapBack:(id)sender
{
    [myMapView setUserInteractionEnabled:YES];
    [self.ViewOverLay removeFromSuperview];
    
     //[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)BtnGetDirection:(id)sender
{
   
    //DirectionMapVC *direction = [[DirectionMapVC alloc] initWithNibName:@"DirectionMapVC" bundle:nil];
    CouponVC  *coupon =[CouponVC alloc];
   
    [coupon ShowMeDirections:coupon.btnDirection];
    
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *tch = [[touches allObjects] lastObject];
    CGPoint touchLocation = [tch locationInView:self.view];
    //   NSLog(@"touch location %@",NSStringFromCGPoint(touchLocation));
    popupRect = [self.view convertRect:callView.frame fromView:refView1];
    
    btnFrameInPopUp=[self.view convertRect:callView.btnA.frame fromView:callView];
    CGRect B=[self.view convertRect:callView.btnB.frame fromView:callView];
    CGRect C=[self.view convertRect:callView.btnC.frame fromView:callView];
    
    
    if (CGRectContainsPoint(popupRect, touchLocation)&&isPopShowing)
    {
        if (CGRectContainsPoint(btnFrameInPopUp, touchLocation))
        {

            [self btnAclickedOnpopUp  ];
            NSLog(@"button A Clicked");
        }
        else if (CGRectContainsPoint(B, touchLocation))
        {
            [self btnBclickedOnpopUp  ];

            NSLog(@"button B Clicked");
            
        }
        else if(CGRectContainsPoint(C, touchLocation))
            
        {
            [self btnCclickedOnpopUp  ];

            NSLog(@"button C Clicked");
            
        }

    }
    
}


-(void)btnAclickedOnpopUp
{
    [self.navigationController popViewControllerAnimated:YES   ];
}

-(void)btnBclickedOnpopUp
{
    
    
      // NSString* apiUrlStr = [NSString stringWithFormat:@"http://maps.google.com/maps?output=dragdir&saddr=%@&daddr=%@", saddr, daddr];
    // NSURL* apiUrl = [NSURL URLWithString:apiUrlStr];
    


    
    CLLocationCoordinate2D location1 = CLLocationCoordinate2DMake([[currentUserLocationDict valueForKey:@"lat"] doubleValue],[[currentUserLocationDict valueForKey:@"long"] doubleValue]);
    
     CLLocationCoordinate2D location2 = CLLocationCoordinate2DMake(app.userNewLocatiion.coordinate.latitude,app.userNewLocatiion.coordinate.longitude);
    
    //App_Delegate.CurrentUserLocation.coordinate];
    NSString* saddr = [NSString stringWithFormat:@"%f,%f", location1.latitude, location1.longitude];
//    NSString* daddr = [NSString stringWithFormat:@"%f,%f", location1.latitude, t.longitude];
    NSString *daddr = [NSString stringWithFormat:@"%f,%f",location2.latitude, location2.longitude];
    
    NSMutableString *mapURL = [NSMutableString stringWithString:@"http://maps.google.com/maps?"];
    [mapURL appendFormat:@"saddr=%@", saddr];
    [mapURL appendFormat:@"&daddr=%@", daddr];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[mapURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];

    
}



-(void)btnCclickedOnpopUp
{
    NSMutableDictionary *dic_K = [self.arrMapPoints objectAtIndex:currentTag];
    NSDictionary *userInfo  = dic_K;
    NSString *fb_link = @"";
    if ([userInfo objectForKey:@"fb_link"] && [[userInfo objectForKey:@"fb_link"] isKindOfClass:[NSString class]] && [[userInfo objectForKey:@"fb_link"] length]>0) {
        fb_link = [userInfo objectForKey:@"fb_link"];
    }
    else
        if ([userInfo objectForKey:@"website"] && [[userInfo objectForKey:@"website"] isKindOfClass:[NSString class]] && [[userInfo objectForKey:@"website"] length]>0) {
            fb_link = [userInfo objectForKey:@"website"];
        }
        else     if ([userInfo objectForKey:@"logo"] && [[userInfo objectForKey:@"logo"] isKindOfClass:[NSString class]] && [[userInfo objectForKey:@"logo"] length]>0) {
            fb_link = [userInfo objectForKey:@"logo"];
        }
    NSURL *url = [NSURL URLWithString:fb_link];
    [[UIApplication sharedApplication] openURL:url];
    
}




-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    [callView removeFromSuperview];
    isPopShowing=NO;
}




- (IBAction)BtnUserFBInfo:(id)sender{
}
@end
