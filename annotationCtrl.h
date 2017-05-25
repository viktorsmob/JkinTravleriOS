//
//  annotationCtrl.h
//  mapCtrl
//
//  Created by Suresh Malviya on 3/21/12.
//  Copyright (c) 2012 Fox Infosoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface annotationCtrl : NSObject <MKAnnotation>
{
    NSString *title;
    NSString *subtitle;
    
    CLLocationCoordinate2D coordinate;
}
@property int myCustomTag;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (id)initWithTitle:(NSString *)ttl andCoordinate:(CLLocationCoordinate2D)c2d;

@end
