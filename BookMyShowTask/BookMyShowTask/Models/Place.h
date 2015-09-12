//
//  Place.h
//  BookMyShowTask
//
//  Created by Gopi on 10/09/15.
//  Copyright (c) 2015 Gopi. All rights reserved.
//

#import <Foundation/Foundation.h>

///Sub Entities

@interface PlaceGeometry : NSObject
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;

-(id)initWithLat:(NSString*)latitude andLong:(NSString*)longitude;
@end

@interface PlacePhoto : NSObject
@property (nonatomic) NSInteger maxWidth;
@property (nonatomic) NSInteger maxHeight;
@property (nonatomic, strong) NSString *photo_reference;
@property (nonatomic, strong) NSString *placeId;
-(id)initWithMaxWidth:(NSInteger)maxWidth withMaxHeight:(NSInteger)maxHeight withPhotoReference:(NSString *)photo_reference withPlace:(NSString *)placeId;

-(NSData *)getImageObjectWithCompletionBlock:(void (^)(NSData *data))finishBlock;

@end






//Main Entity

@interface Place : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *iconPath;
@property (nonatomic, strong) NSString *pid;
@property (nonatomic, strong) NSString *vicinity;

@property (nonatomic, strong) PlaceGeometry *geometry;
@property (nonatomic, strong) NSMutableArray *placePhotos;

//Convinent constructor
-(id)initWithJsonData:(NSDictionary *)JsonDict;
@end
