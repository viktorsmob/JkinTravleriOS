//
//  CommentCell.m
//  Jwalkin
//
//  Created by Kanika on 24/06/15.
//  Copyright (c) 2015 fox. All rights reserved.
//

#import "CommentCell.h"

@implementation CommentCell
@synthesize lblUsername,lblComment;
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
