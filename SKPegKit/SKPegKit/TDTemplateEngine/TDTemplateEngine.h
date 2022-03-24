//
//  TDTemplateEngine.h
//  SKPegKit
//
//  Created by Sam Krishna on 3/24/22.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@class TDNode;
@class TDTag;
@class TDFilter;
@class TDTemplateContext;

extern NSString *const TDTemplateEngineTagEndPrefix;
extern NSString *const TDTemplateEngineErrorDomain;
extern const NSInteger TDTemplateEngineRenderingErrorCode;

@interface TDTemplateEngine : NSObject

+ (instancetype)templateEngine;

// pre-compile template into a tree
- (TDNode *)compileTemplateString:(NSString *)str error:(NSError **)err;
- (TDNode *)compileTemplateFile:(NSString *)path encoding:(NSStringEncoding)enc error:(NSError **)err;

@end

NS_ASSUME_NONNULL_END
