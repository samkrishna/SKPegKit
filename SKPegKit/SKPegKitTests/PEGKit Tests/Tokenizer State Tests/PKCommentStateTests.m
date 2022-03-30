//
//  PKCommentStateTests.m
//  SKPegKitTests
//
//  Created by Sam Krishna on 3/28/22.
//

#import "TDTestScaffold.h"

@interface PKCommentStateTests : XCTestCase {
    PKCommentState *commentState;
    PKReader *r;
    PKTokenizer *t;
    NSString *s;
    PKToken *tok;
}

@end

@implementation PKCommentStateTests

- (void)setUp {
    r = [[PKReader alloc] init];
    t = [[PKTokenizer alloc] init];
}

- (void)testSlashSlashFoo {
    s = @"// foo";
    r.string = s;
    t.string = s;
    tok = [commentState nextTokenFromReader:r startingWith:'/' tokenizer:t];
    TDEqualObjects([PKToken EOFToken], tok);
    TDEquals([r read], PKEOF);
}

@end
