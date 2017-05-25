//
//  TownInfoCoupanVC.m
//  Jwalkin
//
//  Created by Kanika on 15/07/15.
//  Copyright (c) 2015 fox. All rights reserved.
//

#import "TownInfoCoupanVC.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import "Reachability.h"
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) // iPhone and       iPod touch style UI

#define IS_IPHONE_5_IOS7 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0f)
#define IS_IPHONE_6_IOS7 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 667.0f)
#define IS_IPHONE_6P_IOS7 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 736.0f)
#define IS_IPHONE_4_AND_OLDER_IOS7 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height < 568.0f)

#define IS_IPHONE_5_IOS8 (IS_IPHONE && ([[UIScreen mainScreen] nativeBounds].size.height/[[UIScreen mainScreen] nativeScale]) == 568.0f)
#define IS_IPHONE_6_IOS8 (IS_IPHONE && ([[UIScreen mainScreen] nativeBounds].size.height/[[UIScreen mainScreen] nativeScale]) == 667.0f)
#define IS_IPHONE_6P_IOS8 (IS_IPHONE && ([[UIScreen mainScreen] nativeBounds].size.height/[[UIScreen mainScreen] nativeScale]) == 736.0f)
#define IS_IPHONE_4_AND_OLDER_IOS8 (IS_IPHONE && ([[UIScreen mainScreen] nativeBounds].size.height/[[UIScreen mainScreen] nativeScale]) < 568.0f)

#define IS_IPHONE_5 ( ( [ [ UIScreen mainScreen ] respondsToSelector: @selector( nativeBounds ) ] ) ? IS_IPHONE_5_IOS8 : IS_IPHONE_5_IOS7 )
#define IS_IPHONE_6 ( ( [ [ UIScreen mainScreen ] respondsToSelector: @selector( nativeBounds ) ] ) ? IS_IPHONE_6_IOS8 : IS_IPHONE_6_IOS7 )
#define IS_IPHONE_6P ( ( [ [ UIScreen mainScreen ] respondsToSelector: @selector( nativeBounds ) ] ) ? IS_IPHONE_6P_IOS8 : IS_IPHONE_6P_IOS7 )
#define IS_IPHONE_4_AND_OLDER ( ( [ [ UIScreen mainScreen ] respondsToSelector: @selector( nativeBounds ) ] ) ? IS_IPHONE_4_AND_OLDER_IOS8 : IS_IPHONE_4_AND_OLDER_IOS7 )


#define _IS_IPHONE_5 (IS_IPHONE && ([[UIScreen mainScreen] nativeBounds].size.height/[[UIScreen mainScreen] nativeScale]) == 568.0f)
#define _IS_IPHONE_6 (IS_IPHONE && ([[UIScreen mainScreen] nativeBounds].size.height/[[UIScreen mainScreen] nativeScale]) == 667.0f)
#define _IS_IPHONE_6P (IS_IPHONE && ([[UIScreen mainScreen] nativeBounds].size.height/[[UIScreen mainScreen] nativeScale]) == 736.0f)
#define _IS_IPHONE_4_AND_OLDER (IS_IPHONE && ([[UIScreen mainScreen] nativeBounds].size.height/[[UIScreen mainScreen] nativeScale]) < 568.0f)



@interface TownInfoCoupanVC ()

@end

@implementation TownInfoCoupanVC
@synthesize lblMNameTown,dictMerchantInfo,scrl;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    lblMNameTown.text = self.strMNameTown;
    //NSLog(@"%@",dictMerchantInfo);
    arrAllData=[[NSMutableArray alloc]init];
    arrVideoUrl =[[NSMutableArray alloc]init];
    // Do any additional setup after loading the view from its nib.
    [self SetPageControl];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- Button Action

-(IBAction)BackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- Load BillBoards

-(void)SetPageControl
{
   
    arrAllData = [dictMerchantInfo valueForKey:@"billboards"];
    self.scrl.pagingEnabled = YES;
    self.scrl.delegate = self;
    self.scrl.backgroundColor = [ UIColor clearColor];
    self.scrl.contentSize = CGSizeMake(self.scrl.frame.size.width,self.scrl.frame.size.height*[arrAllData count]);
    for (UIView *v in scrl.subviews)
    {
        if (![v isKindOfClass:[UIImageView class]])
        {
            [v removeFromSuperview];
        }
    }
    if ([arrAllData count] > 0)
    {
        for (int i=0; i<[arrAllData count]; i++)
        {
            view1 =[[UIView alloc] init];
            
            
          //  view1.autoresizingMask = UIViewAutoresizingFlexibleWidth |
           // UIViewAutoresizingFlexibleHeight ;//Dp
            
            
            
            view1.frame=CGRectMake(0, self.scrl.frame.size.height*i, self.scrl.frame.size.width-4,self.scrl.frame.size.height-10);
            view1.backgroundColor=[UIColor clearColor];
            dataDictionary = [arrAllData objectAtIndex:i];
            UILabel *lblTitle = [[UILabel alloc] init];
            lblTitle.frame = CGRectMake(10, 2, 220, 20);
            lblTitle.backgroundColor = [UIColor clearColor];
            lblTitle.font = [UIFont fontWithName:@"Helvetica" size:16.0];
            lblTitle.textColor = [UIColor whiteColor];
            if ([[dataDictionary valueForKey:@"billboard_type"] isEqualToString:@"D"])
            {
                view1.tag=1;
                NSArray *arrSubBill = [dataDictionary valueForKey:@"subbillboard"];
                NSDictionary *dictBill = [arrSubBill objectAtIndex:0];

                lblTitle.text = [dictBill valueForKey:@"title"];
                UIWebView *wb;
                if (![[NSString stringWithFormat:@"%@",[[dictBill valueForKey:@"image_name"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] isEqualToString:@"http://emsbapp.com/admin/images/no_image.jpg"]  || ![[NSString stringWithFormat:@"%@",[[dictBill valueForKey:@"video_thumb"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] isEqualToString:@"http://emsbapp.com/admin/images/no_image.jpg"] )
                {
                   // wb = [[UIWebView alloc] initWithFrame:CGRectMake(5, lblTitle.frame.size.height+10, view1.frame.size.width-10, 70)];
                    
                    //Dp30Dec
                    
                    if (IS_IPHONE_4_AND_OLDER || IS_IPHONE_5)
                    {
                        
                        if (IS_IPHONE_4_AND_OLDER)
                        {
                            wb = [[UIWebView alloc] initWithFrame:CGRectMake(self.scrl.frame.origin.x-5, lblTitle.frame.size.height+10, view1.frame.size.width-10, view1.frame.size.height-14)];
                            
                        }
                        else
                        {
                           wb = [[UIWebView alloc] initWithFrame:CGRectMake(self.scrl.frame.origin.x-5, lblTitle.frame.size.height+15, view1.frame.size.width-10, view1.frame.size.height-14)];
                        }
                    }
                    else if(IS_IPHONE_6)
                    {
                        wb = [[UIWebView alloc] initWithFrame:CGRectMake(self.scrl.frame.origin.x+20, lblTitle.frame.size.height+20, view1.frame.size.width-10, view1.frame.size.height-14)];
                        
                    }
                    else if(IS_IPHONE_6P)
                    {
                        
                      wb = [[UIWebView alloc] initWithFrame:CGRectMake(self.scrl.frame.origin.x+38, lblTitle.frame.size.height+20, view1.frame.size.width-10, view1.frame.size.height-14)];
                        
                    }
                    

                }
                else
                {
                    //wb = [[UIWebView alloc] initWithFrame:CGRectMake(5, lblTitle.frame.size.height+10, view1.frame.size.width-10, view1.frame.size.height-8)];
                    
                    
                    
                    //Dp30Dec
                    
                    if (IS_IPHONE_4_AND_OLDER || IS_IPHONE_5)
                    {
                        
                        if (IS_IPHONE_4_AND_OLDER)
                        {
                            wb = [[UIWebView alloc] initWithFrame:CGRectMake(self.scrl.frame.origin.x-5, lblTitle.frame.size.height+10, view1.frame.size.width-10, view1.frame.size.height-14)];
                            
                        }
                        else
                        {
                            wb = [[UIWebView alloc] initWithFrame:CGRectMake(self.scrl.frame.origin.x-5, lblTitle.frame.size.height+15, view1.frame.size.width-10, view1.frame.size.height-14)];
                        }
                    }
                    else if(IS_IPHONE_6)
                    {
                        wb = [[UIWebView alloc] initWithFrame:CGRectMake(self.scrl.frame.origin.x+20, lblTitle.frame.size.height+20, view1.frame.size.width-10, view1.frame.size.height-14)];
                        
                    }
                    else if(IS_IPHONE_6P)
                    {
                        
                        wb = [[UIWebView alloc] initWithFrame:CGRectMake(self.scrl.frame.origin.x+38, lblTitle.frame.size.height+20, view1.frame.size.width-10, view1.frame.size.height-14)];
                        
                    }
                    

                }
                wb.backgroundColor = [UIColor clearColor];
                wb.opaque=NO;
                wb.delegate = self;
                [wb loadHTMLString:[NSString stringWithFormat:@"<html><body text=\"#FFFFFF\">%@</body></html>",[dictBill valueForKey:@"description"]] baseURL:nil];
                [view1 addSubview:lblTitle];
                [view1 addSubview:wb];
                [self.scrl addSubview:view1];
                //cp
                BOOL isImage =NO;
                //image
                if (![[NSString stringWithFormat:@"%@",[[dictBill valueForKey:@"image_name"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] isEqualToString:@"http://emsbapp.com/admin/images/no_image.jpg"])
                {
                    UIImageView *img=[[UIImageView alloc] init];
                    if (![[NSString stringWithFormat:@"%@",[[dictBill valueForKey:@"video_thumb"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] isEqualToString:@"http://emsbapp.com/admin/images/no_image.jpg"])
                    {
                        img.frame=CGRectMake(5, lblTitle.frame.size.height+90, view1.frame.size.width-10, view1.frame.size.height/2-50);
                    }
                    else
                    {
                        img.frame=CGRectMake(5, lblTitle.frame.size.height+90, view1.frame.size.width-10, view1.frame.size.height-70);
                    }
                    img.backgroundColor=[UIColor clearColor];
                    img.tag=999;
                    img.contentMode = UIViewContentModeScaleToFill;
                    [img setContentMode:UIViewContentModeScaleAspectFit];
                    
                    NSString *thumbURL=[[dictBill valueForKey:@"image_name"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    NSURL *url = [NSURL URLWithString:thumbURL];
                    [img  sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                    [view1 addSubview:img];
                    [self.scrl addSubview:view1];
                    isImage =YES;
                }
                //video
                if (![[NSString stringWithFormat:@"%@",[[dictBill valueForKey:@"video_thumb"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] isEqualToString:@"http://emsbapp.com/admin/images/no_image.jpg"])
                {
                    UIImageView *img=[[UIImageView alloc] init];
                    if (isImage)
                    {
                        img.frame=CGRectMake(5,view1.frame.size.height/2+70, view1.frame.size.width-10, view1.frame.size.height/2-50);
                    }
                    else
                    {
                        img.frame=CGRectMake(5, lblTitle.frame.size.height+90, view1.frame.size.width-10, view1.frame.size.height-70);
                    }
                    img.backgroundColor=[UIColor clearColor];
                    img.tag=999;
                    img.contentMode = UIViewContentModeScaleToFill;
                    [img setContentMode:UIViewContentModeScaleAspectFit];
                    NSString *thumbURL=[[dictBill valueForKey:@"video_thumb"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    NSURL *url = [NSURL URLWithString:thumbURL];
                    [img  sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                    NSString *urlVideo = [dictBill valueForKey:@"video_name"];
                    [arrVideoUrl addObject:urlVideo];
                    UIButton *button = [[UIButton alloc] init];
                    [ button setImage:[UIImage imageNamed:@"btn_video_play.png" ] forState:UIControlStateNormal];
                    [button setBackgroundColor:[UIColor clearColor]];
                    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    button.frame = CGRectMake((img.frame.size.width/2)-37, (img.frame.size.height/2)-37,75, 75);
                    button.tag= urlCount;
                    urlCount++;
                    button.enabled = YES;
                    button.userInteractionEnabled = YES;
                    [button addTarget:self action:@selector(btnPlayVideoClicked:) forControlEvents:UIControlEventTouchUpInside];
                    [self.scrl addSubview:view1];
                    [view1 addSubview:lblTitle];
                    [img addSubview:button];
                    [view1 addSubview:img];
                    [view1 bringSubviewToFront:button];
                    img.userInteractionEnabled=YES;
                }
                //cp
            }
            if ([[dataDictionary valueForKey:@"billboard_type"] isEqualToString:@"P"])
            {
                view1.tag=2;
                NSArray *arrSubBill = [dataDictionary valueForKey:@"subbillboard"];
                NSDictionary *dictBill = [arrSubBill objectAtIndex:0];

                lblTitle.text = [dictBill valueForKey:@"title"];
                UIWebView *wb;
                if (![[NSString stringWithFormat:@"%@",[[dictBill valueForKey:@"image_name"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] isEqualToString:@"http://emsbapp.com/admin/images/no_image.jpg"]  || ![[NSString stringWithFormat:@"%@",[[dictBill valueForKey:@"video_thumb"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] isEqualToString:@"http://emsbapp.com/admin/images/no_image.jpg"] )
                {
                    //wb = [[UIWebView alloc] initWithFrame:CGRectMake(5, lblTitle.frame.size.height+10, view1.frame.size.width-10, 70)];
                    
                    
                    //Dp30Dec
                    
                    if (IS_IPHONE_4_AND_OLDER || IS_IPHONE_5)
                    {
                        
                        if (IS_IPHONE_4_AND_OLDER)
                        {
                            wb = [[UIWebView alloc] initWithFrame:CGRectMake(self.scrl.frame.origin.x-5, lblTitle.frame.size.height+10, view1.frame.size.width-10, view1.frame.size.height-14)];
                            
                        }
                        else
                        {
                            wb = [[UIWebView alloc] initWithFrame:CGRectMake(self.scrl.frame.origin.x-5, lblTitle.frame.size.height+15, view1.frame.size.width-10, view1.frame.size.height-14)];
                        }
                    }
                    else if(IS_IPHONE_6)
                    {
                        wb = [[UIWebView alloc] initWithFrame:CGRectMake(self.scrl.frame.origin.x+20, lblTitle.frame.size.height+20, view1.frame.size.width-10, view1.frame.size.height-14)];
                        
                    }
                    else if(IS_IPHONE_6P)
                    {
                        
                        wb = [[UIWebView alloc] initWithFrame:CGRectMake(self.scrl.frame.origin.x+38, lblTitle.frame.size.height+20, view1.frame.size.width-10, view1.frame.size.height-14)];
                        
                    }
                    
                    
                }
                else
                {
                    //wb = [[UIWebView alloc] initWithFrame:CGRectMake(5, lblTitle.frame.size.height+10, view1.frame.size.width-10, view1.frame.size.height-8)];
                    
                    
                    
                    //Dp30Dec
                    
                    if (IS_IPHONE_4_AND_OLDER || IS_IPHONE_5)
                    {
                        
                        if (IS_IPHONE_4_AND_OLDER)
                        {
                            wb = [[UIWebView alloc] initWithFrame:CGRectMake(self.scrl.frame.origin.x-5, lblTitle.frame.size.height+10, view1.frame.size.width-10, view1.frame.size.height-14)];
                            
                        }
                        else
                        {
                            wb = [[UIWebView alloc] initWithFrame:CGRectMake(self.scrl.frame.origin.x-5, lblTitle.frame.size.height+15, view1.frame.size.width-10, view1.frame.size.height-14)];
                        }
                    }
                    else if(IS_IPHONE_6)
                    {
                        wb = [[UIWebView alloc] initWithFrame:CGRectMake(self.scrl.frame.origin.x+20, lblTitle.frame.size.height+20, view1.frame.size.width-10, view1.frame.size.height-14)];
                        
                    }
                    else if(IS_IPHONE_6P)
                    {
                        
                        wb = [[UIWebView alloc] initWithFrame:CGRectMake(self.scrl.frame.origin.x+38, lblTitle.frame.size.height+20, view1.frame.size.width-10, view1.frame.size.height-14)];
                        
                    }
                    

                }
                /*else
                {
                    wb = [[UIWebView alloc] initWithFrame:CGRectMake(5, lblTitle.frame.size.height+10, view1.frame.size.width-10, view1.frame.size.height-8)];
                }
                 */
                wb.backgroundColor = [UIColor clearColor];
                wb.opaque=NO;
                wb.delegate = self;
                
                [wb loadHTMLString:[NSString stringWithFormat:@"<html><body text=\"#FFFFFF\">%@</body></html>",[dictBill valueForKey:@"description"]] baseURL:nil];
                [view1 addSubview:lblTitle];
                [view1 addSubview:wb];
                [self.scrl addSubview:view1];
                BOOL isImage =NO;
                //cp
                //image
                if (![[NSString stringWithFormat:@"%@",[[dictBill valueForKey:@"image_name"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] isEqualToString:@"http://emsbapp.com/admin/images/no_image.jpg"])
                {
                    UIImageView *img=[[UIImageView alloc] init];
                    if (![[NSString stringWithFormat:@"%@",[[dictBill valueForKey:@"video_thumb"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] isEqualToString:@"http://emsbapp.com/admin/images/no_image.jpg"])
                    {
                        img.frame=CGRectMake(5, lblTitle.frame.size.height+90, view1.frame.size.width-10, view1.frame.size.height/2-50);
                    }
                    else
                    {
                        img.frame=CGRectMake(5, lblTitle.frame.size.height+90, view1.frame.size.width-10, view1.frame.size.height-70);
                    }
                    img.backgroundColor=[UIColor clearColor];
                    img.tag=999;
                    img.contentMode = UIViewContentModeScaleToFill;
                    [img setContentMode:UIViewContentModeScaleAspectFit];
                    NSString *thumbURL=[[dictBill valueForKey:@"image_name"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    NSURL *url = [NSURL URLWithString:thumbURL];
                    [img  sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                    [view1 addSubview:img];
                    [self.scrl addSubview:view1];
                    isImage =YES;
                }
                //video
                if (![[NSString stringWithFormat:@"%@",[[dictBill valueForKey:@"video_thumb"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] isEqualToString:@"http://emsbapp.com/admin/images/no_image.jpg"])
                {
                    UIImageView *img=[[UIImageView alloc] init];
                    if (isImage)
                    {
                        img.frame=CGRectMake(5,view1.frame.size.height/2+70, view1.frame.size.width-10, view1.frame.size.height/2-50);
                    }
                    else
                    {
                        img.frame=CGRectMake(5, lblTitle.frame.size.height+90, view1.frame.size.width-10, view1.frame.size.height-70);
                    }
                    img.backgroundColor=[UIColor clearColor];
                    img.tag=999;
                    img.contentMode = UIViewContentModeScaleToFill;
                    [img setContentMode:UIViewContentModeScaleAspectFit];
                    NSString *thumbURL=[[dictBill valueForKey:@"video_thumb"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    NSURL *url = [NSURL URLWithString:thumbURL];
                    [img  sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                    NSString *urlVideo = [dictBill valueForKey:@"video_name"];
                    [arrVideoUrl addObject:urlVideo];
                    UIButton *button = [[UIButton alloc] init];
                    [ button setImage:[UIImage imageNamed:@"btn_video_play.png" ] forState:UIControlStateNormal];
                    [button setBackgroundColor:[UIColor clearColor]];
                    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    button.frame = CGRectMake((img.frame.size.width/2)-37, (img.frame.size.height/2)-37,75, 75);
                    button.tag= urlCount;
                    urlCount++;
                    button.enabled = YES;
                    button.userInteractionEnabled = YES;
                    [button addTarget:self action:@selector(btnPlayVideoClicked:) forControlEvents:UIControlEventTouchUpInside];
                    [self.scrl addSubview:view1];
                    [view1 addSubview:lblTitle];
                    [img addSubview:button];
                    [view1 addSubview:img];
                    [view1 bringSubviewToFront:button];
                    img.userInteractionEnabled=YES;
                }
                //cp
            }
            if ([[dataDictionary valueForKey:@"billboard_type"] isEqualToString:@"E"])
            {
                view1.tag=3;
                NSArray *arrSubBill = [dataDictionary valueForKey:@"subbillboard"];
                NSDictionary *dictBill = [arrSubBill objectAtIndex:0];

                lblTitle.text = [dictBill valueForKey:@"title"];
                UIWebView *wb;
                if (![[NSString stringWithFormat:@"%@",[[dictBill valueForKey:@"image_name"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] isEqualToString:@"http://emsbapp.com/admin/images/no_image.jpg"]  || ![[NSString stringWithFormat:@"%@",[[dictBill valueForKey:@"video_thumb"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] isEqualToString:@"http://emsbapp.com/admin/images/no_image.jpg"] )
                {
                    wb = [[UIWebView alloc] initWithFrame:CGRectMake(5, lblTitle.frame.size.height+10, view1.frame.size.width-10, 70)];
                }
                else
                {
                    wb = [[UIWebView alloc] initWithFrame:CGRectMake(5, lblTitle.frame.size.height+10, view1.frame.size.width-10, view1.frame.size.height-8)];
                }
                wb.backgroundColor = [UIColor clearColor];
                wb.opaque=NO;
                wb.delegate = self;
                [wb loadHTMLString:[NSString stringWithFormat:@"<html><body text=\"#FFFFFF\">%@</body></html>",[dictBill valueForKey:@"description"]] baseURL:nil];
                [view1 addSubview:lblTitle];
                [view1 addSubview:wb];
                [self.scrl addSubview:view1];
                //cp
                BOOL isImage =NO;
                //image
                if (![[NSString stringWithFormat:@"%@",[[dictBill valueForKey:@"image_name"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] isEqualToString:@"http://emsbapp.com/admin/images/no_image.jpg"])
                {
                    UIImageView *img=[[UIImageView alloc] init];
                    if (![[NSString stringWithFormat:@"%@",[[dictBill valueForKey:@"video_thumb"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] isEqualToString:@"http://emsbapp.com/admin/images/no_image.jpg"])
                    {
                        img.frame=CGRectMake(5, lblTitle.frame.size.height+90, view1.frame.size.width-10, view1.frame.size.height/2-50);
                    }
                    else
                    {
                        img.frame=CGRectMake(5, lblTitle.frame.size.height+90, view1.frame.size.width-10, view1.frame.size.height-70);
                    }
                    img.backgroundColor=[UIColor clearColor];
                    img.tag=999;
                    img.contentMode = UIViewContentModeScaleToFill;
                    [img setContentMode:UIViewContentModeScaleAspectFit];
                    NSString *thumbURL=[[dictBill valueForKey:@"image_name"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    NSURL *url = [NSURL URLWithString:thumbURL];
                    [img  sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                    [view1 addSubview:img];
                    [self.scrl addSubview:view1];
                    isImage =YES;
                }
                //video
                if (![[NSString stringWithFormat:@"%@",[[dictBill valueForKey:@"video_thumb"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] isEqualToString:@"http://emsbapp.com/admin/images/no_image.jpg"])
                {
                    UIImageView *img=[[UIImageView alloc] init];
                    if (isImage)
                    {
                        img.frame=CGRectMake(5,view1.frame.size.height/2+70, view1.frame.size.width-10, view1.frame.size.height/2-50);
                    }
                    else
                    {
                        img.frame=CGRectMake(5, lblTitle.frame.size.height+90, view1.frame.size.width-10, view1.frame.size.height-70);
                    }
                    img.backgroundColor=[UIColor clearColor];
                    img.tag=999;
                    img.contentMode = UIViewContentModeScaleToFill;
                    [img setContentMode:UIViewContentModeScaleAspectFit];
                    NSString *thumbURL=[[dictBill valueForKey:@"video_thumb"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    NSURL *url = [NSURL URLWithString:thumbURL];
                    [img  sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                    NSString *urlVideo = [dictBill valueForKey:@"video_name"];
                    [arrVideoUrl addObject:urlVideo];
                    UIButton *button = [[UIButton alloc] init];
                    [ button setImage:[UIImage imageNamed:@"btn_video_play.png" ] forState:UIControlStateNormal];
                    [button setBackgroundColor:[UIColor clearColor]];
                    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    button.frame = CGRectMake((img.frame.size.width/2)-37, (img.frame.size.height/2)-37,75, 75);
                    button.tag= urlCount;
                    urlCount++;
                    button.enabled = YES;
                    button.userInteractionEnabled = YES;
                    [button addTarget:self action:@selector(btnPlayVideoClicked:) forControlEvents:UIControlEventTouchUpInside];
                    [self.scrl addSubview:view1];
                    [view1 addSubview:lblTitle];
                    [img addSubview:button];
                    [view1 addSubview:img];
                    [view1 bringSubviewToFront:button];
                    img.userInteractionEnabled=YES;
                }
                //cp
            }
            if ([[dataDictionary valueForKey:@"billboard_type"] isEqualToString:@"I"])
            {
                view1.tag=4;
                NSArray *arrSubBill = [dataDictionary valueForKey:@"subbillboard"];
                NSDictionary *dictBill = [arrSubBill objectAtIndex:0];
                lblTitle.text = [dictBill valueForKey:@"title"];
                UIImageView *img=[[UIImageView alloc] init];
                //Dp30Dec
                if (IS_IPHONE_4_AND_OLDER || IS_IPHONE_5)
                {
                    
                    if (IS_IPHONE_4_AND_OLDER)
                    {
                         img.frame=CGRectMake(self.scrl.frame.origin.x-5, lblTitle.frame.size.height+10, view1.frame.size.width-10, view1.frame.size.height-14);
                        
                    }
                    else
                    {
                        img.frame=CGRectMake(self.scrl.frame.origin.x-5, lblTitle.frame.size.height+15, view1.frame.size.width-10, view1.frame.size.height-14);
                    }
                }
                else if(IS_IPHONE_6)
                {
                     img.frame=CGRectMake(self.scrl.frame.origin.x+20, lblTitle.frame.size.height+20, view1.frame.size.width-10, view1.frame.size.height-14);
                    
                }
                else if(IS_IPHONE_6P)
                {
                
                    img.frame=CGRectMake(self.scrl.frame.origin.x+38, lblTitle.frame.size.height+20, view1.frame.size.width-10, view1.frame.size.height-14);
                
                }
                

                //img.frame=CGRectMake(5, lblTitle.frame.size.height+20, view1.frame.size.width-10, view1.frame.size.height-14);
                img.backgroundColor=[UIColor clearColor];
                img.tag=999;
                img.contentMode = UIViewContentModeScaleToFill;
                [img setContentMode:UIViewContentModeScaleAspectFit];
                [img setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
                NSString *thumbURL=[[dictBill valueForKey:@"image_name"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSURL *url = [NSURL URLWithString:thumbURL];
                [img  sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                [view1 addSubview:lblTitle];
                [view1 addSubview:img];
                [self.scrl addSubview:view1];
            }
            if ([[dataDictionary valueForKey:@"billboard_type"] isEqualToString:@"V"])
            {
                view1.tag=5;
                NSArray *arrSubBill = [dataDictionary valueForKey:@"subbillboard"];
                NSDictionary *dictBill = [arrSubBill objectAtIndex:0];

                lblTitle.text = [dictBill valueForKey:@"title"];
                UIImageView *img=[[UIImageView alloc] init];
                
                if (IS_IPHONE_4_AND_OLDER || IS_IPHONE_5)
                {
                    
                    if (IS_IPHONE_4_AND_OLDER)
                    {
                        img.frame=CGRectMake(self.scrl.frame.origin.x-5, lblTitle.frame.size.height+10, view1.frame.size.width-10, view1.frame.size.height-14);
                        
                    }
                    else
                    {
                        img.frame=CGRectMake(self.scrl.frame.origin.x-5, lblTitle.frame.size.height+15, view1.frame.size.width-10, view1.frame.size.height-14);
                    }
                }
                else if(IS_IPHONE_6)
                {
                    img.frame=CGRectMake(self.scrl.frame.origin.x+20, lblTitle.frame.size.height+20, view1.frame.size.width-10, view1.frame.size.height-14);
                    
                }
                else if(IS_IPHONE_6P)
                {
                    
                    img.frame=CGRectMake(self.scrl.frame.origin.x+38, lblTitle.frame.size.height+20, view1.frame.size.width-10, view1.frame.size.height-14);
                    
                }
                

                
              // img.frame=CGRectMake(5, lblTitle.frame.size.height+10, view1.frame.size.width-10, view1.frame.size.height-14);
                img.backgroundColor=[UIColor clearColor];
                img.tag=999;
                img.contentMode = UIViewContentModeScaleToFill;
                [img setContentMode:UIViewContentModeScaleAspectFit];
                img.layer.masksToBounds=YES;
                NSString *thumbURL=[[dictBill valueForKey:@"video_thumb"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSURL *url = [NSURL URLWithString:thumbURL];
                [img  sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                NSString *urlVideo = [dictBill valueForKey:@"video_name"];
                [arrVideoUrl addObject:urlVideo];
                UIButton *button = [[UIButton alloc] init];
                [ button setImage:[UIImage imageNamed:@"btn_video_play.png" ] forState:UIControlStateNormal];
                [button setBackgroundColor:[UIColor clearColor]];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                button.frame = CGRectMake((img.frame.size.width/2)-37, (img.frame.size.height/2)-37,75, 75);
                button.tag= urlCount;
                urlCount++;
                button.enabled = YES;
                button.userInteractionEnabled = YES;
                [button addTarget:self action:@selector(btnPlayVideoClicked:) forControlEvents:UIControlEventTouchUpInside];
                [self.scrl addSubview:view1];
                [view1 addSubview:lblTitle];
                [img addSubview:button];
                [view1 addSubview:img];
                [view1 bringSubviewToFront:button];
                img.userInteractionEnabled=YES;
            }
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Jaywalk.In" message:@"Offers and more Coming Soon!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag = 23;
        [alert show];
    }
}

#pragma mark Playing Video

-(IBAction)btnPlayVideoClicked:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSURL *url=[[NSURL alloc] initWithString:[arrVideoUrl objectAtIndex:button.tag]];
    moviePlayer=[[MPMoviePlayerController alloc] initWithContentURL:url];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayBackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:moviePlayer];
    moviePlayer.controlStyle=MPMovieControlStyleDefault;
    moviePlayer.shouldAutoplay=YES;
    [self.view addSubview:moviePlayer.view];
    [moviePlayer setFullscreen:YES animated:YES];
}
-(void)moviePlayBackDidFinish:(NSNotification*)notification
{
    MPMoviePlayerController *player = [notification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification object:player];
    if ([player respondsToSelector:@selector(setFullscreen:animated:)])
    {
        [player.view removeFromSuperview];
    }
}

@end
