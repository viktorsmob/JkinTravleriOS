//
//  DirectionMapVC.m
//  Jwalkin
//
//  Created by Kanika on 11/11/13.
//  Copyright (c) 2013 fox. All rights reserved.
//

#import "DirectionMapVC.h"
#import <MapKit/MapKit.h>
#import "RegexKitLite.h"

@interface DirectionMapVC ()

@end

@implementation DirectionMapVC

@synthesize mapLat,mapLong,address,arrMapPoints,locationName,lblTitle,strTitle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    lblTitle.text =self.strTitle;
    app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    av.hidden = NO;
    [av startAnimating];
    routeView = [[UIImageView alloc] init];
    myMapView.showsUserLocation = TRUE;
    [myMapView addSubview:routeView];
    routeView.frame = myMapView.bounds;
    [self FindLocation:self.address location:self.strTitle];
    // Do any additional setup after loading the view from its nib.
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
                 //NSString *myadd=add_annSubtitle;
                 NSNumber *lat = [NSNumber numberWithDouble:coordinate.latitude];
                 NSNumber *lon = [NSNumber numberWithDouble:coordinate.longitude];
                 NSDictionary *userLocation=@{@"lat":lat,@"long":lon,@"title":loc_annTitle,@"subTitle":add_annSubtitle};
                 [self performSelectorOnMainThread:@selector(Called:) withObject:userLocation waitUntilDone:YES];
             }
         });
     }];
}

-(void)Called:(NSMutableDictionary *)locationdict
{
    CLLocationCoordinate2D location1 = CLLocationCoordinate2DMake([[locationdict valueForKey:@"lat"] doubleValue],[[locationdict valueForKey:@"long"] doubleValue]);
    RouteArray = [[NSArray alloc] init];
    myMapView.mapType = MKMapTypeStandard;
    myMapView.delegate = self;
    MKCoordinateSpan span;
    span.latitudeDelta=0.2;
    span.longitudeDelta=0.2;
    CLLocationCoordinate2D CurrentLoc;
	//CurrentLoc.latitude= app.clLocation.coordinate.latitude;
	//CurrentLoc.longitude= app.clLocation.coordinate.longitude;
    CurrentLoc.latitude= 26.2389469;
    CurrentLoc.longitude= 73.0243094;
	[self showRouteFrom:CurrentLoc to:location1];
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
    [myMapView setHidden:YES];
    
    NSString* saddr = [NSString stringWithFormat:@"%f,%f", f.latitude, f.longitude];
    NSString* daddr = [NSString stringWithFormat:@"%f,%f", t.latitude, t.longitude];
   // NSString* apiUrlStr = [NSString stringWithFormat:@"http://maps.google.com/maps?output=dragdir&saddr=%@&daddr=%@", saddr, daddr];
   // NSURL* apiUrl = [NSURL URLWithString:apiUrlStr];
    
    NSMutableString *mapURL = [NSMutableString stringWithString:@"http://maps.google.com/maps?"];
    [mapURL appendFormat:@"saddr=%@",saddr];
    [mapURL appendFormat:@"&daddr=%@", daddr];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[mapURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
   
 //   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:apiUrl]];
    
   
    return nil;
    }

-(void)centerMap
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

-(void)showRouteFrom:(CLLocationCoordinate2D)f to:(CLLocationCoordinate2D)t
{
    if(RouteArray)
    {
		[myMapView removeAnnotations:[myMapView annotations]];
    }
    CLLocation *locA = [[CLLocation alloc] initWithLatitude:f.latitude longitude:f.longitude];
    CLLocation *locB = [[CLLocation alloc] initWithLatitude:t.latitude longitude:t.longitude];
    CLLocationDistance distance = [locA distanceFromLocation:locB] * 0.000621371;
	MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(f, 1000000, 1000000);
	[myMapView setRegion:region animated:YES];
	annotationCtrl *newAnnotation2 = [[annotationCtrl alloc] initWithTitle:@"B" andCoordinate:t];
    newAnnotation2.title = self.strTitle;
	newAnnotation2.subtitle = [NSString stringWithFormat:@"%@ \nDistance: %.2f miles",self.address,distance];
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
	else
    {
		av.hidden=YES;
		[av stopAnimating];
	}
	av.hidden=YES;
	[av stopAnimating];
}

#pragma mark MKPolyline delegate functions

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
    polylineView.strokeColor = [UIColor purpleColor];
    polylineView.lineWidth = 5.0;
    return polylineView;
}

#pragma mark - END
    //sba
	//new code ends here
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
    for(annotationCtrl* annotation in mapView.annotations)
    {
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
        
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
    }
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1; // Add a little extra space on the sides
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1; // Add a little extra space on the sides
    region = [mapView regionThatFits:region];
    [mapView setRegion:region animated:YES];
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
            pinAnotation.canShowCallout = YES;
            pinAnotation.animatesDrop = YES;
        }
    }
    return pinAnotation;
}

- (void)mapView:(MKMapView *)mapView1 didSelectAnnotationView:(MKAnnotationView *)mapView2
{
    CLLocationCoordinate2D toLoc;
    toLoc.latitude = mapView2.annotation.coordinate.latitude;
    toLoc.longitude = mapView2.annotation.coordinate.longitude;
    CLLocationCoordinate2D CurrentLoc;
	//CurrentLoc.latitude= app.clLocation.coordinate.latitude;
	//CurrentLoc.longitude= app.clLocation.coordinate.longitude;
    CurrentLoc.latitude= 26.2389469;
    CurrentLoc.longitude= 73.0243094;

}

-(IBAction)BackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
