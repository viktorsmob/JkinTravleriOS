//
//  ImageWebViewController.m
//  Jwalkin
//
//  Created by Manish Sawlot on 19/05/16.
//  Copyright (c) 2016 fox. All rights reserved.
//

#import "ImageWebViewController.h"

@interface ImageWebViewController ()

@end

@implementation ImageWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *fullURL = self.Strlink;
    if ([fullURL isEqualToString:@"null"])
    {
        return;
    }
    NSURL *url = [NSURL URLWithString:fullURL];
    
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.wbImgLinkopen loadRequest:requestObj];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)BtnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
