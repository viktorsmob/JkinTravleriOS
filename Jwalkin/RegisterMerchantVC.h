//
//  RegisterMerchantVC.h
//  Jwalkin
//
//  Created by Chanchal Warde on 5/14/15.
//  Copyright (c) 2015 fox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "NIDropDown.h"
#import "AppDelegate.h"


@interface RegisterMerchantVC : UIViewController <UIGestureRecognizerDelegate , UIActionSheetDelegate , UITextFieldDelegate , UIImagePickerControllerDelegate , UINavigationControllerDelegate , MKMapViewDelegate ,NIDropDownDelegate>
{
    IBOutlet UIScrollView *scrollReg;
    
    IBOutlet UITextField *tfName;
    IBOutlet UITextField *tfPassword;
    IBOutlet UITextField *tfEmail;
    IBOutlet UITextField *tfAdd1;
    IBOutlet UITextField *tfAdd2;
    IBOutlet UITextField *tfCity;
    IBOutlet UITextField *tfCountry;
    IBOutlet UITextField *tfState;
    IBOutlet UITextField *tfZipcode;
    IBOutlet UITextField *tfCategary;
    IBOutlet UITextField *tfSubcategary;
    IBOutlet UITextField *tfBusinesshour;
    IBOutlet UITextField *tfCreditCardNo;
    IBOutlet UITextField *tfCreditcardType;
    IBOutlet UITextField *tfCVVNo;
    IBOutlet UITextField *tfAverageRating;
    IBOutlet UITextField *tfData;
    IBOutlet UITextField *tfAmount;
    IBOutlet UITextField *tfPromoCode;
    IBOutlet UITextField *tfPhNO;

    
    
    IBOutlet UIImageView *imgviewDP;
    IBOutlet UIImageView *imgviewLogo;
    
    IBOutlet UIButton *btnRegister;
    IBOutlet UIButton *btnLocationPick;
    IBOutlet UIButton *btnDatePick;
    IBOutlet UIButton *btnCardExpdate;
    IBOutlet UILabel *lblDate;
    
    IBOutlet    UILabel *lblLocation;
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
    NSDictionary *dictResultRegister;
    NSDictionary *dictResultState;
    NSDictionary *dictResultCat;
    
    NSMutableArray *arrSubCatId;
    NSMutableArray *arrCatId;
    NSMutableArray *arrStateId;
    
    
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
    
    //Chanchal
    UIButton *button;
}
-(IBAction)btnExpdateClick:(id)sender;
-(IBAction)btnLocationClick;
-(IBAction)btnRegistrterClick;
-(IBAction)btnSearchLocation;
-(IBAction)btnAddLocation;
-(IBAction)btnPickerCancel;
-(IBAction)btnPickerDone;
//-(IBAction)billBoardOption:(id)sender;
-(IBAction)btnCancelReg;

@property (weak, nonatomic) IBOutlet UIButton *dropDownButtonState;

@property (strong,nonatomic) NSMutableDictionary *dictFacebookData;


//Manish
@property BOOL isViaFB;


@end



