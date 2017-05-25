//
//  AddOfferVC.m
//  Jwalkin
//
//  Created by Kanika on 22/07/15.
//  Copyright (c) 2015 fox. All rights reserved.
//

#import "AddOfferVC.h"
#import "Reachability.h"
#import "UrlFile.h"
#import "AFHTTPClient.h"
#import "AFImageRequestOperation.h"
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



@interface AddOfferVC ()

@end

@implementation AddOfferVC
@synthesize isUpdate,dictOffer;
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
    app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
        if (IS_IPHONE_4_AND_OLDER)
        {
            scrollOffer.contentSize =CGSizeMake(self.view.frame.size.width,btnAdd.frame.origin.y+btnAdd.frame.size.height-100);
            
        }
        else
        {
            scrollOffer.contentSize =CGSizeMake(self.view.frame.size.width,btnAdd.frame.origin.y+btnAdd.frame.size.height+140);
        }
  
    
   
    
    
    

   // scrollOffer.contentSize = CGSizeMake(self.view.frame.size.width,btnAdd.frame.origin.y+btnAdd.frame.size.height+50);
    [self setEdgesInsectForTextField:txtMaxCount];
    [self setEdgesInsectForTextField:txtTitle];
    whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    imgView.layer.borderColor =[[UIColor blackColor] CGColor];
    imgView.layer.borderWidth = 1.0;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [scrollOffer addGestureRecognizer:singleTap];
    if (isUpdate)
    {
        [btnAdd setImage:[UIImage imageNamed:@"btn_submit.png"] forState:UIControlStateNormal];
        lblBarTitle.text = @"Update Offer";
        [self setData];
    }

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- Button Action

-(IBAction)btnAddClicked:(id)sender
{
    //http://198.57.247.185/~jwalkin/admin/api/add_offer.php
    // parameter: title, description, image, is_active, start_on (eg. 2015-07-09),expire_on(eg. 2015-07-09), maxcount, merchant_id
    //Update offer
    // http://198.57.247.185/~jwalkin/admin/api/update_offer.php
    //parameter: require: offer_id optional: title, description, image, is_active, start_on (eg. 2015-07-09),expire_on(eg. 2015-07-09), maxcount

    [txtMaxCount resignFirstResponder];
    [txtTitle resignFirstResponder];
    [txtVDescription resignFirstResponder];
    scrollOffer.contentSize = CGSizeMake(self.view.frame.size.width,btnAdd.frame.origin.y+btnAdd.frame.size.height);

    if ([self validation])
    {
        Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
        NSString *mId = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"merchantid"]];
        if (networkStatus == NotReachable)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Please check your internet connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            if (isUpdate)
            {
                NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                NSString *imageName = [NSString stringWithFormat:@"image_%dOffer.png",app.imageNo];
                NSString *filePath = [documentsDirectory stringByAppendingPathComponent:imageName];
                NSData *imageData = UIImagePNGRepresentation(imgView.image);
                [imageData writeToFile:filePath atomically:YES];
                app.imageNo ++;
                NSString *offerId = [dictOffer valueForKey:@"id"];
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                [dict setObject:offerId forKey:@"offer_id"];
                [dict setObject:txtTitle.text forKey:@"title"];
                [dict setObject:txtVDescription.text forKey:@"description"];
                [dict setObject:@"1" forKey:@"is_active"];
                [dict setObject:lblStartOn.text forKey:@"start_on"];
                [dict setObject:lblExpireOn.text forKey:@"expire_on"];
                [dict setObject:txtMaxCount.text forKey:@"maxcount"];
                [dict setObject:mId forKey:@"merchant_id"];
                NSURL *codeURL = [NSURL URLWithString:mainUrl];
                AFHTTPClient *client= [AFHTTPClient clientWithBaseURL:codeURL];
                [app showHUD];
                NSMutableURLRequest *request = [client multipartFormRequestWithMethod:@"POST" path:update_offer parameters:dict constructingBodyWithBlock: ^(id <AFMultipartFormData>formData)
                                                {
                                                    [formData appendPartWithFileData:imageData name:@"image" fileName:@"Photo.png" mimeType:@"image/png"];
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
                         NSString *msg = [NSString stringWithFormat:@"%@",[responseDict valueForKey:@"message"]];
                         if ([[responseDict valueForKey:@"status"] intValue]== 1)
                         {
                             UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Jaywalk.In" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                             alert.tag = 5001;
                             [alert show];
                         }
                         else
                         {
                             
                         }
                     }
                 }
                                                 failure:^(AFHTTPRequestOperation *operation, NSError *error)
                 {
                 }];
                [operation start];

            }
            else
            {
                NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                NSString *imageName = [NSString stringWithFormat:@"image_%dOffer.png",app.imageNo];
                NSString *filePath = [documentsDirectory stringByAppendingPathComponent:imageName];
                NSData *imageData = UIImagePNGRepresentation(imgView.image);
                [imageData writeToFile:filePath atomically:YES];
                app.imageNo ++;
                
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                [dict setObject:txtTitle.text forKey:@"title"];
                [dict setObject:txtVDescription.text forKey:@"description"];
                [dict setObject:@"1" forKey:@"is_active"];
                [dict setObject:lblStartOn.text forKey:@"start_on"];
                [dict setObject:lblExpireOn.text forKey:@"expire_on"];
                [dict setObject:txtMaxCount.text forKey:@"maxcount"];
                [dict setObject:mId forKey:@"merchant_id"];
                NSURL *codeURL = [NSURL URLWithString:mainUrl];
                AFHTTPClient *client= [AFHTTPClient clientWithBaseURL:codeURL];
                [app showHUD];
                NSMutableURLRequest *request = [client multipartFormRequestWithMethod:@"POST" path:add_Offer parameters:dict constructingBodyWithBlock: ^(id <AFMultipartFormData>formData)
                                                {
                                                    [formData appendPartWithFileData:imageData name:@"image" fileName:@"Photo.png" mimeType:@"image/png"];
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
                         NSString *msg = [NSString stringWithFormat:@"%@",[responseDict valueForKey:@"message"]];
                         if ([[responseDict valueForKey:@"status"] intValue]== 1)
                         {
                             UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Jaywalk.In" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                             alert.tag = 5001;
                             [alert show];
                         }
                         else
                         {
                             
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
}

-(IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btnDateClicked:(id)sender
{
    [txtMaxCount resignFirstResponder];
    [txtTitle resignFirstResponder];
    [txtVDescription resignFirstResponder];
    if (IS_IPHONE_4_AND_OLDER || IS_IPHONE_5)
    {
        
        if (IS_IPHONE_4_AND_OLDER)
        {
            scrollOffer.contentSize =CGSizeMake(self.view.frame.size.width,btnAdd.frame.origin.y+btnAdd.frame.size.height-100);
            
        }
        else
        {
           scrollOffer.contentSize =CGSizeMake(self.view.frame.size.width,btnAdd.frame.origin.y+btnAdd.frame.size.height+15);
        }
    }
    else
    {
        
        scrollOffer.contentSize =CGSizeMake(self.view.frame.size.width,btnAdd.frame.origin.y+btnAdd.frame.size.height+160);
    }
    

    scrollOffer.contentSize = CGSizeMake(self.view.frame.size.width,btnAdd.frame.origin.y+btnAdd.frame.size.height+10);
    viewPicker.frame =self.view.frame;
    viewPicker.alpha = 0;
    btnTemp = (UIButton *)sender;
    [self.view addSubview:viewPicker];
    [UIView animateWithDuration:0.2 delay:0.2 options:UIViewAnimationOptionCurveEaseIn  animations:^
     {
         viewPicker.alpha = 1;
     }
                     completion:nil];
    [UIView commitAnimations];
}

-(IBAction)btnPickerDone:(id)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString * strExpDateSel = [dateFormatter stringFromDate:pickerDate.date];
    if (btnTemp.tag == 1)
    {
        lblStartOn.hidden = NO;
        lblStartOn.text = strExpDateSel;
    }
    else if(btnTemp.tag == 2)
    {
        lblExpireOn.hidden = NO;
        lblExpireOn.text = strExpDateSel;
    }
    [viewPicker removeFromSuperview];
}

-(IBAction)btnCancel:(id)sender
{
    [viewPicker removeFromSuperview];
}

-(IBAction)btnSelectImageClicked:(id)sender
{
    [txtVDescription resignFirstResponder];
    [txtTitle resignFirstResponder];
    [txtMaxCount resignFirstResponder];
    if (IS_IPHONE_4_AND_OLDER || IS_IPHONE_5)
    {
        
        if (IS_IPHONE_4_AND_OLDER)
        {
            scrollOffer.contentSize =CGSizeMake(self.view.frame.size.width,btnAdd.frame.origin.y+btnAdd.frame.size.height-100);
            
        }
        else
        {
            scrollOffer.contentSize =CGSizeMake(self.view.frame.size.width,btnAdd.frame.origin.y+btnAdd.frame.size.height+15);
        }
    }
    else
    {
        
        scrollOffer.contentSize =CGSizeMake(self.view.frame.size.width,btnAdd.frame.origin.y+btnAdd.frame.size.height+160);
    }

   // scrollOffer.contentSize = CGSizeMake(self.view.frame.size.width,btnAdd.frame.origin.y+btnAdd.frame.size.height+10);
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

#pragma mark- Action Sheet

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.delegate = self;
    picker.allowsEditing = NO;
    [[picker navigationBar]setBackgroundImage:[UIImage imageNamed:@"status_bar.png"] forBarMetrics:UIBarMetricsDefault];
    [[picker navigationBar]setTintColor:[UIColor clearColor]];
    [[picker navigationBar]setTintColor:[UIColor whiteColor]];
    
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

#pragma mark- ImagePiker Delegates

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (picker.allowsEditing)
    {
        imageSelected =info[UIImagePickerControllerOriginalImage];
        NSData *imageData = UIImageJPEGRepresentation([self fixOrientation:imageSelected], 0.3);
        //    [imageData writeToFile:filePath atomically:YES];
        imageSelected = [UIImage imageWithData:imageData];

    }
    else
    {
        imageSelected =info[UIImagePickerControllerOriginalImage];
        NSData *imageData = UIImageJPEGRepresentation([self fixOrientation:imageSelected], 0.3);
        //    [imageData writeToFile:filePath atomically:YES];
        imageSelected = [UIImage imageWithData:imageData];

    }
    //imageSelected = [self fixOrientation:imageSelected];

        imgView.image =imageSelected;
                [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - TextField Delegates

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag != 11)
    {
        scrollOffer.contentSize = CGSizeMake(self.view.frame.size.width,btnAdd.frame.origin.y+btnAdd.frame.size.height+250);
    }
    if (textField.tag == 11)
    {
        if (scrollOffer.contentSize.height != btnAdd.frame.origin.y+btnAdd.frame.size.height+250)
        {
            [scrollOffer setContentOffset:CGPointMake(0,400) animated:YES];
            scrollOffer.contentSize = CGSizeMake(self.view.frame.size.width,btnAdd.frame.origin.y+btnAdd.frame.size.height+250);
        }
        
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    scrollOffer.contentSize = CGSizeMake(self.view.frame.size.width,btnAdd.frame.origin.y+btnAdd.frame.size.height+10);
    [textField resignFirstResponder];
    return YES;
}

#pragma mark- Alert View Delegates

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 5001)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark- Tap Gesture

- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    [txtMaxCount resignFirstResponder];
    [txtTitle resignFirstResponder];
    [txtVDescription resignFirstResponder];
    scrollOffer.contentSize = CGSizeMake(self.view.frame.size.width,btnAdd.frame.origin.y+btnAdd.frame.size.height+10);
}

#pragma mark- Other Method

-(void)setEdgesInsectForTextField:(UITextField *)txt
{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 7, 20)];
    txt.leftView = paddingView;
    txt.leftViewMode = UITextFieldViewModeAlways;
}

-(BOOL)validation
{
    if ([txtTitle.text stringByTrimmingCharactersInSet:whitespace].length == 0 && [[txtTitle.text stringByTrimmingCharactersInSet:whitespace] isEqualToString:@""])
    {
        UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:@"Jaywalk.In" message:@"Please enter title." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alrt show];
        return NO;
    }
    else if ([txtVDescription.text stringByTrimmingCharactersInSet:whitespace].length == 0 && [[txtVDescription.text stringByTrimmingCharactersInSet:whitespace] isEqualToString:@""])
    {
        UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please writes some description about offer." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alrt show];
        return NO;
    }
    else if(UIImagePNGRepresentation(imgView.image) == nil)
    {
        
        UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please select offer image." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alrt show];
        return NO;
    }
    else if ([lblStartOn.text stringByTrimmingCharactersInSet:whitespace].length == 0 && [[lblStartOn.text stringByTrimmingCharactersInSet:whitespace] isEqualToString:@""] )
    {
        UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please select start date of the offer." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alrt show];
        return NO;
    }
    else if ([lblExpireOn.text stringByTrimmingCharactersInSet:whitespace].length == 0 && [[lblExpireOn.text stringByTrimmingCharactersInSet:whitespace] isEqualToString:@""] )
    {
        UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please select expiry date of the offer." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alrt show];
        return NO;
    }
    else if ([txtMaxCount.text stringByTrimmingCharactersInSet:whitespace].length == 0 && [[txtMaxCount.text stringByTrimmingCharactersInSet:whitespace] isEqualToString:@""])
    {
        UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter the max count" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
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
    lblStartOn.hidden = NO;
    lblExpireOn.hidden = NO;
    
    txtTitle.text = [dictOffer valueForKey:@"title"];
    txtVDescription.text = [dictOffer valueForKey:@"description"];
    txtMaxCount.text = [dictOffer valueForKey:@"maxcount"];
    lblStartOn.text =[dictOffer valueForKey:@"start_on"];
    lblExpireOn.text = [dictOffer valueForKey:@"expire_on"];
    NSString *imgUrl = [dictOffer valueForKey:@"image"];
    imgView.imageURL = [NSURL URLWithString:imgUrl];
}

- (UIImage *)fixOrientation:(UIImage *)imgLocal
{
    
    // No-op if the orientation is already correct
    if (imgLocal.imageOrientation == UIImageOrientationUp) return imgLocal;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (imgLocal.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, imgLocal.size.width, imgLocal.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, imgLocal.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, imgLocal.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (imgLocal.imageOrientation)
    {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, imgLocal.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, imgLocal.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, imgLocal.size.width, imgLocal.size.height,
                                             CGImageGetBitsPerComponent(imgLocal.CGImage), 0,
                                             CGImageGetColorSpace(imgLocal.CGImage),
                                             CGImageGetBitmapInfo(imgLocal.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (imgLocal.imageOrientation)
    {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,imgLocal.size.height,imgLocal.size.width), imgLocal.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,imgLocal.size.width,imgLocal.size.height), imgLocal.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}


@end
