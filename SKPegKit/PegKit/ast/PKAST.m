//
//  PKAST.m
//  SKPegKit
//
//  Created by Sam Krishna on 3/24/22.
//

#import "PKToken.h"
#import "PKAST.h"

@implementation PKAST

+ (instancetype)ASTWithToken:(PKToken *)tok {
    return [[self alloc] initWithToken:tok];
}

- (instancetype)init {
    return [self initWithToken:nil];
}

- (instancetype)initWithToken:(PKToken *)tok {
    if (!(self = [super init])) { return nil; }
    self.token = tok;
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    PKAST *that = [[[self class] alloc] initWithToken:_token];
    that->_children = [_children mutableCopyWithZone:zone];
    return that;
}

- (BOOL)isEqual:(id)obj {
    if (![obj isKindOfClass:[self class]]) {
        return NO;
    }

    PKAST *that = (PKAST *)obj;

    if (![_token isEqual:that->_token]) {
        return NO;
    }

    if (self.children && that.children && ![self.children isEqualToArray:that.children]) {
        return NO;
    }

    return YES;
}

@end
