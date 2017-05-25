//
//  MapAnnotation.m
//  ThrowElbows
//
//  Created by a on 10/12/14.
//  Copyright (c) 2014 Square Bits Private Limited. All rights reserved.
//

#import "MapAnnotation.h"

@implementation MapAnnotation
-(id)initWithTitle:(NSString *)title andCoordinate:(CLLocationCoordinate2D)coordinate2d
{
    self.title = title;
    self.coordinate =coordinate2d;
    return self;
}
@end
