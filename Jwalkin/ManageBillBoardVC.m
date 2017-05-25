//
//  ManageBillBoardVC.m
//  Jwalkin
//
//  Created by Kanika on 11/06/15.
//  Copyright (c) 2015 fox. All rights reserved.
//

#import "ManageBillBoardVC.h"
#import "UrlFile.h"
#import "JSON.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import "Reachability.h"
#import "ManageBillBoardCoupanVC.h"


@interface ManageBillBoardVC ()
{
    BOOL isCheck;
    NSMutableArray *arrExpTimeTitle;
    NSMutableDictionary *dictData;
    NSMutableArray *arrDictData;
}
@end

@implementation ManageBillBoardVC
@synthesize scrl,lblMName,strMId;
@synthesize arrTempMerchantDetail;
@synthesize tempMerchantTag;

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
   
    arrButton = [[NSMutableArray alloc]init];
    arrBtnTitle=[[NSMutableArray alloc]init];
    arrBtnCheck =[[NSMutableArray alloc]init];
    arrSelected =[[NSMutableArray alloc]init];
    arrExpTimeTitle =[[NSMutableArray alloc]init];
    arrDictData = [[NSMutableArray alloc]init];
    dictData =[[NSMutableDictionary alloc]init];
       // isCheck=NO;
    wrpr = [[WrapperClass alloc] initwithDev];
    app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    arrVideoUrl = [[NSMutableArray alloc] init];
    urlCount=0;
    imgViewMain.layer.cornerRadius = 5.0;
    imgViewMain.layer.borderWidth = 1.0;
    imgViewMain.layer.borderColor = [[UIColor whiteColor] CGColor];
    imgViewMain.clipsToBounds = YES;
    arrAllData = [[NSMutableArray alloc] init];
    dataDictionary = [[NSMutableDictionary alloc] init];
    //[self getAllBill];
    // Do any additional setup after loading the view from its nib.
    scrl.contentOffset = CGPointMake(0, 0);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [arrDictData removeAllObjects];
    [self getAllBill];
   // scrl.contentOffset = CGPointMake(0, 0);
    CurrentPage = 0;
}
#pragma mark- Other Method

-(void)getAllBill
{
    //http://198.57.247.185/~jwalkin/admin/api/getmerchant_all_billboard.php?merchant_id=9
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Please check your internet connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        lblMName.text = [[NSUserDefaults standardUserDefaults]valueForKey:@"merchantName"];
        netUtills = [[NetworkUtills alloc] initWithSelector:@selector(ParseResponseGetBill:) WithCallBackObject:self];
        netUtills.tag = 1;
        strMId= [[NSUserDefaults standardUserDefaults]valueForKey:@"merchantid"];
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        if (strMId.length != 0 )
        {
            [dict setObject:strMId forKey:@"merchant_id"];
            
            [netUtills GetResponseByASIFormDataRequest:[NSString stringWithFormat:@"%@%@",mainUrl,getAllBillBoard] WithDictionary:dict];
        }
    }
}

-(void)SetPageControl
{
    CGRect mainScreen = [UIScreen mainScreen].bounds;
    self.scrl.pagingEnabled = YES;
    self.scrl.delegate = self;
    self.scrl.backgroundColor = [ UIColor clearColor];
    
    self.scrl.contentSize = CGSizeMake(self.scrl.frame.size.width,self.scrl.frame.size.height*[arrAllData count]);
    [arrButton removeAllObjects];
    [arrBtnTitle removeAllObjects];
    [arrBtnCheck removeAllObjects];
    [arrSelected removeAllObjects];
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
            view1.frame=CGRectMake(0, self.scrl.frame.size.height*i, self.scrl.frame.size.width-4,self.scrl.frame.size.height);
            view1.backgroundColor=[UIColor clearColor];
            dataDictionary = [arrAllData objectAtIndex:i];
            if (![[dataDictionary valueForKey:@"BillboardType"] isEqualToString:@"Social"])
            {
                NSString *townCat =[NSString stringWithFormat:@"%@",[dataDictionary objectForKey:@"Towncategory_name"]];
                [arrBtnTitle addObject:townCat];
            }
            UILabel *lblTitle = [[UILabel alloc] init];
            lblTitle.frame = CGRectMake(view1.frame.origin.x+20,0,220,20);
            lblTitle.backgroundColor = [UIColor clearColor];
            lblTitle.font = [UIFont fontWithName:@"Helvetica" size:16.0];
            lblTitle.textColor = [UIColor whiteColor];
            UILabel *lblStatus =[[UILabel alloc]initWithFrame:CGRectMake(view1.frame.size.width-60, 0, 60, 20)];
            lblStatus.backgroundColor = [UIColor clearColor];
            lblStatus.font =[UIFont fontWithName:@"Helvetica" size:16.0];
            if ([[dataDictionary valueForKey:@"BillboardType"] isEqualToString:@"Discount"])
            {
                view1.tag=1;
                lblTitle.text = [dataDictionary valueForKey:@"Title"];
                NSString *strSt =[dataDictionary valueForKey:@"Billboard_status"];
                if ([strSt isEqualToString:@"expire"])
                {
                    lblStatus.textColor =[UIColor redColor];
                    lblStatus.text =@"Expired";
                }
                else
                {
                    lblStatus.textColor=[UIColor greenColor];
                    lblStatus.text =@"Active";
                }
                UITextView *wb;
                if (![[NSString stringWithFormat:@"%@",[[dataDictionary valueForKey:@"Discount_image"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] isEqualToString:@"http://emsbapp.com/admin/images/no_image.jpg"]  && ![[NSString stringWithFormat:@"%@",[[dataDictionary valueForKey:@"Discount_thumb"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] isEqualToString:@"http://emsbapp.com/admin/images/no_image.jpg"])
                {
                    
                    if (mainScreen.size.height == 480)
                    {
                        wb = [[UITextView alloc] initWithFrame:CGRectMake(5, lblTitle.frame.size.height, view1.frame.size.width-10, 80)];
                    }
                    else
                    {
                        wb = [[UITextView alloc] initWithFrame:CGRectMake(5, lblTitle.frame.size.height+10, view1.frame.size.width-10, 100)];
                    }
                }
                else if (![[NSString stringWithFormat:@"%@",[[dataDictionary valueForKey:@"Discount_image"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] isEqualToString:@"http://emsbapp.com/admin/images/no_image.jpg"]  || ![[NSString stringWithFormat:@"%@",[[dataDictionary valueForKey:@"Discount_thumb"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] isEqualToString:@"http://emsbapp.com/admin/images/no_image.jpg"])
                {
                    wb = [[UITextView alloc] initWithFrame:CGRectMake(5, lblTitle.frame.size.height+10, view1.frame.size.width-10, 70)];
                }
                else
                {
                    wb = [[UITextView alloc] initWithFrame:CGRectMake(5, lblTitle.frame.size.height+10, view1.frame.size.width-10, view1.frame.size.height-80)];
                }
                wb.backgroundColor = [UIColor clearColor];
                wb.opaque=NO;
                wb.textColor =[UIColor whiteColor];
                wb.font = [UIFont systemFontOfSize:16.0];
                wb.userInteractionEnabled =YES;
                wb.editable = NO;
                wb.scrollEnabled = YES;

                //[wb loadHTMLString:[NSString stringWithFormat:@"<html><body text=\"#FFFFFF\">%@</body></html>",[dataDictionary valueForKey:@"Description"]] baseURL:nil];
                wb.text = [dataDictionary valueForKey:@"Description"];
                btnEdit = [[UIButton alloc]init];
                btnEdit.frame=CGRectMake(7, view1.frame.size.height-43, view1.frame.size.width-10, 43);
                [btnEdit setImage:[UIImage imageNamed:@"btn_edit.png"] forState:UIControlStateNormal];
                btnEdit.userInteractionEnabled = YES;
                btnEdit.layer.cornerRadius = 5.0;
                [btnEdit addTarget:self action:@selector(btnEditClicked:) forControlEvents:UIControlEventTouchUpInside];
                
                btnEdit.tag = [arrAllData indexOfObject:dataDictionary];
               
                dictData =dataDictionary;
                
                [view1 addSubview:lblTitle];
                [view1 addSubview:lblStatus];
                [view1 addSubview:wb];
                [view1 addSubview:btnEdit];
                [self.scrl addSubview:view1];
                BOOL isImage =NO;
                //image
                if (![[NSString stringWithFormat:@"%@",[[dataDictionary valueForKey:@"Discount_image"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] isEqualToString:@"http://emsbapp.com/admin/images/no_image.jpg"])
                {
                    UIImageView *img=[[UIImageView alloc] init];
                    
                  

                    if (![[NSString stringWithFormat:@"%@",[[dataDictionary valueForKey:@"Discount_thumb"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] isEqualToString:@"http://emsbapp.com/admin/images/no_image.jpg"])
                        
                    {
                                              
                        if (mainScreen.size.height == 480)
                        
                        {
                            
                            img.frame=CGRectMake(5, lblTitle.frame.size.height+100, view1.frame.size.width/2-5,view1.frame.size.width/2-5);
                        }
                        else
                        {
                            img.frame=CGRectMake(5, lblTitle.frame.size.height+150, view1.frame.size.width/2-5,view1.frame.size.width/2-5);
                        }
                        
                    }
                    else
                    {
                        img.frame=CGRectMake(7, lblTitle.frame.size.height+90, view1.frame.size.width-10, view1.frame.size.height-200);
                    }
                    img.backgroundColor=[UIColor blackColor];
                    img.tag=999;
                    img.contentMode = UIViewContentModeScaleToFill;
                    [img setContentMode:UIViewContentModeScaleAspectFit];
                    
                    NSString *thumbURL=[[dataDictionary valueForKey:@"Discount_image"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    NSURL *url = [NSURL URLWithString:thumbURL];
                    [img  sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder.png"]] ;
                    
                    [view1 addSubview:img];
                    [self.scrl addSubview:view1];
                    isImage =YES;
                }
                //video
                if (![[NSString stringWithFormat:@"%@",[[dataDictionary valueForKey:@"Discount_thumb"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] isEqualToString:@"http://emsbapp.com/admin/images/no_image.jpg"])
                {
                    UIImageView *img=[[UIImageView alloc] init];
                    if (isImage)
                    {
                        if (mainScreen.size.height == 480)
                        {
                            img.frame=CGRectMake(view1.frame.size.width/2+5,lblTitle.frame.size.height+100, view1.frame.size.width/2-5,view1.frame.size.width/2-5);
                        }
                        else
                        {
                            img.frame=CGRectMake(view1.frame.size.width/2+5,lblTitle.frame.size.height+150, view1.frame.size.width/2-5,view1.frame.size.width/2-5);
                        }
                    }
                    else
                    {
                        img.frame=CGRectMake(7, lblTitle.frame.size.height+100, view1.frame.size.width-10, view1.frame.size.height-200);
                    }
                    img.backgroundColor=[UIColor blackColor];
                    img.tag=999;
                    img.contentMode = UIViewContentModeScaleToFill;
                    [img setContentMode:UIViewContentModeScaleAspectFit];
                    NSString *thumbURL=[[dataDictionary valueForKey:@"Discount_thumb"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    NSURL *url = [NSURL URLWithString:thumbURL];
                    [img  sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                    NSString *urlVideo = [dataDictionary valueForKey:@"Discount_video"];
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
                    //[view1 addSubview:lblTitle];
                    [img addSubview:button];
                    [view1 addSubview:img];
                    [view1 bringSubviewToFront:button];
                    img.userInteractionEnabled=YES;
                }
            }
            if ([[dataDictionary valueForKey:@"BillboardType"] isEqualToString:@"Promos"])
            {
                view1.tag=2;
                lblTitle.text = [dataDictionary valueForKey:@"Title"];
                NSString *strSt =[dataDictionary valueForKey:@"Billboard_status"];
                if ([strSt isEqualToString:@"expire"])
                {
                    lblStatus.textColor =[UIColor redColor];
                    lblStatus.text =@"Expired";
                }
                else
                {
                    lblStatus.textColor=[UIColor greenColor];
                    lblStatus.text =@"Active";
                }
                
                UITextView *wb;
                if (![[NSString stringWithFormat:@"%@",[[dataDictionary valueForKey:@"Promo_image"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] isEqualToString:@"http://emsbapp.com/admin/images/no_image.jpg"]  && ![[NSString stringWithFormat:@"%@",[[dataDictionary valueForKey:@"Promo_thumb"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] isEqualToString:@"http://emsbapp.com/admin/images/no_image.jpg"])
                {
                    if (mainScreen.size.height == 480)
                    {
                        wb = [[UITextView alloc] initWithFrame:CGRectMake(5, lblTitle.frame.size.height, view1.frame.size.width-10, 80)];
                    }
                    else
                    {
                        wb = [[UITextView alloc] initWithFrame:CGRectMake(5, lblTitle.frame.size.height+10, view1.frame.size.width-10, 100)];
                    }

                }
                
                else if (![[NSString stringWithFormat:@"%@",[[dataDictionary valueForKey:@"Promo_image"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] isEqualToString:@"http://emsbapp.com/admin/images/no_image.jpg"]  || ![[NSString stringWithFormat:@"%@",[[dataDictionary valueForKey:@"Promo_thumb"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] isEqualToString:@"http://emsbapp.com/admin/images/no_image.jpg"])
                {
                    wb = [[UITextView alloc] initWithFrame:CGRectMake(5, lblTitle.frame.size.height+10, view1.frame.size.width-10, 70)];
                }
                else
                {
                    wb = [[UITextView alloc] initWithFrame:CGRectMake(5, lblTitle.frame.size.height+10, view1.frame.size.width-10, view1.frame.size.height-80)];
                }
                
                //[wb loadHTMLString:[NSString stringWithFormat:@"<html><body text=\"#FFFFFF\">%@</body></html>",[dataDictionary valueForKey:@"Description"]] baseURL:nil];
                wb.text = [dataDictionary valueForKey:@"Description"];
                wb.backgroundColor = [UIColor clearColor];
                wb.opaque=NO;
                wb.textColor =[UIColor whiteColor];
                wb.font = [UIFont systemFontOfSize:16.0];
                wb.userInteractionEnabled =YES;
                wb.editable = NO;
                wb.scrollEnabled = YES;

                btnEdit = [[UIButton alloc]init];
                btnEdit.frame=CGRectMake(7, view1.frame.size.height-43, view1.frame.size.width-10, 43);
                [btnEdit setImage:[UIImage imageNamed:@"btn_edit.png"] forState:UIControlStateNormal];
                btnEdit.userInteractionEnabled = YES;
                btnEdit.layer.cornerRadius = 5.0;
                [btnEdit addTarget:self action:@selector(btnEditClicked:) forControlEvents:UIControlEventTouchUpInside];
                btnEdit.tag = [arrAllData indexOfObject:dataDictionary];
                dictData =dataDictionary;
                
                [view1 addSubview:lblStatus];
                [view1 addSubview:btnEdit];
                [view1 addSubview:wb];
                [self.scrl addSubview:view1];
                BOOL isImage =NO;
                //image
                if (![[NSString stringWithFormat:@"%@",[[dataDictionary valueForKey:@"Promo_image"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] isEqualToString:@"http://emsbapp.com/admin/images/no_image.jpg"])
                {
                    UIImageView *img=[[UIImageView alloc] init];
                    if (![[NSString stringWithFormat:@"%@",[[dataDictionary valueForKey:@"Promo_thumb"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] isEqualToString:@"http://emsbapp.com/admin/images/no_image.jpg"])
                    {
                        if (mainScreen.size.height == 480)
                        {
                            img.frame=CGRectMake(5, lblTitle.frame.size.height+100, view1.frame.size.width/2-5,view1.frame.size.width/2-5);
                        }
                        else
                        {
                            img.frame=CGRectMake(5, lblTitle.frame.size.height+150, view1.frame.size.width/2-5,view1.frame.size.width/2-5);
                        }

                        
                    }
                    else
                    {
                        img.frame=CGRectMake(5, lblTitle.frame.size.height+90, view1.frame.size.width-10, view1.frame.size.height-200);
                    }
                    img.backgroundColor=[UIColor blackColor];
                    img.tag=999;
                    img.contentMode = UIViewContentModeScaleToFill;
                    [img setContentMode:UIViewContentModeScaleAspectFit];
                    
                    NSString *thumbURL=[[dataDictionary valueForKey:@"Promo_image"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    NSURL *url = [NSURL URLWithString:thumbURL];
                    [img  sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                    
                    
                    
                    
                    
                    
                    [view1 addSubview:img];
                    [self.scrl addSubview:view1];
                    isImage =YES;
                }
                //video
                if (![[NSString stringWithFormat:@"%@",[[dataDictionary valueForKey:@"Promo_thumb"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] isEqualToString:@"http://emsbapp.com/admin/images/no_image.jpg"])
                {
                    UIImageView *img=[[UIImageView alloc] init];
                    if (isImage)
                    {
                        if (mainScreen.size.height == 480)
                        {
                            img.frame=CGRectMake(view1.frame.size.width/2+5,lblTitle.frame.size.height+100, view1.frame.size.width/2-5,view1.frame.size.width/2-5);
                        }
                        else
                        {
                            img.frame=CGRectMake(view1.frame.size.width/2+5,lblTitle.frame.size.height+150, view1.frame.size.width/2-5,view1.frame.size.width/2-5);
                        }

                    }
                    else
                    {
                        img.frame=CGRectMake(5, lblTitle.frame.size.height+90, view1.frame.size.width-10, view1.frame.size.height-200);
                    }
                    img.backgroundColor=[UIColor blackColor];
                    img.tag=999;
                    img.contentMode = UIViewContentModeScaleToFill;
                    [img setContentMode:UIViewContentModeScaleAspectFit];
                    NSString *thumbURL=[[dataDictionary valueForKey:@"Promo_thumb"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    NSURL *url = [NSURL URLWithString:thumbURL];
                    [img  sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                    NSString *urlVideo = [dataDictionary valueForKey:@"Promo_video"];
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
            if ([[dataDictionary valueForKey:@"BillboardType"] isEqualToString:@"Event"])
            {
                view1.tag=3;
                lblTitle.text = [dataDictionary valueForKey:@"Title"];
                NSString *strSt =[dataDictionary valueForKey:@"Billboard_status"];
                if ([strSt isEqualToString:@"expire"])
                {
                    lblStatus.textColor =[UIColor redColor];
                    lblStatus.text =@"Expired";
                }
                else
                {
                    lblStatus.textColor=[UIColor greenColor];
                    lblStatus.text =@"Active";
                }
                
                UITextView *wb;
                if (![[NSString stringWithFormat:@"%@",[[dataDictionary valueForKey:@"Event_image"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] isEqualToString:@"http://emsbapp.com/admin/images/no_image.jpg"]  && ![[NSString stringWithFormat:@"%@",[[dataDictionary valueForKey:@"Event_thumb"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] isEqualToString:@"http://emsbapp.com/admin/images/no_image.jpg"])
                {
                    if (mainScreen.size.height == 480)
                    {
                        wb = [[UITextView alloc] initWithFrame:CGRectMake(5, lblTitle.frame.size.height, view1.frame.size.width-10, 80)];
                    }
                    else
                    {
                        wb = [[UITextView alloc] initWithFrame:CGRectMake(5, lblTitle.frame.size.height+10, view1.frame.size.width-10, 100)];
                    }

                }
                
                else if (![[NSString stringWithFormat:@"%@",[[dataDictionary valueForKey:@"Event_image"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] isEqualToString:@"http://emsbapp.com/admin/images/no_image.jpg"]  || ![[NSString stringWithFormat:@"%@",[[dataDictionary valueForKey:@"Event_thumb"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] isEqualToString:@"http://emsbapp.com/admin/images/no_image.jpg"])
                {
                    wb = [[UITextView alloc] initWithFrame:CGRectMake(5, lblTitle.frame.size.height+10, view1.frame.size.width-10, 70)];
                }
                else
                {
                    wb = [[UITextView alloc] initWithFrame:CGRectMake(5, lblTitle.frame.size.height+10, view1.frame.size.width-10, view1.frame.size.height-80)];
                }
                wb.text = [dataDictionary valueForKey:@"Description"];
                wb.backgroundColor = [UIColor clearColor];
                wb.opaque=NO;
                wb.textColor =[UIColor whiteColor];
                wb.font = [UIFont systemFontOfSize:16.0];
                wb.userInteractionEnabled =YES;
                wb.editable = NO;
                wb.scrollEnabled = YES;

                //[wb loadHTMLString:[NSString stringWithFormat:@"<html><body text=\"#FFFFFF\">%@</body></html>",[dataDictionary valueForKey:@"Description"]] baseURL:nil];
                btnEdit = [[UIButton alloc]init];
                btnEdit.frame=CGRectMake(7, view1.frame.size.height-43, view1.frame.size.width-10, 43);
                [btnEdit setImage:[UIImage imageNamed:@"btn_edit.png"] forState:UIControlStateNormal];
                btnEdit.userInteractionEnabled = YES;
                btnEdit.layer.cornerRadius = 5.0;
                [btnEdit addTarget:self action:@selector(btnEditClicked:) forControlEvents:UIControlEventTouchUpInside];
                btnEdit.tag = [arrAllData indexOfObject:dataDictionary];
                dictData =dataDictionary;
                
                [view1 addSubview:lblStatus];
                [view1 addSubview:btnEdit];
                [view1 addSubview:wb];
                [self.scrl addSubview:view1];
                BOOL isImage =NO;
                //image
                if (![[NSString stringWithFormat:@"%@",[[dataDictionary valueForKey:@"Event_image"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] isEqualToString:@"http://emsbapp.com/admin/images/no_image.jpg"])
                {
                    UIImageView *img=[[UIImageView alloc] init];
                    if (![[NSString stringWithFormat:@"%@",[[dataDictionary valueForKey:@"Event_thumb"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] isEqualToString:@"http://emsbapp.com/admin/images/no_image.jpg"])
                    {
                        if (mainScreen.size.height == 480)
                        {
                            img.frame=CGRectMake(5, lblTitle.frame.size.height+100, view1.frame.size.width/2-5,view1.frame.size.width/2-5);
                        }
                        else
                        {
                            img.frame=CGRectMake(5, lblTitle.frame.size.height+150, view1.frame.size.width/2-5,view1.frame.size.width/2-5);
                        }

                        
                    }
                    else
                    {
                        img.frame=CGRectMake(5, lblTitle.frame.size.height+90, view1.frame.size.width-10, view1.frame.size.height-200);
                    }
                    img.backgroundColor=[UIColor blackColor];
                    img.tag=999;
                    img.contentMode = UIViewContentModeScaleToFill;
                    [img setContentMode:UIViewContentModeScaleAspectFit];
                    
                    NSString *thumbURL=[[dataDictionary valueForKey:@"Event_image"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    NSURL *url = [NSURL URLWithString:thumbURL];
                    [img  sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                    [view1 addSubview:img];
                    [self.scrl addSubview:view1];
                    isImage =YES;
                }
                //video
                if (![[NSString stringWithFormat:@"%@",[[dataDictionary valueForKey:@"Event_thumb"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] isEqualToString:@"http://emsbapp.com/admin/images/no_image.jpg"])
                {
                    UIImageView *img=[[UIImageView alloc] init];
                    if (isImage)
                    {
                        if (mainScreen.size.height == 480)
                        {
                            img.frame=CGRectMake(view1.frame.size.width/2+5,lblTitle.frame.size.height+100, view1.frame.size.width/2-5,view1.frame.size.width/2-5);
                        }
                        else
                        {
                            img.frame=CGRectMake(view1.frame.size.width/2+5,lblTitle.frame.size.height+150, view1.frame.size.width/2-5,view1.frame.size.width/2-5);
                        }

                    }
                    else
                    {
                        img.frame=CGRectMake(5, lblTitle.frame.size.height+90, view1.frame.size.width-10, view1.frame.size.height-200);
                    }
                    img.backgroundColor=[UIColor blackColor];
                    img.tag=999;
                    img.contentMode = UIViewContentModeScaleToFill;
                    [img setContentMode:UIViewContentModeScaleAspectFit];
                    NSString *thumbURL=[[dataDictionary valueForKey:@"Event_thumb"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    NSURL *url = [NSURL URLWithString:thumbURL];
                    [img  sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                    NSString *urlVideo = [dataDictionary valueForKey:@"Event_video"];
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
            if ([[dataDictionary valueForKey:@"BillboardType"] isEqualToString:@"Image"])
            {
                view1.tag=4;
                lblTitle.text = [dataDictionary valueForKey:@"Title"];
                NSString *strSt =[dataDictionary valueForKey:@"Billboard_status"];
                if ([strSt isEqualToString:@"expire"])
                {
                    lblStatus.textColor =[UIColor redColor];
                    lblStatus.text =@"Expired";
                }
                else
                {
                    lblStatus.textColor=[UIColor greenColor];
                    lblStatus.text =@"Active";
                }
                
                UIImageView *img=[[UIImageView alloc] init];
                if (mainScreen.size.height == 480)
                {
                    img.frame=CGRectMake(5, lblTitle.frame.size.height+5, view1.frame.size.width-10, view1.frame.size.height-100);
                }
                else
                {
                    img.frame=CGRectMake(5, lblTitle.frame.size.height+90, view1.frame.size.width-10, view1.frame.size.height-200);
                }
                img.backgroundColor=[UIColor blackColor];
                img.tag=999;
                img.contentMode = UIViewContentModeScaleToFill;
                [img setContentMode:UIViewContentModeScaleAspectFit];
                NSString *thumbURL=[[dataDictionary valueForKey:@"Image_Name"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSURL *url = [NSURL URLWithString:thumbURL];
                [img  sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                
                btnEdit = [[UIButton alloc]init];
                btnEdit.frame=CGRectMake(7, view1.frame.size.height-43, view1.frame.size.width-10, 43);
                [btnEdit setImage:[UIImage imageNamed:@"btn_edit.png"] forState:UIControlStateNormal];
                btnEdit.userInteractionEnabled = YES;
                btnEdit.layer.cornerRadius = 5.0;
                [btnEdit addTarget:self action:@selector(btnEditClicked:) forControlEvents:UIControlEventTouchUpInside];
                btnEdit.tag = [arrAllData indexOfObject:dataDictionary];
                dictData =dataDictionary;
                
                [view1 addSubview:lblTitle];
                [view1 addSubview:lblStatus];
                [view1 addSubview:btnEdit];
                [view1 addSubview:img];
                [self.scrl addSubview:view1];
            }
            if ([[dataDictionary valueForKey:@"BillboardType"] isEqualToString:@"Video"])
            {
                view1.tag=5;
                lblTitle.text = [dataDictionary valueForKey:@"Title"];
                NSString *strSt =[dataDictionary valueForKey:@"Billboard_status"];
                if ([strSt isEqualToString:@"expire"])
                {
                    lblStatus.textColor =[UIColor redColor];
                    lblStatus.text =@"Expired";
                }
                else
                {
                    lblStatus.textColor=[UIColor greenColor];
                    lblStatus.text =@"Active";
                }
                
                UIImageView *img=[[UIImageView alloc] init];
                img.frame=CGRectMake(5, lblTitle.frame.size.height+90, view1.frame.size.width-5, view1.frame.size.height-200);
                img.backgroundColor=[UIColor blackColor];
                img.tag=999;
                img.contentMode = UIViewContentModeScaleToFill;
                [img setContentMode:UIViewContentModeScaleAspectFit];
                NSString *thumbURL=[[dataDictionary valueForKey:@"video_thumb"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSURL *url = [NSURL URLWithString:thumbURL];
                [img  sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                NSString *urlVideo = [dataDictionary valueForKey:@"Embed_Code"];
                [arrVideoUrl addObject:urlVideo];
                UIButton *button = [[UIButton alloc] init];
                [button setImage:[UIImage imageNamed:@"btn_video_play.png" ] forState:UIControlStateNormal];
                [button setBackgroundColor:[UIColor clearColor]];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                button.frame = CGRectMake((img.frame.size.width/2)-37, (img.frame.size.height/2)-37,75, 75);
                button.tag= urlCount;
                urlCount++;
                button.enabled = YES;
                button.userInteractionEnabled = YES;
                [button addTarget:self action:@selector(btnPlayVideoClicked:) forControlEvents:UIControlEventTouchUpInside];
                btnEdit = [[UIButton alloc]init];
                btnEdit.frame=CGRectMake(7, view1.frame.size.height-43, view1.frame.size.width-10, 43);
                [btnEdit setImage:[UIImage imageNamed:@"btn_edit.png"] forState:UIControlStateNormal];
                btnEdit.userInteractionEnabled = YES;
                btnEdit.layer.cornerRadius = 5.0;
                [btnEdit addTarget:self action:@selector(btnEditClicked:) forControlEvents:UIControlEventTouchUpInside];
                btnEdit.tag = [arrAllData indexOfObject:dataDictionary];
                dictData =dataDictionary;
                
                [self.scrl addSubview:view1];
                [view1 addSubview:lblTitle];
                [view1 addSubview:lblStatus];
                [view1 addSubview:btnEdit];
                [img addSubview:button];
                [view1 addSubview:img];
                [view1 bringSubviewToFront:button];
                img.userInteractionEnabled=YES;
            }
            if ([[dataDictionary valueForKey:@"BillboardType"] isEqualToString:@"Social"])
            {
                view1.tag=6;
                lblTitle.text = @"Connect with us";
                NSString *strSt =[dataDictionary valueForKey:@"Billboard_status"];
                if ([strSt isEqualToString:@"expire"])
                {
                    lblStatus.textColor =[UIColor redColor];
                    lblStatus.text =@"Expired";
                }
                else
                {
                    lblStatus.textColor=[UIColor greenColor];
                    lblStatus.text =@"Active";
                }
                
                UIWebView *wb = [[UIWebView alloc] initWithFrame:CGRectMake(5, lblTitle.frame.size.height+10, view1.frame.size.width-5, view1.frame.size.height-80)];
                wb.backgroundColor = [UIColor clearColor];
                wb.opaque=NO;
                wb.delegate = self;
                //[wb loadHTMLString:[NSString stringWithFormat:@"<html><body text=\"#FFFFFF\">%@</body></html>",[[dataDictionary valueForKey:@"social"] valueForKey:@"url"]] baseURL:nil];
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[dataDictionary valueForKey:@"social"]]];
                [wb loadRequest:[NSURLRequest requestWithURL:url]];
                [arrBtnTitle addObject:@""];
                
                btnEdit = [[UIButton alloc]init];
                btnEdit.frame=CGRectMake(7, view1.frame.size.height-43, view1.frame.size.width-10, 43);
                [btnEdit setImage:[UIImage imageNamed:@"btn_edit.png"] forState:UIControlStateNormal];
                btnEdit.userInteractionEnabled = YES;
                btnEdit.layer.cornerRadius = 5.0;
                [btnEdit addTarget:self action:@selector(btnEditClicked:) forControlEvents:UIControlEventTouchUpInside];
                btnEdit.tag = [arrAllData indexOfObject:dataDictionary];
                dictData =dataDictionary;
                
                [view1 addSubview:lblTitle];
                [view1 addSubview:wb];
                [view1 addSubview:lblStatus];
                [view1 addSubview:btnEdit];
                [self.scrl addSubview:view1];
            }
            [arrDictData addObject:dictData];
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Jaywalk.In" message:@"Offers and more Coming Soon!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag = 23;
        [alert show];
    }
}

#pragma mark- AlertView Delegates

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 401)
    {
        if (buttonIndex == 0)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }

    if (alertView.tag == 23)
    {
        if (buttonIndex == 0)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    if (alertView.tag == 1)
    {
        if (buttonIndex == 0)
        {
            NSMutableDictionary *dic_K = [arrTempMerchantDetail objectAtIndex:tempMerchantTag];
            NSString * phoneNumber = [NSString stringWithFormat:@"tel://%@",[dic_K valueForKey:@"Phoneno"]];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
        }
    }
}

#pragma mark- ScrollView Delegates

- (void)scrollViewDidScroll:(UIScrollView *)scrollview
{
	oldoffset_y=scrollview.contentOffset.y;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView1
{
    CurrentPage=scrollView1.contentOffset.y/scrollView1.frame.size.height;
    pgCtrl.currentPage = CurrentPage;
}


#pragma mark- Playing Video

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

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    [self.scrl bringSubviewToFront:loading];
    [loading setHidden:NO];
    [loading startAnimating];
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [loading stopAnimating];
    [loading setHidden:YES];
}

-(IBAction)btnBackMediaPlayerClick:(id)sender
{
    [viewPlayer removeFromSuperview];
}

#pragma mark - ParseResponse


-(void)ParseResponseGetBill:(id)sender
{
    NetworkUtills *utills=(NetworkUtills *)sender;
    [self ParseResult:utills.strResponse];
}

-(void)ParseResult:(NSString *)strResponse
{
    if (netUtills.tag == 1)
    {
        mainDict = [strResponse JSONValue];
        if (([mainDict valueForKey:@"Billboards"] == [NSNull null]))
        {
            [arrAllData removeAllObjects];
        }
        else
        {
            arrAllData = [mainDict valueForKey:@"Billboards"];
            if ([arrAllData isKindOfClass:[NSString class]])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Jaywalk.In" message:@"Offers and more Coming Soon!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                alert.tag = 401;
                [alert show];
                return;
            }
        }
    }
    [self SetPageControl];
}

#pragma mark- Button Action

-(IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btnEditClicked:(id)sender
{
    UIButton *btn   = (UIButton *)sender;
    
    ManageBillBoardCoupanVC *manageCoupon = [[ManageBillBoardCoupanVC alloc] initWithNibName:@"ManageBillBoardCoupanVC" bundle:nil];
    manageCoupon.dictBillBoardInfo=[[NSMutableDictionary alloc]init];
    //DP
    manageCoupon.dictBillBoardInfo =[arrDictData objectAtIndex:btn.tag];
    manageCoupon.strTitle =[[NSUserDefaults standardUserDefaults]valueForKey:@"merchantName"];
    [self.navigationController pushViewController:manageCoupon animated:YES];
}


@end
