//
//  PKSymbolRootNode.m
//  SKPegKit
//
//  Created by Sam Krishna on 3/26/22.
//

#import "PKReader.h"
#import "PKSymbolRootNode.h"

@interface PKSymbolNode ()
@property (nonatomic, readwrite, strong) NSMutableDictionary *children;
@end

@implementation PKSymbolRootNode

- (instancetype)init {
    if (!(self = [super initWithParent:nil character:PKEOF])) { return nil; }

    return self;
}

- (void)add:(NSString *)s {
    NSParameterAssert(s);
    if (!s.length) { return; }

    [self addWithFirst:[s characterAtIndex:0] rest:[s substringFromIndex:1] parent:self];
}

- (void)remove:(NSString *)s {
    NSParameterAssert(s);
    if (!s.length) { return; }
    [self removeWithFirst:[s characterAtIndex:0] rest:[s substringFromIndex:1] parent:self];
}

- (void)addWithFirst:(PKUniChar)c rest:(NSString *)s parent:(PKSymbolNode *)p {
    NSParameterAssert(p);
    NSString *key = [[NSString alloc] initWithCharacters:(const unichar *)&c length:1];
    PKSymbolNode *child = p.children[key];
    if (!child) {
        child = [[PKSymbolNode alloc] initWithParent:p character:c];
        child.reportsAddedSymbolsOnly = self.reportsAddedSymbolsOnly;
        p.children[key] = child;
    }

    NSUInteger len = s.length;

    if (len) {
        NSString *rest = nil;

        if (len > 1) {
            rest = [s substringFromIndex:1];
        }

        [self addWithFirst:[s characterAtIndex:0] rest:rest parent:child];
    }
}

- (void)removeWithFirst:(PKUniChar)c rest:(NSString *)s parent:(PKSymbolNode *)p {
    NSParameterAssert(p);
    NSString *key = [[NSString alloc] initWithCharacters:(const unichar *)&c length:1];
    PKSymbolNode *child = p.children[key];

    if (child) {
        NSString *rest = nil;
        NSUInteger len = s.length;

        if (0 == len) {
            return;
        }
        else if (len > 1) {
            rest = [s substringFromIndex:1];
            [self removeWithFirst:[s characterAtIndex:0] rest:rest parent:child];
        }

        [p.children removeObjectForKey:key];
    }
}

- (NSString *)nextSymbol:(PKReader *)r startingWith:(PKUniChar)cin {
    NSParameterAssert(r);
    return [self nextWithFirst:cin rest:r parent:self];
}

- (NSString *)nextWithFirst:(PKUniChar)c rest:(PKReader *)r parent:(PKSymbolNode *)p {
    NSParameterAssert(p);
    NSString *result = [[NSString alloc] initWithCharacters:(const unichar *)&c length:1];
    PKSymbolNode *child = p.children[result];

    if (!child) {
        if (p == self) {
            result = self.reportsAddedSymbolsOnly ? @"" : result;
        }
        else {
            [r unread];
            result = @"";
        }

        return result;
    }

    c = [r read];
    if (PKEOF == c) {
        return result;
    }

    return [result stringByAppendingString:[self nextWithFirst:c rest:r parent:child]];
}

@end
