//
//  MapAnnotation.h
//  ThrowElbows
//
//  Created by a on 10/12/14.
//  Copyright (c) 2014 Square Bits Private Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapAnnotation : NSObject<MKAnnotation>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@property (nonatomic, strong) NSString *itemID;
@property (nonatomic, strong) NSString *imageName;

@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;

- (id)initWithTitle:(NSString *)title andCoordinate:(CLLocationCoordinate2D)coordinate2d;

@end
