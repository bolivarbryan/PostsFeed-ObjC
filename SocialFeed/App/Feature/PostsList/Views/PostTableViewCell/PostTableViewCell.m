//
//  PostTableViewCell.m
//  SocialFeed
//
//  Created by Bryan A Bolivar M on 2/26/19.
//  Copyright © 2019 BolivarBryan. All rights reserved.
//

#import "PostTableViewCell.h"
#import "SocialFeed-Swift.h"

@implementation PostTableViewCell

- (void)setPost:(SFPost *)post {
    self.nameLabel.text = post.author.name;
    self.usernameLabel.text = post.author.accountValue;
    self.dateLabel.text = [NSString stringWithFormat:@"%@", post.dateFormatted];

    [self.picture sd_setImageWithURL:[NSURL URLWithString: post.author.pictureLink]
                    placeholderImage:[[UIImage alloc] init]];

    self.imageHeightConstraint.constant = 0;

    [self.postedImage sd_setImageWithURL:[NSURL URLWithString: post.attachment.pictureLink]
                               completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       if (image.size.height != post.attachment.height) {
                                           [self updateImageFrameWithHeight: image.size.height width: image.size.height];
                                       }
                                   });
                               }];

    [self updateImageFrameWithHeight: post.attachment.height width: post.attachment.width];
    [self validateNetworkType];
    [self applyTextAttributes: post];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateImageFrameWithHeight:(CGFloat)height width:(CGFloat)width {
    CGFloat p = height / UIScreen.mainScreen.bounds.size.height;
    CGFloat w = width / UIScreen.mainScreen.bounds.size.width;

    if (w > 0) {
        p = p / w;
    } else {
        p = 0;
    }

    self.imageHeightConstraint.constant = UIScreen.mainScreen.bounds.size.height *  p;
    [self.postedTextLabel sizeToFit];
    [self layoutIfNeeded];
}

-(void)validateNetworkType {

    switch (self.post.networkValue) {
        case Twitter:
            [self.networkImageView setImage:[UIImage imageNamed:@"twitter"]];
            break;
        case Facebook:
            [self.networkImageView setImage:[UIImage imageNamed:@"facebook"]];
        case Instagram:
            [self.networkImageView setImage:[UIImage imageNamed:@"instagram"]];
    }
}
- (void)applyTextAttributes: (SFPost *)post {
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString: post.text.plain attributes: nil];

    for (NSInteger i = 0; i < post.text.markup.count; i++ ) {
        NSRange range = NSMakeRange([[post.text.markup objectAtIndex:i] location],
                                    [[post.text.markup objectAtIndex:i] length]);
        [attributedText applyAttributeWithText: post.text.plain range:range];
    }

    self.postedTextLabel.attributedText = attributedText;
}

@end
