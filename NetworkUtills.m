//
//  NetworkUtills.m
//  IFINotes
//
//  Created by Rajendra soni on 2/29/12.
//  Copyright (c) 2012 Fox Infosoft. All rights reserved.
//

#import "NetworkUtills.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "Reachability.h"
#import "MBProgressHUD.h"
@implementation NetworkUtills

@synthesize tag,strResponse;
// to Check that internet is available or not

-(NetworkUtills *)initWithSelector:(SEL )selector WithCallBackObject:(id)objcallbackObject
{
    [super init]; 
    
   // myAlert=[[SohanLoadingView alloc] init];
    //myAlert = [[SohanLoadingView alloc] initWithTitle:nil message:@"Please wait..." delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    callbackSelector=selector;
    CallBackObject=objcallbackObject;
    return self;
}


-(BOOL)isInternetAvailable
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];  
    NetworkStatus networkStatus = [reachability currentReachabilityStatus]; 
    if (networkStatus==NotReachable) 
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Message" message:@"Please check your internet connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        alert=nil;
        return NO;
    }
    return YES;
}
-(void)RequestFinished
{
    if (CallBackObject)
    {
        [CallBackObject performSelector:callbackSelector withObject:self afterDelay:0.0];
    }
}
-(void)GetResponseByASIHttpRequest:(NSString *)strURL
{
    if ([self isInternetAvailable])
    {
       // [myAlert show];
        UIViewController *v=(UIViewController *)CallBackObject;
        [MBProgressHUD showHUDAddedTo:v.view animated:YES];
        strURL=[strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url=[NSURL URLWithString:strURL];
        ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:url];
        [request setDelegate:self];
        [request setDidFailSelector:@selector(ASIHTTPRequestRequestFailed:)];
        [request setDidFinishSelector:@selector(ASIHTTPRequestRequestFinished:)];
        [request setTimeOutSeconds:60.0];
        [request startAsynchronous];
        
    }
    
}


#pragma  ASIHTTPRequest request delegate
-(void)ASIHTTPRequestRequestFinished:(ASIHTTPRequest *)request
{
    //[myAlert dismissWithClickedButtonIndex:0 animated:NO];
    UIViewController *v=(UIViewController *)CallBackObject;
    [MBProgressHUD hideHUDForView:v.view animated:YES];
	self.strResponse = [request responseString];
    [self RequestFinished];
}
- (void)ASIHTTPRequestRequestFailed:(ASIHTTPRequest *)request
{
    //[myAlert dismissWithClickedButtonIndex:0 animated:NO];
    UIViewController *v=(UIViewController *)CallBackObject;
    [MBProgressHUD hideHUDForView:v.view animated:YES];
	NSError *error = [request error];
	NSString *errorString = [error localizedDescription];
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Message" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
   // [self RequestFinished];
    
}
-(void)GetResponseByASIFormDataRequest:(NSString *)strURL WithDictionary:(NSDictionary *)dictPostParamas
{
    if ([self isInternetAvailable])
    {
       // [myAlert show];
        UIViewController *v=(UIViewController *)CallBackObject;
        [MBProgressHUD showHUDAddedTo:v.view animated:YES];
        strURL=[strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url=[NSURL URLWithString:strURL];
        ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
        [request setDelegate:self];
        [request setDidFailSelector:@selector(ASIFormDataRequestRequestRequestFailed:)];
        [request setDidFinishSelector:@selector(ASIFormDataRequestRequestRequestFinished:)];
        [request setTimeOutSeconds:30.0];
        NSArray *arrAllKeys=[dictPostParamas allKeys];
        for (int i=0; i<[arrAllKeys count]; i++) 
        {
            NSString *strKeyName=[arrAllKeys objectAtIndex:i];
            if ([[dictPostParamas objectForKey:strKeyName] isKindOfClass:[UIImage class]]) 
            {
                UIImage *img=[dictPostParamas objectForKey:strKeyName];
                NSData *data=UIImageJPEGRepresentation(img, 1.0);
                [request setData:data forKey:strKeyName];
            }
            else
            {
                [request setPostValue:[dictPostParamas objectForKey:strKeyName] forKey:strKeyName];
            }
            
        }
     
       // NSArray *arrAllKeys=[dictPostParamas allKeys];
        for (NSString *strKey in arrAllKeys) 
        {
           // NSLog(@"kay and valuue -  %@=%@",strKey,[dictPostParamas objectForKey:strKey]);
        }
        
        
       [request startAsynchronous];
    }
    else
    {
        [self RequestFinished];
    }
    
}


#pragma Login ASIHTTPRequest request delegate
-(void)ASIFormDataRequestRequestRequestFinished:(ASIFormDataRequest *)request
{
   // [myAlert dismissWithClickedButtonIndex:0 animated:NO];
    UIViewController *v=(UIViewController *)CallBackObject;
    [MBProgressHUD hideHUDForView:v.view animated:YES];
	self.strResponse = [request responseString];
    [self RequestFinished];
}
- (void)ASIFormDataRequestRequestRequestFailed:(ASIFormDataRequest *)request
{
   // [myAlert dismissWithClickedButtonIndex:0 animated:NO];
    UIViewController *v=(UIViewController *)CallBackObject;
    [MBProgressHUD hideHUDForView:v.view animated:YES];
	NSError *error = [request error];
	NSString *errorString = [error localizedDescription];
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Message" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
    //[self RequestFinished];
    
}

@end
