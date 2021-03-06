//
//  PKWordStateTests.m
//  SKPegKitTests
//
//  Created by Sam Krishna on 3/28/22.
//

#import "TDTestScaffold.h"

@interface PKWordStateTests : XCTestCase {
    PKWordState *wordState;
    PKReader *r;
    NSString *s;
}

@end

@implementation PKWordStateTests

- (void)setUp {
    wordState = [[PKWordState alloc] init];
}

- (void)testA {
    s = @"a";
    r = [[PKReader alloc] initWithString:s];
    PKToken *tok = [wordState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEqualObjects(@"a", tok.stringValue);
    TDEqualObjects(@"a", tok.value);
    TDTrue(tok.isWord);
    TDEquals(PKEOF, [r read]);
}

- (void)testASpace {
    s = @"a ";
    r = [[PKReader alloc] initWithString:s];
    PKToken *tok = [wordState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEqualObjects(@"a", tok.stringValue);
    TDEqualObjects(@"a", tok.value);
    TDTrue(tok.isWord);
    TDEquals((PKUniChar)' ', [r read]);
}

- (void)testAB {
    s = @"ab";
    r = [[PKReader alloc] initWithString:s];
    PKToken *tok = [wordState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEqualObjects(s, tok.stringValue);
    TDEqualObjects(s, tok.value);
    TDTrue(tok.isWord);
    TDEquals(PKEOF, [r read]);
}

- (void)testABC {
    s = @"abc";
    r = [[PKReader alloc] initWithString:s];
    PKToken *tok = [wordState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEqualObjects(s, tok.stringValue);
    TDEqualObjects(s, tok.value);
    TDTrue(tok.isWord);
    TDEquals(PKEOF, [r read]);
}

- (void)testItApostropheS {
    s = @"it's";
    r = [[PKReader alloc] initWithString:s];
    PKToken *tok = [wordState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEqualObjects(s, tok.stringValue);
    TDEqualObjects(s, tok.value);
    TDTrue(tok.isWord);
    TDEquals(PKEOF, [r read]);
}

- (void)testTwentyDashFive {
    s = @"twenty-five";
    r = [[PKReader alloc] initWithString:s];
    PKToken *tok = [wordState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEqualObjects(s, tok.stringValue);
    TDEqualObjects(s, tok.value);
    TDTrue(tok.isWord);
    TDEquals(PKEOF, [r read]);
}

- (void)testTwentyUnderscoreFive {
    s = @"twenty_five";
    r = [[PKReader alloc] initWithString:s];
    PKToken *tok = [wordState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEqualObjects(s, tok.stringValue);
    TDEqualObjects(s, tok.value);
    TDTrue(tok.isWord);
    TDEquals(PKEOF, [r read]);
}

- (void)testNumber1 {
    s = @"number1";
    r = [[PKReader alloc] initWithString:s];
    PKToken *tok = [wordState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDEqualObjects(s, tok.stringValue);
    TDEqualObjects(s, tok.value);
    TDTrue(tok.isWord);
    TDEquals(PKEOF, [r read]);
}

@end
