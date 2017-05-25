//
//  MyFavVC.h
//  Jwalkin
//
//  Created by Kanika on 22/11/13.
//  Copyright (c) 2013 fox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkUtills.h"
#import "WrapperClass.h"

@interface MyFavVC : UIViewController
{
    NetworkUtills *netUtills;
    NSMutableArray *mainArray;
    
    NSInteger endindex;
    NSInteger startindex;
    int currentCounter;
    NSString * midForUnFavurite;
    WrapperClass *wrpr;
    NSMutableArray *arrMerchantDetail;
    IBOutlet UITableView *tblFav;
    NSInteger merchantTag;
    UITapGestureRecognizer *tap;
    IBOutlet UIView *subView;
    UISwipeGestureRecognizer *swipe;
    IBOutlet UIButton *btnOffer;
}
- (IBAction)unFavorite:(id)sender;
@property(nonatomic,strong)IBOutlet UILabel *lblTotalWalkin;
@property(nonatomic,strong)IBOutlet UILabel *lblPercentage;

@property(nonatomic,strong)IBOutlet UILabel *lblCouponMName;
@property(nonatomic,strong)IBOutlet UILabel *lblCouponMAddress;
@end
