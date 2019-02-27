//
//  PostTableViewCell.h
//  SocialFeed
//
//  Created by Bryan A Bolivar M on 2/26/19.
//  Copyright © 2019 BolivarBryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "SFPost.h"

NS_ASSUME_NONNULL_BEGIN

@interface PostTableViewCell : UITableViewCell
    @property (weak, nonatomic) SFPost* post;
    @property (weak, nonatomic) IBOutlet UIImageView *picture;
    @property (weak, nonatomic) IBOutlet UILabel *nameLabel;
    @property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
    @property (weak, nonatomic) IBOutlet UIImageView *networkImageView;
    @property (weak, nonatomic) IBOutlet UILabel *postedTextLabel;
    @property (weak, nonatomic) IBOutlet UILabel *dateLabel;
    @property (weak, nonatomic) IBOutlet UIImageView *postedImage;
    @property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeightConstraint;
    @property (weak, nonatomic) IBOutlet NSLayoutConstraint *ratioConstraint;
    @property (weak, nonatomic) IBOutlet NSLayoutConstraint *imagewidthConstraint;

@end

NS_ASSUME_NONNULL_END
