//
//  SubCatNameCell.m
//  Jwalkin
//
//  Created by Kanika on 08/11/13.
//  Copyright (c) 2013 fox. All rights reserved.
//

#import "SubCatNameCell.h"

@implementation SubCatNameCell
@synthesize lblSubCatName;

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
