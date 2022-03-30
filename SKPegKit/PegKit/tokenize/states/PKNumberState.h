//
//  PKNumberState.h
//  SKPegKit
//
//  Created by Sam Krishna on 3/25/22.
//

#import <SKPegKit/PKTokenizerState.h>

@class PKSymbolRootNode;

@interface PKNumberState : PKTokenizerState

- (void)addPrefix:(NSString *)s forRadix:(NSUInteger)r;
- (void)removePrefix:(NSString *)s;

- (void)addSuffix:(NSString *)s forRadix:(NSUInteger)r;
- (void)removeSuffix:(NSString *)s;

- (void)addGroupingSeparator:(PKUniChar)sepChar forRadix:(NSUInteger)r;
- (void)removeGroupingSeparator:(PKUniChar)sepChar forRadix:(NSUInteger)r;

@property (nonatomic, readwrite, assign) BOOL allowsTrailingDecimalSeparator;
@property (nonatomic, readwrite, assign) BOOL allowsScientificNotation;
@property (nonatomic, readwrite, assign) BOOL allowsFloatingPoint;
@property (nonatomic, readwrite, assign) PKUniChar positivePrefix;
@property (nonatomic, readwrite, assign) PKUniChar negativePrefix;
@property (nonatomic, readwrite, assign) PKUniChar decimalSeparator;

@end
