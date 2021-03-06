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
#import "UserPhotoDetailViewController.h"

#define DEFAULT_MAP_ZOOM 12
#define DEFAULT_MARKER_ZOOM 15
#define DEFAULT_OFFSET 8
static NSString *CellIdentifier = @"userViewOffMap";
static NSString *headerReusView = @"UserGeoCollectionReusableView";
static NSString *segueID = @"userPhotodetail";
@interface UserGeoLocationViewController () {
    GMSMapView *myMapView;
}
@property (strong, nonatomic) UIView *emptyCalloutView;
typedef void(^myCompletion)(BOOL);
@end

@implementation UserGeoLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setGMSData];
    [self setCollectionViewData];
    [self makingCoordinates];
    [self setCollectionViewDisappear];
  //  NSLog(@"%@", [WebServiceManager sharedInstance].userMediaDictionary);
    
}
-(BOOL)prefersStatusBarHidden{
    return YES;
}
- (void)setCollectionViewData {
    [_userCollectionViewOffMap setDataSource:self];
    [_userCollectionViewOffMap setDelegate:self];
    _userCollectionViewOffMap.backgroundColor = [UIColor whiteColor];
    _userCollectionViewOffMap.layer.cornerRadius = 3;
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([UserGeoCollectionReusableView class]) bundle:[NSBundle mainBundle]];
    [_userCollectionViewOffMap registerNib:nib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerReusView];
   
}

- (void)setGMSData {
    myMapView.delegate = self;
    _defaultZoom = 12;
    _emptyCalloutView = nil;
}

- (void)setCollectionViewDisappear {
    _viewOfCollectionView.frame = self.view.bounds;
    [CATransaction begin];
    [CATransaction setValue:[NSNumber numberWithFloat: 0.5f] forKey:kCATransactionAnimationDuration];
    [CATransaction setCompletionBlock:^{
        _viewOfCollectionView.clipsToBounds = YES;
        _viewOfCollectionView.hidden = YES;
    }];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDelay:.1f];
    [UIView setAnimationDuration:0.4f];
    _viewOfCollectionView.frame = CGRectMake(self.view.center.x, self.view.center.y, 0, 0);
    [UIView commitAnimations];
    [CATransaction commit]; //Transaction controling animation with completion block (self idea)
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
            [dict setObject:[array[i] valueForKeyPath:@"images.thumbnail.url"] forKey:@"thumbnails_url"];
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
    NSString *imageUrlString = [_resultArray[IndexUrl] valueForKey:@"thumbnails_url"];
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
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDelay:.2f];
    [UIView setAnimationDuration:0.3f];
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
- (BOOL) tracksViewChanges {
    return NO;
}
- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
        [myMapView setSelectedMarker:marker];

    return YES;
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
    [returnButton addTarget:self action:@selector(goToDetailedViewController) forControlEvents:UIControlEventTouchUpInside];
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
}
- (void)hideMapButtons {
    _backButtonOutlet.hidden = YES;
    _zoomInButton.hidden = YES;
    _zoomOut.hidden = YES;
    _collectionViewButton.hidden = YES;
}

-(void) myMethod:(myCompletion) compblock{
    NSMutableDictionary * location = [myMapView.selectedMarker.userData objectForKey:@"location"];
//    NSLog(@"%@", location);
    double latitude = [[location objectForKey:@"latitude"] floatValue];
    double longitude = [[location objectForKey:@"longitude"] floatValue];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:latitude
                                                            longitude:longitude
                                                                 zoom:DEFAULT_MARKER_ZOOM];
    _defaultZoom = DEFAULT_MARKER_ZOOM;
    [CATransaction begin];
    [CATransaction setValue:[NSNumber numberWithFloat: 0.5f] forKey:kCATransactionAnimationDuration];
    [CATransaction setCompletionBlock:^{
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
    [[_viewForDetailedPhoto subviews]
     makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _viewForDetailedPhoto.frame = CGRectMake(self.view.center.x, self.view.center.y, 0, 0);
    _viewForDetailedPhoto.clipsToBounds = YES;
    _viewForDetailedPhoto.hidden = YES;
    [self allButonsAppear];
   // NSLog(@"%@", _viewForDetailedPhoto);
     }
- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker {
    NSDictionary *dict = myMapView.selectedMarker.userData;
    NSString *string = [dict valueForKey:@"image_url"];
    NSURL *url = [NSURL URLWithString:string];
    SDWebImageDownloader *downloader = [SDWebImageDownloader sharedDownloader];
    [downloader downloadImageWithURL: url
                             options:0
                            progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                            }
                           completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                               if (image && finished) {
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       UIImageView *markerView = [[UIImageView alloc] initWithImage:image];
                                       markerView.layer.borderWidth = 5.0;
                                       markerView.layer.borderColor = [UIColor whiteColor].CGColor;
                                       [self myMethod:^(BOOL finished) {
                                           if(finished){
                                               double delayInSeconds = 0.1;
                                               dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                                               dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                                                   [self deatailedViewOfTappedMarker:markerView andPhotoData:string];
                                                   
                                               });
                                           }
                                       }];
                                       
                                   });
                               }
                           }];
    
    return self.emptyCalloutView;
}
- (void)allButonsAppear {
    _backButtonOutlet.hidden = NO;
    _zoomInButton.hidden = NO;
    _zoomOut.hidden = NO;
    _collectionViewButton.hidden = NO;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width - 2*DEFAULT_OFFSET;
        float cellWidth = screenWidth / 3.0 - 1;
        CGSize size = CGSizeMake(cellWidth, cellWidth);
        return size;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 1;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([WebServiceManager sharedInstance].userPhotoUrlArray) {
        return [WebServiceManager sharedInstance].userPhotoUrlArray.count;
    } else
        return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UserCollectionViewCell *cell = (UserCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell setMyGeoImageForKey:indexPath.row];
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *view = [_userCollectionViewOffMap dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerReusView forIndexPath:indexPath];
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UserGeoCollectionReusableView *header = (UserGeoCollectionReusableView *)view;
        [header.closeButton addTarget:self action:@selector(setCollectionViewDisappear) forControlEvents:UIControlEventTouchUpInside];
        [header setNumberOfPublications];
}
    return  view;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(self.view.frame.size.width - 2*DEFAULT_OFFSET, 44);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"tapped %lu", indexPath.row);
    [self goToDetailedViewControllerWithPhotoIndex:indexPath.row];
}
- (void)goToDetailedViewControllerWithPhotoIndex: (float)Index{
    _parentVC.segueDataString = [NSString stringWithFormat:@"%f",Index];
     [self.parentVC goToDetaileddata];
    [self dismissViewControllerAnimated:NO completion:nil];

}
- (void)goToDetailedViewController {
    NSDictionary *dict = myMapView.selectedMarker.userData;
    NSString *string = [dict valueForKey:@"index"];
    _parentVC.segueDataString = string;
    [self.parentVC goToDetaileddata];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
