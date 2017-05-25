//
//  CommentVC.m
//  Jwalkin
//
//  Created by Kanika on 24/06/15.
//  Copyright (c) 2015 fox. All rights reserved.
//

#import "CommentVC.h"
#import "CommentCell.h"
#import "Reachability.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <Bolts/Bolts.h>
#import "UrlFile.h"
#import "JSON.h"
#import "SignupVC.h"

@interface CommentVC ()
{
    NSMutableArray *arrUserName;
    NSMutableArray *arrComment;
    NSMutableArray *arrTime;
    NSString *name;
    NSMutableDictionary *dictRegister;
    NSString *uid;
}
@end

@implementation CommentVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 25)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.backgroundColor = [UIColor colorWithRed:(23/255.0) green:(127/255.0) blue:(101/255.0) alpha:1.0];
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithKeyPad)],
                           nil];
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    [numberToolbar sizeToFit];
    tvComment.inputAccessoryView = numberToolbar;
    btnSend.layer.cornerRadius = 5.0;
    arrComment = [[NSMutableArray alloc]init];
    arrUserName =[[NSMutableArray alloc]init];
    arrTime =[[NSMutableArray alloc]init];
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Please check your internet connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        /*
         http://198.57.247.185/~jwalkin/admin/api/getMerchantComments.php?merchant_id=1
         */
        NSString *merId = [[NSUserDefaults standardUserDefaults] valueForKey:@"merchant_id"];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:merId forKey:@"merchant_id"];
        
        netUtills = [[NetworkUtills alloc] initWithSelector:@selector(ParseResponseGet:) WithCallBackObject:self];
        [netUtills GetResponseByASIFormDataRequest:[NSString stringWithFormat:@"%@%@",mainUrl,getMerchantComments] WithDictionary:dict];
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- Button Action

-(IBAction)btnBackClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)doneWithKeyPad
{
    CGRect mainScreen = [UIScreen mainScreen].bounds;
    [tvComment resignFirstResponder];
    [UIView animateWithDuration:0.40f animations:
     ^{
         [self.view setFrame:CGRectMake(mainScreen.origin.x, mainScreen.origin.y,mainScreen.size.width,mainScreen.size.height)];
     }
                     completion:^(BOOL finished)
     {}];
}

-(IBAction)btnSendClick:(id)sender
{
    CGRect mainScreen = [UIScreen mainScreen].bounds;
    //NSString *str =[App_Delegate.dictUserInfoFB1 valueForKey:@"name"];
    NSString *str =[[NSUserDefaults standardUserDefaults] valueForKey:@"fbname"];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"loggedin"])
    {
        if (tvComment.text.length != 0)
        {
            NSString *merName = [[NSUserDefaults standardUserDefaults] valueForKey:@"merchantName"];
            NSString *uId = [[NSUserDefaults standardUserDefaults]valueForKey:@"merchantid"];
            NSString *comment =tvComment.text;
            [arrUserName addObject:merName];
            [arrComment addObject:comment];
            NSDate *theDate = [NSDate date];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"dd MMM yyyy hh:mm:ss"];
            NSString *timeString = [formatter stringFromDate:theDate];
            [arrTime addObject:timeString];
            Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
            NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
            if (networkStatus == NotReachable)
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Please check your internet connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            else
            {
                /*
                  >> http://198.57.247.185/~jwalkin/admin/api/add_comment.php?user_id=5&text=test%20comment&merchant_id=1&user_type=U
                 
                 >> http://198.57.247.185/~jwalkin/admin/api/add_comment.php?user_id=18&text=test%20comment&merchant_id=1&user_type=M
                 */
                NSString *merId = [[NSUserDefaults standardUserDefaults] valueForKey:@"merchant_id"];
                NSString *comment =tvComment.text;
                
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                [dict setObject:uId forKey:@"user_id"];
                [dict setObject:comment forKey:@"text"];
                [dict setValue:merId forKey:@"merchant_id"];
                [dict setObject:@"M" forKey:@"user_type"];
                netUtills = [[NetworkUtills alloc] initWithSelector:@selector(ParseResponseAdd:) WithCallBackObject:self];
                [netUtills GetResponseByASIFormDataRequest:[NSString stringWithFormat:@"%@%@",mainUrl,addComment] WithDictionary:dict];
            }
        }
        else
        {
            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"Jaywalk.In" message:@"Please enter some comments" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        [tvComment resignFirstResponder];
        [UIView animateWithDuration:0.40f animations:
         ^{
             [self.view setFrame:CGRectMake(mainScreen.origin.x, mainScreen.origin.y,mainScreen.size.width,mainScreen.size.height)];
         }
                         completion:^(BOOL finished)
         {}];
        tvComment.text=@"";
        [tblComment reloadData];
        
    }
    else if(str.length == 0)
    {
        if (tvComment.text.length != 0)
        {
            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"Jaywalk.In" message:@"Sorry! you are not Login. You want to login with facebook?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No",nil];
            alert.tag = 1001;
            [alert show];
            [tvComment resignFirstResponder];
            [UIView animateWithDuration:0.40f animations:
             ^{
                 [self.view setFrame:CGRectMake(mainScreen.origin.x, mainScreen.origin.y,mainScreen.size.width,mainScreen.size.height)];
             }
                             completion:^(BOOL finished)
             {}];
        }
        else
        {
            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"Jaywalk.In" message:@"Please enter some comments" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
    else
    {
        if (tvComment.text.length != 0)
        {
            [arrUserName addObject:str];
            [arrComment addObject:tvComment.text];
            NSDate *theDate = [NSDate date];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"dd MMM yyyy hh:mm a"];
            NSString *timeString = [formatter stringFromDate:theDate];
            [arrTime addObject:timeString];
            Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
            NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
            if (networkStatus == NotReachable)
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Please check your internet connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            else
            {
                NSString *merId = [[NSUserDefaults standardUserDefaults] valueForKey:@"merchant_id"];
                NSString *comment =tvComment.text;
                
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                [dict setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"user-Id"] forKey:@"user_id"];
                [dict setObject:comment forKey:@"text"];
                [dict setValue:merId forKey:@"merchant_id"];
                [dict setObject:@"U" forKey:@"user_type"];

                netUtills = [[NetworkUtills alloc] initWithSelector:@selector(ParseResponseAdd:) WithCallBackObject:self];
                [netUtills GetResponseByASIFormDataRequest:[NSString stringWithFormat:@"%@%@",mainUrl,addComment] WithDictionary:dict];
            }
        }
        else
        {
            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"Jaywalk.In" message:@"Please enter some comments" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        [tblComment reloadData];
        tvComment.text =@"";
        [tvComment resignFirstResponder];
        [UIView animateWithDuration:0.40f animations:
         ^{
             [self.view setFrame:CGRectMake(mainScreen.origin.x, mainScreen.origin.y,mainScreen.size.width,mainScreen.size.height)];
         }
                         completion:^(BOOL finished)
         {}];
    }
}

#pragma mark - TextView Delegates

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    CGRect mainScreen = [UIScreen mainScreen].bounds;
    [UIView animateWithDuration:0.40f animations:
     ^{
         [self.view setFrame:CGRectMake(mainScreen.origin.x, mainScreen.origin.y-255, mainScreen.size.width, mainScreen.size.height)];
     }
                     completion:^(BOOL finished)
     {}];
}

#pragma mark - TableView Delegates

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrUserName.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    CellIdentifier = @"CommentCell";
    CommentCell *cell = (CommentCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CommentCell" owner:self options:nil] objectAtIndex:0];
    }
    NSString *chatText = [arrComment objectAtIndex:indexPath.row];
    UIFont *font = [UIFont systemFontOfSize:15];
    CGSize size = [chatText sizeWithFont:font constrainedToSize:CGSizeMake(225.0f, 1000.0f) lineBreakMode:NSLineBreakByWordWrapping];
    cell.lblComment.frame = CGRectMake(cell.lblComment.frame.origin.x,cell.lblComment.frame.origin.y,cell.lblComment.frame.size.width, size.height);
    cell.lblComment.text = chatText;
    cell.lblUsername.text =[arrUserName objectAtIndex:indexPath.row];
    cell.lblDate.text=[arrTime objectAtIndex:indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellText = [arrComment objectAtIndex:indexPath.row];
    UIFont *cellFont = [UIFont systemFontOfSize:15];
    CGSize constraintSize = CGSizeMake(225.0f, MAXFLOAT);
    CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
    return labelSize.height + 40;
}

#pragma mark- alert view delegates

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    CGRect mainScreen = [UIScreen mainScreen].bounds;
    if (alertView.tag == 1001)
    {
        if (buttonIndex == 0)
        {
            //[self loginWithFb];
            SignupVC *signup = [[SignupVC alloc] initWithNibName:@"SignupVC" bundle:nil];
            [self.navigationController pushViewController:signup animated:YES];
            [tvComment resignFirstResponder];
            [UIView animateWithDuration:0.40f animations:
             ^{
                 [self.view setFrame:CGRectMake(mainScreen.origin.x, mainScreen.origin.y,mainScreen.size.width,mainScreen.size.height)];
             }
                             completion:^(BOOL finished)
             {}];
            [tblComment reloadData];
        }
    }
}
/*
#pragma mark- loginWIthFb

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
        NSLog(@"Facebook user id %@",strUserId);
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
                    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
                     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
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
 
                             // http://198.57.247.185/~jwalkin/admin/api/user_register.php?facebook_id=56466&name=sohan&email=sohan@fox.com
 
                             NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                             [dict setObject:[App_Delegate.dictUserInfoFB1 valueForKey:@"fbId"]forKey:@"facebook_id"];
                             [dict setObject:name forKey:@"name"];
                             [dict setValue:[App_Delegate.dictUserInfoFB1 valueForKey:@"email"] forKey:@"email"];
                             netUtills = [[NetworkUtills alloc] initWithSelector:@selector(ParseResponseRegister:) WithCallBackObject:self];
                             [netUtills GetResponseByASIFormDataRequest:[NSString stringWithFormat:@"%@%@",mainUrl,userRegister] WithDictionary:dict];
                             [arrUserName addObject:name];
                             [arrComment addObject:tvComment.text];
                             NSDate *theDate = [NSDate date];
                             NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                             [formatter setDateFormat:@"dd MMM yyyy hh:mm a"];
                             NSString *timeString = [formatter stringFromDate:theDate];
                             [arrTime addObject:timeString];
                             [tblComment reloadData];
                         }
                     }];
                }
            }
        }];
    }
}

#pragma mark- API Response

-(void)ParseResponseRegister:(id)sender
{
    NetworkUtills *utills=(NetworkUtills *)sender;
    [self ParseResultRegister:utills.strResponse];
}

-(void)ParseResultRegister:(NSString *)strResponse
{
    dictRegister = [strResponse JSONValue];
    uid = [dictRegister valueForKey:@"user_id"];
    [[NSUserDefaults standardUserDefaults] setObject:uid forKey:@"uid"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Please check your internet connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        NSString *merId = [[NSUserDefaults standardUserDefaults] valueForKey:@"merchant_id"];
        NSString *comment =tvComment.text;
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"uid"] forKey:@"user_id"];
        [dict setObject:comment forKey:@"text"];
        [dict setValue:merId forKey:@"merchant_id"];
        [dict setObject:@"U" forKey:@"user_type"];
        netUtills = [[NetworkUtills alloc] initWithSelector:@selector(ParseResponseAdd:) WithCallBackObject:self];
        [netUtills GetResponseByASIFormDataRequest:[NSString stringWithFormat:@"%@%@",mainUrl,addComment] WithDictionary:dict];
        tvComment.text=@"";
    }
}
*/

#pragma mark- API Response

-(void)ParseResponseAdd:(id)sender
{
    NetworkUtills *utills=(NetworkUtills *)sender;
    [self ParseResultAdd:utills.strResponse];
}

-(void)ParseResultAdd:(NSString *)strResponse
{
    //NSMutableDictionary *d = [strResponse JSONValue];
    CGPoint bottomOffset = CGPointMake(0, tblComment.contentSize.height - tblComment.bounds.size.height);
    if ( bottomOffset.y > 0 )
    {
        [tblComment setContentOffset:bottomOffset animated:YES];
    }
}

-(void)ParseResponseGet:(id)sender
{
    NetworkUtills *utills=(NetworkUtills *)sender;
    [self ParseResultGet:utills.strResponse];
}

-(void)ParseResultGet:(NSString *)strResponse
{
    NSMutableDictionary *d = [strResponse JSONValue];
    int sts =[[d valueForKey:@"status"] intValue];
    if (sts!= 0)
    {
        NSMutableArray *arrCmmt = [d valueForKey:@"comments"];
        if (arrCmmt.count !=0)
        {
            for (int i=0; i<arrCmmt.count; i++)
            {
                NSMutableDictionary *dictCmmt =[arrCmmt objectAtIndex:i];
                [arrUserName addObject:[dictCmmt objectForKey:@"name"]];
                [arrComment addObject: [dictCmmt objectForKey:@"message"]];
                NSString *dateStr =[dictCmmt objectForKey:@"commented_on"];
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
                NSDate *sourceDate = [dateFormat dateFromString:dateStr];
                NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithName:@"GMT"];
                NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
                //calc time difference
                NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
                NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate];
                NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
                //set current real date
                NSDate* date = [[NSDate alloc] initWithTimeInterval:interval sinceDate:sourceDate];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"dd MMM yyyy hh:mm a"];
                NSString *timeString = [formatter stringFromDate:date];
                [arrTime addObject:timeString];
            }
            [tblComment reloadData];
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Jaywalk.In" message:[d valueForKey:@"message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

@end
