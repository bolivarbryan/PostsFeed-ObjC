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
    NSLog(@"%@", post);
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
                                           [self updateImageFrameWithHeight: image.size.height width: image.size.width];
                                       }
                                   });
                               }];

    [self updateImageFrameWithHeight: post.attachment.height width: post.attachment.width];
    [self validateNetworkType: post.network];
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

-(void)validateNetworkType: (NSString *)networkString {
    if ([networkString isEqualToString:@"facebook"]) {
        [self.networkImageView setImage:[UIImage imageNamed:@"facebook"]];
    } else if ([networkString isEqualToString:@"twitter"]) {
        [self.networkImageView setImage:[UIImage imageNamed:@"twitter"]];
    } else if ([networkString isEqualToString:@"instagram"]) {
        [self.networkImageView setImage:[UIImage imageNamed:@"instagram"]];
    }
}
- (void)applyTextAttributes: (SFPost *)post {
    NSDictionary *attribs = @{
                              NSForegroundColorAttributeName: self.postedTextLabel.textColor,
                              NSFontAttributeName: self.postedTextLabel.font
                              };
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString: post.text.plain attributes: attribs];

    for (NSInteger i = 0; i < post.text.markup.count; i++ ) {
        NSRange range = NSMakeRange([[post.text.markup objectAtIndex:i] location],
                                    [[post.text.markup objectAtIndex:i] length]);
        [attributedText applyAttributeWithText: post.text.plain range:range link: [post.text.markup objectAtIndex:i].link];
    }
    self.bodytTextView.attributedText = attributedText;
}

@end
