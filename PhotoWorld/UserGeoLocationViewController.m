//
//  UserGeoLocationViewController.m
//  PhotoWorld
//
//  Created by Paul on 08.07.16.
//  Copyright © 2016 Paul. All rights reserved.
//

#import "UserGeoLocationViewController.h"
#import "UserInfoViewController.h"
#import "WebServiceManager.h"
#import <QuartzCore/QuartzCore.h>
@import GoogleMaps;

@interface UserGeoLocationViewController () {
    GMSMapView *mapView;
}

@end

@implementation UserGeoLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makingCoordinates];
    [self setCollectionViewAppear];
  //  NSLog(@"%@", [WebServiceManager sharedInstance].userMediaDictionary);
    
}

- (void)setCollectionViewAppear {
    
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [self.view addSubview:_viewOfCollectionView];
    _viewOfCollectionView.layer.frame = CGRectMake(1, 1, 1, 1);
    _viewOfCollectionView.frame = CGRectMake(1, 1, 1, 1);
//    _viewOfCollectionView.layer.frame.size = CGSizeZero;
    _viewOfCollectionView.clipsToBounds = YES;
}

- (void)setCameraAndMapViewOfGoogleMaps: (double)Latitude andWith: (double)Longitude  {
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:Latitude
                                                            longitude:Longitude
                                                                 zoom:12];
    mapView = [GMSMapView mapWithFrame:self.view.frame camera:camera];
    mapView.myLocationEnabled = YES;
    [self.view addSubview:mapView];
    [self setAllButtons];
    for (int i = 0; i < _resultArray.count; i++) {
        NSMutableDictionary *indexDict = _resultArray[i];
        double lat = [[indexDict valueForKeyPath:@"location.latitude"] doubleValue];
        double lon = [[indexDict valueForKeyPath:@"location.longitude"] doubleValue];
        [self makeMarkersWithLatitude:lat andWithLongitude:lon withUrlIndex:i];
    }
}

- (void)setAllButtons {
    NSString *dict = [[WebServiceManager sharedInstance].userDataDictionary valueForKeyPath:@"data.full_name"];
    [_backButtonOutlet setTitle:dict forState:UIControlStateNormal];
    _backButtonOutlet = (UIButton *)[self roundCornersOnView:_backButtonOutlet onTopLeft:YES topRight:NO bottomLeft:YES bottomRight:NO radius:10];
    _zoomInButton = (UIButton *)[self setLayerOfButton:_zoomInButton];
    _zoomOut = (UIButton *)[self setLayerOfButton:_zoomOut];
    _collectionViewButton = (UIButton *)[self setLayerOfButton:_collectionViewButton];
    [self.view addSubview:_backButtonOutlet];
    [self.view addSubview:_zoomOut];
    [self.view addSubview:_zoomInButton];
    [self.view addSubview:_collectionViewButton];
}

- (void)makingCoordinates {
    NSMutableArray *array = [[WebServiceManager sharedInstance].userMediaDictionary valueForKey:@"data"];
    _resultArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < array.count; i ++) {
        NSMutableDictionary  *dict = [[NSMutableDictionary alloc] init];
        if (!([array[i] valueForKey:@"location"] == [NSNull null])) {
            [dict setObject:[array[i] valueForKey:@"location"] forKey:@"location"];
            [dict setObject:[array[i] valueForKeyPath:@"images.thumbnail.url"] forKey:@"image_url"];
            [_resultArray addObject:dict];
        }
    }
    NSMutableDictionary * location = [_resultArray[0] objectForKey:@"location"];
    double latitude = [[location objectForKey:@"latitude"] floatValue];
    double longitude = [[location objectForKey:@"longitude"] floatValue];
    [self setCameraAndMapViewOfGoogleMaps:latitude andWith:longitude];
    
}
- (void)makeMarkersWithLatitude: (double)Latitude andWithLongitude: (double)Longitude withUrlIndex: (int)IndexUrl {
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(Latitude, Longitude);
    NSString *imageUrlString = [_resultArray[IndexUrl] valueForKey:@"image_url"];
    SDWebImageDownloader *downloader = [SDWebImageDownloader sharedDownloader];
    NSURL *url = [NSURL URLWithString:imageUrlString];
    [downloader downloadImageWithURL: url
                             options:0
                            progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                            }
                           completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                               if (image && finished) {
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   UIImageView *markeView = [[UIImageView alloc] initWithImage:image];
                                   markeView.frame = CGRectMake(0, 0, 50, 50);
                                   markeView.layer.borderWidth = 4.0;
                                   markeView.layer.borderColor = [UIColor whiteColor].CGColor;
                                   markeView.layer.cornerRadius = 5;
                                   markeView.clipsToBounds = YES;
                                   marker.iconView = markeView;
                                   marker.map = mapView;
                                   marker.appearAnimation = kGMSMarkerAnimationPop;
                                });
                               }
                           }];
    
}

- (IBAction)returnToPreviousView: (id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (IBAction)showCollectionView:(id)sender {
    _viewOfCollectionView.frame = CGRectMake(0, 0, self.view.frame.size.width , self.view.frame.size.height);
  
}

- (IBAction)zoomIn:(id)sender {
}

- (IBAction)zoomOut:(id)sender {
}
- (UIView *)roundCornersOnView:(UIView *)view onTopLeft:(BOOL)tl topRight:(BOOL)tr bottomLeft:(BOOL)bl bottomRight:(BOOL)br radius:(float)radius
{
    if (tl || tr || bl || br) {
        UIRectCorner corner = 0;
        if (tl) corner = corner | UIRectCornerTopLeft;
        if (tr) corner = corner | UIRectCornerTopRight;
        if (bl) corner = corner | UIRectCornerBottomLeft;
        if (br) corner = corner | UIRectCornerBottomRight;
        
        UIView *roundedView = view;
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:roundedView.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(radius, radius)];
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = roundedView.bounds;
        maskLayer.path = maskPath.CGPath;
        roundedView.layer.mask = maskLayer;
        
        return roundedView;
    }
    return view;
}

- (UIView *)setLayerOfButton: (UIView *)view {
    UIView *layerButton = view;
    layerButton.layer.shadowColor = [UIColor grayColor].CGColor;
    layerButton.layer.shadowOpacity = 0.8;
    layerButton.layer.shadowRadius = 2.0;
    layerButton.layer.shadowOffset = CGSizeMake(0.0, 2.0);
    layerButton.layer.cornerRadius = 2;
    return layerButton;
}
@end
