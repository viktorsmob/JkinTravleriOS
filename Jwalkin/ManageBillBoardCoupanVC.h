//
//  ManageBillBoardCoupanVC.h
//  Jwalkin
//
//  Created by Kanika on 17/07/15.
//  Copyright (c) 2015 fox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkUtills.h"
#import "NIDropDown.h"
#import <MediaPlayer/MediaPlayer.h>

@interface ManageBillBoardCoupanVC : UIViewController<UIWebViewDelegate,NIDropDownDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextViewDelegate>
{
   // IBOutlet UIImageView *img;

    
    NetworkUtills *netUtills;
    NIDropDown *dropDown;
    MPMoviePlayerController *moviePlayer;
    
    IBOutlet UIView *view1;
    
    IBOutlet UIImageView *imgViewBackground;
    
    UIActivityIndicatorView *loading;
    IBOutlet UIView *viewPicker;
    IBOutlet UIPickerView *pickerExpDate;

    NSArray *arrTownCat;
    NSMutableArray *arrExpBttn;
    NSArray *arrExpDate;
    NSString *urlVideo;
    UIButton *btnTemp;
    UIButton *btnSaveExpDate;
    IBOutlet UIButton *btnDelete;
    IBOutlet UIButton *btnSave;
    IBOutlet UIButton *btnCheck;
    IBOutlet UIButton *btnTownCatName;
    IBOutlet UIButton *btnExpTime;
    IBOutlet UIButton *btnPickerCancel;
    IBOutlet UIButton *btnPickerDone;
    IBOutlet UIButton *btnTownInfoRemove;
    
    IBOutlet UILabel *lblTitle;
    IBOutlet UILabel *lblStatus;
    IBOutlet UILabel *lblTownStatus;
    IBOutlet UILabel *lblTownRemove;
    IBOutlet UILabel *lblExpiryStatus;
    IBOutlet UILabel *lblSetExpire;
    IBOutlet UILabel *lblInDays;
    IBOutlet UILabel *lblMName;
    IBOutlet UILabel *lblSelectTown;
    
   
}
@property(nonatomic,strong)NSString *strTitle;
@property(nonatomic,strong)NSMutableDictionary *dictBillBoardInfo;
-(IBAction)backClick:(id)sender;
-(IBAction)btnDeleteClicked:(id)sender;
-(IBAction)btnCheckClicked:(id)sender;
-(IBAction)btnCatNameClicked:(id)sender;
-(IBAction)btnExpTimeClick:(id)sender;
-(IBAction)btnPickerDone:(id)sender;
-(IBAction)btnPickerCancel;
-(IBAction)btnSaveClicked:(id)sender;
-(IBAction)btnTownInfoRemoveClicked:(id)sender;

@end
