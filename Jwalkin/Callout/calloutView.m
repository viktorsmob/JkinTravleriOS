//
//  calloutView.m
//  HuntersRoom
//
//  Created by Ashok Choudhary on 14/08/14.
//  Copyright (c) 2014 Ramprakash. All rights reserved.
//

#import "calloutView.h"


@interface calloutView ()
@end

@implementation calloutView

+ (calloutView*)ViewWithFrame:(CGRect)frame
{
    calloutView *customView;
    NSArray *nibs = [[NSBundle mainBundle ] loadNibNamed:@"calloutView" owner:nil options:nil];
    if (nibs >0) {
        customView = [nibs firstObject];
    }
    else{
        customView  = [[calloutView alloc] init];
    }
	
	customView.frame=frame;
	if ([customView isKindOfClass:[calloutView class]])
		return customView;
	else
		return nil;
}

@end
