//
//  PKTokenizer.m
//  SKPegKit
//
//  Created by Sam Krishna on 3/24/22.
//

#import <SKPegKit/SKPegKit.h>

#define STATE_COUNT 256

@interface PKToken ()
@property (nonatomic, readwrite, assign) NSUInteger lineNumber;
@end

@interface PKTokenizerState ()
- (PKTokenizerState *)nextTokenizerStateFor:(PKUniChar)c tokenizer:(PKTokenizer *)t;
@end

@interface PKTokenizer ()
@property (nonatomic, readwrite, strong) PKReader *reader;
@property (nonatomic, readwrite, strong) NSMutableArray *tokenizerStates;
@property (nonatomic, readwrite, assign) NSUInteger lineNumber;
@property (nonatomic, readwrite, strong) PKNumberState *numberState;
@property (nonatomic, readwrite, strong) PKQuoteState *quoteState;
@property (nonatomic, readwrite, strong) PKCommentState *commentState;
@property (nonatomic, readwrite, strong) PKSymbolState *symbolState;
@property (nonatomic, readwrite, strong) PKWhitespaceState *whitespaceState;
@property (nonatomic, readwrite, strong) PKWordState *wordState;
@property (nonatomic, readwrite, strong) PKDelimitState *delimitState;
@property (nonatomic, readwrite, strong) PKURLState *URLState;
#if PK_PLATFORM_EMAIL_STATE
@property (nonatomic, readwrite, strong) PKEmailState *emalState;
#endif
#if PK_PLATFORM_TWITTER_STATE
@property (nonatomic, readwrite, strong) PKTwitterState *twitterState;
@property (nonatomic, readwrite, strong) PKHashtagState *hashtagState;
#endif

- (instancetype)initWithString:(NSString *)str stream:(NSInputStream *)stm;
- (PKTokenizerState *)tokenizerStateFor:(PKUniChar)c;
- (PKTokenizerState *)defaultTokenizerStateFor:(PKUniChar)c;
- (NSInteger)tokenKindForStringValue:(NSString *)str;
@end

@implementation PKTokenizer

+ (PKTokenizer *)tokenizer {
    return [self tokenizerWithString:nil];
}

+ (PKTokenizer *)tokenizerWithString:(NSString *)s {
    return [[self alloc] initWithString:s];
}

+ (PKTokenizer *)tokenizerWithStream:(NSInputStream *)s {
    return [[self alloc] initWithStream:s];
}

- (instancetype)init {
    return [self initWithString:nil stream:nil];
}

- (instancetype)initWithString:(NSString *)s {
    self = [self initWithString:s stream:nil];
    return self;
}

- (instancetype)initWithStream:(NSInputStream *)s {
    self = [self initWithString:nil stream:s];
    return self;
}

- (void)setString:(NSString *)s {
    if (_string != s) {
        _string = [s copy];
    }
}

- (PKToken *)nextToken {
    NSCAssert(self.reader, @"");
    PKUniChar c = [self.reader read];

    PKToken *result = nil;

    if (PKEOF == c) {
        result = [PKToken EOFToken];
    }
    else {
        PKTokenizerState *state = [self tokenizerStateFor:c];

        if (state) {
            result = [state nextTokenFromReader:_reader startingWith:c tokenizer:self];
            result.lineNumber = _lineNumber;
        }
        else {
            result = [PKToken EOFToken];
        }
    }

    return result;
}

- (void)setTokenizerState:(PKTokenizerState *)state from:(PKUniChar)start to:(PKUniChar)end {

}

@end
