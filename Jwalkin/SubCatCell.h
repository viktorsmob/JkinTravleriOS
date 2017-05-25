//
//  SubCatCell.h
//  Jwalkin
//
//  Created by Kanika on 08/11/13.
//  Copyright (c) 2013 fox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubCatCell : UITableViewCell

@property(nonatomic,strong)IBOutlet UIButton *btnM1;
@property(nonatomic,strong)IBOutlet UIButton *btnM2;

@property(nonatomic,strong)IBOutlet UILabel *lblMerchant1;
@property(nonatomic,strong)IBOutlet UILabel *lblMerchant2;

@property(nonatomic,strong)IBOutlet UIImageView *imgMerchant1;
@property(nonatomic,strong)IBOutlet UIImageView *imgMerchant2;

@property(nonatomic,strong)IBOutlet UIImageView *imgBorder1;
@property(nonatomic,strong)IBOutlet UIImageView *imgBorder2;
@end
