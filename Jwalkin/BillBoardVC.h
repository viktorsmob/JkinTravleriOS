//
//  BillBoardVC.h
//  Jwalkin
//
//  Created by Chanchal Warde on 5/18/15.
//  Copyright (c) 2015 fox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

#import "NIDropDown.h"
#import "RemoteImageView.h"

@interface BillBoardVC : UIViewController <UIActionSheetDelegate , UITextFieldDelegate ,UITextViewDelegate , UINavigationBarDelegate , UIImagePickerControllerDelegate,UIScrollViewDelegate,NIDropDownDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIApplicationDelegate,UINavigationControllerDelegate>
{
    AppDelegate *app;
    
    //Dicount View
    IBOutlet UIView *viewDiscount;
    IBOutlet UITextField *tfTitleDiscount;
    IBOutlet UITextView  *tvDescDiscount;
    IBOutlet UIButton *btnSubmitDiscount;
    IBOutlet UIButton *btnExpdateDiscount;
    IBOutlet UILabel *lblExpDateDiscount;
    
    IBOutlet UIButton *btnCheckDisVu;
    IBOutlet UIButton *btnSubCategoryDisVu;
    IBOutlet UIImageView *imgViewDiscountSelected;
    IBOutlet UIImageView *imgViewVideoThumbnailDiscout;
    IBOutlet UIImageView *imgViewPlayDiscount;
    IBOutlet UIButton *btnDiscountExpDate;

    //Promo view
    IBOutlet UIView *viewPromos;
    IBOutlet UITextField *tfTitlePromo;
    IBOutlet UITextView *tvDescPromo;
    IBOutlet UIButton *btnSubmitPromo;
    
    IBOutlet UIButton *btnSubCategoryPromoVu;
     IBOutlet UIButton *btnCheckPromoVu;
    IBOutlet UIImageView *imgViewPromoSelected;
    IBOutlet UIImageView *imgViewVideoThumbnailPromo;
    IBOutlet UIImageView *imgViewPlayPromo;
    IBOutlet UIButton *btnPromoExpDate;


    //Event View
    IBOutlet UIView *viewEvents;
    IBOutlet UIButton *btnSubmitEvent;
    IBOutlet UIButton *btnEventDate;
    IBOutlet UITextView *tvDescEvent;
    IBOutlet UITextField *tfTitleEvents;
    IBOutlet UITextField *tfLocationEvent;
    IBOutlet UILabel *lblEventDate;
    
    IBOutlet UIButton *btnSubCategoryEventVu;
     IBOutlet UIButton *btnCheckEventVu;
    IBOutlet UIImageView *imgViewEventSelected;
    IBOutlet UIImageView *imgViewVideoThumbnailEvent;
    IBOutlet UIImageView *imgViewPlayEvent;
    IBOutlet UIButton *btnEventExpDate;


    //Image View
    IBOutlet UIView *viewImage;
    IBOutlet UITextField *tfTitleImage;
    IBOutlet UIButton *btnAddImage;
    IBOutlet UIButton *btnSubmitImage;
    UIImage *imageSelected;
    IBOutlet UIImageView *imgViewSelected;
    
    IBOutlet UIButton *btnSubCategoryImageVu;
     IBOutlet UIButton *btnCheckImageVu;
    IBOutlet UIButton *btnImageExpDate;

    
    //video View
    IBOutlet UIView *viewVideo;
    IBOutlet UITextField *tfTitleVideo;
    IBOutlet UIButton *btnSubmitVideo;
    IBOutlet UIButton *btnSelectVideo;
    IBOutlet UIImageView *imgViewVideoThumbnail;
    
    IBOutlet UIButton *btnSubCategoryVideoVu;
     IBOutlet UIButton *btnCheckVideoVu;
    IBOutlet UIImageView *imgViewPlay;
    IBOutlet UIButton *btnVideoExpDate;

    //Social View
    IBOutlet UIView *viewSocial;
    IBOutlet UIButton *btnSubmitSocial;
    IBOutlet UITextField *tfTitleSocial;
    IBOutlet UITextField *tfTwitter;
    IBOutlet UITextField *tfFacebook;
    IBOutlet UITextField *tfGoogle;
    IBOutlet UITextField *tfWebsite;
    IBOutlet UIButton *btnSocialExpDate;

    
    //Pickers & temp storage
    IBOutlet UIView *viewDatePicker;
    IBOutlet UIDatePicker *datePicker;
    IBOutlet UIButton *btnDatePickCancel;
    IBOutlet UIButton   *btnDatePickDone;
    UIButton *btnTemp;
    NSString *strDate;
    
    //Picker
    IBOutlet UIView *viewPicker;
    IBOutlet UIPickerView *pickerExpDate;
    IBOutlet UIButton *btnPickerCancel;
    IBOutlet UIButton *btnPickerDone;
    
    
    IBOutlet UIButton *btnCancel;
    int flagPicker;
    NSURL *videoUrl;
    
    
    NSCharacterSet *whitespace ;
    
    IBOutlet UILabel *lblImage;
    IBOutlet UILabel *lblVideo;
    
    
    IBOutlet UIView *viewActivity;
    IBOutlet UIActivityIndicatorView *activity;
    
    UIImage *thumbImg;
    
    //Custome drop down
    NIDropDown *dropDown;
    NSMutableArray *arrSubCatTownInfo;
    
    //cp
    IBOutlet UIScrollView *scrollViewPromo;
    IBOutlet UIScrollView *scrollViewDisc;
    IBOutlet UIScrollView *scrollViewEvent;
    IBOutlet UIScrollView *scrollViewVideo;
    IBOutlet UIScrollView *scrollViewImage;
}
    //Custome drop down
@property (weak, nonatomic) IBOutlet UIButton *dropDownButtonState;

@property(strong,nonatomic) RemoteImageView *tempImg;



-(IBAction)btnCheckPressed:(id)sender;
-(IBAction)btnSelectSubCategoryPressed:(id)sender;
-(IBAction)btnExpiredClicked:(id)sender;
-(IBAction)btnExpDateClicked:(id)sender;
-(IBAction)btnCancel;
-(IBAction)btnPickerDone:(id)sender;
@property int billBoardNo;
@end
