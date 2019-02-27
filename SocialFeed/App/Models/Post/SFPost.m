//
//  SFPost.m
//  SocialFeed
//
//  Created by Bryan A Bolivar M on 2/26/19.
//  Copyright © 2019 BolivarBryan. All rights reserved.
//

#import "SFPost.h"

#define λ(decl, expr) (^(decl) { return (expr); })

NS_ASSUME_NONNULL_BEGIN

@interface SFPost (JSONConversion)
- (NSDictionary *)JSONDictionary;
    @end

@interface SFAttachment (JSONConversion)
+ (instancetype)fromJSONDictionary:(NSDictionary *)dict;
- (NSDictionary *)JSONDictionary;
    @end

@interface SFAuthor (JSONConversion)
+ (instancetype)fromJSONDictionary:(NSDictionary *)dict;
- (NSDictionary *)JSONDictionary;
    @end

@interface SFText (JSONConversion)
+ (instancetype)fromJSONDictionary:(NSDictionary *)dict;
- (NSDictionary *)JSONDictionary;
    @end

@interface SFMarkup (JSONConversion)
+ (instancetype)fromJSONDictionary:(NSDictionary *)dict;
- (NSDictionary *)JSONDictionary;
    @end

static id map(id collection, id (^f)(id value)) {
    id result = nil;
    if ([collection isKindOfClass:NSArray.class]) {
        result = [NSMutableArray arrayWithCapacity:[collection count]];
        for (id x in collection) [result addObject:f(x)];
    } else if ([collection isKindOfClass:NSDictionary.class]) {
        result = [NSMutableDictionary dictionaryWithCapacity:[collection count]];
        for (id key in collection) [result setObject:f([collection objectForKey:key]) forKey:key];
    }
    return result;
}

#pragma mark - JSON serialization


@implementation SFPost

-(void)setNetwork:(NSString *)network {
    
    if ([network isEqualToString:@"facebook"]) {
        self.networkValue = Facebook;
    } else if ([network isEqualToString:@"twitter"]) {
        self.networkValue = Twitter;
    } else if ([network isEqualToString:@"instagram"]) {
        self.networkValue = Instagram;
    }
}

- (NSDate *)dateValue {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";
    return [formatter dateFromString: self.date];
}

- (NSString *)dateFormatted {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"EEEE, d MMMM yyyy";
    return [formatter stringFromDate: self.dateValue];
}

+ (NSDictionary<NSString *, NSString *> *)properties
    {
        static NSDictionary<NSString *, NSString *> *properties;
        return properties = properties ? properties : @{
                                                        @"author": @"author",
                                                        @"date": @"date",
                                                        @"link": @"link",
                                                        @"text": @"text",
                                                        @"attachment": @"attachment",
                                                        @"network": @"network",
                                                        };
    }


+ (instancetype)fromJSONDictionary:(NSDictionary *)dict
    {
        return dict ? [[SFPost alloc] initWithJSONDictionary:dict] : nil;
    }

- (instancetype)initWithJSONDictionary:(NSDictionary *)dict
    {
        if (self = [super init]) {
            [self setValuesForKeysWithDictionary:dict];
            _author = [SFAuthor fromJSONDictionary:(id)_author];
            _text = [SFText fromJSONDictionary:(id)_text];
            _attachment = [SFAttachment fromJSONDictionary:(id)_attachment];
        }
        return self;
    }

- (NSDictionary *)JSONDictionary
    {
        id dict = [[self dictionaryWithValuesForKeys:SFPost.properties.allValues] mutableCopy];

        [dict addEntriesFromDictionary:@{
                                         @"author": [_author JSONDictionary],
                                         @"text": [_text JSONDictionary],
                                         @"attachment": [_attachment JSONDictionary],
                                         }];

        return dict;
    }

@end

@implementation SFAttachment
+ (NSDictionary<NSString *, NSString *> *)properties
    {
        static NSDictionary<NSString *, NSString *> *properties;
        return properties = properties ? properties : @{
                                                        @"picture-link": @"pictureLink",
                                                        @"width": @"width",
                                                        @"height": @"height",
                                                        };
    }

+ (instancetype)fromJSONDictionary:(NSDictionary *)dict
    {
        return dict ? [[SFAttachment alloc] initWithJSONDictionary:dict] : nil;
    }

- (instancetype)initWithJSONDictionary:(NSDictionary *)dict
    {
        if (self = [super init]) {
            [self setValuesForKeysWithDictionary:dict];
        }
        return self;
    }

- (void)setValue:(nullable id)value forKey:(NSString *)key
    {
        id resolved = SFAttachment.properties[key];
        if (resolved) [super setValue:value forKey:resolved];
    }

- (NSDictionary *)JSONDictionary
    {
        id dict = [[self dictionaryWithValuesForKeys:SFAttachment.properties.allValues] mutableCopy];

        for (id jsonName in SFAttachment.properties) {
            id propertyName = SFAttachment.properties[jsonName];
            if (![jsonName isEqualToString:propertyName]) {
                dict[jsonName] = dict[propertyName];
                [dict removeObjectForKey:propertyName];
            }
        }

        return dict;
    }
    @end

@implementation SFAuthor

///If user does not have any account value, return name as default
- (NSString *)accountValue {
    if (self.account != nil) {
        return self.account;
    } else {
        return self.name;
    }
}

+ (NSDictionary<NSString *, NSString *> *)properties
    {
        static NSDictionary<NSString *, NSString *> *properties;
        return properties = properties ? properties : @{
                                                        @"is-verified": @"isVerified",
                                                        @"name": @"name",
                                                        @"picture-link": @"pictureLink",
                                                        @"account": @"account"
                                                        };
    }

+ (instancetype)fromJSONDictionary:(NSDictionary *)dict
    {
        return dict ? [[SFAuthor alloc] initWithJSONDictionary:dict] : nil;
    }

- (instancetype)initWithJSONDictionary:(NSDictionary *)dict
    {
        if (self = [super init]) {
            [self setValuesForKeysWithDictionary:dict];
        }
        return self;
    }

- (void)setValue:(nullable id)value forKey:(NSString *)key
    {
        id resolved = SFAuthor.properties[key];
        if (resolved) [super setValue:value forKey:resolved];
    }

- (NSDictionary *)JSONDictionary
    {
        id dict = [[self dictionaryWithValuesForKeys:SFAuthor.properties.allValues] mutableCopy];

        for (id jsonName in SFAuthor.properties) {
            id propertyName = SFAuthor.properties[jsonName];
            if (![jsonName isEqualToString:propertyName]) {
                dict[jsonName] = dict[propertyName];
                [dict removeObjectForKey:propertyName];
            }
        }

        [dict addEntriesFromDictionary:@{
                                         @"is-verified": _isVerified ? @YES : @NO,
                                         }];

        return dict;
    }
    @end

@implementation SFText
+ (NSDictionary<NSString *, NSString *> *)properties
    {
        static NSDictionary<NSString *, NSString *> *properties;
        return properties = properties ? properties : @{
                                                        @"markup": @"markup",
                                                        @"plain": @"plain",
                                                        };
    }

+ (instancetype)fromJSONDictionary:(NSDictionary *)dict
    {
        return dict ? [[SFText alloc] initWithJSONDictionary:dict] : nil;
    }

- (instancetype)initWithJSONDictionary:(NSDictionary *)dict
    {
        if (self = [super init]) {
            [self setValuesForKeysWithDictionary:dict];
            _markup = map(_markup, λ(id x, [SFMarkup fromJSONDictionary:x]));
        }
        return self;
    }

- (NSDictionary *)JSONDictionary
    {
        id dict = [[self dictionaryWithValuesForKeys:SFText.properties.allValues] mutableCopy];

        [dict addEntriesFromDictionary:@{
                                         @"markup": map(_markup, λ(id x, [x JSONDictionary])),
                                         }];

        return dict;
    }
    @end

@implementation SFMarkup
+ (NSDictionary<NSString *, NSString *> *)properties
    {
        static NSDictionary<NSString *, NSString *> *properties;
        return properties = properties ? properties : @{
                                                        @"length": @"length",
                                                        @"location": @"location",
                                                        @"link": @"link",
                                                        };
    }

+ (instancetype)fromJSONDictionary:(NSDictionary *)dict
    {
        return dict ? [[SFMarkup alloc] initWithJSONDictionary:dict] : nil;
    }

- (instancetype)initWithJSONDictionary:(NSDictionary *)dict
    {
        if (self = [super init]) {
            [self setValuesForKeysWithDictionary:dict];
        }
        return self;
    }

- (NSDictionary *)JSONDictionary
    {
        return [self dictionaryWithValuesForKeys:SFMarkup.properties.allValues];
    }
    @end

NS_ASSUME_NONNULL_END
