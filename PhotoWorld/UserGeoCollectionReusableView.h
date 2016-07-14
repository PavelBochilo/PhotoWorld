//
//  UserGeoCollectionReusableView.h
//  PhotoWorld
//
//  Created by Paul on 14.07.16.
//  Copyright © 2016 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServiceManager.h"

@interface UserGeoCollectionReusableView : UICollectionReusableView
@property (strong, nonatomic) IBOutlet UIButton *closeButton;
@property (strong, nonatomic) IBOutlet UILabel *publicationOutlet;
- (void)setNumberOfPublications;

@end
