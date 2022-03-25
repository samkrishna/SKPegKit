//
//  TDTemplateEngine.h
//  SKPegKit
//
//  Created by Sam Krishna on 3/24/22.
//

@import Foundation;

@class TDNode;
@class TDTag;
@class TDFilter;
@class TDTemplateContext;
@class XParser;

extern NSString *const TDTemplateEngineTagEndPrefix;
extern NSString *const TDTemplateEngineErrorDomain;
extern const NSInteger TDTemplateEngineRenderingErrorCode;

@interface TDTemplateEngine : NSObject

// statitc/complile-time variables go here. This is the global scope at both compile-time and render-time. persists across compiles and renders
@property (nonatomic, readonly, strong) TDTemplateContext *staticContext;

@property (nonatomic, readwrite, strong) NSString *printStartDelimiter;
@property (nonatomic, readwrite, strong) NSString *printEndDelimiter;
@property (nonatomic, readwrite, strong) NSString *tagStartDelimiter;
@property (nonatomic, readwrite, strong) NSString *tagEndDelimiter;

+ (instancetype)templateEngine;

// pre-compile template into a tree
- (TDNode *)compileTemplateString:(NSString *)str error:(NSError **)err;
- (TDNode *)compileTemplateFile:(NSString *)path encoding:(NSStringEncoding)enc error:(NSError **)err;

// render pre-compiled tree with render-time vars
- (BOOL)renderTemplateTree:(TDNode *)root withVariables:(NSDictionary *)vars toStream:(NSOutputStream *)output error:(NSError **)err;

// convenience. compile + render with render-time vars in one-shot
- (BOOL)processTemplateString:(NSString *)str withVariables:(NSDictionary *)vars toStream:(NSOutputStream *)output error:(NSError **)err;
- (BOOL)processTemplateFile:(NSString *)path encoding:(NSStringEncoding)enc withVariables:(NSDictionary *)vars toStream:(NSOutputStream *)output error:(NSError **)err;

@end

@interface TDTemplateEngine (TagRegistration)
- (void)registerTagClass:(Class)cls forName:(NSString *)tagName;
- (Class)registeredTagClassForName:(NSString *)tagName;
- (TDFilter *)makeTagForName:(NSString *)tagName;
@end

@interface TDTemplateEngine (FilterRegistration)
- (void)registerFilterClass:(Class)cls forName:(NSString *)filterName;
- (Class)registeredFilterClassForName:(NSString *)filterName;
- (TDFilter *)makeFilterForName:(NSString *)filterName;
@end
