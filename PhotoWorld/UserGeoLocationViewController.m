//
//  UserGeoLocationViewController.m
//  PhotoWorld
//
//  Created by Paul on 08.07.16.
//  Copyright © 2016 Paul. All rights reserved.
//

#import "UserGeoLocationViewController.h"
@import GoogleMaps;

@interface UserGeoLocationViewController () {
    GMSMapView *mapView;
}

@end

@implementation UserGeoLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makingCoordinates];
  //  NSLog(@"%@", [WebServiceManager sharedInstance].userMediaDictionary);
    
}

- (void)setCameraAndMapViewOfGoogleMaps: (double)Latitude andWith: (double)Longitude  {
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:Latitude
                                                            longitude:Longitude
                                                                 zoom:12];
    mapView = [GMSMapView mapWithFrame:self.view.frame camera:camera];
    mapView.myLocationEnabled = YES;
    self.view = mapView;
    for (int i = 0; i < _resultArray.count; i++) {
        NSMutableDictionary *indexDict = _resultArray[i];
        double lat = [[indexDict valueForKeyPath:@"location.latitude"] doubleValue];
        double lon = [[indexDict valueForKeyPath:@"location.longitude"] doubleValue];
        [self makeMarkersWithLatitude:lat andWithLongitude:lon withUrlIndex:i];
    }
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
//                                   marker.appearAnimation = kGMSMarkerAnimationPop;
                                   marker.map = mapView;
                                });
                               }
                           }];
    
    NSLog(@"%@", _resultArray);
}

@end
