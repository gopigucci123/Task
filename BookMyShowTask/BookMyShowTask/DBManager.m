//THis is good
//  DBManager.m
//  The Food Soldier
//
//  Created by Gopi on 10/09/15.
//  Copyright (c) 2015 Gopi. All rights reserved.
//

#import "DBManager.h"
#import "Place.h"

NSString*databasePath;
sqlite3 *Userdata;
NSString *sourcePath,*destinationPath;
NSArray *docPath;
sqlite3_stmt *statement;
sqlite3 *BookMyShowDB;

NSString *itemget_id;

@implementation DBManager

#pragma mark-  Initialized the database
+(NSString *)initializedatabase
{
    
    sourcePath=[[NSBundle mainBundle]pathForResource:@"BookMyShowDB" ofType:@"sqlite"];
    docPath=NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory,NSUserDomainMask,YES);
    destinationPath=[NSString stringWithFormat:@"%@BookMyShowDB.sqlite",[docPath objectAtIndex:0]];
    
    
    
    NSLog(@"Document Path    - %@",[docPath objectAtIndex:0]);
    
    NSLog(@"Source Path      - %@",sourcePath);
    NSLog(@"Destination Path - %@",destinationPath);
    
    NSFileManager *filemgr= [[NSFileManager alloc] init];
    
    if([filemgr fileExistsAtPath:destinationPath] == YES)
    {
        NSLog(@"Database Exist");
    }
    else
    {
        NSError *err;
        [filemgr copyItemAtPath:sourcePath toPath:destinationPath error:&err];
        NSLog(@"Database Created");
    }
    return destinationPath;
}


#pragma mark- saving and fetching the data in the Database while receiving the message.





//=====================================================================================================================================


+(BOOL)SaveLocation:(NSString *)LocationImg LocationName:(NSString *)LocationName LocationAddress:(NSString *)LocationAddress LocationLat:(NSString *)LocationLat LocationLong:(NSString *)LocationLong
{
    
    
    const char *dbpath = [destinationPath UTF8String];
    if (sqlite3_open(dbpath, &BookMyShowDB) == SQLITE_OK)
    {
        
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO FavouriteTable(LocationImg_URL,Location_Name,Location_Address,Location_Lat,Location_Long) VALUES(\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",LocationImg,LocationName,LocationAddress,LocationLat,LocationLong];
        
        
        NSLog(@"insert query: %@", insertSQL);
        const char *insert_stmt = [insertSQL UTF8String];
        
        sqlite3_prepare_v2(BookMyShowDB, insert_stmt, -1, &statement, NULL);
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"record inserted Successfully");
        }
        else
        {
            NSLog(@"insert Failed");
            NSLog(@"errmessage:%s",sqlite3_errmsg(BookMyShowDB));
            return NO;
        }
        if (sqlite3_step(statement) ==SQLITE_ROW)
        {
            NSLog(@"value is there");
        }
        else
        {
            NSLog(@"value not there");
            NSLog(@"errmessage:%s",sqlite3_errmsg(BookMyShowDB));
        }
        sqlite3_finalize(statement);
        sqlite3_close(BookMyShowDB);
    }
    
    
    return YES;
    
    
    
}





//Get favourite Locations
+(NSMutableArray *)GetFavouriteLocations
{
    NSMutableArray *getFavLocationArray=[[NSMutableArray alloc]init];
    
    if(sqlite3_open([destinationPath UTF8String],&BookMyShowDB)==SQLITE_OK)
    {
        NSString *query = [NSString stringWithFormat:@"SELECT * FROM FavouriteTable"];
        
        if(sqlite3_prepare_v2(BookMyShowDB,[query UTF8String] ,-1,&statement,NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW)
            {
                NSString *LocImgURL = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                
                NSString *LocName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                
                NSString *LocAddress = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                
                NSString *LocLat = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                
                NSString *LocLong = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                
                Place *plc = [[Place alloc] init];
                plc.name=LocName;
                plc.vicinity=LocAddress;
                plc.pid=LocImgURL;
                
                PlaceGeometry *plc_geo = [[PlaceGeometry alloc] initWithLat:LocLat andLong:LocLong];
                plc.geometry=plc_geo;
                
                PlacePhoto *photo = [[PlacePhoto alloc] init];
                photo.photo_reference=LocImgURL;
                plc.placePhotos=[NSMutableArray arrayWithObject:photo];
                photo.placeId=LocImgURL;
                
                [getFavLocationArray addObject:plc];
            }
        }
    }
    
    NSLog(@"getFavLocationArray=======%@",getFavLocationArray);
    
    return getFavLocationArray;
}









@end
