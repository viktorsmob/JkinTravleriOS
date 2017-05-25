//
//  SubCategoriesVC.m
//  Jwalkin
//
//  Created by Kanika on 08/11/13.
//  Copyright (c) 2013 fox. All rights reserved.
//

#import "SubCategoriesVC.h"
#import "SubCatCell.h"
#import "SubCatNameCell.h"
#import "JSON.h"
#import "UrlFile.h"
#import "UIImageView+WebCache.h"
#import "DirectionMapVC.h"
#import "ShowLocationsVC.h"
#import "CouponVC.h"
#import "WrapperClass.h"
#import "MyFavVC.h"
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




@interface SubCategoriesVC ()
{
   NSString *uid;
}
@end

@implementation SubCategoriesVC
@synthesize lblDListSubCatName,lblCouponMName,lblCouponMAddress,mainDict,catId,lblPercentage;
@synthesize lblTotalWalkin;

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
    isTableShowing = 0;
    wrpr = [[WrapperClass alloc] initwithDev];
    arrAllMerchantCopy = [[NSMutableArray alloc] init];
    app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    if (!IS_IPHONE_5)
//    {
//        topView.frame = CGRectMake(0, 0, 320, 44);
//    }
    
    NSString *str =[[NSUserDefaults standardUserDefaults] valueForKey:@"fbname"];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"loggedin"] || str.length != 0)
    {
        uid = [[NSUserDefaults standardUserDefaults] valueForKey:@"user-Id"];
    }
    else
    {
        uid =@"0";
    }

    app.isFromFav = 0;
    arrSubCatNames = [[NSMutableArray alloc] init];
    arrSubCatIDs = [[NSMutableArray alloc] init];
    arrMerchantDetail = [[NSMutableArray alloc] init];
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Please check your internet connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        btnFav.userInteractionEnabled=YES;
        btnHome.userInteractionEnabled=YES;
        btnMap.userInteractionEnabled=YES;
        btnSearch.userInteractionEnabled=YES;
    }
    else
    {
        self.catId = [mainDict objectForKey:@"categoryid"];
        arrSubcatagories = [mainDict objectForKey:@"subcategory_info"];
        netUtills = [[NetworkUtills alloc] initWithSelector:@selector(ParseResponse:) WithCallBackObject:self];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:self.catId forKey:@"categoryid"];
        [dict setValue:[[arrSubcatagories objectAtIndex:0] valueForKey:@"subcategoryid"] forKey:@"subcategoryid"];
        //[dict setValue:[NSString stringWithFormat:@"%f",app.clLocation.coordinate.latitude] forKey:@"latitude"];
        //[dict setValue:[NSString stringWithFormat:@"%f",app.clLocation.coordinate.longitude] forKey:@"longitude"];
        [dict setValue:[NSString stringWithFormat:@"%f",26.2389469] forKey:@"latitude"];
        [dict setValue:[NSString stringWithFormat:@"%f",73.0243094] forKey:@"longitude"];
        [self GetAllVals];
        if ([lblDListSubCatName.text isEqual:[NSString stringWithFormat:@"%@", [mainDict objectForKey:@"category_name"]]])
        {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue:self.catId forKey:@"categoryid"];
            isTableShowing = 0;
            NSString *radius =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"radius"]];
          
            [dict setValue:radius forKey:@"radius"];
            //[dict setValue:[NSString stringWithFormat:@"%f",app.clLocation.coordinate.latitude] forKey:@"latitude"];
            //[dict setValue:[NSString stringWithFormat:@"%f",app.clLocation.coordinate.longitude] forKey:@"longitude"];
            [dict setValue:[NSString stringWithFormat:@"%f",26.2389469] forKey:@"latitude"];
            [dict setValue:[NSString stringWithFormat:@"%f",73.0243094] forKey:@"longitude"];

            [dict setObject:uid forKey:@"userid"];
            netUtills.tag = 1;
            [netUtills GetResponseByASIFormDataRequest:[NSString stringWithFormat:@"%@%@",mainUrl,subcatagories] WithDictionary:dict];
        }
        else
        {
            btnFav.userInteractionEnabled=YES;
            btnHome.userInteractionEnabled=YES;
            btnMap.userInteractionEnabled=YES;
            btnSearch.userInteractionEnabled=YES;
        }
    }
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [picker selectRow:4 inComponent:0 animated:YES];
    [picker reloadComponent:0];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    if (IS_IPHONE_4_AND_OLDER_IOS8 || IS_IPHONE_4_AND_OLDER_IOS7)
    {
        [btnFav bringSubviewToFront:self.view];
        [btnHome bringSubviewToFront:self.view];
        [btnMap bringSubviewToFront:self.view];
        [btnSearch bringSubviewToFront:self.view];
    }

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- API Response

-(void)ParseResponse:(id)sender
{
    NetworkUtills *utills=(NetworkUtills *)sender;
    [self ParseResult:utills.strResponse];
}

-(void)ParseResult:(NSString *)strResponse
{
    if (netUtills.tag == 1)
    {
        //dp
        if (![strResponse isEqualToString:@"Requested Data not found"])
        {
            arrMerchantDetail = [strResponse JSONValue];
            arrAllMerchantCopy = arrMerchantDetail;

        }
        if ([arrMerchantDetail count] > 0)
        {
            tblMrchnt.hidden = NO;
            [tblMrchnt reloadData];
            btnFav.userInteractionEnabled=YES;
            btnHome.userInteractionEnabled=YES;
            btnMap.userInteractionEnabled=YES;
            btnSearch.userInteractionEnabled=YES;
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Jaywalk.In" message:@"No Data Found" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            alert.tag = 888;
            tblMrchnt.hidden = YES;
            btnFav.userInteractionEnabled=YES;
            btnHome.userInteractionEnabled=YES;
            btnMap.userInteractionEnabled=YES;
            btnSearch.userInteractionEnabled=YES;
        }
    }
    else if (netUtills.tag == 2)
    {
        arrMerchantDetail = [strResponse JSONValue];
        if ([arrMerchantDetail count] > 0)
        {
            tblMrchnt.hidden = NO;
            [tblMrchnt reloadData];
        }
        else
        {
            tblMrchnt.hidden = YES;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Jaywalk.In" message:@"No Match Found" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            alert.tag = 91;
            [alert show];
            if ([arrAllMerchantCopy count] > 0)
            {
                arrMerchantDetail = arrAllMerchantCopy;
                tblMrchnt.hidden = NO;
                [tblMrchnt reloadData];
            }
        }
    }
}

-(void)GetAllVals
{
    for (int i = 0; i < [arrSubcatagories count]; i++)
    {
        NSMutableDictionary *dict = [arrSubcatagories objectAtIndex:i];
        [arrSubCatNames addObject:[dict objectForKey:@"subcategory"]];
        [arrSubCatIDs addObject:[dict objectForKey:@"subcategoryid"]];
        lblDListSubCatName.text = [NSString stringWithFormat:@"%@", [mainDict objectForKey:@"category_name"]]; //cp
        [picker reloadAllComponents];
        [tblDrList reloadData];
    }
    [arrSubCatNames addObject:[NSString stringWithFormat:@"%@", [mainDict objectForKey:@"category_name"]]];//cp
}

#pragma mark- TableView Delegates

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1)
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
                cell.lblMerchant1.text = [dic_K valueForKey:@"merchant_name"];
                NSURL *url = [NSURL URLWithString:thumbURL];
                [cell.imgMerchant1 sd_setImageWithURL:url];
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
                cell.lblMerchant2.text = [dic_K valueForKey:@"merchant_name"];
                NSURL *url = [NSURL URLWithString:thumbURL];
                [cell.imgMerchant2 sd_setImageWithURL:url];
                [cell.btnM2 addTarget:self action:@selector(SlectedMerchentDetail:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        return cell;
    }
    if (tableView.tag == 2)
    {
        static NSString *CellIdentifier;
        CellIdentifier = @"SubCatNameCell";
        SubCatNameCell *cell = (SubCatNameCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            {
                NSArray *toplevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SubCatNameCell" owner:nil options:nil];
                for(id currentObject in toplevelObjects)
                {
                    if([currentObject isKindOfClass:[UITableViewCell class]])
                    {
                        cell = (SubCatNameCell *)currentObject;
                        break;
                    }
                }
            }
        }
        cell.lblSubCatName.text = [arrSubCatNames objectAtIndex:indexPath.row];
        return cell;
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 1)
    {
        return ([arrMerchantDetail count]+1)/2;
    }
    if (tableView.tag == 2)
    {
        return [arrSubCatNames count];
    }
    return 0;
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
    if (tableView.tag == 2)
    {
        lblDListSubCatName.text = [arrSubCatNames objectAtIndex:indexPath.row];
        NSUserDefaults *de = [NSUserDefaults standardUserDefaults];
        [de setObject:[arrSubcatagories objectAtIndex:indexPath.row] forKey:@"Subcatid"];
        [de synchronize];
        isTableShowing = 0;
         NSString *radius =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"radius"]];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
        [dict setValue:self.catId forKey:@"categoryid"];
        [dict setValue:[arrSubCatIDs objectAtIndex:indexPath.row] forKey:@"subcategoryid"];
        //[dict setValue:[NSString stringWithFormat:@"%f",app.clLocation.coordinate.latitude] forKey:@"latitude"];
        //[dict setValue:[NSString stringWithFormat:@"%f",app.clLocation.coordinate.longitude] forKey:@"longitude"];
        [dict setValue:[NSString stringWithFormat:@"%f",26.2389469] forKey:@"latitude"];
        [dict setValue:[NSString stringWithFormat:@"%f",73.0243094] forKey:@"longitude"];
        
        [dict setObject:uid forKey:@"userid"];
        [dict setValue:radius forKey:@"radius"];
        netUtills.tag = 1;
        [netUtills GetResponseByASIFormDataRequest:[NSString stringWithFormat:@"%@%@",mainUrl,subcatagories] WithDictionary:dict];
    }
}

-(IBAction)SlectedMerchentDetail:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    merchantTag = btn.tag;
    NSMutableDictionary *dic_K = [arrMerchantDetail objectAtIndex:btn.tag];
    NSUserDefaults *d1 = [NSUserDefaults standardUserDefaults];
    [d1 setObject:[dic_K valueForKey:@"merchant_id"] forKey:@"merchant_id"];
    [d1 synchronize];
    lblCouponMName.text = [dic_K valueForKey:@"merchant_name"];
    lblCouponMAddress.text = [NSString stringWithFormat:@"%@\n%@\n%@",[dic_K valueForKey:@"merchant_address"],[dic_K valueForKey:@"Phoneno"],[dic_K valueForKey:@"business_hours"]];
    lblPercentage.text = [dic_K valueForKey:@"Percentage"];
    lblTotalWalkin.text = [NSString stringWithFormat:@"(%@)",[dic_K valueForKey:@"walkins"]];
    [self ShowCoupons];
}

#pragma mark- Button Action

-(IBAction)HomeClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)DropDownClicked:(id)sender
{
    if (isTableShowing == 0)
    {
        isTableShowing = 1;
        tblDrList.hidden = NO;
        [UIView beginAnimations:NULL context:nil];
        CGRect fullRect;
        fullRect = CGRectMake(tblDrList.frame.origin.x, tblDrList.frame.origin.y, 176, 284);
        tblDrList.frame = fullRect;
                [UIView commitAnimations];
        [tblDrList reloadData];
    }
    else
    {
        isTableShowing = 0;
        tblDrList.hidden = YES;
    }
}

-(IBAction)MakeACall:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Jaywalk.In" message:@"Call local business?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    alert.tag = 1;
    [alert show];
}


-(IBAction)AddToFav:(id)sender
{
    NSMutableDictionary *dic_K = [arrMerchantDetail objectAtIndex:merchantTag];
    NSString * mid = [dic_K valueForKey:@"merchant_id"];
    NSMutableArray *arrIDs = [wrpr GetIds];

    if (![arrIDs containsObject:mid])
    {
        int K = [wrpr InsertToFavorite:mid];
        if (K > 0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Jaywalk.In" message:@"Added to favorites." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            alert.tag = 3333;
            [alert show];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Jaywalk.In" message:@"Unable to add to favorites." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            alert.tag = 4444;
            [alert show];
        }
    }
    else
    {
        BOOL k=[wrpr RemoveFromfav:mid];
        if(k==YES)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Jaywalk.In" message:@"Removed from favorites." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            alert.tag = 5555;
            [alert show];
        }
    }
}

-(IBAction)ShowMeDirections:(id)sender
{
    NSMutableDictionary *dic_K = [arrMerchantDetail objectAtIndex:merchantTag];
    DirectionMapVC *direction = [[DirectionMapVC alloc] initWithNibName:@"DirectionMapVC" bundle:nil];
    direction.strTitle = [dic_K valueForKey:@"merchant_name"];
    direction.address = [dic_K valueForKey:@"merchant_address"];
    [self.navigationController pushViewController:direction animated:YES];
}

-(IBAction)ShowCoupons
{
    NSMutableDictionary *dic_K = [arrMerchantDetail objectAtIndex:merchantTag];
    CouponVC *c = [[CouponVC alloc] initWithNibName:@"CouponVC" bundle:nil];
    c.arrTempMerchantDetail = arrMerchantDetail;
    c.tempMerchantTag = merchantTag;
    c.strMName = [dic_K valueForKey:@"merchant_name"];
    c.strMId = [dic_K valueForKey:@"merchant_id"];
    [self.navigationController pushViewController:c animated:YES];
}

-(IBAction)ShowAllLocations:(id)sender
{
    ShowLocationsVC *direction = [[ShowLocationsVC alloc] initWithNibName:@"ShowLocationsVC" bundle:nil];
    direction.strTitle = [mainDict valueForKey:@"category_name"];
    direction.arrMapPoints = arrMerchantDetail;
    [self.navigationController pushViewController:direction animated:YES];
}

-(IBAction)SearchClicked:(id)sender
{
    searchView.frame  = CGRectMake(0,0, self.view.frame.size.width, 44);
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];
    //Dp 28Dec
    searchView.frame = CGRectMake(0, (self.view.frame.size.height/8)+20,  self.view.frame.size.width, 44);
    [UIView commitAnimations];
    [self.view addSubview:searchView];
}

-(IBAction)ShowFav:(id)sender
{
    MyFavVC *my = [[MyFavVC alloc] initWithNibName:@"MyFavVC" bundle:nil];
    [self.navigationController pushViewController:my animated:YES];
}

-(void)RemoveSubView
{
    [subView removeFromSuperview];
}

#pragma mark- AlertView Delegates

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1)
    {
        if (buttonIndex == 0)
        {
            NSMutableDictionary *dic_K = [arrMerchantDetail objectAtIndex:merchantTag];
            NSString * phoneNumber = [NSString stringWithFormat:@"tel://%@",[dic_K valueForKey:@"Phoneno"]];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
        }
    }
}

#pragma mark - Searchbar Delegates

- (void) searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar
{
}

- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText
{
	searchBar.showsCancelButton = YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)theSearchBar
{
	searchBar.showsCancelButton = NO;
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)theSearchBar
{
	// if a valid search was entered but the user wanted to cancel, bring back the main list filteredcontent
    [searchView removeFromSuperview];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)theSearchBar
{
    [self searchData:theSearchBar.text];
	[searchBar resignFirstResponder];
}

-(void)searchData:(NSString *)searchText
{
    netUtills = [[NetworkUtills alloc] initWithSelector:@selector(ParseResponse:) WithCallBackObject:self];
    netUtills.tag = 2;
    [netUtills GetResponseByASIHttpRequest:[NSString stringWithFormat:@"%@%@?merchant=%@",mainUrl,findMerchants,searchText]];
}

-(IBAction)SearchCloseClicked:(id)sender
{
    [searchBar resignFirstResponder];
    [searchView removeFromSuperview];
}

#pragma mark - picker view delegates- Select the subcategories

-(IBAction)PickerClicked:(id)sender
{
    if ([UIScreen mainScreen].bounds.size.height > 500)
    {
        
        //dp 28 Dec
//        picView.frame  = CGRectMake(0, 568, 320, 568);
//        [UIView beginAnimations:nil context:NULL];
//        [UIView setAnimationDuration:0.5];
//        picView.frame  = CGRectMake(0, 0, 320, 568);
//        picView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);

       // [UIView commitAnimations];
        picView.frame = CGRectMake(self.view.frame.origin.x, 580, self.view.frame.size.width, self.view.frame.size.height+15);
        [self.view addSubview:picView];

        [UIView animateWithDuration:0.5 animations:^{
            picView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height+15);
        }];
        
    }
    else
    {
//        picView.frame  = CGRectMake(0, 460, 320, 460);
//        [UIView beginAnimations:nil context:NULL];
//        [UIView setAnimationDuration:0.5];
//        picView.frame  = CGRectMake(0, 0, 320, 480);
//        [UIView commitAnimations];
        
        picView.frame = CGRectMake(self.view.frame.origin.x, 580, self.view.frame.size.width, self.view.frame.size.height);
        [self.view addSubview:picView];

        [UIView animateWithDuration:0.5 animations:^{
        picView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
        }];
         }
    
    [picker reloadAllComponents];
}


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    return [arrSubCatNames count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
    return [arrSubCatNames objectAtIndex:row];
}

-(IBAction)pickerDoneClicked:(id)sender
{
    lblDListSubCatName.text = [arrSubCatNames objectAtIndex:[picker selectedRowInComponent:0]];
     NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:self.catId forKey:@"categoryid"];
    isTableShowing = 0;
    if (![[arrSubCatNames objectAtIndex:[picker selectedRowInComponent:0]] isEqualToString:[NSString stringWithFormat:@"%@", [mainDict objectForKey:@"category_name"]]])
    {
        NSUserDefaults *de = [NSUserDefaults standardUserDefaults];
        [de setObject:[arrSubcatagories objectAtIndex:[picker selectedRowInComponent:0]] forKey:@"Subcatid"];
        [de synchronize];
        [dict setValue:[arrSubCatIDs objectAtIndex:[picker selectedRowInComponent:0]] forKey:@"subcategoryid"];
    }
    NSString *radius =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"radius"]];
    [dict setValue:radius forKey:@"radius"];
    //[dict setValue:[NSString stringWithFormat:@"%f",app.clLocation.coordinate.latitude] forKey:@"latitude"];
    //[dict setValue:[NSString stringWithFormat:@"%f",app.clLocation.coordinate.longitude] forKey:@"longitude"];
    [dict setValue:[NSString stringWithFormat:@"%f",26.2389469] forKey:@"latitude"];
    [dict setValue:[NSString stringWithFormat:@"%f",73.0243094] forKey:@"longitude"];

    [dict setObject:uid forKey:@"userid"];


    netUtills.tag = 1;
    [netUtills GetResponseByASIFormDataRequest:[NSString stringWithFormat:@"%@%@",mainUrl,subcatagories] WithDictionary:dict];
    
//    picView.frame  = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//    
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:0.5];
//    
//    picView.frame  = CGRectMake(0, 568, 320, 568);
//   
//    [UIView commitAnimations];
    [UIView animateWithDuration:0.5 animations:^{
        picView.frame = CGRectMake(self.view.frame.origin.x, 580, self.view.frame.size.width, self.view.frame.size.height+15);
    }];

}

-(IBAction)pickerCancelClicked:(id)sender
{
    [UIView animateWithDuration:0.5 animations:^{
        picView.frame = CGRectMake(self.view.frame.origin.x, 580, self.view.frame.size.width, self.view.frame.size.height+15);
    }];

}

@end
