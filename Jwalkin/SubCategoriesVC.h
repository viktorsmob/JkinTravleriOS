//
//  SubCategoriesVC.h
//  Jwalkin
//
//  Created by Kanika on 08/11/13.
//  Copyright (c) 2013 fox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkUtills.h"
#import "AppDelegate.h"
#import "WrapperClass.h"

@interface SubCategoriesVC : UIViewController<UISearchBarDelegate>
{
    IBOutlet UITableView *tblMrchnt;
    IBOutlet UIButton *btnDropdown;
    IBOutlet UIButton *btnHome;
    IBOutlet UIButton *btnSearch;
    IBOutlet UIButton *btnFav;
    IBOutlet UIButton *btnMap;
    
    IBOutlet UITableView *tblDrList;
    
    // SubView
    
    IBOutlet UIView *subView;
   
    
    NSMutableArray *arrSubcatagories;
    NSMutableArray *arrSubCatNames;
    NSMutableArray *arrSubCatIDs;
    
    int isTableShowing;
    
    NetworkUtills *netUtills;
    AppDelegate *app;
    NSMutableArray *arrMerchantDetail;
    
    
    NSInteger endindex;
    NSInteger startindex;
    int currentCounter;
    
    UITapGestureRecognizer *tap;
    NSInteger merchantTag;
    WrapperClass *wrpr;
    
    IBOutlet UIView *topView;
    
    IBOutlet UISearchBar *searchBar;
    IBOutlet UIView *searchView;
    NSMutableArray *arrAllMerchantCopy;
    IBOutlet UIView *picView;
    IBOutlet UIPickerView *picker;
}
@property(nonatomic,strong)IBOutlet UILabel *lblTotalWalkin;
@property(nonatomic,strong)IBOutlet UILabel *lblPercentage;
@property(nonatomic,strong)NSString *catId;
@property(nonatomic,strong)IBOutlet UILabel *lblDListSubCatName;

@property(nonatomic,retain)IBOutlet UILabel *lblCouponMName;
@property(nonatomic,retain)IBOutlet UILabel *lblCouponMAddress;

@property(nonatomic,strong)NSMutableDictionary *mainDict;


-(IBAction)pickerDoneClicked:(id)sender;
-(IBAction)pickerCancelClicked:(id)sender;
@end
