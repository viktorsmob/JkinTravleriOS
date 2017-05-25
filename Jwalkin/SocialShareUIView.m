//
//  SocialShareUIView.m
//  Jwalkin
//
//  Created by RichMan on 4/6/17.
//  Copyright © 2017 fox. All rights reserved.
//

#import "SocialShareUIView.h"

@implementation SocialShareUIView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+(id)customView{
    SocialShareUIView * recView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])
                                                                           owner:self
                                                                         options:nil] objectAtIndex:0];
    
    [self setRoundedRectBorderView:recView withBorderWidth:3.0f withBorderColor:[UIColor redColor] withBorderRadius:10.0f];
    
    return recView;
}
+ (void) setRoundedRectBorderView:(UIView *)view withBorderWidth:(float) borderWidth withBorderColor:(UIColor *) color withBorderRadius:(float)radius{
    view.clipsToBounds = YES;
    view.layer.cornerRadius = radius;
    view.layer.borderColor = color.CGColor;
    view.layer.borderWidth = borderWidth;
}
@end
