//
//  CallOutViewForFeed.m
//  HuntersRoom
//
//  Created by Ashok Choudhary on 14/08/14.
//  Copyright (c) 2014 Ramprakash. All rights reserved.
//

#import "CallOutViewForFeed.h"

@interface CallOutViewForFeed ()
@end

@implementation CallOutViewForFeed

- (IBAction)BtnBackClicked:(id)sender {
}

+ (CallOutViewForFeed*)ViewWithFrame:(CGRect)frame
{
	CallOutViewForFeed *customView = [[[NSBundle mainBundle] loadNibNamed:@"CallOutViewForFeed" owner:nil options:nil] lastObject];
 	customView.frame=frame;

 	if ([customView isKindOfClass:[CallOutViewForFeed class]])
		return customView;
	else
		return nil;
}


@end
