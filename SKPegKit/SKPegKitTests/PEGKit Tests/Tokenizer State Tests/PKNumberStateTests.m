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
    s = @"0";
    t.string = s;
    PKToken *tok = [t nextToken];
    TDTrue(tok.isNumber);
    TDEqualObjects(@"0", tok.stringValue);
}

- (void)testOctPrefixNeg0 {
    [t.numberState addPrefix:@"0" forRadix:8];
    s = @"-0";
    t.string = s;
    PKToken *tok = [t nextToken];
    TDTrue(tok.isNumber);
    TDEqualObjects(@"-0", tok.stringValue);
}

- (void)testOctPrefix01 {
    [t.numberState addPrefix:@"0" forRadix:8];
    s = @"01";
    t.string = s;
    PKToken *tok = [t nextToken];
    TDEquals(1.0, tok.doubleValue);
    TDTrue(tok.isNumber);
    TDEqualObjects(@"01", tok.stringValue);
}

- (void)testOctPrefix010 {
    [t.numberState addPrefix:@"0" forRadix:8];
    s = @"010";
    t.string = s;
    PKToken *tok = [t nextToken];
    TDEquals(8.0, tok.doubleValue);
    TDTrue(tok.isNumber);
    TDEqualObjects(@"010", tok.stringValue);
}


@end
