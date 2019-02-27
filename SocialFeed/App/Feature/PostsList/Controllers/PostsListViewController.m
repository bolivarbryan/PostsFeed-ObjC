//
//  PostsListViewController.m
//  SocialFeed
//
//  Created by Bryan A Bolivar M on 2/26/19.
//  Copyright © 2019 BolivarBryan. All rights reserved.
//

#import "PostsListViewController.h"
#import "PostTableViewCell.h"

@interface PostsListViewController ()
@property (nonatomic, retain) PostsListViewModel *viewModel;
@end

@implementation PostsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewModel = [[PostsListViewModel alloc] init];
    self.viewModel.delegate = self;
    [self.viewModel fetchPosts];
}

//MARK: - UITableViewDatasource & UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostTableViewCell"];
    cell.post = [self.viewModel.posts objectAtIndex:indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.viewModel.posts.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated: YES];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

//MARK: - PostsListViewModelDelegate

- (void)networkDidFetchPosts:(NSArray *)posts {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

@end
