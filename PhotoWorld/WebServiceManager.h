//
//  WebServiceManager.h
//  PhotoWorld
//
//  Created by Paul on 20.06.16.
//  Copyright © 2016 Paul. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "UserInfoViewController.h"


@interface WebServiceManager : NSObject <NSURLSessionDataDelegate, NSURLSessionDelegate>

@property (strong, nonatomic) NSString *myAccessToken;
@property (strong, nonatomic) NSString *mySessionID;

- (void) sendPOSTRequestWithCode: (NSString *) code;
- (void) handleMyTokenAndID: (NSString *) myToken andMyName: (NSString *) myFullName;
- (void) sendPOSTRequestUserInfo: (NSString *) myToken andMyID: (NSString *) myID;
- (void) sendRequestForUserMedia: (NSString *) myToken andMyID: (NSString *) myID;

+ (WebServiceManager *)sharedInstance;

@property (strong, nonatomic) NSDictionary *userDataDictionary;
@property (strong, nonatomic) NSDictionary *userMediaDictionaty;

@end
