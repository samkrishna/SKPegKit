//
//  XPBaseExpressionTests.m
//  SKPegKitTests
//
//  Created by Sam Krishna on 3/24/22.
//

#import "XPBaseExpressionTests.h"

@implementation XPBaseExpressionTests

- (void)setUp {
    [super setUp];

    self.eng = [TDTemplateEngine templateEngine];
    self.expr = nil;
}

- (void)tearDown {
    self.expr = nil;
    self.eng = nil;

    [super tearDown];
}

- (NSArray *)tokenize:(NSString *)input {
    PKTokenizer *t = [XPParser tokenizer];
    t.string = input;

    PKToken *tok = nil;
    PKToken *eof = [PKToken EOFToken];

    NSMutableArray *toks = [NSMutableArray array];

    while (eof != (tok = [t nextToken])) {
        [toks addObject:tok];
    }

    return [toks copy];
}
@end
