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
            currentPage = 1;
        }
        return self;
    }

    - (void)fetchPosts:(int)page {
        NSString *urlString = [NSString stringWithFormat:@"https://storage.googleapis.com/cdn-og-test-api/test-task/social/%d.json", page];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
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

                                                            NSMutableArray *posts = [[NSMutableArray alloc] init];

                                                            for (NSInteger i = 0; i < [json count]; i++){
                                                                SFPost *post = [SFPost fromJSONDictionary:[json objectAtIndex:i]];
                                                                [posts addObject:post];
                                                            }

                                                            if (page == 1) {
                                                                self.posts = posts;
                                                            } else {
                                                                [self.posts addObjectsFromArray:posts];
                                                            }

                                                            [self.delegate networkDidFetchPosts: self.posts count: posts.count];

                                                        }
                                                    }];
        [dataTask resume];
    }

@end
