//
//  PKNumberState.m
//  SKPegKit
//
//  Created by Sam Krishna on 3/25/22.
//

#import "PKReader.h"
#import "PKToken.h"
#import "PKTokenizer.h"
#import "PKSymbolState.h"
#import "PKWhitespaceState.h"
#import "PKSymbolRootNode.h"
#import "PKNumberState.h"

@interface PKNumberState ()
@property (nonatomic, readwrite, strong) PKSymbolRootNode *prefixRootNode;
@property (nonatomic, readwrite, strong) PKSymbolRootNode *suffixRootNode;
@property (nonatomic, readwrite, strong) NSMutableDictionary *radixForPrefix;
@property (nonatomic, readwrite, strong) NSMutableDictionary *radixForSuffix;
@property (nonatomic, readwrite, strong) NSMutableDictionary *separatorsForRadix;

@property (nonatomic, readwrite, strong) NSString *prefix;
@property (nonatomic, readwrite, strong) NSString *suffix;
@property (nonatomic, readonly, assign) double value;
@end

@implementation PKNumberState {
    BOOL _isFraction;
    BOOL _isNegative;
    BOOL _gotADigit;
    NSUInteger _base;
    PKUniChar _originalCin;
    PKUniChar _c;
    double _doubleValue;

    NSUInteger _exp;
    BOOL _isNegativeExp;
}

- (instancetype)init {
    if (!(self = [super init])) { return nil; }

    self.prefixRootNode = [[PKSymbolRootNode alloc] init];
    self.suffixRootNode = [[PKSymbolRootNode alloc] init];
    self.radixForPrefix = [NSMutableDictionary dictionary];
    self.radixForSuffix = [NSMutableDictionary dictionary];
    self.separatorsForRadix = [NSMutableDictionary dictionary];

    self.allowsFloatingPoint = YES;
    self.positivePrefix = '+';
    self.negativePrefix = '-';
    self.decimalSeparator = '.';

    return self;
}

- (void)addPrefix:(NSString *)s forRadix:(NSUInteger)r {
    NSParameterAssert(s.length);
    NSParameterAssert(NSNotFound != r);
    TDConditionAssert(_radixForPrefix);

    [_prefixRootNode add:s];
    NSNumber *n = @(r);
    self.radixForPrefix[s] = n;
}

- (void)addSuffix:(NSString *)s forRadix:(NSUInteger)r {
    NSParameterAssert(s.length);
    NSParameterAssert(NSNotFound != r);
    TDConditionAssert(_radixForSuffix);
    [_prefixRootNode add:s];
    NSNumber *n = @(r);
    self.radixForSuffix[s] = n;
}

- (void)removePrefix:(NSString *)s {
    NSParameterAssert(s.length);
    TDConditionAssert(_radixForPrefix);
    TDConditionAssert(self.radixForPrefix[s]);
    [self.radixForPrefix removeObjectForKey:s];
}

- (void)removeSuffix:(NSString *)s {
    NSParameterAssert(s.length);
    TDConditionAssert(_radixForSuffix);
    TDConditionAssert(self.radixForSuffix[s]);
    [self.radixForSuffix removeObjectForKey:s];
}

- (void)addGroupingSeparator:(PKUniChar)c forRadix:(NSUInteger)r {

}

- (void)removeGroupingSeparator:(PKUniChar)c {

}

- (NSUInteger)radixForPrefix:(NSString *)s {
    NSParameterAssert(s.length);
    TDConditionAssert(self.radixForPrefix);
    NSNumber *n = self.radixForPrefix[s];
    NSUInteger r = n.unsignedIntegerValue;
    return r;
}

- (NSUInteger)radixForSuffix:(NSString *)s {
    NSParameterAssert(s.length);
    TDConditionAssert(self.radixForSuffix);
    NSNumber *n = self.radixForSuffix[s];
    NSUInteger r = n.unsignedIntegerValue;
    return r;
}

- (void)resetWithReader:(PKReader *)r startingWith:(PKUniChar)cin {
    [super resetWithReader:r];
    self.prefix = nil;
    self.suffix = nil;

    _base = 10;
    _isNegative = NO;
    _originalCin = cin;
}

- (PKUniChar)checkForPositiveNegativeFromReader:(PKReader *)r startingWith:(PKUniChar)cin {
    if (_negativePrefix == cin) {
        _isNegative = YES;
        cin = [r read];
        [self append:_negativePrefix];
    }
    else if (_positivePrefix == cin) {
        cin = [r read];
        [self append:_positivePrefix];
    }

    return cin;
}

- (BOOL)isValidSeparator:(PKUniChar)sepChar forRadix:(NSUInteger)radix {
    TDConditionAssert(_base > 1);
    if (PKEOF == sepChar) { return NO; }
    NSNumber *radixKey = @(radix);
    NSMutableSet *vals = self.separatorsForRadix[radixKey];
    NSNumber *sepVal = @(sepChar);
    BOOL result = [vals containsObject:sepVal];
    return result;
}

- (PKUniChar)checkForPrefixFromReader:(PKReader *)r startingWith:(PKUniChar)cin {
    if (PKEOF != cin) {
        self.prefix = [_prefixRootNode nextSymbol:r startingWith:cin];
        NSUInteger radix = [self radixForPrefix:_prefix];
        BOOL foundPrefix = NO;

        if (radix > 1 && NSNotFound != radix) {
            PKUniChar peek = [r read];
            if (PKEOF != peek) {
                [r unread];
            }

            if ([self isDigit:peek forRadix:radix]) {
                TDConditionAssert(PKEOF != peek);
                TDConditionAssert(peek != _decimalSeparator);
                TDConditionAssert(![self isValidSeparator:peek forRadix:radix]);
                foundPrefix = YES;
                [self appendString:_prefix];
                _base = radix;
            }
        }

        if (!foundPrefix) {
            _base = 16;
            [r unread:_prefix.length];
            self.prefix = nil;
        }

        cin = [r read];
    }

    return cin;
}

- (BOOL)isDigit:(PKUniChar)c forRadix:(NSUInteger)radix {
    BOOL isDigit = isdigit(c);
    BOOL isHexAlpha = (16 == radix && !isDigit && ishexnumber(c));
    return isDigit || isHexAlpha;
}

- (void)parseAllDigitsFromReader:(PKReader *)r startingWith:(PKUniChar)cin {
    [self prepareToParseDigits:cin];
    if (_decimalSeparator == _c) {
        if (10 == _base && _allowsFloatingPoint) {
            [self parseRightSideFromReader:r];
        }
    }
    else {
        [self parseLeftSideFromReader:r];
        if (10 == _base && _allowsFloatingPoint) {
            [self parseRightSideFromReader:r];
        }
    }
}

- (PKToken *)checkForErroneousMatchFromReader:(PKReader *)r tokenizer:(PKTokenizer *)t {
    PKToken *tok = nil;

    if (!_gotADigit) {
        if (_prefix && '0' == _originalCin) {
            [r unread];
            tok = [PKToken tokenWithTokenType:PKTokenTypeNumber stringValue:@"0" doubleValue:0.0];
        }
        else {
            if ((_originalCin == _positivePrefix || _originalCin == _negativePrefix) && PKEOF != _c) {
                [r unread];
            }
            tok = [[self nextTokenizerStateFor:_originalCin tokenizer:t] nextTokenFromReader:r startingWith:_originalCin tokenizer:t];
        }
    }

    return tok;
}

- (void)applySuffixFromReader:(PKReader *)r {
    NSParameterAssert(r);
    NSUInteger len = _suffix.length;
    TDConditionAssert(len && len != NSNotFound);
    for (NSUInteger i = 0; i < len; ++i) {
        [r read];
    }

    [self appendString:_suffix];
}

- (PKToken *)nextTokenFromReader:(PKReader *)r startingWith:(PKUniChar)cin tokenizer:(PKTokenizer *)t {
    NSParameterAssert(r);
    NSParameterAssert(t);

    // reset first
    [self resetWithReader:r startingWith:cin];

    // then check for explicit positive, negative (e.g. `+1`, `-2`)
    cin = [self checkForPositiveNegativeFromReader:r startingWith:cin];

    // then check for prefix (e.g. `$`, `%`, `0x`)
    cin = [self checkForPrefixFromReader:r startingWith:cin];

    // then check for suffix (e.g. `h`, `b`)
    cin = [self checkForSuffixFromReader:r startingWith:cin tokenizer:t];

    // then absorb all digits on both sides of decimal point
    [self parseAllDigitsFromReader:r startingWith:cin];

    // check for erroneous `.`, `+`, `-`, `0x`, `$`, etc.
    PKToken *tok = [self checkForErroneousMatchFromReader:r tokenizer:t];
    if (!tok) {
        // unread one char
        if (PKEOF != _c) { [r unread]; }

        // apply negative
        if (_isNegative) { _doubleValue = -_doubleValue; }

        // apply suffix
        if (_suffix) { [self applySuffixFromReader:r]; }

        tok = [PKToken tokenWithTokenType:PKTokenTypeNumber stringValue:self.bufferedString doubleValue:self.value];
    }

    tok.offset = self.offset;
    return tok;
}

- (double)value {
    double result = _doubleValue;

    for (NSUInteger i = 0; i < _exp; i++) {
        if (_isNegativeExp) {
            result /= _base;
        }
        else {
            result *= _base;
        }
    }

    return result;
}

- (PKUniChar)checkForSuffixFromReader:(PKReader *)r startingWith:(PKUniChar)cin tokenizer:(PKTokenizer *)t {
    if (_radixForSuffix.count && !_prefix) {
        PKUniChar nextChar = cin;
        PKUniChar lastChar = PKEOF;
        NSUInteger len = 0;

        for (;;) {
            if (PKEOF == nextChar || [t.whitespaceState isWhitespaceChar:nextChar]) {
                TDConditionAssert(PKEOF != lastChar && '\0' != lastChar);
                NSString *str = [NSString stringWithCharacters:(const unichar *)&lastChar length:1];
                TDConditionAssert(str);
                NSNumber *n = self.radixForSuffix[str];
                if (n) {
                    self.suffix = str;
                    _base = n.unsignedIntegerValue;
                }
                break;
            }
            ++len;
            [self append:nextChar];
            lastChar = nextChar;
            nextChar = [r read];
        }

        [r unread:(PKEOF == nextChar) ? (len - 1) : len];
        [self resetWithReader:r];
    }
    return cin;
}

- (void)parseLeftSideFromReader:(PKReader *)r {
    _isFraction = NO;
    _doubleValue = [self absorbDigitsFromReader:r];
}

- (void)parseRightSideFromReader:(PKReader *)r {
    if (_decimalSeparator == _c) {
        PKUniChar n = [r read];
        BOOL nextIsDigit = isdigit(n);
        if (PKEOF != n) {
            [r unread];
        }

        if (nextIsDigit || _allowsTrailingDecimalSeparator) {
            [self append:_decimalSeparator];
            if (nextIsDigit) {
                _c = [r read];
                _isFraction = YES;
                _doubleValue = [self absorbDigitsFromReader:r];
            }
        }
    }

    if (_allowsScientificNotation) {
        [self parseExponentFromReader:r];
    }
}

- (void)parseExponentFromReader:(PKReader *)r {
    NSParameterAssert(r);
    if ('e' == _c || 'E' == _c) {
        PKUniChar e = _c;
        _c = [r read];

        BOOL hasExp = isdigit(_c);
        _isNegativeExp = (_negativePrefix == _c);
        BOOL positiveExp = (_positivePrefix == _c);

        if (!hasExp && (_isNegativeExp || positiveExp)) {
            _c = [r read];
            hasExp = isdigit(_c);
        }
        if (PKEOF != _c) {
            [r unread];
        }
        if (hasExp) {
            [self append:e];
            if (_isNegativeExp) {
                [self append:_negativePrefix];
            }
            else if (positiveExp) {
                [self append:_positivePrefix];
            }
            _c = [r read];
            _isFraction = NO;
            _exp = [self absorbDigitsFromReader:r];
        }
    }
}

- (double)absorbDigitsFromReader:(PKReader *)r {
    double dividedBy = 1.0;
    double v = 0.0;
    BOOL isDigit = NO;
    BOOL isHexAlpha = NO;

    for (;;) {
        isDigit = isdigit(_c);
        isHexAlpha = (16 == _base && !isDigit && ishexnumber(_c));

        if (isDigit || isHexAlpha) {
            [self append:_c];
            _gotADigit = YES;

            if (isHexAlpha) {
                _c = toupper(_c);
                _c -= 7;
            }

            v = v * _base + (_c - '0');
            _c = [r read];
            if (_isFraction) {
                dividedBy *= _base;
            }
        }
        else if (_gotADigit && [self isValidSeparator:_c forRadix:_base]) {
            [self append:_c];
            _c = [r read];
        }
        else {
            break;
        }
    }

    if (_isFraction) {
        v = v / dividedBy;
    }

    return v;
}

- (void)prepareToParseDigits:(PKUniChar)cin {
    _c = cin;
    _gotADigit = NO;
    _isFraction = NO;
    _doubleValue = 0.0;
    _exp = 0;
    _isNegativeExp = NO;
}

@end
