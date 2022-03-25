//
//  PKTokenizer.h
//  SKPegKit
//
//  Created by Sam Krishna on 3/24/22.
//

@import Foundation;
#import "PKTypes.h"

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

@property (nonatomic, readonly, assign) NSUInteger lineNumber;
@property (nonatomic, readwrite, weak) id<PKTokenizerDelegate> delegate;

@property (nonatomic, readwrite, strong) NSString *string;
@property (nonatomic, readwrite, strong) NSInputStream *stream;

+ (PKTokenizer *)tokenizer;
+ (PKTokenizer *)tokenizerWithString:(NSString *)s;
+ (PKTokenizer *)tokenizerWithStream:(NSInputStream *)s;

- (instancetype)initWithString:(NSString *)s;
- (instancetype)initWithStream:(NSInputStream *)s;

- (PKToken *)nextToken;

@property (nonatomic, readonly, strong) PKNumberState *numberState;
@property (nonatomic, readonly, strong) PKQuoteState *quoteState;
@property (nonatomic, readonly, strong) PKCommentState *commentState;
@property (nonatomic, readonly, strong) PKSymbolState *symbolState;
@property (nonatomic, readonly, strong) PKWhitespaceState *whitespaceState;
@property (nonatomic, readonly, strong) PKWordState *wordState;
@property (nonatomic, readonly, strong) PKDelimitState *delimitState;
@property (nonatomic, readonly, strong) PKURLState *URLState;
@property (nonatomic, readonly, strong) PKEmailState *emalState;
@property (nonatomic, readonly, strong) PKHashtagState *hashtagState;

@end

