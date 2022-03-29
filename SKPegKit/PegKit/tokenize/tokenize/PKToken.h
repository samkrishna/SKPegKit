//
//  PKToken.h
//  SKPegKit
//
//  Created by Sam Krishna on 3/24/22.
//

@import Foundation;
#import <SKPegKit/PKTypes.h>

typedef NS_ENUM(NSInteger, PKTokenType) {
    PKTokenTypeEOF = -1,
    PKTokenTypeInvalid = 0,
    PKTokenTypeNumber = 1,
    PKTokenTypeQuotedString = 2,
    PKTokenTypeSymbol = 3,
    PKTokenTypeWord = 4,
    PKTokenTypeWhitespace = 5,
    PKTokenTypeComment = 6,
    PKTokenTypeDelimitedString = 7,
    PKTokenTypeURL = 8,
    PKTokenTypeEmail = 9,
    PKTokenTypeTwitter = 10,
    PKTokenTypeHashtag = 11,
    PKTokenTypeEmpty = 12,
    PKTokenTypeAny = 13
};

@interface PKToken : NSObject <NSCopying>

@property (nonatomic, readonly, assign) BOOL isEOF;
@property (nonatomic, readonly, assign) BOOL isNumber;
@property (nonatomic, readonly, assign) BOOL isQuotedString;
@property (nonatomic, readonly, assign) BOOL isSymbol;
@property (nonatomic, readonly, assign) BOOL isWord;
@property (nonatomic, readonly, assign) BOOL isWhitespace;
@property (nonatomic, readonly, assign) BOOL isComment;
@property (nonatomic, readonly, assign) BOOL isDelimitedString;
@property (nonatomic, readonly, assign) BOOL isURL;
@property (nonatomic, readonly, assign) BOOL isEmail;
@property (nonatomic, readonly, assign) BOOL isTwitter;
@property (nonatomic, readonly, assign) BOOL isHashtag;

@property (nonatomic, readwrite, assign) NSUInteger offset;

@property (nonatomic, readonly, assign) PKTokenType tokenType;
@property (nonatomic, readonly, assign) NSUInteger lineNumber;
@property (nonatomic, readonly, assign) NSInteger tokenKind;
@property (nonatomic, readonly, assign) double doubleValue;

@property (nonatomic, readonly, strong) NSString *stringValue;
@property (nonatomic, readonly, strong) NSString *quotedStringValue;
@property (nonatomic, readonly, strong) id value;

+ (PKToken *)EOFToken;

+ (instancetype)tokenWithTokenType:(PKTokenType)t stringValue:(NSString *)s doubleValue:(double)n;

- (instancetype)initWithTokenType:(PKTokenType)t stringValue:(NSString *)s doubleValue:(double)n;

- (BOOL)isEqualIgnoringCase:(id)obj;

- (NSString *)debugDescription;

@end

