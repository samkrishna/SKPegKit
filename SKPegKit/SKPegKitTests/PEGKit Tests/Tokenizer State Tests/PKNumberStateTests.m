//
//  PKNumberStateTests.m
//  SKPegKitTests
//
//  Created by Sam Krishna on 3/28/22.
//

#import "TDTestScaffold.h"


@interface PKNumberStateTests : XCTestCase {
    PKNumberState *numberState;
    PKTokenizer *t;
    PKReader *r;
    NSString *s;
}

@end

@implementation PKNumberStateTests

- (void)setUp {
    t = [[PKTokenizer alloc] init];
    r = [[PKReader alloc] init];
    numberState = t.numberState;
}

- (void)testOctPrefix0 {
    [t.numberState addPrefix:@"0" forRadix:8];
    s= @"0";
    t.string = s;
    PKToken *tok = [t nextToken];
    TDTrue(tok.isNumber);
    TDEqualObjects(@"0", tok.stringValue);
}

@end
