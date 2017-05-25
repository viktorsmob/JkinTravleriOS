//
//  annotationCtrl.m
//  mapCtrl
//
//  Created by Suresh Malviya on 3/21/12.
//  Copyright (c) 2012 Fox Infosoft. All rights reserved.
//

#import "annotationCtrl.h"

@implementation annotationCtrl
@synthesize title,coordinate,subtitle;

-(id)initWithTitle:(NSString *)ttl andCoordinate:(CLLocationCoordinate2D)c2d {
	[super init];
	title = ttl;
	coordinate = c2d;
	return self;
}

- (void)dealloc {
	[title release];
	[super dealloc];
}

@end
