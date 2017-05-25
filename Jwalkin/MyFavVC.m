//
//  MyFavVC.m
//  Jwalkin
//
//  Created by Kanika on 22/11/13.
//  Copyright (c) 2013 fox. All rights reserved.
//

#import "MyFavVC.h"

#import "UrlFile.h"
#import "JSON.h"
#import "SubCatCell.h"
#import "UIImageView+WebCache.h"
#import "DirectionMapVC.h"
#import "CouponVC.h"
#import "ShowLocationsVC.h"
#import "HomeVC.h"
#import "AppDelegate.h"
#import "Reachability.h"

@interface MyFavVC ()

@end

@implementation MyFavVC
@synthesize lblCouponMName,lblCouponMAddress,lblPercentage,lblTotalWalkin;

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
    swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(SwipeToLeft:)];
    //There is a direction property on UISwipeGestureRecognizer. You can set that to both right and left swipes
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipe];
    [self getfavoritelist];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- Swipe Method

-(IBAction)SwipeToLeft:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- API Response

-(void)ParseResponse:(id)sender
{
    NetworkUtills *utills=(NetworkUtills *)sender;
    [self ParseResult:utills.strResponse];
}

-(void)ParseResult:(NSString *)strResponse
{
    NSMutableDictionary *d = [strResponse JSONValue];
    arrMerchantDetail = [d valueForKey:@"favorites"];
    if ([arrMerchantDetail count] > 0)
    {
        [tblFav reloadData];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Jaywalk.In" message:@"No Data Found" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag = 2222;
        [alert show];
    }
}

#pragma mark- TableView Delegates

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    CellIdentifier = @"SubCatCell";
    SubCatCell *cell = (SubCatCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            NSArray *toplevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SubCatCell" owner:nil options:nil];
            for(id currentObject in toplevelObjects)
            {
                if([currentObject isKindOfClass:[UITableViewCell class]])
                {
                    cell = (SubCatCell *)currentObject;
                    break;
                }
            }
        }
    }
    NSInteger IndexRow = indexPath.row+1;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    endindex = IndexRow *2;
    startindex = endindex-2;
    currentCounter=0;
    if(endindex > [arrMerchantDetail count])
    {
        endindex=[arrMerchantDetail count];
    }
    for(NSInteger Counter=startindex;Counter<endindex;Counter++)
    {
        NSMutableDictionary *dic_K = [arrMerchantDetail objectAtIndex:Counter];
        currentCounter++;
        if (currentCounter < 2 )
        {
            cell.lblMerchant2.hidden = YES;
            cell.imgMerchant2.hidden = YES;
            cell.imgBorder2.hidden = YES;
        }
        else
        {
            cell.lblMerchant1.hidden = NO;
            cell.imgMerchant1.hidden = NO;
            cell.lblMerchant2.hidden = NO;
            cell.imgMerchant2.hidden = NO;
            cell.imgBorder1.hidden = NO;
            cell.imgBorder2.hidden = NO;
        }
        if(currentCounter == 1)
        {
            cell.btnM1.tag = Counter;
            NSString *thumbURL = [[dic_K valueForKey:@"logo"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *url = [NSURL URLWithString:thumbURL];
            [cell.imgMerchant1 sd_setImageWithURL:url];
            cell.lblMerchant1.text = [dic_K valueForKey:@"merchant_name"];
            cell.imgBorder1.hidden = NO;
            [cell.btnM1 addTarget:self action:@selector(SlectedMerchentDetail:) forControlEvents:UIControlEventTouchUpInside];
            NSUserDefaults *de = [NSUserDefaults standardUserDefaults];
            [de setObject:[NSString stringWithFormat:@"%@",[dic_K valueForKey:@"merchant_id"]] forKey:@"MerchentId"];
            [de synchronize];
        }
        if(currentCounter == 2)
        {
            cell.btnM2.tag = Counter;
            NSString *thumbURL=[[dic_K valueForKey:@"logo"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            cell.imgBorder1.hidden = NO;
            cell.imgBorder2.hidden = NO;
            NSURL *url = [NSURL URLWithString:thumbURL];
            [cell.imgMerchant2 sd_setImageWithURL:url];
            cell.lblMerchant2.text = [dic_K valueForKey:@"merchant_name"];
            [cell.btnM2 addTarget:self action:@selector(SlectedMerchentDetail:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return cell;
    return nil;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ([arrMerchantDetail count]+1)/2;;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1)
    {
        return 115;
    }
    if (tableView.tag == 2)
    {
        return 44;
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

-(IBAction)SlectedMerchentDetail:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    merchantTag = btn.tag;
    NSMutableDictionary *dic_K = [arrMerchantDetail objectAtIndex:btn.tag];
    lblCouponMName.text = [dic_K valueForKey:@"merchant_name"];
    lblCouponMAddress.text = [NSString stringWithFormat:@"%@ %@",[dic_K valueForKey:@"merchant_address"],[dic_K valueForKey:@"Phoneno"]];
    lblPercentage.text = [dic_K valueForKey:@"Percentage"];
    lblTotalWalkin.text = [NSString stringWithFormat:@"%@",[dic_K valueForKey:@"walkins"]];
    midForUnFavurite=[dic_K valueForKey:@"merchant_id"];
    
    //Dp
    subView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    
    
    [self.view addSubview:subView];
    tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(RemoveSubView)];
    tap.numberOfTapsRequired = 1;
    [subView addGestureRecognizer:tap];
}


#pragma mark- Button Action

-(IBAction)HomeClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)MakeACall:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Jaywalk.In" message:@"Call local business?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    alert.tag = 105;
    [alert show];
}

-(IBAction)ShowMeDirections:(id)sender
{
    NSMutableDictionary *dic_K = [arrMerchantDetail objectAtIndex:merchantTag];
    DirectionMapVC *direction = [[DirectionMapVC alloc] initWithNibName:@"DirectionMapVC" bundle:nil];
    direction.address = [dic_K valueForKey:@"merchant_address"];
    direction.strTitle = [dic_K valueForKey:@"merchant_name"];
    [self.navigationController pushViewController:direction animated:YES];
}

-(IBAction)ShowCoupons:(id)sender
{
    NSMutableDictionary *dic_K = [arrMerchantDetail objectAtIndex:merchantTag];
    CouponVC *c = [[CouponVC alloc] initWithNibName:@"CouponVC" bundle:nil];
    c.strMName = [dic_K valueForKey:@"merchant_name"];
    c.strMId = [dic_K valueForKey:@"merchant_id"];
    [self.navigationController pushViewController:c animated:YES];
}

-(IBAction)ShowAllLocations:(id)sender
{
    ShowLocationsVC *direction = [[ShowLocationsVC alloc] initWithNibName:@"ShowLocationsVC" bundle:nil];
    direction.arrMapPoints = arrMerchantDetail;
    [self.navigationController pushViewController:direction animated:YES];
}

- (IBAction)unFavorite:(id)sender
{
    if (midForUnFavurite.length!=0)
    {
        BOOL k=[wrpr RemoveFromfav:midForUnFavurite];
        if(k==YES)
        {
            [self getfavoritelist];
            [subView removeFromSuperview];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Jaywalk.In" message:@"Removed from favorites." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            alert.tag = 5555;
            [alert show];
        }
    }
}


#pragma mark- AlertView Delegates

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 105)
    {
        if (buttonIndex == 0)
        {
            NSMutableDictionary *dic_K = [arrMerchantDetail objectAtIndex:merchantTag];
            NSString * phoneNumber = [NSString stringWithFormat:@"tel://%@",[dic_K valueForKey:@"Phoneno"]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
        }
    }
    if (alertView.tag == 2222)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark- other Method

-(void)RemoveSubView
{
    [subView removeFromSuperview];
}

#pragma mark- API Call

-(void)getfavoritelist
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Please check your internet connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        wrpr = [[WrapperClass alloc] initwithDev];
        arrMerchantDetail = [[NSMutableArray alloc] init];
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        app.isFromFav = 1;
        NSMutableArray *arrIDs = [wrpr GetIds];
        NSString *allids = [arrIDs componentsJoinedByString:@","];
        netUtills = [[NetworkUtills alloc] initWithSelector:@selector(ParseResponse:) WithCallBackObject:self];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:allids forKey:@"merchants"];
        [netUtills GetResponseByASIFormDataRequest:[NSString stringWithFormat:@"%@%@",mainUrl,favMerchants] WithDictionary:dic];
    }
}

@end
