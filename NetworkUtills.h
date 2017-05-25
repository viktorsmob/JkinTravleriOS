//
//  NetworkUtills.h
//  IFINotes
//
//  Created by Rajendra soni on 2/29/12.
//  Copyright (c) 2012 Fox Infosoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkUtills : NSObject
{
    int tag;
    SEL callbackSelector;
    id  CallBackObject;
    NSString *strResponse;
}
@property  int tag;
-(BOOL)isInternetAvailable;
-(void)GetResponseByASIHttpRequest:(NSString *)strURL;
-(void)GetResponseByASIFormDataRequest:(NSString *)strURL WithDictionary:(NSDictionary *)dictPostParamas;
-(NetworkUtills *)initWithSelector:(SEL )selector WithCallBackObject:(id)objcallbackObject;
@property ( nonatomic,retain) NSString *strResponse;
-(void)RequestFinished;
@end
