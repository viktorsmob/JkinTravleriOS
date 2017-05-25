//
//  CommentCell.h
//  Jwalkin
//
//  Created by Kanika on 24/06/15.
//  Copyright (c) 2015 fox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentCell : UITableViewCell
@property (nonatomic,strong) IBOutlet UILabel *lblUsername;
@property(nonatomic,strong) IBOutlet UILabel *lblComment;
@property(nonatomic,strong) IBOutlet UILabel *lblDate;
@end
