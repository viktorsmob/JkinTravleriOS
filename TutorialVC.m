//
//  TutorialVC.m
//  Jwalkin
//
//  Created by Ridmal Choudhary on 22/12/15.
//  Copyright (c) 2015 fox. All rights reserved.
//

#import "TutorialVC.h"
#import "MBProgressHUD.h"
#import "HomeVC.h"

@interface TutorialVC ()

@end

@implementation TutorialVC
@synthesize scrollview,btnSkip;
- (void)viewDidLoad {
   
    
   // btnBack.hidden = YES;
    btnSkip.hidden= NO;
    [[self.view viewWithTag:3000] setHidden:YES];
    
   
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    CGRect main = [UIScreen mainScreen].bounds;
    [scrollview setContentSize:CGSizeMake(main.size.width*11, main.size.height-20)];
    // [scrollview setContentSize:CGSizeMake(main.size.width*5, main.size.height)];
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



- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat pageWidth = self.view.frame.size.width;
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    
    
    if(page<=9)
  //    {  pageCntrol.currentPage = page;
    {}
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
   
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger pageNumber = roundf(scrollView.contentOffset.x / (self.view.frame.size.width));
    
    if(pageNumber<=9)
       
    {}
    else
    {
           [self dismissViewControllerAnimated:YES completion:nil];
    }
   
}

- (IBAction)SkipAction:(id)sender {
    
   HomeVC *skip = [[HomeVC alloc] initWithNibName:@"HomeVC" bundle:nil];
    [self dismissViewControllerAnimated:YES completion:nil];

    [self.navigationController pushViewController:skip animated:YES];
    
}
@end
