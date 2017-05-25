//
//  WrapperClass.h
//  KidDiary
//
//  Created by Suresh Malviya on 25/01/11.
//  Copyright 2011 Fox Infosoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"


@interface WrapperClass : NSObject 
{
	
}

-(NSString *)getDBPath;
-(void)finalizeStatements;
-(WrapperClass *)initwithDev;


-(int)InsertToFavorite:(NSString *)merchantId;
-(BOOL)RemoveFromfav:(NSString*)merchantId;
-(NSMutableArray *)GetIds;

@end
