//
//  PKWordState.m
//  SKPegKit
//
//  Created by Sam Krishna on 3/25/22.
//

#import "PKReader.h"
#import "PKTokenizer.h"
#import "PKToken.h"
#import <SKPegKit/PKTypes.h>
#import "PKWordState.h"

#define PKTRUE (id)kCFBooleanTrue
#define PKFALSE (id)kCFBooleanFalse

@interface PKTokenizerState ()
- (void)resetWithReader:(PKReader *)r;
- (void)append:(PKUniChar)c;

@property (nonatomic, readonly, strong) NSString *bufferedString;
@property (nonatomic, readwrite, assign) NSUInteger offset;
@end

@interface PKWordState ()
@property (nonatomic, readwrite, strong) NSMutableArray *wordChars;
@end

@implementation PKWordState

- (instancetype)init {
    if (!(self = [super init])) { return nil; }

    self.wordChars = [NSMutableArray arrayWithCapacity:256];
    for (NSUInteger i = 0; i < 256; i++) {
        [self.wordChars addObject:PKFALSE];
    }

    [self setWordChars:YES from: 'a' to: 'z'];
    [self setWordChars:YES from: 'A' to: 'Z'];
    [self setWordChars:YES from: '0' to: '9'];
    [self setWordChars:YES from: '-' to: '-'];
    [self setWordChars:YES from: '_' to: '_'];
    [self setWordChars:YES from:'\'' to:'\''];
    [self setWordChars:YES from:0xC0 to:0xFF];

    return self;
}

- (void)setWordChars:(BOOL)yn from:(PKUniChar)start to:(PKUniChar)end {
    NSUInteger len = self.wordChars.count;
    if (start > len || end > len || start < 0 || end < 0) {
        [NSException raise:@"PKWordStateNotSupportedException" format:@"PKWordState only supports setting word chars for chars in the latin1 set (under 256)"];
    }

    id obj = yn ? PKTRUE : PKFALSE;
    for (NSUInteger i = start; i <= end; i++) {
        [self.wordChars replaceObjectAtIndex:i withObject:obj];
    }
}

- (BOOL)isWordChar:(PKUniChar)c {
    if (c > PKEOF && c < (self.wordChars.count - 1)) {
        return (PKTRUE == self.wordChars[c]);
    }

    if (c >= 0x2000 && c <= 0x2BFF) { // various symbols
        return NO;
    }
    else if (c >= 0xFE30 && c <= 0xFE6F) { // general punctuation
        return NO;
    }
    else if (c >= 0xFE30 && c <= 0xFE6F) { // western musical symbols
        return NO;
    }
    else if (c >= 0xFF00 && c <= 0xFF65) { // symbols within Hiragana & Katakana
        return NO;
    }
    else if (c >= 0xFFF0 && c <= 0xFFFF) { // specials
        return NO;
    }
    else if (c < 0) {
        return NO;
    }

    return YES;
}

- (PKToken *)nextTokenFromReader:(PKReader *)r startingWith:(PKUniChar)cin tokenizer:(PKTokenizer *)t {
    NSParameterAssert(r);
    [self resetWithReader:r];

    PKUniChar c = cin;
    do {
        [self append:c];
        c = [r read];
    } while ([self isWordChar:c]);

    if (PKEOF != c) {
        [r unread];
    }

    PKToken *tok = [PKToken tokenWithTokenType:PKTokenTypeWord stringValue:self.bufferedString doubleValue:0.0];
    tok.offset = self.offset;
    return tok;
}

@end
