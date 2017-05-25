//
//  ImageWebViewController.h
//  Jwalkin
//
//  Created by Manish Sawlot on 19/05/16.
//  Copyright (c) 2016 fox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageWebViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIWebView *wbImgLinkopen;
@property (strong,nonatomic) NSString *Strlink;
- (IBAction)BtnBackClicked:(id)sender;

@end
