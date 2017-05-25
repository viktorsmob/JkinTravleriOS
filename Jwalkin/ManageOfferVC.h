//
//  ManageOfferVC.h
//  Jwalkin
//
//  Created by Kanika on 22/07/15.
//  Copyright (c) 2015 fox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkUtills.h"
#import "ZBarSDK.h"
#import "RemoteImageView.h"
@interface ManageOfferVC : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,ZBarReaderDelegate>
{
    NetworkUtills *netUtills;
    NSMutableArray *arrOffers;
    IBOutlet UITableView *tblOffers;
    IBOutlet UILabel *lblBarTitle;
    IBOutlet UIButton *btnAddNew;
    NSString *resultText;
    NSString *name;
    NSString *strOfferId;
    
    //detail view
    IBOutlet UIView *viewDetail;
    IBOutlet UIButton *btnRedeem;
    
    IBOutlet UITextView *txtViewDescription;
    IBOutlet RemoteImageView *imgViewOfferImg;
    IBOutlet UILabel *lblTitleDetail;
    IBOutlet UIImageView *imgViewBackImage;
    ZBarReaderViewController *reader;
   
}
 @property (nonatomic, strong) IBOutlet UIView *scanView;
@property(nonatomic)BOOL isOffer;
@property(nonatomic)NSString *strMid;
-(IBAction)btnBackClicked:(id)sender;
-(IBAction)btnAddOfferClicked:(id)sender;
-(IBAction)btnRedeamClicked:(id)sender;
-(IBAction)btnCancelClicked:(id)sender;
@end
