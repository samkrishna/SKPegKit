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

@end
