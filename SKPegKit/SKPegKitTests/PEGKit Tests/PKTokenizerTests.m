//
//  PKTokenizerTests.m
//  SKPegKitTests
//
//  Created by Sam Krishna on 3/25/22.
//

#import "TDTestScaffold.h"

@interface PKTokenizerTests : XCTestCase {
    PKTokenizer *t;
    NSString *s;
}

@end

@implementation PKTokenizerTests

- (void)testPythonImports {
    s =
    @"from Quartz.CoreGraphics import *\n"
    @"from Quartz.ImageIO import *\n"
    @"from Foundation import *\n";

    t = [PKTokenizer tokenizerWithString:s];
    TDNotNil(t);
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
