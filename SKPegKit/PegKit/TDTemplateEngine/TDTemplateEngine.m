//
//  TDTemplateEngine.m
//  SKPegKit
//
//  Created by Sam Krishna on 3/24/22.
//

#import "TDTemplateEngine.h"

NSString *const TDTemplateEngineTagEndPrefix = @"/";
NSString *const TDTemplateEngineErrorDomain = @"TDTemplateEngineErrorDomain";
const NSInteger TDTemplateEngineRenderingErrorCode = 1;

@interface TDTemplateEngine ()
@property (nonatomic, readwrite, strong) NSRegularExpression *delimiterRegex;
@property (nonatomic, readwrite, strong) NSRegularExpression *cleanerRegex;
@property (nonatomic, readwrite, strong) TDTemplateContext *staticContext;
@property (nonatomic, readwrite, strong) NSMutableDictionary *tagTab;
@property (nonatomic, readwrite, strong) NSMutableDictionary *filterTab;
@property (nonatomic, readwrite, strong) XParser *expressionParser;
@end

@implementation TDTemplateEngine

+ (instancetype)templateEngine {
    return [[TDTemplateEngine alloc] init];
}

- (instancetype)init {
    if (!(self = [super init])) { return nil; }

    self.printStartDelimiter = @"{{";
    self.printEndDelimiter = @"}}";
    self.tagStartDelimiter = @"{%";
    self.tagEndDelimiter = @"%}";
    self.staticContext = [[TDTemplateContext alloc] init]

    return self;
}

// pre-compile template into a tree
- (TDNode *)compileTemplateString:(NSString *)str error:(NSError **)err {
    return nil;
}

- (TDNode *)compileTemplateFile:(NSString *)path encoding:(NSStringEncoding)enc error:(NSError **)err {
    return nil;
}

- (BOOL)renderTemplateTree:(TDNode *)root withVariables:(NSDictionary *)vars toStream:(NSOutputStream *)output error:(NSError **)err {
    return NO;
}

- (BOOL)processTemplateString:(NSString *)str withVariables:(NSDictionary *)vars toStream:(NSOutputStream *)output error:(NSError **)err {
    return NO;
}

- (BOOL)processTemplateFile:(NSString *)path encoding:(NSStringEncoding)enc withVariables:(NSDictionary *)vars toStream:(NSOutputStream *)output error:(NSError **)err {
    return NO;
}

#pragma mark - TagRegistration

- (void)registerTagClass:(Class)cls forName:(NSString *)tagName {

}

- (Class)registeredTagClassForName:(NSString *)tagName {
    return Nil;
}

- (TDFilter *)makeTagForName:(NSString *)tagName {
    return nil;
}

#pragma mark - Filter Registration

- (void)registerFilterClass:(Class)cls forName:(NSString *)filterName {

}

- (Class)registeredFilterClassForName:(NSString *)filterName {
    return Nil;
}

- (TDFilter *)makeFilterForName:(NSString *)filterName {
    return nil;
}


@end
