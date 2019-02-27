//
//  PostTableViewCell.m
//  SocialFeed
//
//  Created by Bryan A Bolivar M on 2/26/19.
//  Copyright © 2019 BolivarBryan. All rights reserved.
//

#import "PostTableViewCell.h"

@implementation PostTableViewCell

- (void)setPost:(SFPost *)post {
    self.nameLabel.text = post.author.name;
    self.usernameLabel.text = post.author.accountValue;
    self.dateLabel.text = [NSString stringWithFormat:@"%@", post.dateFormatted];
    self.postedTextLabel.text = post.text.plain;
    [self.picture sd_setImageWithURL:[NSURL URLWithString: post.author.pictureLink]
                    placeholderImage:[[UIImage alloc] init]];

    self.imageHeightConstraint.constant = 0;

    [self.postedImage sd_setImageWithURL:[NSURL URLWithString: post.attachment.pictureLink]
                               completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       if (image.size.height != post.attachment.height) {
                                           CGFloat p = image.size.height / UIScreen.mainScreen.bounds.size.height;
                                           CGFloat w = image.size.width / UIScreen.mainScreen.bounds.size.width;

                                           if (w > 0) {
                                               p = p / w;
                                           } else {
                                               p = 0;
                                           }

                                           self.imageHeightConstraint.constant = UIScreen.mainScreen.bounds.size.height *  p;
                                           [self.postedTextLabel sizeToFit];
                                           [self layoutIfNeeded];
                                       }
                                   });
                               }];

    CGFloat p = post.attachment.height/ UIScreen.mainScreen.bounds.size.height;
    CGFloat w = post.attachment.width/ UIScreen.mainScreen.bounds.size.width;

    if (w > 0) {
        p = p / w;
    } else {
        p = 0;
    }

    self.imageHeightConstraint.constant = UIScreen.mainScreen.bounds.size.height *  p;
    [self layoutIfNeeded];

    switch (post.networkValue) {
        case Twitter:
            self.networkImageView.backgroundColor = [UIColor blueColor];
            break;
        case Facebook:
            self.networkImageView.backgroundColor = [UIColor purpleColor];
        case Instagram:
            self.networkImageView.backgroundColor = [UIColor redColor];
    }

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

    @end
