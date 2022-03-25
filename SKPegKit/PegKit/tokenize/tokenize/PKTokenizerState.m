//
//  PKTokenizerState.m
//  SKPegKit
//
//  Created by Sam Krishna on 3/24/22.
//

#import "PKTokenizerState.h"
#import "PKTokenizer.h"
#import "PKReader.h"

#define STATE_COUNT 256

@interface PKTokenizer ()
- (PKTokenizerState *)defaultTokenizerStateFor:(PKUniChar)c;
@end

@interface PKTokenizerState ()
@property (nonatomic, readwrite, strong) NSMutableString *stringbuf;
@property (nonatomic, readwrite, assign) NSUInteger offset;
@property (nonatomic, readwrite, strong) NSMutableArray *fallbackStates;
@end

@implementation PKTokenizerState

- (PKToken *)nextTokenFromReader:(PKReader *)r startingWith:(PKUniChar)cin tokenizer:(PKTokenizer *)t {
    NSCAssert(0, @"%s must be overridden", __PRETTY_FUNCTION__);
    return nil;
}

- (void)setFallbackState:(PKTokenizerState *)state from:(PKUniChar)start to:(PKUniChar)end {
    NSParameterAssert(start >= 0 && start < STATE_COUNT);
    NSParameterAssert(end >= 0 && end < STATE_COUNT);

    if (!self.fallbackStates) {
        self.fallbackStates = [NSMutableArray arrayWithCapacity:STATE_COUNT];

        for (NSUInteger i = 0; i < STATE_COUNT; i++) {
            [self.fallbackStates addObject:[NSNull null]];
        }
    }

    for (NSUInteger i = start; i <= end; i++) {
        self.fallbackStates[i] = state;
    }
}

- (void)resetWithReader:(PKReader *)r {
    self.stringbuf = [NSMutableString string];
    self.offset = r.offset - 1;
}

- (void)append:(PKUniChar)c {
    NSParameterAssert(c != PKEOF);
    NSCAssert(self.stringbuf, @"");
    [self.stringbuf appendFormat:@"%C", (unichar)c];
}

- (void)appendString:(NSString *)s {
    NSParameterAssert(s);
    NSCAssert(self.stringbuf, @"");
    [self.stringbuf appendString:s];
}

- (NSString *)bufferedString {
    return [self.stringbuf copy];
}

- (PKTokenizerState *)nextTokenizerStateFor:(PKUniChar)c tokenizer:(PKTokenizer *)t {
    NSParameterAssert(c < STATE_COUNT);

    if (self.fallbackStates) {
        id obj = self.fallbackStates[c];
        if ([NSNull null] != obj) {
            return obj;
        }
    }

    if (self.fallbackState) {
        return self.fallbackState;
    }

    return [t defaultTokenizerStateFor:c];
}

@end
