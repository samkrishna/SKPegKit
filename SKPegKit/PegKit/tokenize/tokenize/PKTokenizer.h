//
//  PKTokenizer.h
//  SKPegKit
//
//  Created by Sam Krishna on 3/24/22.
//

@import Foundation;
#import <SKPegKit/PKTypes.h>

@class PKTokenizer;
@class PKToken;
@class PKTokenizerState;
@class PKNumberState;
@class PKQuoteState;
@class PKCommentState;
@class PKSymbolState;
@class PKWhitespaceState;
@class PKWordState;
@class PKDelimitState;
@class PKURLState;
@class PKEmailState;
@class PKTwitterState;
@class PKHashtagState;
@class PKReaderState;

@protocol PKTokenizerDelegate <NSObject>
- (NSInteger)tokenizer:(PKTokenizer *)t tokenKindForStringValue:(NSString *)str;
@end

@interface PKTokenizer : NSObject

+ (PKTokenizer *)tokenizer;
+ (PKTokenizer *)tokenizerWithString:(NSString *)s;
+ (PKTokenizer *)tokenizerWithStream:(NSInputStream *)s;

- (instancetype)initWithString:(NSString *)s;
- (instancetype)initWithStream:(NSInputStream *)s;

- (PKToken *)nextToken;

- (void)setTokenizerState:(PKTokenizerState *)state from:(PKUniChar)start to:(PKUniChar)end;

@property (nonatomic, readonly, assign) NSUInteger lineNumber;
@property (nonatomic, readwrite, weak) id<PKTokenizerDelegate> delegate;

@property (nonatomic, readwrite, strong) NSString *string;
@property (nonatomic, readwrite, strong) NSInputStream *stream;

@property (nonatomic, readonly, strong) PKNumberState *numberState;
@property (nonatomic, readonly, strong) PKQuoteState *quoteState;
@property (nonatomic, readonly, strong) PKCommentState *commentState;
@property (nonatomic, readonly, strong) PKSymbolState *symbolState;
@property (nonatomic, readonly, strong) PKWhitespaceState *whitespaceState;
@property (nonatomic, readonly, strong) PKWordState *wordState;
@property (nonatomic, readonly, strong) PKDelimitState *delimitState;
@property (nonatomic, readonly, strong) PKURLState *URLState;
#if PK_PLATFORM_EMAIL_STATE
@property (nonatomic, readonly, strong) PKEmailState *emalState;
#endif
#if PK_PLATFORM_TWITTER_STATE
@property (nonatomic, readonly, strong) PKTwitterState *twitterState;
@property (nonatomic, readonly, strong) PKHashtagState *hashtagState;
#endif

@end

