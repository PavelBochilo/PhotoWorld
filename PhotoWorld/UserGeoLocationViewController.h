//
//  UserGeoLocationViewController.h
//  PhotoWorld
//
//  Created by Paul on 08.07.16.
//  Copyright © 2016 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServiceManager.h"


@interface UserGeoLocationViewController : UIViewController
@property (nonatomic, strong) NSMutableArray *resultArray;
@property (weak, nonatomic) IBOutlet UIButton *backButtonOutlet;
- (IBAction)returnToPreviousView:(id)sender;
- (IBAction)showCollectionView:(id)sender;
- (IBAction)zoomIn:(id)sender;
- (IBAction)zoomOut:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewOfCollectionView;
@property (strong, nonatomic) IBOutlet UIButton *collectionViewButton;
@property (strong, nonatomic) IBOutlet UIButton *zoomInButton;
@property (strong, nonatomic) IBOutlet UIButton *zoomOut;

@end
