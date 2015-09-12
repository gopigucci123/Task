//
//  Place.m
//  BookMyShowTask
//
//  Created by Gopi on 10/09/15.
//  Copyright (c) 2015 Gopi. All rights reserved.
//

#import "Place.h"

#define kGlobalQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@implementation PlacePhoto

-(id)initWithMaxWidth:(NSInteger)maxWidth withMaxHeight:(NSInteger)maxHeight withPhotoReference:(NSString *)photo_reference withPlace:(NSString *)placeId{
    self=[super init];
    
    if (self) {
        self.maxWidth=maxWidth;
        self.maxHeight=maxHeight;
        self.photo_reference=photo_reference;
        self.placeId=placeId;
    }
    return self;
}

-(NSData *)getImageObjectWithCompletionBlock:(void (^)(NSData *data))finishBlock{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString* fullFilePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:self.placeId];

    //cache
    __block NSData *imageData = nil;
    if ([fileManager fileExistsAtPath:fullFilePath]) {
        imageData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:fullFilePath]];
        finishBlock(imageData);
    }else{

        dispatch_async(kGlobalQueue, ^{
            
            NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=%@&key=AIzaSyBroCC5NHKPzai5A3odoEh4-dUvumTvWTc",self.photo_reference];
            imageData = [NSData dataWithContentsOfURL: [NSURL URLWithString:url]];
            
            if (imageData) {
                [imageData writeToFile:fullFilePath atomically:YES];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                finishBlock(imageData);
            });
        });
    }
    
    return imageData;
}
- (NSString *) applicationDocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = paths.firstObject;
    return basePath;
}

@end

@implementation PlaceGeometry
-(id)initWithLat:(NSString*)latitude andLong:(NSString*)longitude;
{
    self=[super init];
    
    if (self) {
        self.latitude=latitude;
        self.longitude=longitude;
    }
    return self;
}
@end



@implementation Place
-(id)initWithJsonData:(NSDictionary *)JsonDict{
    self = [super init];
    if (self) {
        self.pid= JsonDict[@"id"];
        self.iconPath= JsonDict[@"icon"];
        self.name= JsonDict[@"name"];
        self.vicinity=JsonDict[@"vicinity"];
        
        NSDictionary *locationDict = JsonDict[@"geometry"][@"location"];
        self.geometry=[[PlaceGeometry alloc] initWithLat:[locationDict[@"lat"] stringValue] andLong:[locationDict[@"lng"] stringValue]];
        
        NSArray *photos=JsonDict[@"photos"];
        self.placePhotos=[[NSMutableArray alloc] initWithCapacity:photos.count];
        [photos enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
            [self.placePhotos addObject:[[PlacePhoto alloc] initWithMaxWidth:[obj[@"width"] integerValue] withMaxHeight:[obj[@"height"] integerValue] withPhotoReference:obj[@"photo_reference"] withPlace:self.pid]];
        }];
        
    }
    return self;
}

@end



