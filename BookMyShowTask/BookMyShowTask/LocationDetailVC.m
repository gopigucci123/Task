//
//  LocationDetailVC.m
//  BookMyShowTask
//
//  Created by Gopi on 10/09/15.
//  Copyright (c) 2015 Gopi. All rights reserved.
//

#import "LocationDetailVC.h"
#import "DBManager.h"

#import "Place.h"
#import <CoreLocation/CoreLocation.h>
#import "MapKitVC.h"

@interface LocationDetailVC ()
{
    NSString *address;
    NSString *city;
    NSString *state;
    NSString *zip;
}
@property (weak, nonatomic) IBOutlet UIView *tableHeaderView;
@property (weak, nonatomic) IBOutlet UIImageView *placeReferenceImageView;

@property (weak, nonatomic) IBOutlet UILabel *placeNameLable;
@property (weak, nonatomic) IBOutlet UILabel *placeAddressLabel;
@property (weak, nonatomic) IBOutlet UIButton *favButton;
- (IBAction)favouriteButtonTapped:(id)sender;


@end

@implementation LocationDetailVC


- (void)viewDidLoad
{
    [super viewDidLoad];

    if (self.selectedPlace.placePhotos.count) {
        [(PlacePhoto*)self.selectedPlace.placePhotos[0] getImageObjectWithCompletionBlock:^(NSData *data) {
            self.placeReferenceImageView.image = [UIImage imageWithData:data];
        }];
    }
    
    self.clearsSelectionOnViewWillAppear = NO;

    self.placeNameLable.text = self.selectedPlace.name;
    self.placeAddressLabel.text = self.selectedPlace.vicinity;
    //self.LocationLat.text = self.selectedPlace.geometry.latitude;
    //self.LocationLong.text = self.selectedPlace.geometry.longitude;
    //self.LocationAddress.text = LocationAddressSTR;


    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    CLLocation *newLocation = [[CLLocation alloc]initWithLatitude:self.selectedPlace.geometry.latitude.floatValue
                                                        longitude:self.selectedPlace.geometry.longitude.floatValue];
    
    [geocoder reverseGeocodeLocation:newLocation
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       
                       if (error) {
                           NSLog(@"Geocode failed with error: %@", error);
                           return;
                       }
                       
                       if (placemarks && placemarks.count > 0)
                       {
                           CLPlacemark *placemark = placemarks[0];
                           
                           NSDictionary *addressDictionary =
                           placemark.addressDictionary;
                           
                           NSLog(@"%@ ", addressDictionary);
                           address = [[addressDictionary
                                                objectForKey:@"FormattedAddressLines"] componentsJoinedByString:@","];
                           city = [addressDictionary
                                             objectForKey:@"City"];
                           state = [addressDictionary
                                              objectForKey:@"State"];
                           zip = [addressDictionary
                                            objectForKey:@"ZIP"];
                           
                           
                           NSLog(@"%@ %@ %@ %@", address,city, state, zip);
                       }
                       
                       [self.tableView reloadData];
                       
                   }];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (IBAction)FavAction:(UIButton *)sender
{
    sender.selected = !sender.selected;

}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 6;
}


 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
     cell.accessoryType=UITableViewCellAccessoryNone;
     cell.selectionStyle=UITableViewCellSelectionStyleNone;
     cell.textLabel.numberOfLines=0;
     switch (indexPath.row) {
         case 0:
             cell.textLabel.text=address;
             break;
         case 1:
             cell.textLabel.text=city;
             break;
         case 2:
             cell.textLabel.text=state;
             break;
         case 3:
             cell.textLabel.text=zip;
             break;
         case 4:{
             cell.textLabel.text=@"View on Map";
             cell.accessoryType=UITableViewCellAccessoryDetailDisclosureButton;
             cell.selectionStyle=UITableViewCellSelectionStyleBlue;
         }
             break;

         default:
             break;
     }
 
 // Configure the cell...
 
 return cell;
 }

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return 85.0;
    }
    
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MapKitVC *DetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MapKitID"];
    DetailVC.selectedPlace=self.selectedPlace;
    [self.navigationController pushViewController:DetailVC animated:YES];
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)favouriteButtonTapped:(id)sender {
    NSLog(@"%s",__FUNCTION__);
    //Check if favourite and update the button image aswell as database
    [self.favButton setImage:[UIImage imageNamed:@"fav-like.png"] forState:UIControlStateNormal];
    [DBManager initializedatabase];

    [DBManager SaveLocation:self.selectedPlace.pid LocationName:self.selectedPlace.name LocationAddress:address LocationLat:self.selectedPlace.geometry.latitude LocationLong:self.selectedPlace.geometry.longitude];

}
@end
