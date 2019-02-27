//
//  PostsListViewController.h
//  SocialFeed
//
//  Created by Bryan A Bolivar M on 2/26/19.
//  Copyright © 2019 BolivarBryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostsListViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface PostsListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, PostsListViewModelDelegate> {
    int currentPage;
    Boolean isRefresing;
}
    @property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

NS_ASSUME_NONNULL_END
