//
//  PKWhitespaceState.m
//  SKPegKit
//
//  Created by Sam Krishna on 3/25/22.
//

#import "PKReader.h"
#import "PKTokenizer.h"
#import "PKToken.h"
#import <SKPegKit/PKTypes.h>
#import "PKWhitespaceState.h"

#define PKTRUE (id)kCFBooleanTrue
#define PKFALSE (id)kCFBooleanFalse

@interface PKTokenizer ()
@property (nonatomic, readwrite, assign) NSUInteger lineNumber;
@end

@interface PKTokenizerState ()
- (void)resetWithReader:(PKReader *)r;
- (void)append:(PKUniChar)c;

@property (nonatomic, readwrite, assign) NSUInteger offset;
@end

@interface PKWhitespaceState ()
@property (nonatomic, readwrite, strong) NSMutableArray *whitespaceChars;
@end

@implementation PKWhitespaceState

- (instancetype)init {
    if (!(self = [super init])) { return nil; }

    const NSUInteger len = 255;
    self.whitespaceChars = [NSMutableArray arrayWithCapacity:len];

    for (NSUInteger i = 0; i <= len; i++) {
        [self.whitespaceChars addObject:PKFALSE];
    }

    [self setWhitespaceChars:YES from:0 to:' '];

    return self;
}

- (void)setWhitespaceChars:(BOOL)yn from:(PKUniChar)start to:(PKUniChar)end {
    NSUInteger len = self.whitespaceChars.count;

    if (start > len || end > len || start < 0 || end < 0) {
        [NSException raise:@"PKWhitespaceStateNotSupportedException" format:@"PKWhitespaceState only supports setting word chars for chars in the latin1 set (under 256)"];
    }

    id obj = yn ? PKTRUE : PKFALSE;
    for (NSUInteger i = start; i <= end; i++) {
        [self.whitespaceChars replaceObjectAtIndex:i withObject:obj];
    }
}

- (BOOL)isWhitespaceChar:(PKUniChar)cin {
    if (cin < 0 || cin > (self.whitespaceChars.count - 1)) {
        return NO;
    }

    return (PKTRUE == self.whitespaceChars[cin]);
}

- (PKToken *)nextTokenFromReader:(PKReader *)r startingWith:(PKUniChar)cin tokenizer:(PKTokenizer *)t {
    NSParameterAssert(r);
    if (self.reportsWhitespaceTokens) {
        [self resetWithReader:r];
    }

    PKUniChar c = cin;
    while ([self isWhitespaceChar:c]) {
        if ('\n' == c) {
            t.lineNumber++;
        }
        if (self.reportsWhitespaceTokens) {
            [self append:c];
        }
        c = [r read];
    }

    if (PKEOF != c) {
        [r unread];
    }

    if (self.reportsWhitespaceTokens) {
        PKToken *tok = [PKToken tokenWithTokenType:PKTokenTypeWhitespace stringValue:self.bufferedString doubleValue:0.0];
        tok.offset = self.offset;
        return tok;
    }

    return [t nextToken];
}

@end
