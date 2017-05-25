//
//  ManageBillBoardCoupanVC.m
//  Jwalkin
//
//  Created by Kanika on 17/07/15.
//  Copyright (c) 2015 fox. All rights reserved.
//

#import "ManageBillBoardCoupanVC.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import "UrlFile.h"
#import "JSON.h"
#import "Reachability.h"

@interface ManageBillBoardCoupanVC ()
{
    NSString *str;
}
@end

@implementation ManageBillBoardCoupanVC
@synthesize dictBillBoardInfo,strTitle;

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
    //NSLog(@"%@",dictBillBoardInfo);
    arrTownCat =[[NSArray alloc]initWithObjects:@"Contest",@"Happy Hour",@"Breakfast Specials",@"Lunch Specials",@"Dinner Specials",@"Kids Activites",@"Events",@"Local Sales",@"School News",@"Town News",@"Holiday", nil];
    arrExpDate = [[NSArray alloc]initWithObjects:@"30",@"7",@"3",@"1" ,nil];
    [self SetPageControl];
    lblMName.text =strTitle;
    view1.layer.cornerRadius =5.0;
    imgViewBackground.layer.cornerRadius =5.0;
    imgViewBackground.layer.borderWidth = 1.0;
    imgViewBackground.layer.borderColor = [[UIColor whiteColor] CGColor];
    imgViewBackground.clipsToBounds = YES;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- Button Action

-(IBAction)backClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btnDeleteClicked:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Jaywalk.In" message:@"Are you sure you want to delete this billboard?" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
    [alert show];
    alert.tag =10;
}

-(IBAction)btnCheckClicked:(id)sender
{
    if ([btnCheck isSelected])
    {
        [btnCheck setSelected:NO];
        [btnTownCatName setEnabled:NO];
        [btnTownCatName setTitle:@"" forState:UIControlStateDisabled];
        [dropDown hideDropDown:btnTownCatName];
        dropDown = nil;
    }
    else
    {
        [btnCheck setSelected:YES];
        [btnTownCatName setEnabled:YES];
    }

}

-(IBAction)btnCatNameClicked:(id)sender
{
    CGFloat f = 80;
    if(dropDown == nil)
    {
        dropDown = [[NIDropDown alloc]showDropDown:btnTownCatName :&f :arrTownCat :nil :@"up"];
        [self.view bringSubviewToFront:dropDown];
        dropDown.delegate = self;
    }
    else
    {
        [dropDown hideDropDown:btnTownCatName];
        dropDown = nil;
    }
}

-(IBAction)btnExpTimeClick:(id)sender
{
    btnTemp = (UIButton *)sender;
    viewPicker.frame =self.view.frame;
    viewPicker.alpha = 0;
    [self.view addSubview:viewPicker];
    [UIView animateWithDuration:0.2 delay:0.2 options:UIViewAnimationOptionCurveEaseIn  animations:^
     {
         viewPicker.alpha = 1;
     }
                     completion:nil];
    //UIViewAnimationOptionCurveLinear
    [UIView commitAnimations];
}

-(IBAction)btnPickerDone:(id)sender
{
    NSString *text = [arrExpDate objectAtIndex:[pickerExpDate selectedRowInComponent:0]];
    [btnExpTime setTitle:text forState:UIControlStateNormal];
    [viewPicker removeFromSuperview];
}

-(IBAction)btnPickerCancel
{
    [viewPicker removeFromSuperview];
}

-(IBAction)btnSaveClicked:(id)sender
{
    // Enable Billboard
    // http://198.57.247.185/~jwalkin/admin/api/enable_billboard.php?time=3&billboardid=50
    /*
     add or update towncategory
     http://198.57.247.185/~jwalkin/admin/api/updatetownbillboard.php?billboard_id=43&towncat_name=gamenia&merchant_id=43
     */

    NSString *billId = [dictBillBoardInfo objectForKey:@"BillboardId"];
    NSString *mId = [dictBillBoardInfo objectForKey:@"Merchant_id"];
    NSString *time =[btnExpTime.titleLabel text];
    NSString *tonwCat = [btnTownCatName.titleLabel text];
    if ([btnCheck isSelected])
    {
        if (tonwCat == nil)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Jaywalk.In" message:@"Please select town info category!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            return;
        }
        netUtills = [[NetworkUtills alloc] initWithSelector:@selector(ParseResponseSave:) WithCallBackObject:self];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:billId forKey:@"billboard_id"];
        [dict setObject:tonwCat forKey:@"towncat_name"];
        [dict setObject:mId forKey:@"merchant_id"];
        [netUtills GetResponseByASIFormDataRequest:[NSString stringWithFormat:@"%@%@",mainUrl,updateBillBoard] WithDictionary:dict];
    }
    else
    {
        if (time != nil)
        {
            netUtills = [[NetworkUtills alloc] initWithSelector:@selector(ParseResponseSaveExpDate:) WithCallBackObject:self];
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setObject:billId forKey:@"billboardid"];
            [dict setObject:time forKey:@"time"];
            [netUtills GetResponseByASIFormDataRequest:[NSString stringWithFormat:@"%@%@",mainUrl,enableBillBoard] WithDictionary:dict];
        }
    }
    if (tonwCat == nil && time == nil)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Jaywalk.In" message:@"No changes in this billboard!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

-(IBAction)btnTownInfoRemoveClicked:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Jaywalk.In" message:@"Are you sure you want to remove this billboard from town info center?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No",nil];
    alert.tag = 5002;
    [alert show];
}

#pragma mark- PickerView Delegate

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    return [arrExpDate count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
    return [arrExpDate objectAtIndex:row];
}

#pragma mark- WebView Delegates

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    [imgViewBackground bringSubviewToFront:loading];
    [loading setHidden:NO];
    [loading startAnimating];
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [loading stopAnimating];
    [loading setHidden:YES];
}

#pragma mark- AlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 10)
    {
        if (buttonIndex == 0)
        {
            [self callDeleteApi];
        }
    }
    if (alertView.tag == 400)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (alertView.tag == 5001)
    {
         [self.navigationController popViewControllerAnimated:YES];
    }
    if (alertView.tag == 5002)
    {
        if (buttonIndex == 0)
        {
            [self callRemoveFromTownInfoApi];
        }
    }
    if (alertView.tag == 5003)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (alertView.tag == 5004)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - NIDropDown Delegates

- (void) niDropDownDelegateMethod: (NIDropDown *) sender
{
    dropDown=nil;
   
}

#pragma mark- Api Call And Response

-(void)callDeleteApi
{
    /*
    1. Delete billboard http://198.57.247.185/~jwalkin/admin/api/delete_billboard.php?billboard_id=324&billboard_type=I
    billboard_id,billboard_type
    
     http://198.57.247.185/~jwalkin/admin/api/delete_socialbillboard.php?billboard_id=121&socialbill_type=facebook
    */
    NSString *billId = [dictBillBoardInfo objectForKey:@"BillboardId"];
    NSString *billType = [dictBillBoardInfo objectForKey:@"BillboardType"];
    if ([billType isEqualToString:@"Social"])
    {
        netUtills = [[NetworkUtills alloc] initWithSelector:@selector(ParseResponseSocialDelete:) WithCallBackObject:self];
        NSString *socialBillType = [[dictBillBoardInfo valueForKey:@"social"] valueForKey:@"type"];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:billId forKey:@"billboard_id"];
        [dict setObject:socialBillType forKey:@"socialbill_type"];
        [netUtills GetResponseByASIFormDataRequest:[NSString stringWithFormat:@"%@%@",mainUrl,deleteSocialBillBoard] WithDictionary:dict];
    }
    else
    {
        netUtills = [[NetworkUtills alloc] initWithSelector:@selector(ParseResponseDelete:) WithCallBackObject:self];
        NSString *type;
        if (billType.length > 0)
        {
            type = [billType substringToIndex:1];
        }
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:billId forKey:@"billboard_id"];
        [dict setObject:type forKey:@"billboard_type"];
        [netUtills GetResponseByASIFormDataRequest:[NSString stringWithFormat:@"%@%@",mainUrl,deleteBillboard] WithDictionary:dict];
    }
}

-(void)callRemoveFromTownInfoApi
{
    //delete towncategory
   // http://198.57.247.185/~jwalkin/admin/api/delete_towncategory.php?billboard_id=43&merchant_id=1
    NSString *billId = [dictBillBoardInfo objectForKey:@"BillboardId"];
    NSString *mId = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"merchantid"]];
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Please check your internet connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        netUtills = [[NetworkUtills alloc] initWithSelector:@selector(ParseResponseRemoveTownInfo:) WithCallBackObject:self];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:billId forKey:@"billboard_id"];
        [dict setObject:mId forKey:@"merchant_id"];
        [netUtills GetResponseByASIFormDataRequest:[NSString stringWithFormat:@"%@%@",mainUrl,deletetowncategory] WithDictionary:dict];
    }


}

-(void)ParseResponseDelete:(id)sender
{
    NetworkUtills *utills=(NetworkUtills *)sender;
    NSDictionary *resDic =[utills.strResponse JSONValue];
    NSString *st = [resDic objectForKey:@"status"];
    if ([st isEqualToString:@"1"])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Jaywalk.In" message:[NSString stringWithFormat:@"%@",[resDic objectForKey:@"message"]] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        alert.tag = 400;
        [alert show];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@",[resDic objectForKey:@"message"]] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)ParseResponseSocialDelete:(id)sender
{
    NetworkUtills *utills=(NetworkUtills *)sender;
    NSDictionary *resDic =[utills.strResponse JSONValue];
    NSString *st = [resDic objectForKey:@"status"];
    if ([st isEqualToString:@"1"])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Jaywalk.In" message:[NSString stringWithFormat:@"%@",[resDic objectForKey:@"message"]] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        alert.tag = 400;
        [alert show];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@",[resDic objectForKey:@"message"]] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)ParseResponseSaveExpDate:(id)sender
{
    NetworkUtills *utills=(NetworkUtills *)sender;
    NSDictionary *resDic =[utills.strResponse JSONValue];
    NSString *st = [resDic objectForKey:@"status"];
    if ([st isEqualToString:@"1"])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Jaywalk.In" message:@"Billboard update successfully." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        alert.tag = 5001;
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@",[resDic objectForKey:@"message"]] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)ParseResponseRemoveTownInfo:(id)sender
{
    NetworkUtills *utills=(NetworkUtills *)sender;
    NSDictionary *resDic =[utills.strResponse JSONValue];
    NSString *st = [resDic objectForKey:@"status"];
    if ([st isEqualToString:@"1"])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Jaywalk.In" message:@"Billboard deleted from town info center successfully." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        alert.tag = 5003;
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@",[resDic objectForKey:@"message"]] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }

}
-(void)ParseResponseSave:(id)sender
{
    NetworkUtills *utills=(NetworkUtills *)sender;
    NSDictionary *resDic =[utills.strResponse JSONValue];
    NSString *st = [resDic objectForKey:@"status"];
    if ([st isEqualToString:@"1"])
    {
        NSString *billId = [dictBillBoardInfo objectForKey:@"BillboardId"];
        NSString *time =[btnExpTime.titleLabel text];
        if (time != nil)
        {
            netUtills = [[NetworkUtills alloc] initWithSelector:@selector(ParseResponseSaveExpDate:) WithCallBackObject:self];
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setObject:billId forKey:@"billboardid"];
            [dict setObject:time forKey:@"time"];
            [netUtills GetResponseByASIFormDataRequest:[NSString stringWithFormat:@"%@%@",mainUrl,enableBillBoard] WithDictionary:dict];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Jaywalk.In" message:@"Billboard update successfully." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            alert.tag = 5001;
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@",[resDic objectForKey:@"message"]] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark- SetBillBoard

-(void)SetPageControl
{
    CGRect mainScreen = [UIScreen mainScreen].bounds;
    
    NSString *townCat;
    if (![[dictBillBoardInfo valueForKey:@"BillboardType"] isEqualToString:@"Social"])
    {
        townCat =[NSString stringWithFormat:@"%@",[dictBillBoardInfo objectForKey:@"Towncategory_name"]];
    }
    
    if ([[dictBillBoardInfo valueForKey:@"BillboardType"] isEqualToString:@"Discount"])
    {
        view1.tag=1;
        lblTitle.text = [dictBillBoardInfo valueForKey:@"Title"];
        NSString *strSt =[dictBillBoardInfo valueForKey:@"Billboard_status"];
        UITextView *wb;
        if (![[NSString stringWithFormat:@"%@",[[dictBillBoardInfo valueForKey:@"Discount_image"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] isEqualToString:@"http://emsbapp.com/admin/images/no_image.jpg"]  && ![[NSString stringWithFormat:@"%@",[[dictBillBoardInfo valueForKey:@"Discount_thumb"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] isEqualToString:@"http://emsbapp.com/admin/images/no_image.jpg"])
        {
            
            if (mainScreen.size.height == 480)
            {
                wb = [[UITextView alloc] initWithFrame:CGRectMake(7, lblTitle.frame.size.height+10, view1.frame.size.width-10, 80)];
            }
            
            
            else
            {
                wb = [[UITextView alloc] initWithFrame:CGRectMake(7, lblTitle.frame.size.height+20, view1.frame.size.width-10, 100)];
            }
        }
        else if (![[NSString stringWithFormat:@"%@",[[dictBillBoardInfo valueForKey:@"Discount_image"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] isEqualToString:@"http://emsbapp.com/admin/images/no_image.jpg"]  || ![[NSString stringWithFormat:@"%@",[[dictBillBoardInfo valueForKey:@"Discount_thumb"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] isEqualToString:@"http://emsbapp.com/admin/images/no_image.jpg"])
        {
            wb = [[UITextView alloc] initWithFrame:CGRectMake(7, lblTitle.frame.size.height+23, view1.frame.size.width-10, 70)];
        }
        else
        {
            if (mainScreen.size.height == 480)
            {
                wb = [[UITextView alloc] initWithFrame:CGRectMake(7, lblTitle.frame.size.height+20, view1.frame.size.width-10, view1.frame.size.height-270)];
            }
            
            else if (IS_IPHONE_6P)
            {
             
                
            wb = [[UITextView alloc] initWithFrame:CGRectMake(7, lblTitle.frame.size.height+30, view1.frame.size.width-10, view1.frame.size.height-200)];
                
            
            }
            else if (IS_IPHONE_6)
            {
                
                
                wb = [[UITextView alloc] initWithFrame:CGRectMake(7, lblTitle.frame.size.height+30, view1.frame.size.width-10, view1.frame.size.height-200)];
                
                
            }

            else
            {
                wb = [[UITextView alloc] initWithFrame:CGRectMake(7, lblTitle.frame.size.height+20, view1.frame.size.width-10, view1.frame.size.height-200)];
            }
            
        }
        wb.backgroundColor = [UIColor clearColor];
        wb.opaque=NO;
        wb.textColor =[UIColor whiteColor];
        wb.font = [UIFont systemFontOfSize:16.0];
        wb.userInteractionEnabled =YES;
        wb.editable = NO;
        wb.scrollEnabled = YES;
       // [wb loadHTMLString:[NSString stringWithFormat:@"<html><body text=\"#FFFFFF\">%@</body></html>",[dictBillBoardInfo valueForKey:@"Description"]] baseURL:nil];
        wb.text= [dictBillBoardInfo valueForKey:@"Description"];
        if (townCat.length <= 0)
        {
            btnCheck.hidden=NO;
            btnTownCatName.hidden=NO;
            lblSelectTown.hidden=NO;
        }
        else
        {
            lblTownStatus.hidden=NO;
            btnTownInfoRemove.hidden=NO;
        }
        
        if ([strSt isEqualToString:@"expire"])
        {
            lblStatus.textColor =[UIColor redColor];
            lblStatus.text =@"Expired";
            lblSetExpire.hidden=NO;
            lblInDays.hidden=NO;
            btnExpTime.hidden=NO;
        }
        else
        {
            lblStatus.textColor=[UIColor greenColor];
            lblStatus.text =@"Active";
            lblExpiryStatus.text = [NSString stringWithFormat:@"Billboard will be expired on %@",[dictBillBoardInfo valueForKey:@"expire_on"]];
            lblExpiryStatus.hidden=NO;
        }        

        [view1 addSubview:wb];
        [view1 bringSubviewToFront:wb];

        BOOL isImage =NO;
        //image
        if (![[NSString stringWithFormat:@"%@",[[dictBillBoardInfo valueForKey:@"Discount_image"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] isEqualToString:@"http://emsbapp.com/admin/images/no_image.jpg"])
        {
            UIImageView *img=[[UIImageView alloc] init];
            if (![[NSString stringWithFormat:@"%@",[[dictBillBoardInfo valueForKey:@"Discount_thumb"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] isEqualToString:@"http://emsbapp.com/admin/images/no_image.jpg"])
            {
                //Dp1Jan2016

                if (mainScreen.size.height == 480)
                {
                    img.frame=CGRectMake(5, lblTitle.frame.size.height+100, view1.frame.size.width/2-10,view1.frame.size.width/2-10);
                }
                else
                {
                    if (IS_IPHONE_6)
                    {
                        img.frame=CGRectMake(view1.frame.origin.x+5, lblTitle.frame.size.height+150, view1.frame.size.width/2+5,view1.frame.size.width/2);
                    }
                    else if (IS_IPHONE_6P)
                    {
                        
                        
                        img.frame=CGRectMake(5, lblTitle.frame.size.height+170, view1.frame.size.width/2+35,view1.frame.size.width/2+35);
                        //img.frame=CGRectMake(view1.frame.origin.x+5, lblTitle.frame.size.height+170, view1.frame.size.width/2-10,view1.frame.size.width/2-10);
                    }
                    
                    else{
       
                    img.frame=CGRectMake(5, lblTitle.frame.size.height+150, view1.frame.size.width/2-10,view1.frame.size.width/2-10);
                }
                }
                
            }
            else
            {
                if (mainScreen.size.height == 480)
                {
                     img.frame=CGRectMake(5, lblTitle.frame.size.height+50, view1.frame.size.width-10, view1.frame.size.height-300);
                    // img.frame=CGRectMake(5, lblTitle.frame.size.height+100, view1.frame.size.width-10, view1.frame.size.height-270);
                }
                else
                {
                   // CGSize winSize=[UIScreen mainScreen].bounds.size;
                    if (IS_IPHONE_6)
                    {
                        img.frame=CGRectMake(35, lblTitle.frame.size.height+100, view1.frame.size.width -20,view1.frame.size.height-250);
                    }
                   else if (IS_IPHONE_6P)
                    {
                         img.frame=CGRectMake(43, lblTitle.frame.size.height+110, view1.frame.size.width,view1.frame.size.height-200);
                    }
                   else
                   {
                         img.frame=CGRectMake(5, lblTitle.frame.size.height+100, view1.frame.size.width-10,view1.frame.size.height-270);
                   }

                   
                }
            }
            img.backgroundColor=[UIColor blackColor];
            img.tag=999;
        
            img.contentMode = UIViewContentModeScaleAspectFill;
            [img setContentMode:UIViewContentModeScaleAspectFit];
            
            NSString *thumbURL=[[dictBillBoardInfo valueForKey:@"Discount_image"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *url = [NSURL URLWithString:thumbURL];
            [img  sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            [view1 addSubview:img];
            isImage =YES;
        }
        //video
        if (![[NSString stringWithFormat:@"%@",[[dictBillBoardInfo valueForKey:@"Discount_thumb"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] isEqualToString:@"http://emsbapp.com/admin/images/no_image.jpg"])
        {
            UIImageView *img=[[UIImageView alloc] init];
            
            //Dp1Jan2016

            if (isImage)
            {
                if (mainScreen.size.height == 480)
                {
                    img.frame=CGRectMake(view1.frame.size.width/2+5,lblTitle.frame.size.height+100, view1.frame.size.width/2-10,view1.frame.size.width/2-10);
                }
                else
                    
                    if (IS_IPHONE_6)
                    {
                        img.frame=CGRectMake(view1.frame.size.width/2+30,lblTitle.frame.size.height+150, view1.frame.size.width/2,view1.frame.size.width/2);
                    }
                else if (IS_IPHONE_6P)
                {
                    
                     img.frame=CGRectMake(view1.frame.size.width/2+45,lblTitle.frame.size.height+170, view1.frame.size.width/2+35,view1.frame.size.width/2+35);
                }
                else
                {
                
                 img.frame=CGRectMake(view1.frame.size.width/2,lblTitle.frame.size.height+150, view1.frame.size.width/2-5,view1.frame.size.width/2-10);
                
                
                }
          
            }
            else
            {
                if (mainScreen.size.height == 480)
                {
                    img.frame=CGRectMake(5, lblTitle.frame.size.height+100, view1.frame.size.width-10, view1.frame.size.height-370);
                }
                else
                    
                    if (IS_IPHONE_6)
                    {
                        img.frame=CGRectMake(35, lblTitle.frame.size.height+100, view1.frame.size.width -20,view1.frame.size.height-250);
                         //img.frame=CGRectMake(5, lblTitle.frame.size.height+100, view1.frame.size.width-10, view1.frame.size.height-270);
                    }
                else if (IS_IPHONE_6P)
                {
                    
                      img.frame=CGRectMake(43, lblTitle.frame.size.height+110, view1.frame.size.width,view1.frame.size.height-200);
                
                // img.frame=CGRectMake(5, lblTitle.frame.size.height+100, view1.frame.size.width-10, view1.frame.size.height-270);
                
                }
                else
                    
                
                
                {
                    img.frame=CGRectMake(5, lblTitle.frame.size.height+90, view1.frame.size.width-10, view1.frame.size.height-280);
                }
            }
            img.backgroundColor=[UIColor blackColor];
            img.tag=999;
            img.contentMode = UIViewContentModeScaleToFill;
            [img setContentMode:UIViewContentModeScaleAspectFit];
            NSString *thumbURL=[[dictBillBoardInfo valueForKey:@"Discount_thumb"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *url = [NSURL URLWithString:thumbURL];
            [img  sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            urlVideo = [dictBillBoardInfo valueForKey:@"Discount_video"];
            UIButton *button = [[UIButton alloc] init];
            [ button setImage:[UIImage imageNamed:@"btn_video_play.png" ] forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor clearColor]];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.frame = CGRectMake((img.frame.size.width/2)-37, (img.frame.size.height/2)-37,75, 75);
            //button.tag= urlCount;
            //urlCount++;
            button.enabled = YES;
            button.userInteractionEnabled = YES;
            [button addTarget:self action:@selector(btnPlayVideoClicked:) forControlEvents:UIControlEventTouchUpInside];
            [img addSubview:button];
            [view1 addSubview:img];
            [view1 bringSubviewToFront:button];
            img.userInteractionEnabled=YES;
        }
    }
    if ([[dictBillBoardInfo valueForKey:@"BillboardType"] isEqualToString:@"Promos"])
    {
        view1.tag=2;
        lblTitle.text = [dictBillBoardInfo valueForKey:@"Title"];
        NSString *strSt =[dictBillBoardInfo valueForKey:@"Billboard_status"];
        UITextView *wb;
        if (![[NSString stringWithFormat:@"%@",[[dictBillBoardInfo valueForKey:@"Promo_image"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] isEqualToString:@"http://emsbapp.com/admin/images/no_image.jpg"]  && ![[NSString stringWithFormat:@"%@",[[dictBillBoardInfo valueForKey:@"Promo_thumb"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] isEqualToString:@"http://emsbapp.com/admin/images/no_image.jpg"])
        {
            if (mainScreen.size.height == 480)
            {
                wb = [[UITextView alloc] initWithFrame:CGRectMake(7, lblTitle.frame.size.height+10, view1.frame.size.width-10, 80)];
            }
            else
            {
                wb = [[UITextView alloc] initWithFrame:CGRectMake(7, lblTitle.frame.size.height+20, view1.frame.size.width-10, 100)];
            }
        }
        
        else if (![[NSString stringWithFormat:@"%@",[[dictBillBoardInfo valueForKey:@"Promo_image"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] isEqualToString:@"http://emsbapp.com/admin/images/no_image.jpg"]  || ![[NSString stringWithFormat:@"%@",[[dictBillBoardInfo valueForKey:@"Promo_thumb"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] isEqualToString:@"http://emsbapp.com/admin/images/no_image.jpg"])
        {
            wb = [[UITextView alloc] initWithFrame:CGRectMake(7, lblTitle.frame.size.height+20, view1.frame.size.width-10, 70)];
        }
        else
        {
            if (mainScreen.size.height == 480)
            {
                wb = [[UITextView alloc] initWithFrame:CGRectMake(7, lblTitle.frame.size.height+20, view1.frame.size.width-10, view1.frame.size.height-270)];
            }
            else
            {
                wb = [[UITextView alloc] initWithFrame:CGRectMake(7, lblTitle.frame.size.height+20, view1.frame.size.width-10, view1.frame.size.height-200)];
            }

        }
        wb.backgroundColor = [UIColor clearColor];
        wb.opaque=NO;
        wb.textColor =[UIColor whiteColor];
        wb.font = [UIFont systemFontOfSize:16.0];
        wb.userInteractionEnabled =YES;
        wb.editable = NO;
        wb.scrollEnabled = YES;
        wb.text= [dictBillBoardInfo valueForKey:@"Description"];
        //[wb loadHTMLString:[NSString stringWithFormat:@"<html><body text=\"#FFFFFF\">%@</body></html>",[dictBillBoardInfo valueForKey:@"Description"]] baseURL:nil];
        if (townCat.length <= 0)
        {
            btnCheck.hidden=NO;
            btnTownCatName.hidden=NO;
            lblSelectTown.hidden=NO;
        }
        else
        {
            lblTownStatus.hidden=NO;
            btnTownInfoRemove.hidden=NO;
        }
        
        if ([strSt isEqualToString:@"expire"])
        {
            lblStatus.textColor =[UIColor redColor];
            lblStatus.text =@"Expired";
            lblSetExpire.hidden=NO;
            lblInDays.hidden=NO;
            btnExpTime.hidden=NO;
        }
        else
        {
            lblStatus.textColor=[UIColor greenColor];
            lblStatus.text =@"Active";
            lblExpiryStatus.text = [NSString stringWithFormat:@"Billboard will be expired on %@",[dictBillBoardInfo valueForKey:@"expire_on"]];

            lblExpiryStatus.hidden=NO;
        }
        [view1 addSubview:wb];
        BOOL isImage =NO;
        //image
        if (![[NSString stringWithFormat:@"%@",[[dictBillBoardInfo valueForKey:@"Promo_image"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] isEqualToString:@"http://emsbapp.com/admin/images/no_image.jpg"])
        {
            UIImageView *img=[[UIImageView alloc] init];
            if (![[NSString stringWithFormat:@"%@",[[dictBillBoardInfo valueForKey:@"Promo_thumb"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] isEqualToString:@"http://emsbapp.com/admin/images/no_image.jpg"])
            {
              /*  if (mainScreen.size.height == 480)
                {
                    img.frame=CGRectMake(5, lblTitle.frame.size.height+100, view1.frame.size.width/2-10,view1.frame.size.width/2-10);
                }
                else
                {
                    img.frame=CGRectMake(5, lblTitle.frame.size.height+150, view1.frame.size.width/2-10,view1.frame.size.width/2-10);
                }
            }
            else
            {
                if (mainScreen.size.height == 480)
                {
                    img.frame=CGRectMake(5, lblTitle.frame.size.height+100, view1.frame.size.width-10, view1.frame.size.height-370);
                }
                else
                {
                    img.frame=CGRectMake(5, lblTitle.frame.size.height+100, view1.frame.size.width-10, view1.frame.size.height-270);
                }*/
                
                //Dp1Jan2016

                if (mainScreen.size.height == 480)
                {
                    img.frame=CGRectMake(5, lblTitle.frame.size.height+100, view1.frame.size.width/2-10,view1.frame.size.width/2-10);
                }
                else
                {
                    if (IS_IPHONE_6)
                    {
                        img.frame=CGRectMake(view1.frame.origin.x+5, lblTitle.frame.size.height+150, view1.frame.size.width/2+5,view1.frame.size.width/2);
                    }
                    else if (IS_IPHONE_6P)
                    {
                        img.frame=CGRectMake(view1.frame.origin.x+15, lblTitle.frame.size.height+100, view1.frame.size.width/2-10,view1.frame.size.width/2-10);
                    }
                    
                    else{
                        
                        img.frame=CGRectMake(5, lblTitle.frame.size.height+150, view1.frame.size.width/2-10,view1.frame.size.width/2-10);
                    }
                }
                
            }
            else
            {
                if (mainScreen.size.height == 480)
                {
                    img.frame=CGRectMake(5, lblTitle.frame.size.height+50, view1.frame.size.width-10, view1.frame.size.height-300);
                    // img.frame=CGRectMake(5, lblTitle.frame.size.height+100, view1.frame.size.width-10, view1.frame.size.height-270);
                }
                else
                {
                    // CGSize winSize=[UIScreen mainScreen].bounds.size;
                    if (IS_IPHONE_6)
                    {
                        img.frame=CGRectMake(35, lblTitle.frame.size.height+100, view1.frame.size.width -20,view1.frame.size.height-250);
                    }
                    else if (IS_IPHONE_6P)
                    {
                         img.frame=CGRectMake(43, lblTitle.frame.size.height+110, view1.frame.size.width,view1.frame.size.height-200);
                        
                    }
                    else
                    {
                        img.frame=CGRectMake(5, lblTitle.frame.size.height+100, view1.frame.size.width-10,view1.frame.size.height-270);
                    }
                    
                    
                }
            }


        
            img.backgroundColor=[UIColor blackColor];
            img.tag=999;
            img.contentMode = UIViewContentModeScaleToFill;
            [img setContentMode:UIViewContentModeScaleAspectFit];
            
            NSString *thumbURL=[[dictBillBoardInfo valueForKey:@"Promo_image"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *url = [NSURL URLWithString:thumbURL];
            [img  sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            [view1 addSubview:img];
            isImage =YES;
        }
        //video
        if (![[NSString stringWithFormat:@"%@",[[dictBillBoardInfo valueForKey:@"Promo_thumb"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] isEqualToString:@"http://emsbapp.com/admin/images/no_image.jpg"])
        {
            UIImageView *img=[[UIImageView alloc] init];
           /* if (isImage)
            {
                if (mainScreen.size.height == 480)
                {
                    img.frame=CGRectMake(view1.frame.size.width/2+5,lblTitle.frame.size.height+100, view1.frame.size.width/2-10,view1.frame.size.width/2-10);

                }
                else
                {
                    img.frame=CGRectMake(view1.frame.size.width/2+5,lblTitle.frame.size.height+150, view1.frame.size.width/2-10,view1.frame.size.width/2-10);
                }
            }
            else
            {
                if (mainScreen.size.height == 480)
                {
                    img.frame=CGRectMake(5, lblTitle.frame.size.height+100, view1.frame.size.width-10, view1.frame.size.height-370);
                }
                else
                {
                    img.frame=CGRectMake(5, lblTitle.frame.size.height+100, view1.frame.size.width-10, view1.frame.size.height-270);
                }

            }*/
            
            //Dp1Jan2016

            if (isImage)
            {
                if (mainScreen.size.height == 480)
                {
                    img.frame=CGRectMake(view1.frame.size.width/2+5,lblTitle.frame.size.height+100, view1.frame.size.width/2-10,view1.frame.size.width/2-10);
                }
                else
                    
                    if (IS_IPHONE_6)
                    {
                        img.frame=CGRectMake(view1.frame.size.width/2+30,lblTitle.frame.size.height+150, view1.frame.size.width/2,view1.frame.size.width/2);
                    }
                    else if (IS_IPHONE_6P)
                    {
                        img.frame=CGRectMake(view1.frame.size.width/2+20,lblTitle.frame.size.height+150, view1.frame.size.width/2,view1.frame.size.width/2);
                    }
                    else
                    {
                        
                        img.frame=CGRectMake(view1.frame.size.width/2,lblTitle.frame.size.height+150, view1.frame.size.width/2-5,view1.frame.size.width/2-10);
                        
                        
                    }
                
            }
            else
            {
                if (mainScreen.size.height == 480)
                {
                    img.frame=CGRectMake(5, lblTitle.frame.size.height+100, view1.frame.size.width-10, view1.frame.size.height-370);
                }
                else
                    
                    if (IS_IPHONE_6)
                    {
                        img.frame=CGRectMake(35, lblTitle.frame.size.height+100, view1.frame.size.width -20,view1.frame.size.height-250);
                        //img.frame=CGRectMake(5, lblTitle.frame.size.height+100, view1.frame.size.width-10, view1.frame.size.height-270);
                    }
                    else if (IS_IPHONE_6P)
                    {
                        
                        img.frame=CGRectMake(43, lblTitle.frame.size.height+110, view1.frame.size.width,view1.frame.size.height-200);
                        
                        // img.frame=CGRectMake(5, lblTitle.frame.size.height+100, view1.frame.size.width-10, view1.frame.size.height-270);
                        
                    }
                    else
                        
                        
                        
                    {
                        img.frame=CGRectMake(5, lblTitle.frame.size.height+90, view1.frame.size.width-10, view1.frame.size.height-280);
                    }
            }

            img.backgroundColor=[UIColor blackColor];
            img.tag=999;
            img.contentMode = UIViewContentModeScaleToFill;
            [img setContentMode:UIViewContentModeScaleAspectFit];
            NSString *thumbURL=[[dictBillBoardInfo valueForKey:@"Promo_thumb"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *url = [NSURL URLWithString:thumbURL];
            [img  sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            urlVideo = [dictBillBoardInfo valueForKey:@"Promo_video"];
            UIButton *button = [[UIButton alloc] init];
            [ button setImage:[UIImage imageNamed:@"btn_video_play.png" ] forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor clearColor]];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.frame = CGRectMake((img.frame.size.width/2)-37, (img.frame.size.height/2)-37,75, 75);
            // button.tag= urlCount;
            //urlCount++;
            button.enabled = YES;
            button.userInteractionEnabled = YES;
            [button addTarget:self action:@selector(btnPlayVideoClicked:) forControlEvents:UIControlEventTouchUpInside];
            [img addSubview:button];
            [view1 addSubview:img];
            [view1 bringSubviewToFront:button];
            img.userInteractionEnabled=YES;
        }
    }
    if ([[dictBillBoardInfo valueForKey:@"BillboardType"] isEqualToString:@"Event"])
    {
        view1.tag=3;
        lblTitle.text = [dictBillBoardInfo valueForKey:@"Title"];
        NSString *strSt =[dictBillBoardInfo valueForKey:@"Billboard_status"];
        UITextView *wb;
        if (![[NSString stringWithFormat:@"%@",[[dictBillBoardInfo valueForKey:@"Event_image"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] isEqualToString:@"http://emsbapp.com/admin/images/no_image.jpg"]  && ![[NSString stringWithFormat:@"%@",[[dictBillBoardInfo valueForKey:@"Event_thumb"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] isEqualToString:@"http://emsbapp.com/admin/images/no_image.jpg"])
        {
            if (mainScreen.size.height == 480)
            {
                wb = [[UITextView alloc] initWithFrame:CGRectMake(7, lblTitle.frame.size.height+10, view1.frame.size.width-10, 80)];
            }
            else
            {
                wb = [[UITextView alloc] initWithFrame:CGRectMake(7, lblTitle.frame.size.height+20, view1.frame.size.width-10, 100)];
            }

        }
        
        else if (![[NSString stringWithFormat:@"%@",[[dictBillBoardInfo valueForKey:@"Event_image"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] isEqualToString:@"http://emsbapp.com/admin/images/no_image.jpg"]  || ![[NSString stringWithFormat:@"%@",[[dictBillBoardInfo valueForKey:@"Event_thumb"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] isEqualToString:@"http://emsbapp.com/admin/images/no_image.jpg"])
        {
            wb = [[UITextView alloc] initWithFrame:CGRectMake(7, lblTitle.frame.size.height+20, view1.frame.size.width-10, 70)];
        }
        else
        {
            if (mainScreen.size.height == 480)
            {
                wb = [[UITextView alloc] initWithFrame:CGRectMake(7, lblTitle.frame.size.height+20, view1.frame.size.width-10, view1.frame.size.height-270)];
            }
            else
            {
                wb = [[UITextView alloc] initWithFrame:CGRectMake(7, lblTitle.frame.size.height+20, view1.frame.size.width-10, view1.frame.size.height-200)];
            }

        }
        wb.backgroundColor = [UIColor clearColor];
        wb.opaque=NO;
        wb.textColor =[UIColor whiteColor];
        wb.font = [UIFont systemFontOfSize:16.0];
        wb.userInteractionEnabled =YES;
        wb.editable = NO;
        wb.scrollEnabled = YES;
        wb.text= [dictBillBoardInfo valueForKey:@"Description"];

        //[wb loadHTMLString:[NSString stringWithFormat:@"<html><body text=\"#FFFFFF\">%@</body></html>",[dictBillBoardInfo valueForKey:@"Description"]] baseURL:nil];
        if (townCat.length <= 0)
        {
            btnCheck.hidden=NO;
            btnTownCatName.hidden=NO;
            lblSelectTown.hidden=NO;
        }
        else
        {
            lblTownStatus.hidden=NO;
            btnTownInfoRemove.hidden=NO;
        }
        
        
        if ([strSt isEqualToString:@"expire"])
        {
            lblStatus.textColor =[UIColor redColor];
            lblStatus.text =@"Expired";
            lblSetExpire.hidden=NO;
            lblInDays.hidden=NO;
            btnExpTime.hidden=NO;
            
        }
        else
        {
            lblStatus.textColor=[UIColor greenColor];
            lblStatus.text =@"Active";
            lblExpiryStatus.text = [NSString stringWithFormat:@"Billboard will be expired on %@",[dictBillBoardInfo valueForKey:@"expire_on"]];

            lblExpiryStatus.hidden=NO;
        }

        [view1 addSubview:wb];
        BOOL isImage =NO;
        //image
        if (![[NSString stringWithFormat:@"%@",[[dictBillBoardInfo valueForKey:@"Event_image"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] isEqualToString:@"http://emsbapp.com/admin/images/no_image.jpg"])
        {
            UIImageView *img=[[UIImageView alloc] init];
            if (![[NSString stringWithFormat:@"%@",[[dictBillBoardInfo valueForKey:@"Event_thumb"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] isEqualToString:@"http://emsbapp.com/admin/images/no_image.jpg"])
            {
                /*if (mainScreen.size.height == 480)
                {
                    img.frame=CGRectMake(5, lblTitle.frame.size.height+100, view1.frame.size.width/2-10,view1.frame.size.width/2-10);
                }
                else
                {
                    img.frame=CGRectMake(5, lblTitle.frame.size.height+150, view1.frame.size.width/2-10,view1.frame.size.width/2-10);
                }
            }
            else
            {
                if (mainScreen.size.height == 480)
                {
                    img.frame=CGRectMake(5, lblTitle.frame.size.height+100, view1.frame.size.width-10, view1.frame.size.height-370);
                }
                else
                {
                    img.frame=CGRectMake(5, lblTitle.frame.size.height+100, view1.frame.size.width-10, view1.frame.size.height-270);
                }

            }*/
                //Dp1Jan2016
                
                if (mainScreen.size.height == 480)
                {
                    img.frame=CGRectMake(5, lblTitle.frame.size.height+100, view1.frame.size.width/2-10,view1.frame.size.width/2-10);
                }
                else
                {
                    if (IS_IPHONE_6)
                    {
                        img.frame=CGRectMake(view1.frame.origin.x+5, lblTitle.frame.size.height+150, view1.frame.size.width/2+5,view1.frame.size.width/2);
                    }
                    else if (IS_IPHONE_6P)
                    {
                        img.frame=CGRectMake(view1.frame.origin.x+15, lblTitle.frame.size.height+100, view1.frame.size.width/2-10,view1.frame.size.width/2-10);
                    }
                    
                    else{
                        
                        img.frame=CGRectMake(5, lblTitle.frame.size.height+150, view1.frame.size.width/2-10,view1.frame.size.width/2-10);
                    }
                }
                
            }
            else
            {
                if (mainScreen.size.height == 480)
                {
                    img.frame=CGRectMake(5, lblTitle.frame.size.height+50, view1.frame.size.width-10, view1.frame.size.height-300);
                    // img.frame=CGRectMake(5, lblTitle.frame.size.height+100, view1.frame.size.width-10, view1.frame.size.height-270);
                }
                else
                {
                    // CGSize winSize=[UIScreen mainScreen].bounds.size;
                    if (IS_IPHONE_6)
                    {
                        img.frame=CGRectMake(35, lblTitle.frame.size.height+100, view1.frame.size.width -20,view1.frame.size.height-250);
                    }
                    else if (IS_IPHONE_6P)
                    {
                         img.frame=CGRectMake(43, lblTitle.frame.size.height+110, view1.frame.size.width,view1.frame.size.height-200);
                    }
                    else
                    {
                        img.frame=CGRectMake(5, lblTitle.frame.size.height+100, view1.frame.size.width-10,view1.frame.size.height-270);
                    }
                    
                    
                }
            }

            img.backgroundColor=[UIColor blackColor];
            img.tag=999;
            img.contentMode = UIViewContentModeScaleToFill;
            [img setContentMode:UIViewContentModeScaleAspectFit];
            
            NSString *thumbURL=[[dictBillBoardInfo valueForKey:@"Event_image"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *url = [NSURL URLWithString:thumbURL];
            [img  sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            [view1 addSubview:img];
            isImage =YES;
        }
        //video
        if (![[NSString stringWithFormat:@"%@",[[dictBillBoardInfo valueForKey:@"Event_thumb"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] isEqualToString:@"http://emsbapp.com/admin/images/no_image.jpg"])
        {
            UIImageView *img=[[UIImageView alloc] init];
           /* if (isImage)
            {
                if (mainScreen.size.height == 480)
                {
                    img.frame=CGRectMake(view1.frame.size.width/2+5,lblTitle.frame.size.height+100, view1.frame.size.width/2-10,view1.frame.size.width/2-10);
                }
                else
                {
                    img.frame=CGRectMake(view1.frame.size.width/2+5,lblTitle.frame.size.height+150, view1.frame.size.width/2-10,view1.frame.size.width/2-10);
                }
                
            }
            else
            {
                if (mainScreen.size.height == 480)
                {
                    img.frame=CGRectMake(5, lblTitle.frame.size.height+100, view1.frame.size.width-10, view1.frame.size.height-370);
                }
                else
                {
                    img.frame=CGRectMake(5, lblTitle.frame.size.height+100, view1.frame.size.width-10, view1.frame.size.height-270);
                }
            }*/
            
            // Dp1Jan2016
            if (isImage)
            {
                if (mainScreen.size.height == 480)
                {
                    img.frame=CGRectMake(view1.frame.size.width/2+5,lblTitle.frame.size.height+100, view1.frame.size.width/2-10,view1.frame.size.width/2-10);
                }
                else
                    
                    if (IS_IPHONE_6)
                    {
                        img.frame=CGRectMake(view1.frame.size.width/2+30,lblTitle.frame.size.height+150, view1.frame.size.width/2,view1.frame.size.width/2);
                    }
                    else if (IS_IPHONE_6P)
                    {
                        img.frame=CGRectMake(view1.frame.size.width/2+20,lblTitle.frame.size.height+150, view1.frame.size.width/2,view1.frame.size.width/2);
                    }
                    else
                    {
                        
                        img.frame=CGRectMake(view1.frame.size.width/2,lblTitle.frame.size.height+150, view1.frame.size.width/2-5,view1.frame.size.width/2-10);
                        
                        
                    }
                
            }
            else
            {
                if (mainScreen.size.height == 480)
                {
                    img.frame=CGRectMake(5, lblTitle.frame.size.height+100, view1.frame.size.width-10, view1.frame.size.height-370);
                }
                else
                    
                    if (IS_IPHONE_6)
                    {
                        img.frame=CGRectMake(35, lblTitle.frame.size.height+100, view1.frame.size.width -20,view1.frame.size.height-250);
                        //img.frame=CGRectMake(5, lblTitle.frame.size.height+100, view1.frame.size.width-10, view1.frame.size.height-270);
                    }
                    else if (IS_IPHONE_6P)
                    {
                        
                        img.frame=CGRectMake(43, lblTitle.frame.size.height+110, view1.frame.size.width,view1.frame.size.height-200);
                        
                        // img.frame=CGRectMake(5, lblTitle.frame.size.height+100, view1.frame.size.width-10, view1.frame.size.height-270);
                        
                    }
                    else
                        
                        
                        
                    {
                        img.frame=CGRectMake(5, lblTitle.frame.size.height+90, view1.frame.size.width-10, view1.frame.size.height-280);
                    }
            }

            img.backgroundColor=[UIColor blackColor];
            img.tag=999;
            img.contentMode = UIViewContentModeScaleToFill;
            [img setContentMode:UIViewContentModeScaleAspectFit];
            NSString *thumbURL=[[dictBillBoardInfo valueForKey:@"Event_thumb"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *url = [NSURL URLWithString:thumbURL];
            [img  sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            urlVideo = [dictBillBoardInfo valueForKey:@"Event_video"];
            UIButton *button = [[UIButton alloc] init];
            [ button setImage:[UIImage imageNamed:@"btn_video_play.png" ] forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor clearColor]];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.frame = CGRectMake((img.frame.size.width/2)-37, (img.frame.size.height/2)-37,75, 75);
            //button.tag= urlCount;
            //urlCount++;
            button.enabled = YES;
            button.userInteractionEnabled = YES;
            [button addTarget:self action:@selector(btnPlayVideoClicked:) forControlEvents:UIControlEventTouchUpInside];
            [img addSubview:button];
            [view1 addSubview:img];
            [view1 bringSubviewToFront:button];
            img.userInteractionEnabled=YES;
        }
    }
    if ([[dictBillBoardInfo valueForKey:@"BillboardType"] isEqualToString:@"Image"])
    {
        view1.tag=4;
        lblTitle.text = [dictBillBoardInfo valueForKey:@"Title"];
        NSString *strSt =[dictBillBoardInfo valueForKey:@"Billboard_status"];
        if (townCat.length <= 0)
        {
            btnCheck.hidden=NO;
            btnTownCatName.hidden=NO;
            lblSelectTown.hidden=NO;
        }
        else
        {
            lblTownStatus.hidden=NO;
            btnTownInfoRemove.hidden=NO;
        }
        
        if ([strSt isEqualToString:@"expire"])
        {
            lblStatus.textColor =[UIColor redColor];
            lblStatus.text =@"Expired";
            lblSetExpire.hidden=NO;
            lblInDays.hidden=NO;
            btnExpTime.hidden=NO;
        }
        else
        {
            lblStatus.textColor=[UIColor greenColor];
            lblStatus.text =@"Active";
            lblExpiryStatus.text = [NSString stringWithFormat:@"Billboard will be expired on %@",[dictBillBoardInfo valueForKey:@"expire_on"]];

            lblExpiryStatus.hidden=NO;
        }
        
        UIImageView *img=[[UIImageView alloc] init];
        
        
          //Older
        
       /* if (mainScreen.size.height == 480)
        {
            img.frame=CGRectMake(5, lblTitle.frame.size.height+50, view1.frame.size.width-10, view1.frame.size.height-320);
        }
        else
        {
            img.frame=CGRectMake(5, lblTitle.frame.size.height+50, view1.frame.size.width-10, view1.frame.size.height-220);
        }*/
        
        
        //Dp 1Jan2016
        
         if (mainScreen.size.height == 480)
        {
            img.frame=CGRectMake(5, lblTitle.frame.size.height+50, view1.frame.size.width-10, view1.frame.size.height-300);
            // img.frame=CGRectMake(5, lblTitle.frame.size.height+100, view1.frame.size.width-10, view1.frame.size.height-270);
        }
        else
        {
            // CGSize winSize=[UIScreen mainScreen].bounds.size;
            if (IS_IPHONE_6)
            {
                img.frame=CGRectMake(35, lblTitle.frame.size.height+100, view1.frame.size.width -20,view1.frame.size.height-250);
            }
            else if (IS_IPHONE_6P)
            {
                  img.frame=CGRectMake(43, lblTitle.frame.size.height+110, view1.frame.size.width,view1.frame.size.height-200);
            }
            else
            {
                img.frame=CGRectMake(5, lblTitle.frame.size.height+100, view1.frame.size.width-10,view1.frame.size.height-270);
            }
            
            
        }
  

    
        img.backgroundColor=[UIColor blackColor];
        img.tag=999;
        img.contentMode = UIViewContentModeScaleToFill;
        [img setContentMode:UIViewContentModeScaleAspectFit];
        NSString *thumbURL=[[dictBillBoardInfo valueForKey:@"Image_Name"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:thumbURL];
        [img  sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        [view1 addSubview:img];
    }
    
    if ([[dictBillBoardInfo valueForKey:@"BillboardType"] isEqualToString:@"Video"])
    {
        view1.tag=5;
        lblTitle.text = [dictBillBoardInfo valueForKey:@"Title"];
        NSString *strSt =[dictBillBoardInfo valueForKey:@"Billboard_status"];
        if (townCat.length <= 0)
        {
            btnCheck.hidden=NO;
            btnTownCatName.hidden=NO;
            lblSelectTown.hidden=NO;
        }
        else
        {
            lblTownStatus.hidden=NO;
            btnTownInfoRemove.hidden=NO;
        }
        
        if ([strSt isEqualToString:@"expire"])
        {
            lblStatus.textColor =[UIColor redColor];
            lblStatus.text =@"Expired";
            lblSetExpire.hidden=NO;
            lblInDays.hidden=NO;
            btnExpTime.hidden=NO;
        }
        else
        {
            lblStatus.textColor=[UIColor greenColor];
            lblStatus.text =@"Active";
            lblExpiryStatus.text = [NSString stringWithFormat:@"Billboard will be expired on %@",[dictBillBoardInfo valueForKey:@"expire_on"]];

            lblExpiryStatus.hidden=NO;
        }
        
        UIImageView *img=[[UIImageView alloc] init];
        
             //Older
        
      
//        if (mainScreen.size.height == 480)
//        {
//            img.frame=CGRectMake(5, lblTitle.frame.size.height+50, view1.frame.size.width-10, view1.frame.size.height-320);
//        }
//        else
//        {
//            img.frame=CGRectMake(5, lblTitle.frame.size.height+50, view1.frame.size.width-10, view1.frame.size.height-220);
//        }
        
        
        
        
        
        //Dp 1Jan2016
        
        if (mainScreen.size.height == 480)
        {
            img.frame=CGRectMake(5, lblTitle.frame.size.height+50, view1.frame.size.width-10, view1.frame.size.height-300);
            // img.frame=CGRectMake(5, lblTitle.frame.size.height+100, view1.frame.size.width-10, view1.frame.size.height-270);
        }
        else
        {
            // CGSize winSize=[UIScreen mainScreen].bounds.size;
            if (IS_IPHONE_6)
            {
                img.frame=CGRectMake(35, lblTitle.frame.size.height+100, view1.frame.size.width -20,view1.frame.size.height-250);
            }
            else if ( IS_IPHONE_6P)
            {
                 img.frame=CGRectMake(43, lblTitle.frame.size.height+110, view1.frame.size.width,view1.frame.size.height-200);
            }
            else
            {
                img.frame=CGRectMake(5, lblTitle.frame.size.height+100, view1.frame.size.width-10,view1.frame.size.height-270);
            }
            
            
        }

        
        img.backgroundColor=[UIColor blackColor];
        img.tag=999;
        img.contentMode = UIViewContentModeScaleToFill;
        [img setContentMode:UIViewContentModeScaleAspectFit];
        NSString *thumbURL=[[dictBillBoardInfo valueForKey:@"video_thumb"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:thumbURL];
        [img  sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        urlVideo = [dictBillBoardInfo valueForKey:@"Embed_Code"];
        UIButton *button = [[UIButton alloc] init];
        [button setImage:[UIImage imageNamed:@"btn_video_play.png" ] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor clearColor]];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.frame = CGRectMake((img.frame.size.width/2)-37, (img.frame.size.height/2)-37,75, 75);
        //button.tag= urlCount;
        //urlCount++;
        button.enabled = YES;
        button.userInteractionEnabled = YES;
        [button addTarget:self action:@selector(btnPlayVideoClicked:) forControlEvents:UIControlEventTouchUpInside];
        [img addSubview:button];
        [view1 addSubview:img];
        [view1 bringSubviewToFront:button];
        img.userInteractionEnabled=YES;
    }
    if ([[dictBillBoardInfo valueForKey:@"BillboardType"] isEqualToString:@"Social"])
    {
        view1.tag=6;
        lblTitle.text = @"Connect with us";
        NSString *strSt =[dictBillBoardInfo valueForKey:@"Billboard_status"];
        if ([strSt isEqualToString:@"expire"])
        {
            lblStatus.textColor =[UIColor redColor];
            lblStatus.text =@"Expired";
            lblSetExpire.hidden=NO;
            lblInDays.hidden=NO;
            btnExpTime.hidden=NO;
        }
        else
        {
            lblStatus.textColor=[UIColor greenColor];
            lblStatus.text =@"Active";
            lblExpiryStatus.text = [NSString stringWithFormat:@"Billboard will be expired on %@",[dictBillBoardInfo valueForKey:@"expire_on"]];

            lblExpiryStatus.hidden=NO;
        }
        UIWebView *wb;
        if (mainScreen.size.height == 480)
        {
            wb = [[UIWebView alloc] initWithFrame:CGRectMake(5, lblTitle.frame.size.height+15, view1.frame.size.width-10, view1.frame.size.height-210)];
        }
        else
        {
            wb = [[UIWebView alloc] initWithFrame:CGRectMake(5, lblTitle.frame.size.height+20, view1.frame.size.width-10, view1.frame.size.height-150)];
        }
        
        wb.backgroundColor = [UIColor clearColor];
        wb.opaque=NO;
        wb.delegate = self;
        //[wb loadHTMLString:[NSString stringWithFormat:@"<html><body text=\"#FFFFFF\">%@</body></html>",[[dictBillBoardInfo valueForKey:@"social"] valueForKey:@"url"]] baseURL:nil];
        //[arrBtnTitle addObject:@""];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[dictBillBoardInfo valueForKey:@"social"]]];
        [wb loadRequest:[NSURLRequest requestWithURL:url]];
        [view1 addSubview:wb];
    }
}

#pragma mark- Playing Video

-(IBAction)btnPlayVideoClicked:(id)sender
{
    NSURL *url=[[NSURL alloc] initWithString:urlVideo];
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
