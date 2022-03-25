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
@class PKDelimiterState;
@class PKURLState;
@class PKEmailState;
@class PKTwitterState;
@class PKHashtagState;
@class PKReaderState;

@protocol PKTokenizerDelegate <NSObject>
- (NSInteger)tokenizer:(PKTokenizer *)t tokenKindForStringValue:(NSString *)str;
@end

@interface PKTokenizer : NSObject

@property (nonatomic, readwrite, strong) NSString *string;
@property (nonatomic, readwrite, strong) NSInputStream *stream;

+ (PKTokenizer *)tokenizer;
+ (PKTokenizer *)tokenizerWithString:(NSString *)s;
+ (PKTokenizer *)tokenizerWithStream:(NSInputStream *)s;

- (instancetype)initWithString:(NSString *)s;
- (instancetype)initWithStream:(NSInputStream *)s;

- (PKToken *)nextToken;

@end

