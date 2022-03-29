//
//  PKTokenizerStateTests.m
//  SKPegKitTests
//
//  Created by Sam Krishna on 3/26/22.
//

#import "TDTestScaffold.h"

@interface PKTokenizerStateTests : XCTestCase {
    PKTokenizer *t;
    NSString *s;
    PKToken *tok;
}

@end

@implementation PKTokenizerStateTests

- (void)setUp {
    t = [[PKTokenizer alloc] init];
}

- (void)testFallbackStateCast {
    [t setTokenizerState:t.symbolState from:'c' to:'c'];
    [t.symbolState setFallbackState:t.wordState from:'c' to:'c'];
    [t.symbolState add:@"cast"];
    t.string = @"foo cast cat";
    tok = [t nextToken];
    TDTrue(tok.isWord);
    TDEqualObjects(@"foo", tok.stringValue);

    // TESTS SO FAR FINALLY PASS AT THIS POINT!!! 2022-03-28 20:14:07 -0700

    tok = [t nextToken];
    TDTrue(tok.isSymbol);
    TDEqualObjects(@"cast", tok.stringValue);

//    tok = [t nextToken];
//    TDTrue(tok.isSymbol);
//    TDEqualObjects(@"c", tok.stringValue);
}

@end
