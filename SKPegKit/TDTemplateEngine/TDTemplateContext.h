//
//  TDTemplateContext.h
//  SKPegKit
//
//  Created by Sam Krishna on 3/24/22.
//

@import Foundation;

@class TDWriter;

@interface TDTemplateContext : NSObject

@property (nonatomic, readonly, strong) TDWriter *writer;
@property (nonatomic, readwrite, strong) TDTemplateContext *enclosingScope;

- (instancetype)initWithVariables:(NSDictionary *)vars output:(NSOutputStream *)output;

- (id)resolveVariable:(NSString *)name;
- (void)defineVariable:(NSString *)name value:(id)value;

@end
