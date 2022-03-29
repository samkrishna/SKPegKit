//
//  PKTokenizerState.h
//  SKPegKit
//
//  Created by Sam Krishna on 3/24/22.
//

@import Foundation;
#import <SKPegKit/PKTypes.h>

@class PKToken;
@class PKTokenizer;
@class PKReader;

@interface PKTokenizerState : NSObject

@property (nonatomic, readwrite, strong) PKTokenizerState *fallbackState;
@property (nonatomic, readwrite, assign) BOOL disabled;
@property (nonatomic, readonly, strong) NSString *bufferedString;
@property (nonatomic, readwrite, assign) NSUInteger offset;

- (PKToken *)nextTokenFromReader:(PKReader *)r startingWith:(PKUniChar)cin tokenizer:(PKTokenizer *)t;
- (PKTokenizerState *)nextTokenizerStateFor:(PKUniChar)c tokenizer:(PKTokenizer *)t;
- (void)setFallbackState:(PKTokenizerState *)state from:(PKUniChar)start to:(PKUniChar)end;

- (void)resetWithReader:(PKReader *)r;
- (void)append:(PKUniChar)c;
- (void)appendString:(NSString *)s;

@end
