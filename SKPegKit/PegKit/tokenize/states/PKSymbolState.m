//
//  PKSymbolState.m
//  SKPegKit
//
//  Created by Sam Krishna on 3/25/22.
//

#import "PKTokenizer.h"
#import "PKToken.h"
#import "PKSymbolRootNode.h"
#import "PKReader.h"
#import "PKSymbolState.h"

@interface PKTokenizer ()
@property (nonatomic, readwrite, assign) NSUInteger lineNumber;
@end

@interface PKTokenizerState ()
- (void)resetWithReader:(PKReader *)r;
- (PKTokenizerState *)nextTokenizerStateFor:(PKUniChar)c tokenizer:(PKTokenizer *)t;

@property (nonatomic, readwrite, assign) NSUInteger offset;
@end

@interface PKSymbolState ()
@property (nonatomic, readwrite, strong) PKSymbolRootNode *rootNode;
@property (nonatomic, readwrite, strong) NSMutableSet *addedSymbols;
@end

@implementation PKSymbolState {
    BOOL *_prevented;
}

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

- (PKToken *)nextTokenFromReader:(PKReader *)r startingWith:(PKUniChar)cin tokenizer:(PKTokenizer *)t {
    NSParameterAssert(r);
    [self resetWithReader:r];

    NSString *symbol = [self.rootNode nextSymbol:r startingWith:cin];
    NSUInteger len = symbol.length;

    while (len > 1) {
        if ([self.addedSymbols containsObject:symbol]) {
            if ('\n' == [symbol characterAtIndex:0]) {
                t.lineNumber++;
            }

            return [self symbolTokenWithSymbol:symbol];
        }
    }

    if (1 == len) {
        BOOL isPrevented = NO;
        if (_prevented[cin]) {
            PKUniChar peek = [r read];
            if (peek != EOF) {
                isPrevented = YES;
                [r unread:1];
            }
        }

        if (!isPrevented) {
            return [self symbolTakenWith:cin tokenizer:t];
        }
    }

    PKTokenizerState *state = [self nextTokenizerStateFor:cin tokenizer:t];
    if (!state || state == self) {
        return [self symbolTakenWith:cin tokenizer:t];
    }
    else {
        return [state nextTokenFromReader:r startingWith:cin tokenizer:t];
    }
}

- (void)add:(NSString *)s {
    NSParameterAssert(s);
    [self.rootNode add:s];
    [self.addedSymbols addObject:s];
}

- (void)remove:(NSString *)s {
    NSParameterAssert(s);
    [self.rootNode remove:s];
    [self.addedSymbols removeObject:s];
}

- (void)prevent:(PKUniChar)c {
    PKAssertMainThread();
    NSParameterAssert(c > 0);
    _prevented[c] = YES;
}

- (PKToken *)symbolTokenWithSymbol:(NSString *)s {
    PKToken *tok = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:s doubleValue:0.0];
    tok.offset = self.offset;
    return tok;
}

- (PKToken *)symbolTakenWith:(PKUniChar)cin tokenizer:(PKTokenizer *)t {
    if ('\n' == cin) {
        t.lineNumber++;
    }
    return [self symbolTokenWithSymbol:[NSString stringWithFormat:@"%C", (unichar)cin]];
}

@synthesize rootNode;
@synthesize addedSymbols;
@end
