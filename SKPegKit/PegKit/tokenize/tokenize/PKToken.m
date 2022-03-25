//
//  PKToken.m
//  SKPegKit
//
//  Created by Sam Krishna on 3/24/22.
//

#import "PKToken.h"
#import "PKTypes.h"
#import "NSString+PEGKitAdditions.h"

@interface PKTokenEOF : PKToken
+ (PKTokenEOF *)instance;
@end

@implementation PKTokenEOF

+ (PKTokenEOF *)instance {
    static dispatch_once_t onceToken;
    static PKTokenEOF *EOFToken;
    dispatch_once(&onceToken, ^{
        EOFToken = [[self alloc] initWithTokenType:PKTokenTypeEOF stringValue:@"«EOF»" doubleValue:0.0];
    });
    return EOFToken;
}

- (NSString *)description { return self.stringValue; }
- (NSString *)debugDescription { return [self description]; }
@end

@interface PKToken ()
@property (nonatomic, readwrite, assign) PKTokenType tokenType;
@property (nonatomic, readwrite, assign) NSUInteger offset;
@property (nonatomic, readwrite, assign) NSUInteger lineNumber;
@property (nonatomic, readwrite, assign) NSInteger tokenKind;
@property (nonatomic, readwrite, assign) double doubleValue;

@property (nonatomic, readwrite, strong) NSString *stringValue;
@property (nonatomic, readwrite, strong) NSString *quotedStringValue;
@property (nonatomic, readwrite, strong) id value;

- (BOOL)isEqual:(id)obj ignoringCase:(BOOL)ignoringCase;
@end

@implementation PKToken

+ (PKToken *)EOFToken {
    return [PKTokenEOF instance];
}

+ (instancetype)tokenWithTokenType:(PKTokenType)t stringValue:(NSString *)s doubleValue:(double)n {
    return [[self alloc] initWithTokenType:t stringValue:s doubleValue:n];
}

- (instancetype)initWithTokenType:(PKTokenType)t stringValue:(NSString *)s doubleValue:(double)n {
    if (!(self = [super init])) { return nil; }

    self.tokenType = t;
    self.stringValue = s;
    self.doubleValue = n;
    self.offset = NSNotFound;
    self.lineNumber = NSNotFound;

    return self;
}

- (BOOL)isEOF { return (self.tokenType == PKTokenTypeEOF); }
- (BOOL)isNumber { return (self.tokenType == PKTokenTypeNumber); }
- (BOOL)isQuotedString { return (self.tokenType == PKTokenTypeQuotedString); }
- (BOOL)isSymbol { return (self.tokenType == PKTokenTypeSymbol); }
- (BOOL)isWord { return (self.tokenType == PKTokenTypeWord); }
- (BOOL)isWhitespace { return (self.tokenType == PKTokenTypeWhitespace); }
- (BOOL)isComment { return (self.tokenType == PKTokenTypeComment); }
- (BOOL)isDelimitedString { return (self.tokenType == PKTokenTypeDelimitedString); }
- (BOOL)isURL { return (self.tokenType == PKTokenTypeURL); }
- (BOOL)isEmail { return (self.tokenType == PKTokenTypeEmail); }
- (BOOL)isTwitter { return (self.tokenType == PKTokenTypeTwitter); }
- (BOOL)isHashtag { return (self.tokenType == PKTokenTypeHashtag); }

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (NSUInteger)hash {
    return [self.stringValue hash];
}

- (BOOL)isEqual:(id)obj {
    return [self isEqual:obj ignoringCase:NO];
}

- (BOOL)isEqualIgnoringCase:(id)obj {
    return [self isEqual:obj ignoringCase:YES];
}

- (BOOL)isEqual:(id)obj ignoringCase:(BOOL)ignoringCase {
    if (![obj isMemberOfClass:[PKToken class]]) {
        return NO;
    }

    PKToken *tok = (PKToken *)obj;
    if (self.tokenType != tok.tokenType) {
        return NO;
    }

    if (self.isNumber) {
        return (self.doubleValue == tok.doubleValue);
    }
    else {
        if (ignoringCase) {
            return (NSOrderedSame == [self.stringValue caseInsensitiveCompare:tok.stringValue]);
        }
        else {
            return [self.stringValue isEqualToString:tok.stringValue];
        }
    }
}

- (id)value {
    if (!_value) {
        id v = nil;
        if (self.isNumber) {
            v = @(self.doubleValue);
        }
        else {
            v = self.stringValue;
        }
        _value = v;
    }

    return _value;
}

- (NSString *)quotedStringValue {
    return [self.stringValue stringByTrimmingQuotes];
}

- (NSString *)debugDescription {
    NSString *typeString = nil;
    if (self.isNumber) {
        typeString = @"Number";
    }
    else if (self.isQuotedString) {
        typeString = @"Quoted String";
    }
    else if (self.isSymbol) {
        typeString = @"Symbol";
    }
    else if (self.isWord) {
        typeString = @"Word";

    }
    else if (self.isWhitespace) {
        typeString = @"Whitespace";
    }
    else if (self.isComment) {
        typeString = @"Comment";
    }
    else if (self.isDelimitedString) {
        typeString = @"Delimited String";
    }
    else if (self.isURL) {
        typeString = @"URL";
    }
    else if (self.isEmail) {
        typeString = @"Emaail";
    }
    else if (self.isTwitter) {
        typeString = @"Twitter";
    }
    else if (self.isHashtag) {
        typeString = @"Hashtag";
    }

    return [NSString stringWithFormat:@"%@ %C%@%C", typeString, (unichar)0x00AB, self.value, (unichar)0x00BB];
}

- (NSString *)description {
    return self.stringValue;
}

@end
