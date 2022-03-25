//
//  PKToken.h
//  SKPegKit
//
//  Created by Sam Krishna on 3/24/22.
//

@import Foundation;
#import "PKTypes.h"

typedef NS_ENUM(NSInteger, PKTokenType) {
    PKTokenTypeEOF = -1,
    PKTokenTypeInvalid = 0,
    PKTokenTypeNumber,
    PKTokenTypeQuotedString,
    PKTokenTypeSymbol,
    PKTokenTypeWord,
    PKTokenTypeWhitespace,
    PKTokenTypeComment,
    PKTokenTypeDelimitedString,
    PKTokenTypeURL,
    PKTokenTypeEmail,
    PKTokenTypeTwitter,
    PKTokenTypeHashtag,
    PKTokenTypeEmpty,
    PKTokenTypeAny
};

@interface PKToken : NSObject <NSCopying>

//+ (PKToken *)EOFToken;
//
//+ (instancetype)tokenWithTokenType:(PKTokenType)t stringValue:(NSString *)s doubleValue:(double)n;
//
//- (instancetype)initWithTokenType:(PKTokenType)t stringValue:(NSString *)s doubleValue:(double)n;
//
//- (BOOL)isEqualIgnoringCase:(id)obj;
//
//- (NSString *)debugDescription;

@end

