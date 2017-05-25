//
//  UpdateProfileVC.h
//  Jwalkin
//
//  Created by Kanika on 30/06/15.
//  Copyright (c) 2015 fox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "NIDropDown.h"
#import "AppDelegate.h"
#import "RemoteImageView.h"

@interface UpdateProfileVC : UIViewController <UIGestureRecognizerDelegate , UIActionSheetDelegate , UITextFieldDelegate , UIImagePickerControllerDelegate , UINavigationControllerDelegate , MKMapViewDelegate ,NIDropDownDelegate>
{
    IBOutlet UIScrollView *scrollReg;

    IBOutlet UITextField *tfName;
    IBOutlet UITextField *tfPassword;
    IBOutlet UITextField *tfEmail;
    IBOutlet UITextField *tfAdd1;
    IBOutlet UITextField *tfAdd2;
    IBOutlet UITextField *tfCity;
//    IBOutlet UITextField *tfCountry;
//    IBOutlet UITextField *tfState;
    IBOutlet UITextField *tfZipcode;
//    IBOutlet UITextField *tfCategary;
//    IBOutlet UITextField *tfSubcategary;
    IBOutlet UITextField *tfBusinesshour;
    IBOutlet UITextField *tfCreditCardNo;
    IBOutlet UITextField *tfCreditcardType;
    IBOutlet UITextField *tfCVVNo;
    IBOutlet UITextField *tfAverageRating;
    IBOutlet UITextField *tfData;
    IBOutlet UITextField *tfAmount;
    IBOutlet UITextField *tfPromoCode;
    IBOutlet UITextField *tfPhNO;
    
    
    
    
    
    IBOutlet UIButton *btnUpdate;
    IBOutlet UIButton *btnLocationPick;
    IBOutlet UIButton *btnDatePick;
    IBOutlet UIButton *btnCardExpdate;
    //IBOutlet UILabel *lblDate;
    
    //IBOutlet    UILabel *lblLocation;
    IBOutlet    UILabel *lblExpDate;
    IBOutlet    UILabel *lblCardExp;
    
    
    UIImageView *tempImgview;
    
    IBOutlet UIView *viewDatePicker;
    IBOutlet UIDatePicker *datePicker;
    IBOutlet UIButton *btnDatePickCancel;
    IBOutlet UIButton   *btnDatePickDone;
    UIButton *btnTemp;
    
    
    IBOutlet UIView *viewLocation;
    IBOutlet MKMapView *mapView;
    IBOutlet UITextField *tfSearchMap;
    
    IBOutlet UIButton *btnAdd;
    IBOutlet UIButton *btnSearch;
    
    IBOutlet UILabel *lblLongitute;
    IBOutlet UILabel *lblLatitute;
    
    
    NSCharacterSet *whitespace ;
    
    NSDictionary *dictLocation;
//    NSDictionary *dictResultRegister;
    NSDictionary *dictResultState;
    NSDictionary *dictResultCat;
    
    NSMutableArray *arrSubCatId;
    NSMutableArray *arrCatId;
    NSMutableArray *arrStateId;
    NSMutableArray *arrSubCat;
    
    NIDropDown *dropDown;
    NIDropDown *dropDown1;
    NIDropDown *dropDown2;
    NIDropDown *dropDown3;
    
    NSMutableArray *arrState;
    NSMutableArray *arrCategary;
    NSMutableDictionary *dictSubcategory;
    NSMutableArray *arrMain; //cp
    
    IBOutlet UIButton *btnState;
    IBOutlet UIButton *btnCat;
    IBOutlet UIButton *btnSubcat;
    NSData *temoImageData;;
    AppDelegate *app;
    NSString *strExpDate;
    NSString *strCardExpDate;
    
    
    
    IBOutlet UILabel *lblLatShow;
    IBOutlet UILabel *lblLongShow;
    
    IBOutlet UIView *viewActivity;
    IBOutlet UIActivityIndicatorView *activity;
}
-(IBAction)btnExpdateClick:(id)sender;
-(IBAction)btnLocationClick;
-(IBAction)btnUpdateClick;
-(IBAction)btnSearchLocation;
-(IBAction)btnAddLocation;
-(IBAction)btnPickerCancel;
-(IBAction)btnPickerDone;
//-(IBAction)billBoardOption:(id)sender;
-(IBAction)btnCancelUpdate;
- (IBAction)BtnSaveClicked:(id)sender;

@property(strong,nonatomic)IBOutlet RemoteImageView *imgviewDP;
@property(strong,nonatomic)IBOutlet RemoteImageView *imgviewLogo;
@property(strong,nonatomic) RemoteImageView *tempImg;

@property (strong, nonatomic) IBOutlet UIButton *dropDownButtonState;
@property (strong,nonatomic) NSMutableArray *arrMerchantInfo;
@end
