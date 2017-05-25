//
//  CommentVC.h
//  Jwalkin
//
//  Created by Kanika on 24/06/15.
//  Copyright (c) 2015 fox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "NetworkUtills.h"
@interface CommentVC : UIViewController<UITextViewDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    NetworkUtills *netUtills;

    IBOutlet UIButton *btnBack;
    IBOutlet UIButton *btnSend;
    IBOutlet UITextView *tvComment;
    IBOutlet UITableView *tblComment;
}
-(IBAction)btnBackClick:(id)sender;
-(IBAction)btnSendClick:(id)sender;

@end
