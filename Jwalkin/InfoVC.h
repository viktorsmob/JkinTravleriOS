//
//  InfoVC.h
//  Jwalkin
//
//  Created by Kanika on 11/11/13.
//  Copyright (c) 2013 fox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "NetworkUtills.h"

@interface InfoVC : UIViewController<MFMailComposeViewControllerDelegate,UIWebViewDelegate>
{
    IBOutlet UIWebView *wbView;
    NetworkUtills *netUtills;
    IBOutlet UIButton * btnMail;
    IBOutlet UIButton * btnFacebook;
    IBOutlet UIButton * btnTwitter;
    IBOutlet UILabel *lblShare;
    IBOutlet UIImageView *imgLineview;
    
    IBOutlet UIButton *btnCloseWebView;
    IBOutlet UIWebView *webViewFBTwitter;
    
}
-(IBAction)btnCloseWebViewClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *ShareView;
@end
