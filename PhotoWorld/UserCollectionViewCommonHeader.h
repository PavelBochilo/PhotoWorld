//
//  UserCollectionViewCommonHeader.h
//  PhotoWorld
//
//  Created by Paul on 06.07.16.
//  Copyright © 2016 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServiceManager.h"

@interface UserCollectionViewCommonHeader : UICollectionReusableView
@property (strong, nonatomic) IBOutlet UIImageView *userAvatar;
@property (strong, nonatomic) IBOutlet UILabel *userName;
- (void)avatarAppear;
-(void)setUserNameLabelWithName: (NSString *)name;
@end
