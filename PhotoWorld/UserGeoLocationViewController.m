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
#define DEFAULT_MAP_ZOOM 12

@interface UserGeoLocationViewController () {
    GMSMapView *myMapView;
}
@property (strong, nonatomic) UIView *emptyCalloutView;
typedef void(^myCompletion)(BOOL);
@end

@implementation UserGeoLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    myMapView.delegate = self;
    _defaultZoom = 12;
    _emptyCalloutView = nil;
    [self makingCoordinates];
    [self setCollectionViewDisappear];
    [_testButton addTarget:self action:@selector(tapped) forControlEvents:UIControlEventTouchUpInside];
  //  NSLog(@"%@", [WebServiceManager sharedInstance].userMediaDictionary);
    
}
- (void)tapped {
    NSLog(@"taapped");
    if (myMapView.selectedMarker != nil) {
        NSLog(@"taapped");
    }
}
- (void)setCollectionViewDisappear {
    _viewOfCollectionView.clipsToBounds = YES;
    _viewOfCollectionView.hidden = YES;
    _viewOfCollectionView.frame = CGRectMake(self.view.center.x, self.view.center.y, 0, 0);
    _viewForDetailedPhoto.clipsToBounds = YES;
    _viewForDetailedPhoto.hidden = YES;
    _viewForDetailedPhoto.frame = CGRectMake(self.view.center.x, self.view.center.y, 0, 0);
}
-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
}

- (void)setCameraAndMapViewOfGoogleMaps: (double)Latitude andWith: (double)Longitude  {
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:Latitude
                                                            longitude:Longitude
                                                                 zoom:DEFAULT_MAP_ZOOM];
    [myMapView removeFromSuperview];
    myMapView = [GMSMapView mapWithFrame:self.view.frame camera:camera];
    myMapView.myLocationEnabled = YES;
    [_viewForMap addSubview: myMapView];
    myMapView.delegate = self;
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
}

- (void)makingCoordinates {
    NSMutableArray *array = [[WebServiceManager sharedInstance].userMediaDictionary valueForKey:@"data"];
    _resultArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < array.count; i ++) {
        NSMutableDictionary  *dict = [[NSMutableDictionary alloc] init];
        if (!([array[i] valueForKey:@"location"] == [NSNull null])) {
            [dict setObject:[array[i] valueForKey:@"location"] forKey:@"location"];
            [dict setObject:[array[i] valueForKeyPath:@"images.standard_resolution.url"] forKey:@"image_url"];
            NSNumber *index = [NSNumber numberWithInt:i];
            [dict setObject:index forKey:@"index"];
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
                                   _testButton.frame = marker.iconView.frame;
                                   [marker.iconView insertSubview:_testButton aboveSubview:marker.iconView];
                                   [marker.iconView addSubview:_testButton];
                                   [_testButton addTarget:self action:@selector(tapped) forControlEvents:UIControlEventTouchUpInside];
                                   marker.userData = _resultArray[IndexUrl];
                                   marker.map = myMapView;
                                });
                               }
                           }];
    
}

- (IBAction)returnToPreviousView: (id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (IBAction)showCollectionView:(id)sender {
   _viewOfCollectionView.frame = CGRectMake(self.view.center.x, self.view.center.y, 0, 0);
    _viewOfCollectionView.hidden = NO;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelay:.2f];
    [UIView setAnimationDuration:0.2f];
    _viewOfCollectionView.frame = self.view.bounds;
    [UIView commitAnimations];
    _viewOfCollectionView.frame = self.view.bounds;
}

- (IBAction)zoomIn:(id)sender {
    _defaultZoom = _defaultZoom + 1;
    GMSCameraUpdate *update = [GMSCameraUpdate zoomTo:_defaultZoom];
    [myMapView animateWithCameraUpdate:update];
}

- (IBAction)zoomOut:(id)sender {
    _defaultZoom = _defaultZoom - 1;
    GMSCameraUpdate *update = [GMSCameraUpdate zoomTo:_defaultZoom];
    [myMapView animateWithCameraUpdate:update];
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
- (IBAction)hideView:(id)sender {
    [self setCollectionViewDisappear];
    NSLog(@"result== %@", _resultArray);
}
- (void)addTapToImage: (UIView *)image withLabelIndex: (int)index {
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] init];
    [tapRecognizer setNumberOfTapsRequired:1];
    [image addGestureRecognizer:tapRecognizer];
    image.userInteractionEnabled = YES;
    if (tapRecognizer.numberOfTouches == 1) {
        NSLog(@"tapped");
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDelay:.2f];
        [UIView setAnimationDuration:0.2f];
        image.frame = CGRectMake(10, self.view.frame.size.height/2 - (self.view.frame.size.width - 10)/2, self.view.frame.size.width - 10, self.view.frame.size.width - 10);
        [UIView commitAnimations];
    }

}

- (BOOL) tracksViewChanges {
    return NO;
}
- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
        [myMapView setSelectedMarker:marker];
    
//        UIView *markerView = [[UIView alloc] init];
//        markerView = myMapView.selectedMarker.iconView;
//        marker.iconView = markerView;
//        NSString *string = myMapView.selectedMarker.userData;
//        [self myMethod:^(BOOL finished) {
//            if(finished){
//                double delayInSeconds = 0.1;
//                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//                    [self deatailedViewOfTappedMarker:markerView andPhotoData:string];
//                    
//                });
//         }
//        }];
    return YES;
}
- (BOOL) panoramaView:		(GMSPanoramaView *) 	panoramaView
         didTapMarker:		(GMSMarker *) 	marker {
    return NO;
}
- (void)deatailedViewOfTappedMarker:(UIView *)marker andPhotoData: (NSString *)data {
    [self hideMapButtons];
    _viewForDetailedPhoto.frame = CGRectMake(self.view.center.x, self.view.center.y, 0, 0);
    _viewForDetailedPhoto.backgroundColor = [UIColor clearColor];
    _viewForDetailedPhoto.alpha = 1.0;
    _viewForDetailedPhoto.hidden = NO;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelay:.3f];
    [UIView setAnimationDuration:0.4f];
    _viewForDetailedPhoto.frame = self.view.frame;
    UIView *view = [[UIView alloc] initWithFrame:self.view.frame];
    view.backgroundColor = [UIColor grayColor];
    view.alpha = 0.7;
    [_viewForDetailedPhoto addSubview:view];
    [UIView commitAnimations];
    [_viewForDetailedPhoto superview];
    UIView *markerView = [[UIView alloc] init];
    markerView = marker;
    markerView.frame = CGRectMake(_viewForDetailedPhoto.center.x, _viewForDetailedPhoto.center.y, 0, 0);
    markerView.alpha = 1;
    markerView.backgroundColor = [UIColor whiteColor];
    [_viewForDetailedPhoto insertSubview:markerView aboveSubview:_viewForDetailedPhoto];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelay:.1f];
    [UIView setAnimationDuration:0.8f];
    markerView.frame = CGRectMake(10, _viewForDetailedPhoto.frame.size.height/2 - (_viewForDetailedPhoto.frame.size.width - 10)/2, _viewForDetailedPhoto.frame.size.width - 20, _viewForDetailedPhoto.frame.size.width - 20);
    [UIView commitAnimations];
    UIButton *returnButton = [[UIButton alloc] init];
    CGFloat coordinate = (_viewForDetailedPhoto.frame.size.height/2 - (_viewForDetailedPhoto.frame.size.width - 10)/2) + _viewForDetailedPhoto.frame.size.width;
    [self setButtonData:returnButton withFloat:coordinate];
    [self addTapToView:_viewForDetailedPhoto];
    [_viewForDetailedPhoto insertSubview:returnButton aboveSubview:_viewForDetailedPhoto];
}

- (void)setButtonData: (UIButton *)button withFloat: (CGFloat)coordinate  {
    button.frame = CGRectMake(self.view.frame.size.width*3/4 + self.view.frame.size.width*1/8, coordinate, 30, 30);
    button.layer.cornerRadius = button.frame.size.width/2;
    button.backgroundColor = [UIColor whiteColor];
    button.clipsToBounds = YES;
    [button setTitle:@"" forState:UIControlStateNormal];
    UIImageView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"info"]];
    view.frame = CGRectMake(5, 5, 20, 20);
    [button addSubview:view];
   // [button setImage:[UIImage imageNamed:@"info"] forState:UIControlStateNormal];

}
- (void)hideMapButtons {
    _backButtonOutlet.hidden = YES;
    _zoomInButton.hidden = YES;
    _zoomOut.hidden = YES;
    _collectionViewButton.hidden = YES;
}

-(void) myMethod:(myCompletion) compblock{
    NSMutableDictionary * location = [myMapView.selectedMarker.userData objectForKey:@"location"];
    NSLog(@"%@", location);
    double latitude = [[location objectForKey:@"latitude"] floatValue];
    double longitude = [[location objectForKey:@"longitude"] floatValue];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:latitude
                                                            longitude:longitude
                                                                 zoom:15];
    
    [CATransaction begin];
    [CATransaction setValue:[NSNumber numberWithFloat: 0.5f] forKey:kCATransactionAnimationDuration];
    [CATransaction setCompletionBlock:^{
        //[myMapView removeFromSuperview]; solve printing bug issue ofGoogle maps, but remove map.
        //
        compblock(YES);
    }];
   [myMapView animateToCameraPosition:camera];
    [CATransaction commit];
}
- (GMSFrameRate)preferredFrameRate {
    return kGMSFrameRateMaximum;
}
- (void)addTapToView: (UIView *)viewWithPhoto {
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] init];
    [tapRecognizer setNumberOfTapsRequired:1];
    [viewWithPhoto addGestureRecognizer:tapRecognizer];
    viewWithPhoto.userInteractionEnabled = YES;
    [tapRecognizer addTarget:self action:@selector(returnToGoogleMap)];
}
     
- (void)returnToGoogleMap {
    [_viewForDetailedPhoto removeFromSuperview];
    _viewForDetailedPhoto = nil;
    _viewForDetailedPhoto = [[UIView alloc] init];
    _viewForDetailedPhoto.frame = CGRectMake(self.view.center.x, self.view.center.y, 0, 0);
    _viewForDetailedPhoto.clipsToBounds = YES;
    _viewForDetailedPhoto.hidden = YES;
    NSLog(@"%@", _viewForDetailedPhoto);
     }
- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker {
    UIView *markerView = [[UIView alloc] init];
            markerView = myMapView.selectedMarker.iconView;
            marker.iconView = markerView;
            NSString *string = myMapView.selectedMarker.userData;
            [self myMethod:^(BOOL finished) {
                if(finished){
                    double delayInSeconds = 0.1;
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        [self deatailedViewOfTappedMarker:markerView andPhotoData:string];
    
                    });
             }
            }];
    return self.emptyCalloutView;
}

@end
