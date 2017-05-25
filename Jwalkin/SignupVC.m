//
//  SignupVC.m
//  Jwalkin
//
//  Created by Chanchal Warde on 5/13/15.
//  Copyright (c) 2015 fox. All rights reserved.
//

#import "SignupVC.h"
#import "HomeVC.h"
#import "RegisterMerchantVC.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <Bolts/Bolts.h>
#import "AFHTTPClient.h"
#import "AFImageRequestOperation.h"
#import "UrlFile.h"
#import "Reachability.h"
#import "UpdateProfileVC.h"
#import "JSON.h"

@interface SignupVC ()

@end

@implementation SignupVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    //for testing has to delete value
    //[[NSUserDefaults standardUserDefaults] setObject:@"registered" forKey:@"loggedin"];
    btnSignup.layer.cornerRadius = 5.0;
    app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"status_bar.png"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark- Button Action
/*

-(IBAction)btnSignUpClicked
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
        NSString *strUserId =  [FBSDKAccessToken currentAccessToken].userID;
        //NSLog(@"Facebook user id %@",strUserId);
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        login.loginBehavior = FBSDKLoginBehaviorWeb;
        [login logOut];
        [login logInWithReadPermissions:@[@"email",@"public_profile",@"user_hometown"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            if (error)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
                
            }
            else if (result.isCancelled)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
            }
            else
            {
                if ([FBSDKAccessToken currentAccessToken])
                {
                    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
                    [parameters setValue:@"id,name,email,gender" forKey:@"fields"];

                    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters] //dp 19 Dec 2015
                     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
                     {
                         if (!error)
                         {
                             //NSLog(@"Fetched user %@",result);
                             
                             App_Delegate.dictUserInfoFB =[[NSMutableDictionary alloc]init];
                             [App_Delegate.dictUserInfoFB setObject: [result objectForKey:@"email"] forKey:@"email"];
                             [App_Delegate.dictUserInfoFB setObject: [result objectForKey:@"gender"] forKey:@"gender"];
                             [App_Delegate.dictUserInfoFB setObject: [result objectForKey:@"name"] forKey:@"name"];
                             RegisterMerchantVC *registerVC = [[RegisterMerchantVC alloc] initWithNibName:@"RegisterMerchantVC" bundle:nil];
                             registerVC.isViaFB=YES;
                             registerVC.dictFacebookData=App_Delegate.dictUserInfoFB;
                             [self.navigationController pushViewController:registerVC animated:YES];
                         }
                     }];
                }
            }
        }];
    }
}
*/
- (IBAction)BtnSignUp:(id)sender
{
    
    NSURL *url = [NSURL URLWithString:@"http://emsbapp.com/jwalkin_new_work/signup.php"];
    [[UIApplication sharedApplication] openURL:url];

}

- (IBAction)btnForgetClick:(id)sender
{
    
    UIAlertView * forgotPassword=[[UIAlertView alloc] initWithTitle:@"Forgot Password"      message:@"Please enter your email id" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    forgotPassword.tag = 1;
    forgotPassword.alertViewStyle=UIAlertViewStylePlainTextInput;
//    [forgotPassword textFieldAtIndex:0].delegate=self;
    [forgotPassword show];
}

-(IBAction)btnLoginClicked
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
        if (tfEmail.text.length == 0   )
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Enter email." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else if(tfPassword.text.length == 0 )
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Enter password." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            NSDictionary *parameters = @{@"email_id": tfEmail.text,
                                         @"password":tfPassword.text };
            [app showHUD];
            NSURL *codeURL = [NSURL URLWithString:mainUrl];
            AFHTTPClient *client= [AFHTTPClient clientWithBaseURL:codeURL];
            NSMutableURLRequest *request = [client multipartFormRequestWithMethod:@"POST" path:@"login.php?" parameters:parameters constructingBodyWithBlock: ^(id <AFMultipartFormData>formData)
                                            {
                                            }];
            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
            [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
             {
                 NSString *response = [operation responseString];
                 NSError *error;
                 if (response!=nil)
                 {[app hideHUD];
                     NSDictionary *responseDict = [NSJSONSerialization
                                                   JSONObjectWithData:[operation responseData] options:kNilOptions error:&error];
                     if ([[responseDict valueForKey:@"status"] intValue]== 1)
                     {
                         NSArray *arrData = [responseDict valueForKey:@"data"];
                         NSMutableDictionary *dictData= [[NSMutableDictionary alloc]init];
                         dictData = [[arrData objectAtIndex:0] mutableCopy];
                         NSMutableDictionary *newinfo = [[NSMutableDictionary alloc]init];
                         for(id ss in dictData)
                         {
                             NSString *str  =[dictData objectForKey:ss];
                             if (![str isKindOfClass:[NSNull class]])
                             {
                                 [newinfo setObject:str forKey:ss];
                             }
                         }
                         NSLog(@"dictdata %@",newinfo);
                         [[NSUserDefaults standardUserDefaults]setObject:newinfo forKey:@"userInfo"];
                         NSString *merchantid = [dictData valueForKey:@"id"];
                         NSString *merchantName = [dictData valueForKey:@"name"];
                         NSString *FbLink = [dictData valueForKey:@"fb_link"];
                         NSString *WebLink = [dictData valueForKey:@"website"];
                         [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user-Id"];
                         [[NSUserDefaults standardUserDefaults]synchronize];
                         [[NSUserDefaults standardUserDefaults] setObject:merchantName forKey:@"merchantName"];
                         [[NSUserDefaults standardUserDefaults]synchronize];
                         [[NSUserDefaults standardUserDefaults] setObject:merchantid forKey:@"merchantid"];
                         [[NSUserDefaults standardUserDefaults]synchronize];
                         [[NSUserDefaults standardUserDefaults]setObject:merchantid forKey:@"user-Id"];
                         [[NSUserDefaults standardUserDefaults] synchronize];

                         [[NSUserDefaults standardUserDefaults] setObject:@"registered" forKey:@"loggedin"];
                         [[NSUserDefaults standardUserDefaults] synchronize];
                         [[NSUserDefaults standardUserDefaults] setObject:FbLink forKey:@"fb_link"];
                         [[NSUserDefaults standardUserDefaults]synchronize];
                         [[NSUserDefaults standardUserDefaults] setObject:WebLink forKey:@"Website"];
                         [[NSUserDefaults standardUserDefaults]synchronize];
                         [self.navigationController popViewControllerAnimated:YES];
                     }
                     else if([[responseDict valueForKey:@"status"] intValue]== 0)
                     {
                         UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:@"Message" message:[NSString stringWithFormat:@"%@",[responseDict objectForKey:@"data"]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                         [alrt show];

                     
                     
                     }
                     else if([[responseDict valueForKey:@"status"] intValue] == 2)
                     {
                         UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:@"Message" message:[NSString stringWithFormat:@"%@",[responseDict objectForKey:@"data"]] delegate:self cancelButtonTitle:@"Later" otherButtonTitles:@"Subscribe",nil];
                         alrt.tag = 5001;
                         [alrt show];
                     }

                     else
                     {
                         UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:@"" message:@"Incorrect email id or password." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
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


-(IBAction)btnSignInFBClicked:(id)sender
{
    [self loginWithFb];
}

-(IBAction)btnCancel
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark TextFeild Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField == tfEmail)
    {
        [tfPassword becomeFirstResponder];
    }
    if (textField == tfPassword)
    {
        [textField resignFirstResponder];
        [self btnLoginClicked];
    }
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [tfPassword resignFirstResponder];
    [tfEmail resignFirstResponder];
}

-(void)loginWithFb
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
        NSString *strUserId =  [FBSDKAccessToken currentAccessToken].userID;
        //NSLog(@"Facebook user id %@",strUserId);
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        login.loginBehavior = FBSDKLoginBehaviorWeb;
//        [login logOut];

        [login logInWithPublishPermissions:@[@"publish_actions"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
//        }];
//        [login logInWithReadPermissions:@[@"email",@"public_profile",@"user_hometown",@"publish_action"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            if (error)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
            }
            else if (result.isCancelled)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
            }
            else
            {
                if ([FBSDKAccessToken currentAccessToken])
                {
                    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
                    [parameters setValue:@"id,name,email,gender" forKey:@"fields"];
                    
                    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters]
                     
                     //dp 19 Dec 2015
                     
                     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
 {
                         if (!error)
                         {
                             App_Delegate.dictUserInfoFB1 =[[NSMutableDictionary alloc]init];
                             [App_Delegate.dictUserInfoFB1 setObject: [result objectForKey:@"email"] forKey:@"email"];
                             [App_Delegate.dictUserInfoFB1 setObject: [result objectForKey:@"gender"] forKey:@"gender"];
                             [App_Delegate.dictUserInfoFB1 setObject: [result objectForKey:@"name"] forKey:@"name"];
                             [App_Delegate.dictUserInfoFB1 setObject:[result objectForKey:@"id"] forKey:@"fbId"];
                             name = [App_Delegate.dictUserInfoFB1 valueForKey:@"name"];
                             [[NSUserDefaults standardUserDefaults]setObject:name forKey:@"fbname"];
                             [[NSUserDefaults standardUserDefaults]synchronize];
                             /*
                              http://198.57.247.185/~jwalkin/admin/api/user_register.php?facebook_id=56466&name=sohan&email=sohan@fox.com
                              */
                             NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                             [dict setObject:[App_Delegate.dictUserInfoFB1 valueForKey:@"fbId"]forKey:@"facebook_id"];
                             [dict setObject:name forKey:@"name"];
                             [dict setValue:[App_Delegate.dictUserInfoFB1 valueForKey:@"email"] forKey:@"email"];
                             netUtills = [[NetworkUtills alloc] initWithSelector:@selector(ParseResponseRegister:) WithCallBackObject:self];
                             [netUtills GetResponseByASIFormDataRequest:[NSString stringWithFormat:@"%@%@",mainUrl,userRegister] WithDictionary:dict];
                         }
                     }];
                }
            }
        }];
    }
}

-(void)ParseResponseRegister:(id)sender
{
    NetworkUtills *utills=(NetworkUtills *)sender;
    [self ParseResultRegister:utills.strResponse];
}

-(void)ParseResultRegister:(NSString *)strResponse
{
    NSDictionary *dictRegister = [strResponse JSONValue];
    NSString *uid = [dictRegister valueForKey:@"user_id"];
    [[NSUserDefaults standardUserDefaults] setObject:uid forKey:@"user-Id"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    NSString *sts =[dictRegister valueForKey:@"status"] ;
    if ([sts isEqualToString:@"200"])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 5001)
    {
        if (buttonIndex == 1)
        {
            NSURL *url = [NSURL URLWithString:@"http://emsbapp.com/jwalkin_new_work/signup.php"];
            [[UIApplication sharedApplication] openURL:url];
        }
    }
    
    if (alertView.tag ==1)
    {
        NSLog(@"ok button clicked in forgot password alert view");
        NSString *femailId=[alertView textFieldAtIndex:0].text;
        if (buttonIndex == 1)
        { 
        if (femailId.length>0)
        {
            
            [self callApiForForgotPassword:femailId];
        }
        else
        {
           
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert!" message:@" Please enter the email id" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
            }
            
        }
    }
}
-(void)callApiForForgotPassword:(NSString*)Email
{
    
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    
    [dict setObject:Email forKey:@"email" ];
    utllForgotP = [[NetworkUtills alloc] initWithSelector:@selector(callBackForgotPassword) WithCallBackObject:self];
    [utllForgotP GetResponseByASIFormDataRequest:[NSString stringWithFormat:@"%@%@",mainUrl,forgotPasswordAPi] WithDictionary:dict];

}
-(void)callBackForgotPassword
{
    NSLog(@"Str Response of forgot password api %@",utllForgotP.strResponse);
    
    NSDictionary *dict=[utllForgotP.strResponse JSONValue];
    
    if ([[dict objectForKey:@"status"]integerValue]==1) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert!" message:[dict objectForKey:@"message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert!" message:[dict objectForKey:@"message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}

@end
