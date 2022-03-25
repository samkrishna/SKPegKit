//
//  TDTemplateContext.m
//  SKPegKit
//
//  Created by Sam Krishna on 3/24/22.
//

#import "TDTemplateContext.h"
#import "TDWriter.h"

@interface TDTemplateContext ()
@property (nonatomic, readwrite, strong) NSMutableDictionary *vars;
@property (nonatomic, readwrite, strong) TDWriter *writer;
@end

@implementation TDTemplateContext

- (instancetype)init {
    self = [self initWithVariables:nil output:nil];
    return self;
}

- (instancetype)initWithVariables:(NSDictionary *)vars output:(NSOutputStream *)output {
    if (!(self = [super init])) { return nil; }

    self.vars = [NSMutableDictionary dictionary];
    [self.vars addEntriesFromDictionary:vars];
    self.writer = [TDWriter writerWithOutputStream:output];

    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %p global: %d, %@>", self.className, self, nil == self.enclosingScope, self.vars];
}

- (id)resolveVariable:(NSString *)name {
    NSParameterAssert(name.length);
    TDAssert(self.vars);
    id result = self.vars[name];

    if (!result && self.enclosingScope) {
        result = [self.enclosingScope resolveVariable:name];
    }

    return result;
}

- (void)defineVariable:(NSString *)name value:(id)value {
    NSParameterAssert(name.length);
    TDAssert(self.vars);

    if (value) {
        self.vars[name] = value;
    }
    else {
        self.vars[name] = nil;
    }
}

@end
