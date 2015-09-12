//
//  FavouritesVC.m
//  BookMyShowTask
//
//  Created by Gopi on 11/09/15.
//  Copyright (c) 2015 Gopi. All rights reserved.
//

#import "FavouritesVC.h"
#import "DBManager.h"
#import "LocationListCell.h"

#import "Place.h"

@interface FavouritesVC ()
{
    NSMutableArray *ListArray;
}

@end

@implementation FavouritesVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    
    ListArray = [[NSMutableArray alloc]init];
    
    [DBManager initializedatabase];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    ListArray = [DBManager GetFavouriteLocations];
    [self.FavouritesTableView reloadData];
}


#pragma mark TableView delegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ListArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *staticidentifier=@"cell";
    
    LocationListCell *cell = [_FavouritesTableView dequeueReusableCellWithIdentifier:staticidentifier];
    if (cell==nil)
    {
        NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"LocationListCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.LocationImage.image=nil;
    Place *plc = [ListArray objectAtIndex:indexPath.row];

    // cell.LocationImage.imageURL = [NSURL URLWithString:[[ListArray valueForKey:@"LocationImg_URL"]objectAtIndex:indexPath.row]];
    cell.LocationName_Label.text = plc.name;
    if(plc.placePhotos.count){
        PlacePhoto *photo = plc.placePhotos[0];
        
        [photo getImageObjectWithCompletionBlock:^(NSData *data) {
            
            LocationListCell *updateCell = (id)[tableView cellForRowAtIndexPath:indexPath];
            if (updateCell)
                updateCell.LocationImage.image = [UIImage imageWithData:data];
            else
                cell.LocationImage.image = [UIImage imageWithData:data];
        }];
    }
    
    return cell;
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end
