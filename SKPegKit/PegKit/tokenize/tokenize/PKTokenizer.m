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

- (instancetype)initWithString:(NSString *)str stream:(NSInputStream *)stm {
    if (!(self = [super init])) { return nil; }

    self.string = str;
    self.stream = stm;
    self.reader = [[PKReader alloc] init];

    self.numberState = [[PKNumberState alloc] init];
    self.quoteState = [[PKQuoteState alloc] init];
    self.commentState = [[PKCommentState alloc] init];
    self.symbolState = [[PKSymbolState alloc] init];
    self.whitespaceState = [[PKWhitespaceState alloc] init];
    self.wordState = [[PKWordState alloc] init];
    self.delimitState = [[PKDelimitState alloc] init];
    self.URLState = [[PKURLState alloc] init];

#if PK_PLATFORM_EMAIL_STATE
    self.emalState = [[PKEmailState alloc] init];
    self.emalState.fallbackState = self.wordState;
#endif
#if PK_PLATFORM_TWITTER_STATE
    self.twitterState = [[PKTwitterState alloc] init];
    self.hashtagState = [[PKHashtagState alloc] init];
    self.twitterState.fallbackState = self.symbolState;
    self.hashtagState.fallbackState = self.symbolState;
#endif

    self.numberState.fallbackState = self.symbolState;
    self.quoteState.fallbackState = self.symbolState;
    self.URLState.fallbackState = self.wordState;

    self.tokenizerStates = [NSMutableArray arrayWithCapacity:STATE_COUNT];

    for (NSUInteger i = 0; i < STATE_COUNT; i++) {
        [self.tokenizerStates addObject:[self defaultTokenizerStateFor:(PKUniChar)i]];
    }

    [self.symbolState add:@"<="];
    [self.symbolState add:@">="];
    [self.symbolState add:@"!="];
    [self.symbolState add:@"=="];

    [self.commentState addSingleLineStartMarker:@"//"];
    [self.commentState addMultiLineStartMarker:@"/*" endMarker:@"*/"];
    [self setTokenizerState:self.commentState from:'/' to:'/'];

    return self;
}

- (void)dealloc {
    self.delegate = nil;
}

- (void)setString:(NSString *)s {
    if (_string != s) {
        _string = [s copy];
    }

    self.reader.string = _string;
    self.lineNumber = 1;
}

- (void)setStream:(NSInputStream *)s {
    if (_stream != s) {
        _stream = s;
    }

    self.reader.stream = _stream;
    self.lineNumber = 1;
}

- (PKToken *)nextToken {
    TDConditionAssert(self.reader);
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
    NSParameterAssert(state);
    TDConditionAssert(self.tokenizerStates);

    for (NSUInteger i = start; i <= end; i++) {
        [self.tokenizerStates replaceObjectAtIndex:i withObject:state];
    }
}

- (PKTokenizerState *)tokenizerStateFor:(PKUniChar)c {
    PKTokenizerState *state = nil;

    if (c < 0 || c >= STATE_COUNT) {
        // Customization above 255 is not supported, so fetch default
        state = [self defaultTokenizerStateFor:c];
    }
    else {
        state = self.tokenizerStates[c];
    }

    while (state.disabled) {
        state = [state nextTokenizerStateFor:c tokenizer:self];
    }

    TDConditionAssert(state);
    return state;
}

- (PKTokenizerState *)defaultTokenizerStateFor:(PKUniChar)c {
    if (c >= 0 && c <= ' ') {
        return self.whitespaceState;
    }
    else if (c == 33) {
        return self.symbolState;
    }
    else if (c == '"') {
        return self.quoteState;
    }
    else if (c == '#') {
#if PK_PLATFORM_TWITTER_STATE
        return self.hashtagState;
#else
        return self.symbolState;
#endif
    }
    else if (c >= 36 && c <= 38) {
        return self.symbolState;
    }
    else if (c == '\'') {
        return self.quoteState;
    }
    else if (c >= 40 && c <= 42) {
        return self.symbolState;
    }
    else if (c == '+') {
        return self.symbolState;
    }
    else if (c == 44) {
        return self.symbolState;
    }
    else if (c == '-') {
        return self.numberState;
    }
    else if (c == '.') {
        return self.numberState;
    }
    else if (c == '/') {
        return self.symbolState;
    }
    else if (c >= '0' && c <= '9') {
        return self.numberState;
    }
    else if (c >= 58 && c <= 63) {
        return self.symbolState;
    }
    else if (c == '@') {
#if PK_PLATFORM_TWITTER_STATE
        return self.twitterState;
#else
        return self.symbolState;
#endif
    }
    else if (c >= 'A' && c <= 'Z') {
        return self.URLState;
    }
    else if (c >= 91 && c <= 96) {
        return self.symbolState;
    }
    else if (c >= 'a' && c <= 'z') {
        return self.URLState;
    }
    else if (c >= 123 && c <= 191) {
        return self.symbolState;
    }
    else if (c >= 123 && c <= 191) {
        return self.symbolState;
    }
    else if (c >= 0xC0 && c <= 0xFF) { // From:192 to:255    From:0xC0 to:0xFF
        return self.wordState;
    }
    else if (c >= 0x19E0 && c <= 0x19FF) { // khmer symbols
        return _symbolState;
    }
    else if (c >= 0x2000 && c <= 0x2BFF) { // various symbols
        return _symbolState;
    }
    else if (c >= 0x2E00 && c <= 0x2E7F) { // supplemental punctuation
        return _symbolState;
    }
    else if (c >= 0x3000 && c <= 0x303F) { // cjk symbols & punctuation
        return _symbolState;
    }
    else if (c >= 0x3200 && c <= 0x33FF) { // enclosed cjk letters and months, cjk compatibility
        return _symbolState;
    }
    else if (c >= 0x4DC0 && c <= 0x4DFF) { // yijing hexagram symbols
        return _symbolState;
    }
    else if (c >= 0xFE30 && c <= 0xFE6F) { // cjk compatibility forms, small form variants
        return _symbolState;
    }
    else if (c >= 0xFF00 && c <= 0xFFFF) { // hiragana & katakana halfwitdh & fullwidth forms, Specials
        return _symbolState;
    }

    return _wordState;
}

- (NSInteger)tokenKindForStringValue:(NSString *)str {
    NSInteger x = 0;
    if (self.delegate) {
        x = [self.delegate tokenizer:self tokenKindForStringValue:str];
    }

    return x;
}


@end
