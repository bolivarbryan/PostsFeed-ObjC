//
//  Networking.h
//  SocialFeed
//
//  Created by Bryan A Bolivar M on 2/26/19.
//  Copyright © 2019 BolivarBryan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@protocol PostsListViewModelDelegate<NSObject>
@required

- (void)networkDidFetchPosts:(NSArray *)posts count:(NSInteger)count ;

@end

@interface PostsListViewModel : NSObject{
    int currentPage;
}
@property (nonatomic, retain) NSMutableArray *posts;
@property (nonatomic, weak) id<PostsListViewModelDelegate> delegate;

- (void) fetchPosts:(int)page;

@end

NS_ASSUME_NONNULL_END
