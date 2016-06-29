//
//  UserHeaderCollectionReusableView.h
//  PhotoWorld
//
//  Created by Paul on 27.06.16.
//  Copyright © 2016 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserHeaderCollectionReusableView : UICollectionReusableView
@property (strong, nonatomic) IBOutlet UIImageView *avatar;
@property (strong, nonatomic) IBOutlet UILabel *bio;
@property (strong, nonatomic) IBOutlet UILabel *fullName;
@property (strong, nonatomic) IBOutlet UILabel *media;
@property (strong, nonatomic) IBOutlet UILabel *follows;
@property (strong, nonatomic) IBOutlet UILabel *followedBy;
@property (strong, nonatomic) IBOutlet UIButton *redactionButton;
- (void) setDataBio: (NSString *)bio setFullName: (NSString *)fullName setMedia:(NSInteger)media setFollows:(NSInteger)follows setFoolowedBy: (NSInteger)followedBy;
- (void)setButtonCorners;
- (void)avatarAppear;



@end
