//
//  ManageBillBoardVC.h
//  Jwalkin
//
//  Created by Kanika on 11/06/15.
//  Copyright (c) 2015 fox. All rights reserved.
//
#import "NetworkUtills.h"
#import "WrapperClass.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import <MediaPlayer/MediaPlayer.h>
#import <UIKit/UIKit.h>

@interface ManageBillBoardVC : UIViewController<UIScrollViewDelegate,UIWebViewDelegate,UITextViewDelegate>
{
    IBOutlet UIButton *btnBack;
    IBOutlet UIPageControl *pgCtrl;
    int CurrentPage;
    float oldoffset_y;
    NetworkUtills *netUtills;
    NSMutableDictionary *mainDict;
    NSMutableDictionary *dataDictionary;
    NSMutableArray *arrAllData;
    UIView *view1;
    
    AppDelegate *app;
   // int ratingVal;
    UIActivityIndicatorView *loading;
    
    WrapperClass *wrpr;
    
    MBProgressHUD *progressView;
    
    NSMutableArray *arrVideoUrl;
    int urlCount;
    
    IBOutlet UIView *viewPlayer;
 
    
    MPMoviePlayerController *moviePlayer;
    IBOutlet UIButton *btnDelete;
    IBOutlet UIButton *btnCheck;
    IBOutlet UIButton *btnSave;
    
    UIButton *btnTownCatName;
    
    NSMutableArray *arrButton;
    NSMutableArray *arrBtnTitle;
    NSMutableArray *arrBtnCheck;
    NSMutableArray *arrSelected;
    IBOutlet UIImageView *imgViewMain;
    
    
    //pickerView
    UIButton *btnExpTime;
    UIButton *btnSaveExpDate;
    UIButton *btnEdit;
    
}
//-(IBAction)btnBackMediaPlayerClick:(id)sender;


@property(nonatomic,strong)IBOutlet UIScrollView *scrl;
@property(nonatomic,strong)IBOutlet UILabel *lblMName;
//@property(nonatomic,strong)NSString *strMName1;
@property(nonatomic,strong)NSString *strMId;
@property(nonatomic, strong)NSMutableArray *arrTempMerchantDetail;
@property int tempMerchantTag;
-(IBAction)btnBackClicked:(id)sender;
-(IBAction)btnEditClicked:(id)sender;


@end
