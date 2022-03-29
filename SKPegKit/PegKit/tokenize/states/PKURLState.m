//
//  PKURLState.m
//  SKPegKit
//
//  Created by Sam Krishna on 3/25/22.
//

#import "PKURLState.h"
#import "PKReader.h"
#import "PKTokenizer.h"
#import "PKTypes.h"
#import "PKToken.h"

// Gruber original
//  \b(([\w-]+://?|www[.])[^\s()<>]+(?:\([\w\d]+\)|([^[:punct:]\s]|/)))

@interface PKTokenizerState ()
- (PKTokenizerState *)nextTokenizerStateFor:(PKUniChar)c tokenizer:(PKTokenizer *)t;
- (void)resetWithReader:(PKReader *)r;
- (void)append:(PKUniChar)c;

@property (nonatomic, readonly, strong) NSString *bufferedString;
@property (nonatomic, readonly, assign) NSUInteger offset;
@end

@interface PKURLState ()
@property (nonatomic, readwrite, assign) PKUniChar c;
@property (nonatomic, readwrite, assign) PKUniChar lastChar;
@end

@implementation PKURLState

- (instancetype)init {
    if (!(self = [super init])) { return nil; }

    self.allowsWWWPrefix = YES;

    return self;
}

- (void)append:(PKUniChar)ch {
    self.lastChar = ch;
    [super append:ch];
}

- (PKToken *)nextTokenFromReader:(PKReader *)r startingWith:(PKUniChar)cin tokenizer:(PKTokenizer *)t {
    NSParameterAssert(r);
    [self resetWithReader:r];

    self.lastChar = PKEOF;
    self.c = cin;
    BOOL matched = NO;

    if (self.allowsWWWPrefix && 'w' == self.c) {
        matched = [self parseWWWFromReader:r];

        if (!matched) {
            if (PKEOF != self.c) {
                NSUInteger buffLen = self.bufferedString.length;
                [r unread:buffLen];
            }
            [self resetWithReader:r];
            self.c = cin;
        }
    }

    if (!matched) {
        matched = [self parseSchemeFromReader:r];
    }
    if (matched) {
        matched = [self parseHostFromReader:r];
    }
    if (matched) {
        [self parsePathFromReader:r];
    }

    NSString *s = self.bufferedString;

    if (PKEOF != self.c) {
        [r unread];
    }

    if (matched) {
        if ('.' == self.lastChar || ',' == self.lastChar || '-' == self.lastChar) {
            s = [s substringToIndex:(s.length - 1)];
            [r unread];
        }

        PKToken *tok = [PKToken tokenWithTokenType:PKTokenTypeURL stringValue:s doubleValue:0.0];
        tok.offset = self.offset;
        return tok;
    }
    else {
        [r unread:(s.length - 1)];
        return [[self nextTokenizerStateFor:cin tokenizer:t] nextTokenFromReader:r startingWith:cin tokenizer:t];
    }
}

- (BOOL)parseWWWFromReader:(PKReader *)r {
    BOOL result = NO;
    NSUInteger wcount = 0;

    while ('w' == self.c) {
        wcount++;
        [self append:self.c];
        self.c = [r read];

        if (3 == wcount) {
            if ('.' == self.c) {
                [self append:self.c];
                self.c = [r read];
                result = YES;
                break;
            }
            else {
                result = NO;
                break;
            }
        }
    }

    return result;
}

- (BOOL)parseSchemeFromReader:(PKReader *)r {
    BOOL result = NO;

    // [[:alpha:]-]+://?
    for (;;) {
        if (isalnum(_c) || '-' == _c) {
            [self append:_c];
        }
        else if (':' == _c) {
            [self append:_c];

            self.c = [r read];
            if ('/' == _c) { // endgame
                [self append:_c];
                self.c = [r read];
                if ('/' == _c) {
                    [self append:_c];
                    self.c = [r read];
                }
                result = YES;
                break;
            }
            else {
                result = NO;
                break;
            }
        }
        else {
            result = NO;
            break;
        }

        self.c = [r read];
    }

    return result;
}

- (BOOL)parseHostFromReader:(PKReader *)r {
    BOOL result = NO;
    BOOL hasAtLeastOneChar = NO;

    for (;;) {
        if (PKEOF == _c || isspace(_c) || '(' == _c || ')' == _c || '<' == _c || '>' == _c) {
            result = hasAtLeastOneChar;
            break;
        }
        else if ('/' == _c && hasAtLeastOneChar) {
            result = YES;
            break;
        }
        else {
            hasAtLeastOneChar = YES;
            [self append:_c];
            self.c = [r read];
        }
    }

    return result;
}

- (void)parsePathFromReader:(PKReader *)r {
    BOOL hasOpenParen = NO;

    for (;;) {
        if (PKEOF == _c || isspace(_c) || '<' == _c || '>' == _c) {
            break;
        }
        else if (')' == _c) {
            if (hasOpenParen) {
                hasOpenParen = NO;
                [self append:_c];
            }
            else {
                break;
            }
        }
        else {
            if (!hasOpenParen) {
                hasOpenParen = ('(' == _c);
            }
            [self append:_c];
        }
        self.c = [r read];
    }
}

@end
