//
//  TRNMapViewController.m
//  TicketManager
//
//  Created by Javier Querol Morata on 3/10/14.
//  Copyright (c) 2014 treeNovum. All rights reserved.
//

#import "TRNMapViewController.h"
#import <MapKit/MapKit.h>
#import <TSMessage.h>

@interface TRNMapViewController ()
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *spin;
@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@end

@implementation TRNMapViewController

- (IBAction)dismissMap:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setLocationString:(NSString *)locationString {
    if (!_locationString) {
        _locationString = locationString;
        
        self.title = locationString;
        [self showLocationString:locationString];
    }
}

- (void)showLocationString:(NSString *)locationString {
    locationString = [[NSString alloc] initWithData:[locationString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES] encoding:NSASCIIStringEncoding];
    CLGeocoder *geocoder = [CLGeocoder new];
    [geocoder geocodeAddressString:locationString completionHandler:^(NSArray *placemarks, NSError *error) {
        [self.spin stopAnimating];
        if (!error) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            CLLocation *myLocation = [[CLLocation alloc] initWithLatitude:placemark.location.coordinate.latitude longitude:placemark.location.coordinate.longitude];
            MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
            annotation.coordinate = myLocation.coordinate;
            
            [self.mapView addAnnotation:annotation];
//            self.mapView.showsUserLocation = YES;
            
            MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 1500, 1500);
            [self.mapView setRegion:region animated:YES];
        } else {
            [TSMessage showNotificationInViewController:self title:@"Error" subtitle:NSLocalizedString(@"Cannot find location", nil) type:TSMessageNotificationTypeWarning];
        }
    }];
}

@end
