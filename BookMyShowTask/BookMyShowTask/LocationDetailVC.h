//
//  LocationDetailVC.h
//  BookMyShowTask
//
//  Created by Gopi on 10/09/15.
//  Copyright (c) 2015 Gopi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Place;

@interface LocationDetailVC : UITableViewController
@property (strong, nonatomic) Place *selectedPlace;

- (IBAction)FavAction:(id)sender;
@end
