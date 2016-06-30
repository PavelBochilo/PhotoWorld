//
//  WebServiceManager.m
//  PhotoWorld
//
//  Created by Paul on 20.06.16.
//  Copyright © 2016 Paul. All rights reserved.
//

#import "WebServiceManager.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation WebServiceManager



#pragma mark Singleton
+ (WebServiceManager *)sharedInstance {
    static WebServiceManager *serviceManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        serviceManager = [[WebServiceManager alloc] init];
    });
    return serviceManager;
}

- (void) handleMyTokenAndID:(NSString *)myToken andMyName:(NSString *)myFullName  {
    _myAccessToken = myToken;
    _mySessionID = myFullName;
    _allFollowsUserUrlArray = [[NSMutableArray alloc]init];
    [self sendPOSTRequestUserInfo:_myAccessToken andMyID:_mySessionID];
    NSLog(@"My token succesfully saved, here it is - %@", _myAccessToken);
    NSLog(@"My ID was saved -- %@", _mySessionID);
}

- (void) sendPOSTRequestWithCode: (NSString *) code {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate: nil delegateQueue:nil];
    NSString *post = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&grant_type=authorization_code&redirect_uri=%@&code=%@",INSTAGRAM_CLIENT_ID,INSTAGRAM_CLIENTSERCRET,INSTAGRAM_REDIRECT_URI,code];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSMutableURLRequest *requestData = [NSMutableURLRequest requestWithURL:
                                        [NSURL URLWithString:@"https://api.instagram.com/oauth/access_token"]];
    [requestData setHTTPMethod:@"POST"];
    [requestData setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [requestData setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [requestData setHTTPBody:postData];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:requestData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//        NSLog(@"This is me Dictionary, JSONSerialization from data === %@", dict);
        NSMutableDictionary * userDict = [[NSMutableDictionary alloc] init];
        userDict = [dict valueForKey:@"user"];
        [self handleMyTokenAndID:[dict valueForKey:@"access_token"] andMyName:[userDict valueForKey:@"id"]];
    }];
    
    [postDataTask resume];
}

- (void) sendPOSTRequestUserInfo: (NSString *) myToken andMyID: (NSString *) myID {

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate: self delegateQueue:nil];
    NSMutableURLRequest *requestData = [NSMutableURLRequest requestWithURL:
                                        [NSURL URLWithString:[NSString stringWithFormat:@"https://api.instagram.com/v1/users/%@/?access_token=%@", myID, myToken]]];
    [requestData setHTTPMethod:@"GET"];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:requestData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *userDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//        NSLog(@"This IS USER DATA === %@", userDict);
        [self saveUserData:userDict];
    }];
    
    [postDataTask resume];

}
- (void) sendRequestForUserMedia: (NSString *) myToken andMyID: (NSString *) myID {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate: self delegateQueue:nil];
    NSMutableURLRequest *requestData = [NSMutableURLRequest requestWithURL:
                                        [NSURL URLWithString:[NSString stringWithFormat:@"https://api.instagram.com/v1/users/self/media/recent/?access_token=%@", myToken]]];
    [requestData setHTTPMethod:@"GET"];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:requestData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *userDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        [self saveMediaDictionary:userDict];
        
    }];
    
    [postDataTask resume];
}

- (void) saveMediaDictionary: (NSDictionary *) mediaDict {
dispatch_async(dispatch_get_main_queue(), ^{
    _userMediaDictionary = mediaDict;
    _userPhotoUrlArray = [_userMediaDictionary valueForKeyPath:@"data.images.thumbnail.url"];
    _userStandartPhotoUrlArray = [_userMediaDictionary valueForKeyPath:@"data.images.standard_resolution.url"];
    //NSLog(@"User photo urls === %@", _userStandartPhotoUrlArray);
    [self loadingImagesData];

});
}

- (void) saveUserData: (NSDictionary *) userDict {
    dispatch_async(dispatch_get_main_queue(), ^{
    _userDataDictionary = userDict;
   // NSLog(@"Dict saved === %@", _userDataDictionary);
    NSDictionary *dict1 = [_userDataDictionary objectForKey:@"data"];
    NSString *urlImage = [dict1 objectForKey:@"profile_picture"];
        [self setMyAvatar:urlImage];
    
   });
}
- (void) setMyAvatar:(NSString *)avatarUrl {
    
    SDWebImageDownloader *downloader = [SDWebImageDownloader sharedDownloader];
    NSURL *url = [NSURL URLWithString:avatarUrl];
    [downloader downloadImageWithURL: url
                             options:0
                            progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                            }
                           completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                               if (image && finished) {
                                   [self saveUserAvatarImage:image];
                               }
                           }];
}

- (void)saveUserAvatarImage: (UIImage *)avatar{
  dispatch_async(dispatch_get_main_queue(), ^{
    _userAvatarImage = avatar;
      [self sendRequestForUserFollows:_myAccessToken andMyID:_mySessionID];
      [[NSNotificationCenter defaultCenter] postNotificationName:@"userNotification" object:nil];
      
      });
}


- (void) sendRequestForUserFollows: (NSString *) myToken andMyID: (NSString *) myID {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate: self delegateQueue:nil];
    NSMutableURLRequest *requestData = [NSMutableURLRequest requestWithURL:
                                        [NSURL URLWithString:[NSString stringWithFormat:@"https://api.instagram.com/v1/users/self/follows?access_token=%@", myToken]]];
    [requestData setHTTPMethod:@"GET"];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:requestData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *followsDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        dispatch_sync(dispatch_get_main_queue(), ^{
        _followsIDArray = [followsDict valueForKeyPath:@"data.id"];
        _followsAvatarUrlArray = [followsDict valueForKeyPath:@"data.profile_picture"];
        _followsUserNameArray = [followsDict valueForKeyPath:@"data.full_name"];
       // NSLog(@"ID== %@, %@, %@", _followsIDArray, followsDict, _followsUserNameArray);
        });
        if (_followsIDArray != nil) {
            for (int i = 0; i < _followsIDArray.count; i++) {
                [self sendRequestForFollowUserMedia:_myAccessToken andUserID:_followsIDArray[i]];
            }
        }
    }];
    
    [postDataTask resume];
}

- (void) sendRequestForFollowUserMedia: (NSString *) myToken andUserID: (NSString *) userID {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate: self delegateQueue:nil];
    NSMutableURLRequest *requestData = [NSMutableURLRequest requestWithURL:
                                        [NSURL URLWithString:[NSString stringWithFormat:@"https://api.instagram.com/v1/users/%@/media/recent/?access_token=%@", userID, myToken]]];
    [requestData setHTTPMethod:@"GET"];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:requestData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *userDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSMutableArray *array = [userDict valueForKeyPath:@"data.images.standard_resolution.url"];
        [self addArray:array];
//        for (int i = 0; i < array.count; i++) {
//            NSString * urlString = array[i];
//            [self updateBigArray:urlString];
//        }
    }];
    [postDataTask resume];
        });
}

- (void)addArray:(NSArray *)value {
    @synchronized (value) {
    
    [_allFollowsUserUrlArray addObjectsFromArray:value];
    }
}

- (void)updateBigArray:(NSString *)value {
    @synchronized (value) {
       [self.allFollowsUserUrlArray addObject:value];
    }
}



- (void)loadingImagesData {
    for (int i = 0; i < _userPhotoUrlArray.count; i++) {
    
    SDWebImageDownloader *downloader = [SDWebImageDownloader sharedDownloader];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",_userPhotoUrlArray[i]]];
        [downloader downloadImageWithURL: url
                             options:0
                            progress:^(NSInteger receivedSize, NSInteger expectedSize) {
}
            completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        if (image && finished) {
        NSString *localKey = [NSString stringWithFormat:@"Item-%d", i];
    [[SDImageCache sharedImageCache] storeImage:image forKey:localKey toDisk:NO];
            NSLog(@"CACHED!!!");
            if (i == _userPhotoUrlArray.count -1 && finished) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"userMediaNotification" object:nil];
            }
    
}
}];
}
 
}



@end
