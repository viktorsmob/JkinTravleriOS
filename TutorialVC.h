//
//  TutorialVC.h
//  Jwalkin
//
//  Created by Ridmal Choudhary on 22/12/15.
//  Copyright (c) 2015 fox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "AppDelegate.h"

@interface TutorialVC : UIViewController
@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;

- (IBAction)SkipAction:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *btnSkip;

@end
