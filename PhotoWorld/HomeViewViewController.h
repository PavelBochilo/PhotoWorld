//
//  HomeViewViewController.h
//  PhotoWorld
//
//  Created by Paul on 22.06.16.
//  Copyright © 2016 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServiceManager.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <AVFoundation/AVFoundation.h>


@interface HomeViewViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *homeTableView;
-(UIImage *)resizeImage:(UIImage *)image;
@property (strong, nonatomic) NSMutableArray *rowHeights;
@property (nonatomic) CGFloat height;
- (IBAction)directButton:(id)sender;
@property (nonatomic, strong) AVPlayer *playerCellVideo;
@property (nonatomic, strong) AVPlayerLayer *playerCellVideoLayer;
@end
