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
@property(nonatomic, retain) UIRefreshControl *refreshControl;
@end

@implementation PostsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewModel = [[PostsListViewModel alloc] init];
    self.viewModel.delegate = self;
    [self refreshTable];
    [self configureRefreshControl];
}

- (void)configureRefreshControl {
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];

    if (@available(iOS 10.0, *)) {
        self.tableView.refreshControl = self.refreshControl;
    } else {
        [self.tableView addSubview:self.refreshControl];
    }

    [self.tableView sendSubviewToBack: self.refreshControl];
}

- (void) refreshTable {
    currentPage = 1;
    isRefresing = YES;
    [self.viewModel fetchPosts: currentPage];
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(self.tableView.contentOffset.y >= (self.tableView.contentSize.height - self.tableView.bounds.size.height))
    {
        if(isRefresing == NO){
            isRefresing = YES;
            currentPage++;
            [self.viewModel fetchPosts: currentPage];
        }
    }
}

//MARK: - PostsListViewModelDelegate

- (void)networkDidFetchPosts:(NSArray *)posts count:(NSInteger)count {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.refreshControl  endRefreshing];
        self->isRefresing = NO;

        if (self->currentPage > 2) {
            NSMutableArray *indexes = [[NSMutableArray alloc] init];
            for (int i = 0; i < count; i++) {
                NSIndexPath *index = [NSIndexPath indexPathForRow: self.viewModel.posts.count + (i - count)  inSection:0];
                [indexes addObject: index];
            }

            [self.tableView beginUpdates];
            [self.tableView insertRowsAtIndexPaths:indexes withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        } else {
            [self.tableView reloadData];
        }

    });
}

@end
