//
//  PKSymbolState.m
//  SKPegKit
//
//  Created by Sam Krishna on 3/25/22.
//

#import "PKTokenizer.h"
#import "PKToken.h"
#import "PKSymbolRootNode.h"
#import "PKSymbolState.h"

@interface PKTokenizer ()
@property (nonatomic, readwrite, assign) NSUInteger lineNumber;
@end

@interface PKToken ()
@property (nonatomic, readwrite, assign) NSUInteger offset;
@end

@interface PKTokenizerState ()
- (PKToken *)symbolTakenWith:(PKUniChar)cin tokenizer:(PKTokenizer *)t;
- (PKToken *)symbolTokenWithSymbol:(NSString *)s;

@property (nonatomic, readwrite, strong) PKSymbolRootNode *rootNode;
@property (nonatomic, readwrite, strong) NSMutableSet *addedSymbols;
@end

@interface PKSymbolState ()
@property (nonatomic, readwrite, strong) PKSymbolRootNode *rootNode;
@property (nonatomic, readwrite, strong) NSMutableSet *addedSymbols;
@end

@implementation PKSymbolState {
    BOOL *_prevented;
}

@synthesize rootNode;
@synthesize addedSymbols;

- (instancetype)init {
    if (!(self = [super init])) { return nil; }

    self.rootNode = [[PKSymbolRootNode alloc] init];
    self.addedSymbols = [NSMutableSet set];
    _prevented = (void *)calloc(128, sizeof(BOOL));

    return self;
}

- (void)dealloc {
    if (_prevented) {
        free(_prevented);
    }
}

- (void)add:(NSString *)s {
    NSParameterAssert(s);
}

@end
