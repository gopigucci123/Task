//
//  DBManager.h
//  The Food Soldier
//
//  Created by Gopi on 10/09/15.
//  Copyright (c) 2015 Gopi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBManager : NSObject
{
}

#pragma mark- Initializing the Database

+(NSString *)initializedatabase;

#pragma mark- saving and fetching the data in the Database while receiving the message.




+(NSMutableArray *)getNewsReviews;



//===============
+(BOOL)SaveLocation:(NSString *)LocationImg LocationName:(NSString *)LocationName LocationAddress:(NSString *)LocationAddress LocationLat:(NSString *)LocationLat LocationLong:(NSString *)LocationLong;

+(NSMutableArray *)GetFavouriteLocations;






@end
