//
//  Networking.m
//  SocialFeed
//
//  Created by Bryan A Bolivar M on 2/26/19.
//  Copyright © 2019 BolivarBryan. All rights reserved.
//

#import "PostsListViewModel.h"
#import "SFPost.h"

@implementation PostsListViewModel

    - (instancetype)init
    {
        self = [super init];
        if (self) {
            self.posts = [[NSMutableArray alloc] init];
        }
        return self;
    }

    - (void)fetchPosts {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://storage.googleapis.com/cdn-og-test-api/test-task/social/2.json"]
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:10.0];
        [request setHTTPMethod:@"GET"];

        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                        if (error) {
                                                            NSLog(@"%@", error);
                                                        } else {
                                                            NSError* error;
                                                            NSArray* json = [NSJSONSerialization JSONObjectWithData:data
                                                                                                                 options:kNilOptions
                                                                                                                   error:&error];

                                                            for (NSInteger i = 0; i < [json count]; i++){
                                                                SFPost *post = [SFPost fromJSONDictionary:[json objectAtIndex:i]];
                                                                [self.posts addObject:post];
                                                            }
                                                            [self.delegate networkDidFetchPosts: self.posts];

                                                        }
                                                    }];
        [dataTask resume];
    }

@end
