//
//  Post.h
//  SocialFeed
//
//  Created by Bryan A Bolivar M on 2/26/19.
//  Copyright © 2019 BolivarBryan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SFPost;
@class SFAttachment;
@class SFAuthor;
@class SFText;
@class SFMarkup;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Object interfaces

@interface SFPost : NSObject
    @property (nonatomic, strong) SFAuthor *author;
    @property (nonatomic, copy)   NSString *date;
    @property (nonatomic, copy)   NSString *link;
    @property (nonatomic, strong) SFText *text;
    @property (nonatomic, strong) SFAttachment *attachment;
    @property (nonatomic, copy)   NSString *network;

    @property (nonatomic, copy)   NSDate *dateValue;
    @property (nonatomic, copy)   NSString *dateFormatted;

    + (instancetype)fromJSONDictionary:(NSDictionary *)dict;

    @end

@interface SFAttachment : NSObject
    @property (nonatomic, copy)   NSString *pictureLink;
    @property (nonatomic, assign) NSInteger width;
    @property (nonatomic, assign) NSInteger height;
    @end

@interface SFAuthor : NSObject
    @property (nonatomic, assign) BOOL isVerified;
    @property (nonatomic, copy)   NSString *name;
    @property (nonatomic, copy)   NSString *account;
    @property (nonatomic, copy)   NSString *pictureLink;

    @property (nonatomic, copy)   NSString *accountValue;
    @end

@interface SFText : NSObject
    @property (nonatomic, copy) NSArray<SFMarkup *> *markup;
    @property (nonatomic, copy) NSString *plain;
    @end

@interface SFMarkup : NSObject
    @property (nonatomic, assign) NSInteger length;
    @property (nonatomic, assign) NSInteger location;
    @property (nonatomic, copy)   NSString *link;
    @end

NS_ASSUME_NONNULL_END

