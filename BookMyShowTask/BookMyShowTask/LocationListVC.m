//
//  LocationListVC.m
//  BookMyShowTask
//
//  Created by Gopi on 10/09/15.
//  Copyright (c) 2015 Gopi. All rights reserved.
//

#import "LocationListVC.h"
#import "LocationListCell.h"

#import "LocationDetailVC.h"
#import "CLLocationManager+blocks.h"

#import "Place.h"

@interface LocationListVC ()
@property (nonatomic, strong) NSMutableArray *LocationsArray;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@property (nonatomic, strong) CLLocation *userLocation;
@property (nonatomic, strong) CLLocationManager *manager;

@end

@implementation LocationListVC

@synthesize CarryCategoryStr;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=[self.CarryCategoryStr uppercaseString];
    self.LocationsArray = [NSMutableArray array];
    [self updateLocation];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


-(void)updateLocation{
    _activityIndicatorView.hidden=NO;
    [_activityIndicatorView startAnimating];


    self.manager = [CLLocationManager updateManagerWithAccuracy:50.0 locationAge:15.0 authorizationDesciption:CLLocationUpdateAuthorizationDescriptionWhenInUse];
    
    if ([CLLocationManager isLocationUpdatesAvailable]) {

        [self.manager startUpdatingLocationWithUpdateBlock:^(CLLocationManager *manager, CLLocation *location, NSError *error, BOOL *stopUpdating) {
            NSLog(@"Our new location: %@", location);
            *stopUpdating = YES;
            
            if (error) {
                NSString *outputText=[NSString stringWithFormat:@"Failed to retrieve location with error: %@", error];
                NSLog(@"%@", outputText);
            }

            self.userLocation = [location copy];
            dispatch_async(dispatch_get_main_queue(), ^{
                [_activityIndicatorView stopAnimating];

            });
            
            [self getNearLocations];

        }];
    }
}
- (void)getNearLocations
{
    NSString * UserLat = [NSString stringWithFormat:@"%f",_userLocation.coordinate.latitude];
    NSString * UserLong = [NSString stringWithFormat:@"%f",_userLocation.coordinate.longitude];
    
    
    //for near locations
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%@,%@&radius=100000&types=%@&sensor=true&key=AIzaSyBroCC5NHKPzai5A3odoEh4-dUvumTvWTc",UserLat,UserLong,CarryCategoryStr];
    NSLog(@"\n\n%@\n\n",url);
    NSURL *LocationsURL = [NSURL URLWithString:url];
    NSMutableURLRequest *requestforlocations = [[NSMutableURLRequest alloc] init];
    [requestforlocations setURL:LocationsURL];
    [requestforlocations setHTTPMethod:@"GET"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:requestforlocations queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
    {
        NSDictionary *jsonDataForLocations = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        
        NSMutableArray *LatLongArray = [jsonDataForLocations valueForKey:@"results"];
        
        [LatLongArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
            [self.LocationsArray addObject:[[Place alloc] initWithJsonData:obj]];
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.LocationListTableView reloadData];
        });
        

        
        NSLog(@"requestReply: %@", jsonDataForLocations);

    }];
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
     return self.LocationsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *staticidentifier=@"cell";
    
    LocationListCell *cell = [_LocationListTableView dequeueReusableCellWithIdentifier:staticidentifier];
    if (cell==nil)
    {
        NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"LocationListCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.LocationImage.image=nil;
    Place *plc = [self.LocationsArray objectAtIndex:indexPath.row];
    
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Place *plc = [self.LocationsArray objectAtIndex:indexPath.row];
    
    LocationDetailVC *DetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LocationDetailVC"];
    DetailVC.selectedPlace=plc;
    [self.navigationController pushViewController:DetailVC animated:YES];
    
   // DetailVC.CarryLocationDetils =
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
