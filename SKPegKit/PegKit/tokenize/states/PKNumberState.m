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

- (void)removePrefix:(NSString *)s {

}

- (void)addSuffix:(NSString *)s forRadix:(NSUInteger)r {

}

- (void)removeSuffix:(NSString *)s {

}

- (void)addGroupingSeparator:(PKUniChar)c forRadix:(NSUInteger)r {

}

- (void)removeGroupingSeparator:(PKUniChar)c {

}

@end
