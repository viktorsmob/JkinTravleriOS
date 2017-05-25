//
//  SubCatCell.m
//  Jwalkin
//
//  Created by Kanika on 08/11/13.
//  Copyright (c) 2013 fox. All rights reserved.
//

#import "SubCatCell.h"

@implementation SubCatCell
@synthesize lblMerchant1,lblMerchant2,imgMerchant1,imgMerchant2;
@synthesize btnM1,btnM2,imgBorder1,imgBorder2;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
