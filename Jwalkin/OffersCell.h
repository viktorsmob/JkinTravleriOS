//
//  OffersCell.h
//  Jwalkin
//
//  Created by Kanika on 22/07/15.
//  Copyright (c) 2015 fox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RemoteImageView.h"
@interface OffersCell : UITableViewCell
@property(nonatomic,strong)IBOutlet RemoteImageView *imgOffer;
@property(nonatomic,strong)IBOutlet UILabel *lblTitle;
@property(nonatomic,strong)IBOutlet UILabel *lblDescription;
@property (strong, nonatomic) IBOutlet UILabel *lbValid;

@end
