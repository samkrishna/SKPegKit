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
    [t.symbolState add:@"case"];
}

@end
