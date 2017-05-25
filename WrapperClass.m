//
//  WrapperClass.m
//  KidDiary
//sql = [NSString stringWithFormat:@"select rowid,Title from TripMaster WHERE StrDate>='%@'",[tt stringFromDate:[NSDate date]]];
//  Created by Suresh Malviya on 25/01/11.
//  Copyright 2011 Fox Infosoft. All rights reserved.
//

#import "WrapperClass.h"
#import "FavObj.h"


// sqlite3 and sqlite3_dtmt declared as static and nil because... 
static sqlite3 *database = nil;
static sqlite3_stmt *selectstmt = nil;


@implementation WrapperClass

// check the database path
-(WrapperClass *)initwithDev
{
	if(sqlite3_open([[self getDBPath] UTF8String], &database) == SQLITE_OK)
	{
		////NSLog(@"Success");
		
	}
	else
	{
		////NSLog(@"Fail");
	}
	return self;
	
}
// After execution of query finalizethe query statements
-(void)finalizeStatements
{
	if(database) sqlite3_close(database);
	if(selectstmt) sqlite3_finalize(selectstmt);
}

// Gives the path if database i.e. where te db is exists
-(NSString *) getDBPath
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *documentsDir = [paths objectAtIndex:0];
	return [documentsDir stringByAppendingPathComponent:@"JwalkinDB.sqlite"];
}




// Favorites

-(int)InsertToFavorite:(NSString *)merchantId
{
    int errorCounter=0;
    const char *sqlStatement = "insert into MyFavTbl (merch_id) VALUES (?)";
    
    sqlite3_stmt *compiledStatement;
    if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK)
    {
        sqlite3_bind_text(compiledStatement, 1,[merchantId UTF8String],-1, SQLITE_TRANSIENT);
        
    }
    if(sqlite3_step(compiledStatement) != SQLITE_DONE ) 
    {
        errorCounter ++;
        //NSLog(@"Err: %s",sqlite3_errmsg(database));
    }
    else 
    {
        //NSLog( @"Insert into row succesfully");
    }
    if(errorCounter >0)
    {
        return 0;
    } 
	return sqlite3_last_insert_rowid(database);
}

	//sba
	//remove from favourite
	//delete querry
-(BOOL)RemoveFromfav:(NSString*)merchantId
{
    NSString *sql=@"";
    char *errorMsg;
    sql = [NSString stringWithFormat:@"delete from MyFavTbl where merch_id = %@",merchantId];
    if (sqlite3_exec(database, [sql UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK)
    {
        NSAssert1(0, @"Error in Updating the records with mesg =: %s", errorMsg);
        sqlite3_free(errorMsg);
        return NO;
    }
	else
    {
        //NSLog(@"Succesfully Deleted");
    }
    
    return YES;
}

-(NSMutableArray *)GetIds
{
    NSMutableArray *returnArray=[NSMutableArray array];
    
   	NSString *sql=@"";	
	sql = [NSString stringWithFormat:@"select merch_id from MyFavTbl"];
	if(sqlite3_prepare_v2(database, [sql cStringUsingEncoding:NSUTF8StringEncoding], -1, &selectstmt, NULL) == SQLITE_OK)
	{		
		while(sqlite3_step(selectstmt) == SQLITE_ROW) 
		{
            FavObj *obj=[[FavObj alloc]init];
            obj.srtIds = sqlite3_column_text(selectstmt, 0) != NULL ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 0)] : @"";
            [returnArray addObject:obj.srtIds];
			obj=nil;
        }
    }
	return returnArray;
}




@end
