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

- (NSString *)description {
    return [self treeDescription];
}

- (NSString *)treeDescription {
    if (!self.children.count) {
        return self.name;
    }

    NSMutableString *ms = [NSMutableString string];

    if (![self isNil]) {
        [ms appendFormat:@"(%@ ", self.name];
    }

    NSUInteger i = 0;
    for (PKAST *child in self.children) {
        NSString *fmt = (0 == i++) ? @"%@" : @" %@";
        [ms appendFormat:fmt, [child treeDescription]];
    }

    if (![self isNil]) {
        [ms appendString:@")"];
    }

    return [ms copy];
}

- (NSUInteger)type {
    NSAssert2(0, @"%s is an abstract method. Must be overridden in %@", __PRETTY_FUNCTION__, self.className);
    return NSNotFound;
}

- (void)addChild:(PKAST *)a {
    NSParameterAssert(a);
    if (!self.children) {
        self.children = [NSMutableArray array];
    }

    [self.children addObject:a];
}

- (BOOL)isNil {
    return !self.token;
}


- (NSString *)name {
    return [self.token stringValue];
}

@end
