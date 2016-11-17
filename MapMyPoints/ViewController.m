//
//  ViewController.m
//  MapMyPoints
//
//  Created by Ekaterina Krasnova on 07.02.16.
//  Copyright © 2016 Ekaterina Krasnova. All rights reserved.
//

#import "ViewController.h"
#import "MapKit/MapKit.h"

@interface ViewController () <MKMapViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) MKPointAnnotation *luciAnno;
@property (strong, nonatomic) MKPointAnnotation *wiclAnno;
@property (strong, nonatomic) MKPointAnnotation *gradientAnno;
@property (strong, nonatomic) MKPointAnnotation *currentAnno;


@property (weak, nonatomic) IBOutlet UISwitch *switchField;

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (nonatomic, assign) BOOL mapIsMoving;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
    
    self.mapIsMoving = NO;
    
    [self addAnnotations];
}

- (IBAction)luciTapped:(id)sender {
    [self centerMap:self.luciAnno];
}

- (IBAction)wiclTapped:(id)sender {
    [self centerMap:self.wiclAnno];
}

- (IBAction)gradientTapped:(id)sender {
    [self centerMap:self.gradientAnno];

}

- (void)centerMap:(MKPointAnnotation *)centerPoint {
    [self.mapView setCenterCoordinate:centerPoint.coordinate animated:YES];
}

- (IBAction)switchChanged:(id)sender {
    if (self.switchField.isOn) {
        self.mapView.showsUserLocation = YES;
        [self.locationManager startUpdatingLocation];
    }
    else {
        self.mapView.showsUserLocation = NO;
        [self.locationManager stopUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    self.currentAnno.coordinate = locations.lastObject.coordinate;
    
    if (self.mapIsMoving == NO) {
        [self centerMap:self.currentAnno];
    }
}

- (void)addAnnotations {
    self.luciAnno = [[MKPointAnnotation alloc]init];
    self.luciAnno.coordinate = CLLocationCoordinate2DMake(33.6432094, -117.8439953);
    self.luciAnno.title = @"Laboratory for Ubiquitous Computing and Interaction";
    
    self.wiclAnno = [[MKPointAnnotation alloc]init];
    self.wiclAnno.coordinate = CLLocationCoordinate2DMake(34.448795, -119.6646337);
    self.wiclAnno.title = @"Westmond Inspired Computing Lab";
    
    self.gradientAnno = [[MKPointAnnotation alloc]init];
    self.gradientAnno.coordinate = CLLocationCoordinate2DMake(40.677623, -73.993583);
    self.gradientAnno.title = @"Gradient LLC";
    
    self.currentAnno = [[MKPointAnnotation alloc]init];
    self.currentAnno.coordinate = CLLocationCoordinate2DMake(0.0, 0.0);
    self.currentAnno.title = @"My Location";
    
    [self.mapView addAnnotations:@[self.luciAnno, self.wiclAnno, self.gradientAnno]];
}

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
    self.mapIsMoving = YES;
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    self.mapIsMoving = NO;
}

@end
