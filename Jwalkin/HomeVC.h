//
//  HomeVC.h
//  Jwalkin
//
//  Created by Kanika on 06/11/13.
//  Copyright (c) 2013 fox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkUtills.h"

@interface HomeVC : UIViewController<UIAlertViewDelegate,UIApplicationDelegate,UIActionSheetDelegate>
{
    NetworkUtills *netUtills;

    NSMutableArray *mainArray;
    
    IBOutlet UIScrollView *scrl;
    
    UITapGestureRecognizer *tap;
    
    IBOutlet UIView *viewBgPopup;
    IBOutlet UIView *viewPopUp;
    IBOutlet UIView *viewSettingPopUp;

    IBOutlet UIButton *btnCommunity;
    IBOutlet UIButton *btnPersonal;
    IBOutlet UIButton *btnHealth;
    IBOutlet UIButton *btnFood;
    IBOutlet UIButton *btnNightLife;
    IBOutlet UIButton *btnTravel;
    IBOutlet UIButton *btnShopping;
    IBOutlet UIButton *btnFinantial;
    IBOutlet UIButton *btnTrade;
    IBOutlet UIButton *btnSignup;
    IBOutlet UIButton *btnTownInfoCenter;
    IBOutlet UIButton *btnDiscountBoard;
    IBOutlet UIButton *btnPromosBoard;
    IBOutlet UIButton *btnEventBoard;
    IBOutlet UIButton *btnImageBoard;
    IBOutlet UIButton *btnVideoBoard;
    IBOutlet UIButton *btnSocialBoard;
    IBOutlet UIButton *btnCancelBillBoard;
    IBOutlet UIButton *btnLogout;
    IBOutlet UIButton *btnSetting;
    IBOutlet UIButton *btnSttngSubmit;
    IBOutlet UIButton *btnRadio10Mile;
    IBOutlet UIButton *btnRadio20Mile;
    IBOutlet UIButton *btnRadio30Mile;
    
    
    IBOutlet UIButton *btnRadio100Meter;
    IBOutlet UIButton *btnRadio200Meter;
    IBOutlet UIButton *btnMenu;
}

-(IBAction)btnLogoutClicked:(id)sender;
-(IBAction)btnSettingClicked:(id)sender;
-(IBAction)bttnSttngSubmitClicked:(id)sender;
-(IBAction)radioBtnClicked:(id)sender;
-(IBAction)btnManageBilBoardClicked:(id)sender;
-(IBAction)btnUpdateProfileClicked:(id)sender;
-(IBAction)btnManageOfferClicked:(id)sender;
-(IBAction)btnMenuClicked:(id)sender;
@property(nonatomic,strong)IBOutlet UIImageView *imgBtnView;
@property(nonatomic,strong)IBOutlet UIImageView *imglogo;
@property(nonatomic,strong)IBOutlet UIButton *btnInfo;
@end
