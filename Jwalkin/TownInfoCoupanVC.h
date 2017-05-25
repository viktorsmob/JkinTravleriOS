//
//  TownInfoCoupanVC.h
//  Jwalkin
//
//  Created by Kanika on 15/07/15.
//  Copyright (c) 2015 fox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkUtills.h"
#import "WrapperClass.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import <MediaPlayer/MediaPlayer.h>

@interface TownInfoCoupanVC : UIViewController<UIScrollViewDelegate,UIWebViewDelegate>
{
    NSMutableArray *arrAllData;
    UIView *view1;
    NSMutableDictionary *dataDictionary;
    int urlCount;
    NSMutableArray *arrVideoUrl;
    MPMoviePlayerController *moviePlayer;

}
-(IBAction)BackClicked:(id)sender;
@property(nonatomic,strong)IBOutlet UILabel *lblMNameTown;
@property(nonatomic,strong)NSString *strMNameTown;
@property(nonatomic,strong)NSString *strMIdTown;
@property(nonatomic,strong)NSMutableDictionary *dictMerchantInfo;
@property(nonatomic,strong)IBOutlet UIScrollView *scrl;

@end
