//
//  PKWhitespaceStateTests.m
//  SKPegKitTests
//
//  Created by Sam Krishna on 3/28/22.
//

#import "TDTestScaffold.h"

@interface PKWhitespaceStateTests : XCTestCase {
    PKWhitespaceState *whitespaceState;
    PKReader *r;
    NSString *s;
}

@end

@implementation PKWhitespaceStateTests

- (void)setUp {
    whitespaceState = [[PKWhitespaceState alloc] init];
}

- (void)testSpace {
    s = @" ";
    r = [[PKReader alloc] initWithString:s];
    PKToken *tok = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDNil(tok);
    TDEquals(PKEOF, [r read]);
}

- (void)testTwoSpaces {
    s = @"  ";
    r = [[PKReader alloc] initWithString:s];
    PKToken *tok = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDNil(tok);
    TDEquals(PKEOF, [r read]);
}

- (void)testNil {
    s = NULL;
    r = [[PKReader alloc] initWithString:s];
    PKToken *tok = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDNil(tok);
    TDEquals(PKEOF, [r read]);
}

- (void)testEmptyString {
    s = @"";
    r = [[PKReader alloc] initWithString:s];
    PKToken *tok = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDNil(tok);
    TDEquals(PKEOF, [r read]);
}

- (void)testTab {
    s = @"\t";
    r = [[PKReader alloc] initWithString:s];
    PKToken *tok = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDNil(tok);
    TDEquals(PKEOF, [r read]);
}

- (void)testNewLine {
    s = @"\n";
    r = [[PKReader alloc] initWithString:s];
    PKToken *tok = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDNil(tok);
    TDEquals(PKEOF, [r read]);
}

- (void)testCarriageReturn {
    s = @"\r";
    r = [[PKReader alloc] initWithString:s];
    PKToken *tok = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDNil(tok);
    TDEquals(PKEOF, [r read]);
}

- (void)testSpaceCarriageReturn {
    s = @" \r";
    r = [[PKReader alloc] initWithString:s];
    PKToken *tok = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDNil(tok);
    TDEquals(PKEOF, [r read]);
}

- (void)testSpaceTabNewLineSpace {
    s = @" \t\n ";
    r = [[PKReader alloc] initWithString:s];
    PKToken *tok = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDNil(tok);
    TDEquals(PKEOF, [r read]);
}

- (void)testSpaceA {
    s = @" a";
    r = [[PKReader alloc] initWithString:s];
    PKToken *tok = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDNil(tok.stringValue);
    TDEquals((PKUniChar)'a', [r read]);
}

- (void)testSpaceASpace {
    s = @" a ";
    r = [[PKReader alloc] initWithString:s];
    PKToken *tok = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDNil(tok.stringValue);
    TDEquals((PKUniChar)'a', [r read]);
}

- (void)testTabA {
    s = @"\ta";
    r = [[PKReader alloc] initWithString:s];
    PKToken *tok = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDNil(tok.stringValue);
    TDEquals((PKUniChar)'a', [r read]);
}

- (void)testNewLineA {
    s = @"\na";
    r = [[PKReader alloc] initWithString:s];
    PKToken *tok = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDNil(tok.stringValue);
    TDEquals((PKUniChar)'a', [r read]);
}

#pragma mark - Significant

- (void)testSignificantSpace {
    whitespaceState.reportsWhitespaceTokens = YES;
    s = @" ";
    r = [[PKReader alloc] initWithString:s];
    PKToken *tok = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDNotNil(tok.stringValue);
    TDEqualObjects(s, tok.stringValue);
    TDEquals(PKEOF, [r read]);
}

- (void)testSignificantTwoSpace {
    whitespaceState.reportsWhitespaceTokens = YES;
    s = @"  ";
    r = [[PKReader alloc] initWithString:s];
    PKToken *tok = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDNotNil(tok);
    TDEqualObjects(s, tok.stringValue);
    TDEquals(PKEOF, [r read]);
}

- (void)testSignificantEmptyString {
    whitespaceState.reportsWhitespaceTokens = YES;
    s = @"";
    r = [[PKReader alloc] initWithString:s];
    PKToken *tok = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDNotNil(tok);
    TDEqualObjects(s, tok.stringValue);
    TDEquals(PKEOF, [r read]);
}


- (void)testSignificantTab {
    whitespaceState.reportsWhitespaceTokens = YES;
    s = @"\t";
    r = [[PKReader alloc] initWithString:s];
    PKToken *tok = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDNotNil(tok);
    TDEqualObjects(s, tok.stringValue);
    TDEquals(PKEOF, [r read]);
}


- (void)testSignificantNewLine {
    whitespaceState.reportsWhitespaceTokens = YES;
    s = @"\n";
    r = [[PKReader alloc] initWithString:s];
    PKToken *tok = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDNotNil(tok);
    TDEqualObjects(s, tok.stringValue);
    TDEquals(PKEOF, [r read]);
}


- (void)testSignificantCarriageReturn {
    whitespaceState.reportsWhitespaceTokens = YES;
    s = @"\r";
    r = [[PKReader alloc] initWithString:s];
    PKToken *tok = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDNotNil(tok);
    TDEqualObjects(s, tok.stringValue);
    TDEquals(PKEOF, [r read]);
}


- (void)testSignificantSpaceCarriageReturn {
    whitespaceState.reportsWhitespaceTokens = YES;
    s = @" \r";
    r = [[PKReader alloc] initWithString:s];
    PKToken *tok = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDNotNil(tok);
    TDEqualObjects(s, tok.stringValue);
    TDEquals(PKEOF, [r read]);
}


- (void)testSignificantSpaceTabNewLineSpace {
    whitespaceState.reportsWhitespaceTokens = YES;
    s = @" \t\n ";
    r = [[PKReader alloc] initWithString:s];
    PKToken *tok = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDNotNil(tok);
    TDEqualObjects(s, tok.stringValue);
    TDEquals(PKEOF, [r read]);
}


- (void)testSignificantSpaceA {
    whitespaceState.reportsWhitespaceTokens = YES;
    s = @" a";
    r = [[PKReader alloc] initWithString:s];
    PKToken *tok = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDNotNil(tok);
    TDEqualObjects(@" ", tok.stringValue);
    TDEquals((PKUniChar)'a', [r read]);
}


- (void)testSignificantSpaceASpace {
    whitespaceState.reportsWhitespaceTokens = YES;
    s = @" a ";
    r = [[PKReader alloc] initWithString:s];
    PKToken *tok = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDNotNil(tok);
    TDEqualObjects(@" ", tok.stringValue);
    TDEquals((PKUniChar)'a', [r read]);
}


- (void)testSignificantTabA {
    whitespaceState.reportsWhitespaceTokens = YES;
    s = @"\ta";
    r = [[PKReader alloc] initWithString:s];
    PKToken *tok = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDNotNil(tok);
    TDEqualObjects(@"\t", tok.stringValue);
    TDEquals((PKUniChar)'a', [r read]);
}


- (void)testSignificantNewLineA {
    whitespaceState.reportsWhitespaceTokens = YES;
    s = @"\na";
    r = [[PKReader alloc] initWithString:s];
    PKToken *tok = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDNotNil(tok);
    TDEqualObjects(@"\n", tok.stringValue);
    TDEquals((PKUniChar)'a', [r read]);
}


- (void)testSignificantCarriageReturnA {
    whitespaceState.reportsWhitespaceTokens = YES;
    s = @"\ra";
    r = [[PKReader alloc] initWithString:s];
    PKToken *tok = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDNotNil(tok);
    TDEqualObjects(@"\r", tok.stringValue);
    TDEquals((PKUniChar)'a', [r read]);
}


- (void)testSignificantNewLineSpaceCarriageReturnA {
    whitespaceState.reportsWhitespaceTokens = YES;
    s = @"\n \ra";
    r = [[PKReader alloc] initWithString:s];
    PKToken *tok = [whitespaceState nextTokenFromReader:r startingWith:[r read] tokenizer:nil];
    TDNotNil(tok);
    TDEqualObjects(@"\n \r", tok.stringValue);
    TDEquals((PKUniChar)'a', [r read]);
}

@end
