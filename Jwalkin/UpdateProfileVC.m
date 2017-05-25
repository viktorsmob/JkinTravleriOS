//
//  UpdateProfileVC.m
//  Jwalkin
//
//  Created by Kanika on 30/06/15.
//  Copyright (c) 2015 fox. All rights reserved.
//

#import "UpdateProfileVC.h"
#import "AFHTTPClient.h"
#import "AFImageRequestOperation.h"
#import "UrlFile.h"
#import "HomeVC.h"
#import "Reachability.h"
#import "MBProgressHUD.h"


@interface UpdateProfileVC ()
{
    NSMutableDictionary *dictSubCatId;
    NSMutableDictionary *dictUserInfo;
}

@end

@implementation UpdateProfileVC

@synthesize imgviewDP,imgviewLogo;

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
    strExpDate = @" ";
    strCardExpDate = @" ";
    mapView.showsUserLocation = YES;
   temoImageData = UIImagePNGRepresentation([UIImage imageNamed:@"img_add_photos.png"]);
    dictUserInfo = [[NSMutableDictionary alloc]init];
    btnUpdate.layer.cornerRadius = 5.0;
    
    app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    scrollReg.contentSize  = CGSizeMake(self.view.frame.size.width,btnUpdate.frame.origin.y+btnUpdate.frame.size.height+25);
   // scrollReg.contentSize  = CGSizeMake(self.view.frame.size.width,btnUpdate.frame.origin.y+btnUpdate.frame.origin.y+btnUpdate.frame.size.height);
    
    whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    
    UITapGestureRecognizer *gestureLogo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
    gestureLogo.numberOfTapsRequired = 1;
    gestureLogo.delegate = self;
    [imgviewLogo addGestureRecognizer:gestureLogo];
    
    UITapGestureRecognizer *gestureImageDP = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
    gestureImageDP.numberOfTapsRequired = 1;
    gestureImageDP.delegate = self;
    [imgviewDP addGestureRecognizer:gestureImageDP];
    
    UITapGestureRecognizer *gestureMap = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(mapGestureHandler:)];
    gestureMap.delegate = self;
    gestureMap.numberOfTapsRequired = 1;
    [mapView addGestureRecognizer:gestureMap];
    
//    [self performSelectorInBackground:@selector(getState) withObject:nil];
//    [self performSelectorInBackground:@selector(getCategary) withObject:nil];
    
    
    UITapGestureRecognizer *gestureView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    gestureView.numberOfTapsRequired = 1;
    
    [gestureView setNumberOfTouchesRequired:1];
    gestureView.delegate = self;
    
//    [scrollReg addGestureRecognizer:gestureView];
    //pading in textfield //cp
    [self setEdgesInsectForTextField:tfName];
    [self setEdgesInsectForTextField:tfEmail];
    [self setEdgesInsectForTextField:tfPassword];
    [self setEdgesInsectForTextField:tfPhNO];
    [self setEdgesInsectForTextField:tfAdd1];
    [self setEdgesInsectForTextField:tfAdd2];
    [self setEdgesInsectForTextField:tfCity];
    [self setEdgesInsectForTextField:tfZipcode];
    [self setEdgesInsectForTextField:tfPromoCode];
    [self setEdgesInsectForTextField:tfBusinesshour];
    [self setEdgesInsectForTextField:tfCreditCardNo];
    [self setEdgesInsectForTextField:tfCreditcardType];
    [self setEdgesInsectForTextField:tfCVVNo];
    [self setEdgesInsectForTextField:tfAverageRating];
    [self setEdgesInsectForTextField:tfData];
    [self setEdgesInsectForTextField:tfAmount];
    [self loadData];
    imgviewDP.layer.borderWidth=1.0;
    imgviewDP.layer.borderColor =[[UIColor lightGrayColor] CGColor];
    imgviewLogo.layer.borderWidth=1.0;
    imgviewLogo.layer.borderColor =[[UIColor lightGrayColor] CGColor];
}

-(void)loadData
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dictUserInfo = [[NSUserDefaults standardUserDefaults]valueForKey:@"userInfo"];
    tfName.text = [dictUserInfo valueForKey:@"name"];
    tfEmail.text = [dictUserInfo valueForKey:@"email"];
    tfPassword.text = [dictUserInfo valueForKey:@"password"];
    tfPhNO.text = [dictUserInfo valueForKey:@"phoneno"];
    tfAdd1.text = [dictUserInfo valueForKey:@"address1"];
    tfAdd2.text = [dictUserInfo valueForKey:@"address2"];
    tfCity.text = [dictUserInfo valueForKey:@"city"];
    tfZipcode.text = [dictUserInfo valueForKey:@"zipcode"];
    tfPromoCode.text = [dictUserInfo valueForKey:@"promo"];
//    tfBusinesshour.text = [dictUserInfo valueForKey:@"business_hours"];
//    tfCreditCardNo.text = [dictUserInfo valueForKey:@"creditcardnumber"];
//    tfCreditcardType.text = [dictUserInfo valueForKey:@"creditcardtype"];
//    tfCVVNo.text = [dictUserInfo valueForKey:@"cvvnumber"];
    tfAverageRating.text = [dictUserInfo valueForKey:@"average_rating"];
    tfData.text = [dictUserInfo valueForKey:@"website"];
    tfAmount.text =  [dictUserInfo valueForKey:@"fb_link"];
    lblCardExp.text =[dictUserInfo valueForKey:@"crexpdate"];
    lblExpDate.text=[dictUserInfo valueForKey:@"expdate"];
    lblLatShow.hidden=NO;
    lblLongShow.hidden=NO;
    lblLatShow.text=[dictUserInfo valueForKey:@"latitute"];
    lblLongShow.text=[dictUserInfo valueForKey:@"longitute"];
    lblLatitute.text=[dictUserInfo valueForKey:@"latitute"];
    lblLongitute.text=[dictUserInfo valueForKey:@"longitute"];
    NSString *logoUrl =[dictUserInfo valueForKey:@"logo"];
    NSString *dpUrl =[dictUserInfo valueForKey:@"image"];
    imgviewLogo.imageURL = [NSURL URLWithString:logoUrl];
    imgviewDP.imageURL = [NSURL URLWithString:dpUrl];
    [self performSelectorInBackground:@selector(apiLoad) withObject:nil];
}

-(void)apiLoad
{
    [self getState];
    [self getCategary];
    int state = [[dictUserInfo valueForKey:@"state"] intValue];
    int cat =[[dictUserInfo valueForKey:@"category"] intValue];
    if (cat == 10)
    {
        cat=8;
    }
    int subCat = [[dictUserInfo valueForKey:@"subcategory"]intValue];
    if (arrState.count != 0)
    {
        [btnState setTitle:[arrState objectAtIndex:state-1] forState:UIControlStateNormal];
        app.selectedStateName =btnState.titleLabel.text;
        app.selectedState =state-1;
    }
    if (arrCategary.count != 0)
    {
        [btnCat setTitle:[arrCategary objectAtIndex:cat-1] forState:UIControlStateNormal];
        app.selectedCatName=btnCat.titleLabel.text;
//        if (cat == 8)
//        {
//            cat = 10;
//        }
        app.selectedCat=cat-1;
        NSLog(@"sohan 1  -- %d ",cat-1);
        for (int i =0; i<arrSubCatId.count; i++)
        {
            int subId = [[arrSubCatId objectAtIndex:i] intValue];
            if (subId == subCat)
            {
                [btnSubcat setTitle:[arrSubCat objectAtIndex:i] forState:UIControlStateNormal];
                if (btnSubcat.titleLabel.text.length != 0)
                {
                    app.selectedSubcatName=btnSubcat.titleLabel.text;
                    app.selectedSubCat=subCat;
                }
                break;
            }
        }
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

#pragma Gesture delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:dropDown]||[touch.view isDescendantOfView:dropDown1]||[touch.view isDescendantOfView:dropDown2]||[touch.view isDescendantOfView:dropDown3])
    {
        return NO;
    }
    [self hideKeyboard];

    return YES;
}

#pragma mark- Button Action

-(IBAction)btnExpdateClick:(id)sender
{
    [self hideKeyboard];
    btnTemp = (UIButton *)sender;
    viewDatePicker.frame = self.view.frame;
    viewDatePicker.alpha = 0;
    [self.view addSubview:viewDatePicker];
    [UIView animateWithDuration:0.2 delay:0.2 options:UIViewAnimationOptionCurveEaseIn  animations:^
     {
         viewDatePicker.alpha = 1;
     }
                     completion:nil];
    //UIViewAnimationOptionCurveLinear
    [UIView commitAnimations];
}

-(IBAction)btnLocationClick
{
    [self hideKeyboard];
    viewLocation.frame = self.view.frame;
    [self.view addSubview:viewLocation];
}

-(IBAction)btnCancelUpdate
{
    // [self.navigationController popViewControllerAnimated:YES];
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)BtnSaveClicked:(id)sender

{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Please ceck your internet connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        if ([self validation])
        {
            
            NSMutableArray *imageArray = [[NSMutableArray alloc ]init];
            NSMutableArray *imageNameArray = [[NSMutableArray alloc]init];
            NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            NSString *imageNameLogo = [NSString stringWithFormat:@"image_%d.png",app.imageNo];
            NSString *filePath = [documentsDirectory stringByAppendingPathComponent:imageNameLogo];
            NSData *imageDataLogo = UIImagePNGRepresentation(imgviewLogo.image);
            [imageDataLogo writeToFile:filePath atomically:YES];
            app.imageNo ++;
            [imageArray addObject:imageDataLogo];
            [imageNameArray addObject:@"logo"];
            NSString *filePathDP;
            if(UIImagePNGRepresentation(imgviewDP.image) !=nil)
            {
                NSString *imageNameDP = [NSString stringWithFormat:@"image_%d.png",app.imageNo];
                filePathDP = [documentsDirectory stringByAppendingPathComponent:imageNameDP];
                NSData *imageDataDP = UIImagePNGRepresentation(imgviewDP.image);
                app.imageNo ++;
                [imageDataDP writeToFile:filePathDP atomically:YES];
                [imageArray addObject:imageDataDP];
                [imageNameArray addObject:@"image"];
            }
            [self setData];
            
            
            
            
            
            //            NSMutableArray *imageArray = [[NSMutableArray alloc ]init];
            //            NSMutableArray *imageNameArray = [[NSMutableArray alloc]init];
            //            NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            //            NSString *imageNameLogo = [NSString stringWithFormat:@"image_%d.png",app.imageNo];
            //            NSString *filePath = [documentsDirectory stringByAppendingPathComponent:imageNameLogo];
            //            NSData *imageDataLogo = UIImagePNGRepresentation(imgviewLogo.image);
            //            [imageDataLogo writeToFile:filePath atomically:YES];
            //            app.imageNo ++;
            //            [imageArray addObject:imageDataLogo];
            //            [imageNameArray addObject:@"logo"];
            //
            //            NSString *filePathDP;
            //            if(![UIImagePNGRepresentation(imgviewLogo.image) isEqual:temoImageData] ||  UIImagePNGRepresentation(imgviewLogo.image) !=nil)
            //            {
            //                NSString *imageNameDP = [NSString stringWithFormat:@"image_%d.png",app.imageNo];
            //                filePathDP = [documentsDirectory stringByAppendingPathComponent:imageNameDP];
            //                NSData *imageDataDP = UIImagePNGRepresentation(imgviewDP.image);
            //                app.imageNo ++;
            //                [imageDataDP writeToFile:filePathDP atomically:YES];
            //                [imageArray addObject:imageDataDP];
            //                [imageNameArray addObject:@"image"];
            //            }
            //           [self setData];
            NSString *catId = @"1";
            if ([arrCatId count]>app.selectedCat)
            {
                catId =[arrCatId objectAtIndex:app.selectedCat];
            }
            if ([catId isEqualToString:@"8"])
            {
                catId = @"10";
            }
            
            NSString *strId = [dictUserInfo valueForKey:@"id"];
            /* NSDictionary *parameters = @{ @"email": tfEmail.text,
             @"name":tfName.text,
             @"password" :  tfPassword.text,
             @"address1": tfAdd1.text,
             @"address2": tfAdd2.text,
             @"city": tfCity.text,
             @"state": [arrStateId objectAtIndex:app.selectedState],
             @"country": @"USA",
             @"zipcode": tfZipcode.text,
             @"phoneno" : tfPhNO.text,
             @"category":catId,
             @"subcategory": [NSString stringWithFormat:@"%d", app.selectedSubCat ],
             @"latitute":lblLatitute.text ,
             @"longitute":lblLongitute.text ,
             @"business_hours": tfBusinesshour.text,
             @"expdate": strExpDate,
             @"creditcardnumber": tfCreditCardNo.text,
             @"creditcardtype":tfCreditcardType.text ,
             @"crexpdate": strCardExpDate,
             @"cvvnumber": tfCVVNo.text,
             @"average_rating": tfAverageRating.text,
             @"data": tfData.text,
             @"amount":tfAmount.text,
             @"promo":@"",
             @"id":strId,
             };*/
            NSDictionary *parameters = @{ @"email": tfEmail.text,
                                          @"name":tfName.text,
                                          @"password" :  tfPassword.text,
                                          @"address1": tfAdd1.text,
                                          @"address2": tfAdd2.text,
                                          @"city": tfCity.text,
                                          @"state": [arrStateId objectAtIndex:app.selectedState],
                                          @"country": @"USA",
                                          @"zipcode": tfZipcode.text,
                                          @"phoneno" : tfPhNO.text,
                                          @"category":catId,
                                          @"subcategory": [NSString stringWithFormat:@"%d", app.selectedSubCat ],
                                          @"latitute":lblLatitute.text ,
                                          @"longitute":lblLongitute.text ,
                                          @"business_hours": tfBusinesshour.text,
                                          @"expdate": strExpDate,
                                          @"average_rating": tfAverageRating.text,
                                          @"data": tfData.text,
                                          @"amount":tfAmount.text,
                                          @"website": tfData.text,
                                          @"fb_link":tfAmount.text,
                                          @"promo":@"",
                                          @"id":strId,
                                          };
            
            NSURL *codeURL = [NSURL URLWithString:mainUrl];
            AFHTTPClient *client= [AFHTTPClient clientWithBaseURL:codeURL];
            [app showHUD];
            NSMutableURLRequest *request = [client multipartFormRequestWithMethod:@"POST" path:@"updateMerchantProfile.php?" parameters:parameters constructingBodyWithBlock: ^(id <AFMultipartFormData>formData)
                                            {
                                                for (int i = 0; i < imageArray.count; i++)
                                                {
                                                    [formData appendPartWithFileData:[imageArray objectAtIndex:i] name:[imageNameArray objectAtIndex:i] fileName:@"Photo.png" mimeType:@"image/png"];
                                                }
                                            }];
            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
            [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
             {
                 NSString *response = [operation responseString];
                 [app hideHUD];
                 NSError *error;
                 if (response!=nil)
                 {
                     NSDictionary *responseDict = [NSJSONSerialization
                                                   JSONObjectWithData:[operation responseData] options:kNilOptions error:&error];
                     if ([[responseDict valueForKey:@"status"] intValue] != 0)
                     {
                         NSArray *arrData = [responseDict valueForKey:@"data"];
                         NSDictionary *dictData =[arrData objectAtIndex:0];
                         [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userInfo"];
                         [[NSUserDefaults standardUserDefaults]setObject:dictData forKey:@"userInfo"];
                         [[NSUserDefaults standardUserDefaults]synchronize];
                         UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Jaywalk.In" message:@"Update successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                         alert.tag = 111;
                         [alert show];
                         [[NSUserDefaults standardUserDefaults] setObject:@"registered" forKey:@"loggedin"];
                         [[NSUserDefaults standardUserDefaults] synchronize];
                     }
                     else if ([[responseDict valueForKey:@"status"] intValue]== 0)
                     {
                         UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:@"" message:@"Sorry, try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                         [alrt show];
                     }
                 }
             }
                                             failure:^(AFHTTPRequestOperation *operation, NSError *error)
             {
             }];
            [operation start];
        }
    }

    
}

#pragma mark- Update

-(IBAction)btnUpdateClick
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Please ceck your internet connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        if ([self validation])
        {
            
            NSMutableArray *imageArray = [[NSMutableArray alloc ]init];
            NSMutableArray *imageNameArray = [[NSMutableArray alloc]init];
            NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            NSString *imageNameLogo = [NSString stringWithFormat:@"image_%d.png",app.imageNo];
            NSString *filePath = [documentsDirectory stringByAppendingPathComponent:imageNameLogo];
            NSData *imageDataLogo = UIImagePNGRepresentation(imgviewLogo.image);
            [imageDataLogo writeToFile:filePath atomically:YES];
            app.imageNo ++;
            [imageArray addObject:imageDataLogo];
            [imageNameArray addObject:@"logo"];
            NSString *filePathDP;
            if(UIImagePNGRepresentation(imgviewDP.image) !=nil)
            {
                NSString *imageNameDP = [NSString stringWithFormat:@"image_%d.png",app.imageNo];
                filePathDP = [documentsDirectory stringByAppendingPathComponent:imageNameDP];
                NSData *imageDataDP = UIImagePNGRepresentation(imgviewDP.image);
                app.imageNo ++;
                [imageDataDP writeToFile:filePathDP atomically:YES];
                [imageArray addObject:imageDataDP];
                [imageNameArray addObject:@"image"];
            }
            [self setData];

            
            
            
            
//            NSMutableArray *imageArray = [[NSMutableArray alloc ]init];
//            NSMutableArray *imageNameArray = [[NSMutableArray alloc]init];
//            NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//            NSString *imageNameLogo = [NSString stringWithFormat:@"image_%d.png",app.imageNo];
//            NSString *filePath = [documentsDirectory stringByAppendingPathComponent:imageNameLogo];
//            NSData *imageDataLogo = UIImagePNGRepresentation(imgviewLogo.image);
//            [imageDataLogo writeToFile:filePath atomically:YES];
//            app.imageNo ++;
//            [imageArray addObject:imageDataLogo];
//            [imageNameArray addObject:@"logo"];
//            
//            NSString *filePathDP;
//            if(![UIImagePNGRepresentation(imgviewLogo.image) isEqual:temoImageData] ||  UIImagePNGRepresentation(imgviewLogo.image) !=nil)
//            {
//                NSString *imageNameDP = [NSString stringWithFormat:@"image_%d.png",app.imageNo];
//                filePathDP = [documentsDirectory stringByAppendingPathComponent:imageNameDP];
//                NSData *imageDataDP = UIImagePNGRepresentation(imgviewDP.image);
//                app.imageNo ++;
//                [imageDataDP writeToFile:filePathDP atomically:YES];
//                [imageArray addObject:imageDataDP];
//                [imageNameArray addObject:@"image"];
//            }
 //           [self setData];
            NSString *catId =[arrCatId objectAtIndex:app.selectedCat];
            if ([catId isEqualToString:@"8"])
            {
                catId = @"10";
            }
            
            NSString *strId = [dictUserInfo valueForKey:@"id"];
           /* NSDictionary *parameters = @{ @"email": tfEmail.text,
                                          @"name":tfName.text,
                                          @"password" :  tfPassword.text,
                                          @"address1": tfAdd1.text,
                                          @"address2": tfAdd2.text,
                                          @"city": tfCity.text,
                                          @"state": [arrStateId objectAtIndex:app.selectedState],
                                          @"country": @"USA",
                                          @"zipcode": tfZipcode.text,
                                          @"phoneno" : tfPhNO.text,
                                          @"category":catId,
                                          @"subcategory": [NSString stringWithFormat:@"%d", app.selectedSubCat ],
                                          @"latitute":lblLatitute.text ,
                                          @"longitute":lblLongitute.text ,
                                          @"business_hours": tfBusinesshour.text,
                                          @"expdate": strExpDate,
                                          @"creditcardnumber": tfCreditCardNo.text,
                                          @"creditcardtype":tfCreditcardType.text ,
                                          @"crexpdate": strCardExpDate,
                                          @"cvvnumber": tfCVVNo.text,
                                          @"average_rating": tfAverageRating.text,
                                          @"data": tfData.text,
                                          @"amount":tfAmount.text,
                                          @"promo":@"",
                                          @"id":strId,
                                          };*/
            NSDictionary *parameters = @{ @"email": tfEmail.text,
                                          @"name":tfName.text,
                                          @"password" :  tfPassword.text,
                                          @"address1": tfAdd1.text,
                                          @"address2": tfAdd2.text,
                                          @"city": tfCity.text,
                                          @"state": [arrStateId objectAtIndex:app.selectedState],
                                          @"country": @"USA",
                                          @"zipcode": tfZipcode.text,
                                          @"phoneno" : tfPhNO.text,
                                          @"category":catId,
                                          @"subcategory": [NSString stringWithFormat:@"%d", app.selectedSubCat ],
                                          @"latitute":lblLatitute.text ,
                                          @"longitute":lblLongitute.text ,
                                          @"business_hours": tfBusinesshour.text,
                                          @"expdate": strExpDate,
                                          @"average_rating": tfAverageRating.text,
                                          @"data": tfData.text,
                                          @"amount":tfAmount.text,
                                          @"website": tfData.text,
                                          @"fb_link":tfAmount.text,
                                          @"promo":@"",
                                          @"id":strId,
                                          };

            NSURL *codeURL = [NSURL URLWithString:mainUrl];
            AFHTTPClient *client= [AFHTTPClient clientWithBaseURL:codeURL];
            [app showHUD];
            NSMutableURLRequest *request = [client multipartFormRequestWithMethod:@"POST" path:@"updateMerchantProfile.php?" parameters:parameters constructingBodyWithBlock: ^(id <AFMultipartFormData>formData)
                                            {
                                                for (int i = 0; i < imageArray.count; i++)
                                                {
                                                    [formData appendPartWithFileData:[imageArray objectAtIndex:i] name:[imageNameArray objectAtIndex:i] fileName:@"Photo.png" mimeType:@"image/png"];
                                                }
                                            }];
            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
            [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
             {
                 NSString *response = [operation responseString];
                 [app hideHUD];
                 NSError *error;
                 if (response!=nil)
                 {
                     NSDictionary *responseDict = [NSJSONSerialization
                                                   JSONObjectWithData:[operation responseData] options:kNilOptions error:&error];
                     if ([[responseDict valueForKey:@"status"] intValue] != 0)
                     {
                         NSArray *arrData = [responseDict valueForKey:@"data"];
                         NSDictionary *dictData =[arrData objectAtIndex:0];
                         [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userInfo"];
                         [[NSUserDefaults standardUserDefaults]setObject:dictData forKey:@"userInfo"];
                         [[NSUserDefaults standardUserDefaults]synchronize];
                         UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Jaywalk.In" message:@"Update successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                         alert.tag = 111;
                         [alert show];
                         [[NSUserDefaults standardUserDefaults] setObject:@"registered" forKey:@"loggedin"];
                         [[NSUserDefaults standardUserDefaults] synchronize];
                     }
                     else if ([[responseDict valueForKey:@"status"] intValue]== 0)
                     {
                         UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:@"" message:@"Sorry, try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                         [alrt show];
                     }
                 }
             }
                                             failure:^(AFHTTPRequestOperation *operation, NSError *error)
             {
             }];
            [operation start];
        }
    }
}

-(BOOL)validation
{
    if ([tfName.text stringByTrimmingCharactersInSet:whitespace].length == 0 && [[tfName.text stringByTrimmingCharactersInSet:whitespace] isEqualToString:@""])
    {
        UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter your name." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alrt show];
        return NO;
    }
    else if ([tfEmail.text stringByTrimmingCharactersInSet:whitespace].length == 0 && [[tfEmail.text stringByTrimmingCharactersInSet:whitespace] isEqualToString:@""])
    {
        UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter your email adrress." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alrt show];
        return NO;
    }
    else if ([tfPassword.text stringByTrimmingCharactersInSet:whitespace].length == 0 && [[tfPassword.text stringByTrimmingCharactersInSet:whitespace] isEqualToString:@""])
    {
        UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter your valid phone number" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alrt show];
        return NO;
    }
    else if ([tfPhNO.text stringByTrimmingCharactersInSet:whitespace].length == 0 || [tfPhNO.text stringByTrimmingCharactersInSet:whitespace].length < 10  || [[tfPhNO.text stringByTrimmingCharactersInSet:whitespace] isEqualToString:@""])
    {
        UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter your valid phone number" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alrt show];
        return NO;
    }
    else if ([tfAdd1.text stringByTrimmingCharactersInSet:whitespace].length == 0 && [[tfAdd1.text stringByTrimmingCharactersInSet:whitespace] isEqualToString:@""] )
    {
        UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter your first address." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alrt show];
        return NO;
    }
    else if ([app.selectedStateName stringByTrimmingCharactersInSet:whitespace].length == 0 && [[app.selectedStateName stringByTrimmingCharactersInSet:whitespace] isEqualToString:@""])
    {
        UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please select state." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alrt show];
        return NO;
    }
    else if ([app.selectedCatName stringByTrimmingCharactersInSet:whitespace].length == 0 && [[app.selectedCatName stringByTrimmingCharactersInSet:whitespace] isEqualToString:@""])
    {
        UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please select catagory." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alrt show];
        return NO;
    }
    else if ([app.selectedSubcatName stringByTrimmingCharactersInSet:whitespace].length == 0 && [[app.selectedSubcatName stringByTrimmingCharactersInSet:whitespace] isEqualToString:@""])
    {
        UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please select sub-catagory." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alrt show];
        return NO;
    }
    else if ([lblLatitute.text stringByTrimmingCharactersInSet:whitespace].length == 0 && [[lblLatitute.text stringByTrimmingCharactersInSet:whitespace] isEqualToString:@""] )
    {
        UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please select your location." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alrt show];
        return NO;
    }
    else if(UIImagePNGRepresentation(imgviewLogo.image)  == nil)
    {
        UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please select logo." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alrt show];
        return NO;
    }
    else
    {
        return YES;
    }
}

-(void)setData
{
    if ([tfAdd2.text stringByTrimmingCharactersInSet:whitespace].length == 0 )
    {
        tfAdd2.text = @" ";
    }
    if ([tfCity.text stringByTrimmingCharactersInSet:whitespace].length == 0 )
    {
        tfCity.text = @" ";
    }
    if ([tfZipcode.text stringByTrimmingCharactersInSet:whitespace].length == 0 )
    {
        tfZipcode.text = @" ";
    }
    if ([tfPromoCode.text stringByTrimmingCharactersInSet:whitespace].length == 0 )
    {
        tfPromoCode.text = @" ";
    }
    if ([tfBusinesshour.text stringByTrimmingCharactersInSet:whitespace].length == 0 )
    {
        tfBusinesshour.text = @" ";
    }
    if ([tfCreditCardNo.text stringByTrimmingCharactersInSet:whitespace].length == 0 )
    {
        tfCreditCardNo.text = @" ";
    }
    if ([tfCreditcardType.text stringByTrimmingCharactersInSet:whitespace].length == 0 )
    {
        tfCreditcardType.text = @" ";
    }
    if ([tfCVVNo.text stringByTrimmingCharactersInSet:whitespace].length == 0 )
    {
        tfCVVNo.text = @" ";
    }
    if ([tfAverageRating.text stringByTrimmingCharactersInSet:whitespace].length == 0 )
    {
        tfAverageRating.text = @" ";
    }
    if ([tfData.text stringByTrimmingCharactersInSet:whitespace].length == 0 )
    {
        tfData.text = @" ";
    }
    if ([tfAmount.text stringByTrimmingCharactersInSet:whitespace].length == 0 )
    {
        tfAmount.text = @" ";
    }
    if ([lblLatitute.text stringByTrimmingCharactersInSet:whitespace].length == 0 )
    {
        lblLatitute.text = @" ";
    }
    if ([lblLongitute.text stringByTrimmingCharactersInSet:whitespace].length == 0 )
    {
        lblLongitute.text = @" ";
    }
}

#pragma mark- AlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==111)
    {
        [self dismissModalViewControllerAnimated:YES];
    }
}

#pragma mark- Gesture method

-(void)imageTapped:(UITapGestureRecognizer  *)gesture
{
    [self hideKeyboard];
    tempImgview =(UIImageView *) gesture.view;
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:@"Photo Library"
                                  otherButtonTitles:@"Camera", nil];
    actionSheet.tag = 1;
    actionSheet.actionSheetStyle = UIBarStyleBlackTranslucent;
    [actionSheet showInView:self.view];
}

#pragma mark- action sheet

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    [[picker navigationBar]setTintColor:[UIColor whiteColor]];
    [[picker navigationBar]setBarTintColor:[UIColor colorWithRed:(23/255.0) green:(127/255.0) blue:(101/255.0) alpha:1.0]];
    picker.allowsEditing = YES;
    switch (buttonIndex)
    {
        case 0:
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:picker animated:YES completion:NULL];
            break;
        case 1:
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:NULL];
            break;
        default:
            break;
    }
}

#pragma mark- imagepicker delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage * image =info[UIImagePickerControllerOriginalImage];
    self.tempImg =[[RemoteImageView alloc]init];
    self.tempImg.image = image;
    image =[self.tempImg.image imageWithImage:image convertToSize:CGSizeMake(90, 90)];
    [picker dismissViewControllerAnimated:YES completion:
     ^{
         tempImgview.image = image;
     }];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark- Date View Methods

-(IBAction)btnPickerCancel
{
    [viewDatePicker removeFromSuperview];
}

-(IBAction)btnPickerDone
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString * strExpDateSel = [dateFormatter stringFromDate:datePicker.date];
    if (btnTemp.tag == 1)
    {
        strExpDate = strExpDateSel;
        lblExpDate.hidden = NO;
        lblExpDate.text = strExpDateSel;
    }
    else
    {
        strCardExpDate = strExpDateSel;
        lblCardExp.hidden = NO;
        lblCardExp.text = strExpDateSel;
    }
    [viewDatePicker removeFromSuperview];
}

#pragma mark- DropDown Action

-(IBAction)btnStateClick:(id)sender
{
    [self hideKeyboard];
    if(dropDown2)
    {
        [dropDown2 hideDropDown:btnCat];
        dropDown2 = nil;
    }
    if (dropDown3)
    {
        [dropDown3 hideDropDown:btnSubcat];
        dropDown3 = nil;
    }
    UIButton *btnSt = (UIButton *)sender;
    CGFloat  f = 150;
    if(dropDown1 == nil)
    {
        dropDown1 = [[NIDropDown alloc] showDropDown:btnSt :&f :arrState :nil :@"down"];
        dropDown1.delegate=self;
        dropDown1.tag=101;
    }
    else
    {
        [dropDown1 hideDropDown:btnSt];
        dropDown1 = nil;
    }
}

-(IBAction)btnCatClick:(id)sender
{
    [self hideKeyboard];
    if(dropDown1)
    {
        [dropDown1 hideDropDown:btnState];
        dropDown1 = nil;
    }
    if (dropDown3)
    {
        [dropDown3 hideDropDown:btnSubcat];
        dropDown3 = nil;
    }
    UIButton *btnCt = (UIButton *)sender;
    CGFloat f = 150;
    if(dropDown2 == nil)
    {
        dropDown2 =[[NIDropDown alloc]showDropDown:btnCt :&f :arrCategary :nil :@"down"];
        dropDown2.delegate=self;
        dropDown2.tag=102;
    }
    else
    {
        [dropDown2 hideDropDown:btnCt];
        dropDown2 = nil;
    }
}

-(IBAction)btnSubcatClick:(id)sender
{
    [self hideKeyboard];
    if(dropDown2)
    {
        [dropDown2 hideDropDown:btnCat];
        dropDown2 = nil;
    }
    if (dropDown1)
    {
        [dropDown1 hideDropDown:btnState];
        dropDown1 = nil;
    }
    UIButton *btnSCat = (UIButton *)sender;
    CGFloat f = 150;
    NSMutableArray *arrTemp = [dictSubcategory valueForKey:app.selectedCatName];
    if(dropDown3 == nil)
    {
        dropDown3 = [[NIDropDown alloc]showDropDown:btnSCat :&f :arrTemp :nil :@"down"];
        dropDown3.delegate=self;
        dropDown3.tag=103;
    }
    else
    {
        [dropDown3 hideDropDown:btnSCat];
        dropDown3 = nil;
    }
}

- (void) niDropDownDelegateMethod: (NIDropDown *) sender
{
    if (sender.tag==101)
    {
        dropDown1=nil;
    }
    if (sender.tag ==102)
    {
        dropDown2=nil;
        [btnSubcat setTitle:@"" forState:UIControlStateNormal];
    }
    if (sender.tag ==103)
    {
        NSDictionary *dictCat=[arrMain objectAtIndex:app.selectedCat];
        NSArray *subCat =[dictCat valueForKey:@"subcategory_info"];
        app.selectedSubCat=[[[subCat objectAtIndex:app.selectedSubCat] objectForKey:@"subcategoryid"] intValue];
        dropDown3=nil;
    }
}

#pragma mark- Map View methods

-(IBAction)btnSearchLocation
{
    [tfSearchMap resignFirstResponder];
    if ([tfSearchMap.text stringByTrimmingCharactersInSet:whitespace].length == 0 && [[tfSearchMap.text stringByTrimmingCharactersInSet:whitespace] isEqualToString:@""])
    {
        UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:@"" message:@"Please enter place name to search." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alrt show];
    }
    else
    {
        NSString *address = tfSearchMap.text;
        NSString *url = [[NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@",address] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *jsonURl=[NSURL URLWithString:url];
        NSData *data=[NSData dataWithContentsOfURL:jsonURl];
        NSError *error=nil;
        id response=[NSJSONSerialization JSONObjectWithData:data options:
                     NSJSONReadingMutableContainers error:&error];
        dictLocation = (NSDictionary *)response;
        if ([[dictLocation valueForKey:@"status" ] isEqualToString:@"OK"])
        {
            NSArray *arrData =[dictLocation valueForKey:@"results" ];
            NSDictionary *dictInArray = [arrData objectAtIndex:0];
            NSDictionary *dictGeo = [dictInArray valueForKey:@"geometry" ];
            NSDictionary *dictLoc = [dictGeo valueForKey:@"location"];
            NSString *strLat = [[dictLoc valueForKey:@"lat"] stringValue];
            NSString *strLong =[[dictLoc valueForKey:@"lng"] stringValue];
            [lblLatitute setText:strLat];
            [lblLongitute setText:strLong];
            CLLocationCoordinate2D location;
            location.latitude = [strLat doubleValue];
            location.longitude = [strLong doubleValue];
            MKCoordinateRegion mapRegion;
            mapRegion.center = mapView.userLocation.coordinate;
            mapRegion.span.latitudeDelta = 0.05;
            mapRegion.span.longitudeDelta = 0.05;
            [mapView setCenterCoordinate:mapRegion.center animated:YES];
            MKCoordinateSpan span =
            { .longitudeDelta = mapView.region.span.longitudeDelta / 2,
                .latitudeDelta  = mapView.region.span.latitudeDelta  / 2 };
            // Create a new MKMapRegion with the new span, using the center we want.
            MKCoordinateRegion region = { .center = location, .span = span };
            [mapView setRegion:region animated:YES];
            CLLocationCoordinate2D annotationCoord;
            annotationCoord.latitude = [strLat floatValue];
            annotationCoord.longitude = [strLong floatValue];
            MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
            annotationPoint.coordinate = annotationCoord;
            annotationPoint.title = tfSearchMap.text;
            [mapView addAnnotation:annotationPoint];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Location not found." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        }
    }
}

- (void)mapView:(MKMapView *)aMapView didUpdateUserLocation:(MKUserLocation *)aUserLocation
{
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.05;
    span.longitudeDelta = 0.05;
    CLLocationCoordinate2D location;
    location.latitude = aUserLocation.coordinate.latitude;
    location.longitude = aUserLocation.coordinate.longitude;
    region.span = span;
    region.center = location;
    [aMapView setRegion:region animated:YES];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer
                         :(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)mapGestureHandler:(UITapGestureRecognizer *)gestureMap
{
    MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
    CGPoint touchPoint = [gestureMap locationInView:mapView];
    CLLocationCoordinate2D touchMapCoordinate = [mapView convertPoint:touchPoint toCoordinateFromView:mapView];
    NSString *strLat = [NSString stringWithFormat:@"%f", touchMapCoordinate.latitude ];
    NSString *strLong = [NSString stringWithFormat:@"%f",touchMapCoordinate.longitude];
    CLLocationCoordinate2D annotationCoord;
    annotationCoord.latitude = [strLat floatValue];
    annotationCoord.longitude = [strLong floatValue];
    annotationPoint.coordinate = annotationCoord;
    NSArray *existingpoints = mapView.annotations;
    if ([existingpoints count])
    {
        [mapView removeAnnotations:existingpoints];
    }
    [mapView addAnnotation:annotationPoint];
    [tfSearchMap setText:@""];
    [lblLatitute setText:strLat];
    [lblLongitute setText:strLong];
}

-(IBAction)btnAddLocation
{
    lblLongShow.text = lblLongitute.text;
    lblLongShow.hidden = NO;
    lblLatShow.text =lblLatitute.text;
    lblLatShow.hidden = NO;
    [viewLocation removeFromSuperview];
}

#pragma mark- TextFeild Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
   
    
    scrollReg.contentInset =  UIEdgeInsetsMake(0, 0,216+50, 0);
    [scrollReg scrollRectToVisible:textField.frame animated:NO];
    
    
    if(dropDown1)
    {
        [dropDown1 hideDropDown:btnState];
        dropDown1 = nil;
    }
    if (dropDown3)
    {
        [dropDown3 hideDropDown:btnSubcat];
        dropDown3 = nil;
    }
    if(dropDown2)
    {
        [dropDown2 hideDropDown:btnCat];
        dropDown2 = nil;
    }
    if(textField.tag > 14)
    {
        //Given size may not account for screen rotation
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.2];
        [UIView setAnimationBeginsFromCurrentState:YES];
//        self.view.frame = CGRectMake(self.view.frame.origin.x,-160,self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
    return YES;return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.view.frame = CGRectMake(self.view.frame.origin.x,0 ,self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
     [scrollReg setContentInset:  UIEdgeInsetsMake(0, 0,0, 0)];
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == tfPhNO)
    {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        if(newLength > 10)
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    else
    {
        return YES;
    }
}

#pragma mark- API Call

-(void)getState
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Please ceck your internet connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        arrState = [[NSMutableArray alloc] init];
        arrStateId = [[NSMutableArray alloc]init];
        NSURL *jsonURl=[NSURL URLWithString:GetState];
        NSData *data=[NSData dataWithContentsOfURL:jsonURl];
        NSError *error=nil;
        id response=[NSJSONSerialization JSONObjectWithData:data options:
                     NSJSONReadingMutableContainers error:&error];
        NSArray *arrStateResponse = (NSArray *)response;
        for (int i = 0;i< arrStateResponse.count; i++)
        {
            dictResultState = [arrStateResponse objectAtIndex:i];
            NSString *strState = [dictResultState valueForKey:@"state_name"];
            NSString *strStateId = [dictResultState valueForKey:@"state_id"];
            [arrState addObject:strState ];
            [arrStateId addObject:strStateId];
        }
    }
}

-(void)getCategary
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Please ceck your internet connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else
    {

        NSURL *jsonURl=[NSURL URLWithString:GetCategory];
        NSData *data=[NSData dataWithContentsOfURL:jsonURl];
        NSError *error=nil;
        id response=[NSJSONSerialization JSONObjectWithData:data options:
                     NSJSONReadingMutableContainers error:&error];
        NSArray *arrCat = (NSArray *)response;
        arrMain = [arrCat mutableCopy];
        dictSubcategory = [[NSMutableDictionary alloc] init];
        arrCategary = [[NSMutableArray alloc] init];
        arrCatId = [[NSMutableArray alloc] init];
        arrSubCatId = [[NSMutableArray alloc] init];
        arrSubCat = [[NSMutableArray alloc]init];
        for (int i = 0;i< arrCat.count; i++)
        {
            dictResultCat = [arrCat objectAtIndex:i];
            NSString *strCategary = [dictResultCat valueForKey:@"category_name"];
            NSString *strCategoryId = [dictResultCat valueForKey:@"categoryid"];
            NSArray *subCat =[dictResultCat valueForKey:@"subcategory_info"];
            [arrCatId addObject:strCategoryId];
            if (![strCategary isEqualToString:@"Financial, Legal, & Devel" ] )
            {
                if (![strCategary isEqualToString:@"Home & Garden"])
                {
                    [arrCategary addObject:strCategary];
                }
            }
            NSMutableArray *subCatArr = [[NSMutableArray alloc] init];
            for (int j=0;j<subCat.count;j++)
            {
                NSDictionary *subcat = [subCat objectAtIndex:j];
                NSString *str = [subcat valueForKey:@"subcategory"];
                NSString *strId = [subcat valueForKey:@"subcategoryid"];
                [subCatArr addObject:str];
                [arrSubCatId addObject:strId];
                [arrSubCat addObject:str];
            }
            [dictSubcategory setValue:subCatArr forKey:strCategary];
        }
    }
}

#pragma mark- Touch method

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UIView * txt in self.view.subviews)
    {
        if ([txt isKindOfClass:[UITextField class]] && [txt isFirstResponder])
        {
            [txt resignFirstResponder];
        }
    }
    [self hideKeyboard];
}

-(void)viewTapped:(UITapGestureRecognizer  *)gesture
{
    [self hideKeyboard];
}

-(void)hideKeyboard
{
    
    [self.view endEditing:YES];
    
    [tfAdd1 resignFirstResponder];
    [tfAdd2 resignFirstResponder];
    [tfName resignFirstResponder];
    [tfEmail resignFirstResponder];
    [tfPassword resignFirstResponder];
    [tfPhNO resignFirstResponder];
    [tfPromoCode resignFirstResponder];
    [tfSearchMap resignFirstResponder];
    [tfZipcode resignFirstResponder];
    [tfData resignFirstResponder];
    [tfCVVNo resignFirstResponder];
    [tfCreditCardNo resignFirstResponder];
    [tfCreditcardType resignFirstResponder];
    [tfAmount resignFirstResponder];
    [tfAverageRating resignFirstResponder];
    [tfBusinesshour resignFirstResponder];
    
    [scrollReg setContentInset:  UIEdgeInsetsMake(0, 0,0, 0)];

}


 - (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PrivateMethod Implimentation

-(void)setEdgesInsectForTextField:(UITextField *)txt
{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 7, 20)];
    txt.leftView = paddingView;
    txt.leftViewMode = UITextFieldViewModeAlways;
}

@end
