//
//  MapKitVC.m
//  BookMyShowTask
//
//  Created by Gopi on 10/09/15.
//  Copyright (c) 2015 Gopi. All rights reserved.
//

#import "MapKitVC.h"
#import "Place.h"



@interface MapViewAnnotation : NSObject <MKAnnotation>

@property (nonatomic,copy) NSString *title;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

-(id) initWithTitle:(NSString *) title AndCoordinate:(CLLocationCoordinate2D)coordinate;

@end

@implementation MapViewAnnotation

@synthesize coordinate=_coordinate;

@synthesize title=_title;

-(id) initWithTitle:(NSString *) title AndCoordinate:(CLLocationCoordinate2D)coordinate

{
    
    self = [super init];
    
    _title = title;
    
    _coordinate = coordinate;
    
    return self;
    
}

@end


@interface MapKitVC ()

@end

@implementation MapKitVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.MapView.delegate = self;
    
    //[self.MapView setShowsUserLocation:YES];

    CLLocationCoordinate2D coord;
    
    coord.latitude = self.selectedPlace.geometry.latitude.doubleValue;
    
    coord.longitude = self.selectedPlace.geometry.longitude.doubleValue;
    
    MapViewAnnotation *annotation = [[MapViewAnnotation alloc] initWithTitle:self.selectedPlace.name AndCoordinate:coord];
    [self.MapView addAnnotation:annotation];
}


#pragma mark - MKMapViewDelegate methods.
- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views
{
    CLLocationCoordinate2D coord;
    
    coord.latitude = self.selectedPlace.geometry.latitude.doubleValue;
    
    coord.longitude = self.selectedPlace.geometry.longitude.doubleValue;
    

    MKCoordinateRegion region;
    region = MKCoordinateRegionMakeWithDistance(coord,1000,1000);
    
    [mv setRegion:region animated:YES];
}




-(void) queryGooglePlaces: (NSString *) googleType
{

    NSString *UserLat = @"1.27";
    NSString *UserLong = @"103.79";
    
    NSString *CarryCategoryStr = @"food";
    
    //for near locations
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f,%f&radius=100000&types=%@&sensor=true&key=AIzaSyBroCC5NHKPzai5A3odoEh4-dUvumTvWTc",UserLat.floatValue,UserLong.floatValue,CarryCategoryStr];
    
    NSURL *LocationsURL = [NSURL URLWithString:url];
    NSMutableURLRequest *requestforlocations = [[NSMutableURLRequest alloc] init];
    [requestforlocations setURL:LocationsURL];
    [requestforlocations setHTTPMethod:@"GET"];
    
    NSURLResponse *requestResponseForLocations;
    NSData *requestHandlerForLocations = [NSURLConnection sendSynchronousRequest:requestforlocations returningResponse:&requestResponseForLocations error:nil];
    
    NSDictionary *jsonDataForLocations = [NSJSONSerialization JSONObjectWithData:requestHandlerForLocations options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"requestReply: %@", jsonDataForLocations);
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
