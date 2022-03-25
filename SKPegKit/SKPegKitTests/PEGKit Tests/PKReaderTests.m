//
//  PKReaderTests.m
//  SKPegKitTests
//
//  Created by Sam Krishna on 3/25/22.
//

#import "TDTestScaffold.h"

@interface PKReaderTests : XCTestCase {
    PKReader *reader;
    NSString *string;
}

@end

@implementation PKReaderTests

- (void)setUp {
    string = @"abcdefghijklmnopqrstuvwxyz";
    reader = [[PKReader alloc] initWithString:string];
}

#pragma mark -

- (void)testReadCharsMatch {
    TDNotNil(reader);
    PKUniChar c;

    for (NSUInteger i = 0; i < string.length; i++) {
        c = [string characterAtIndex:i];
        TDEquals(c, [reader read]);
    }
}

- (void)testReadTooFar {
    for (NSUInteger i = 0; i < string.length; i++) {
        [reader read];
    }

    TDEquals(PKEOF, [reader read]);
}

- (void)testUnread {
    [reader read];
    [reader unread];
    PKUniChar a = 'a';
    TDEquals(a, [reader read]);

    [reader read];
    [reader read];
    [reader unread];
    PKUniChar c = 'c';
    TDEquals(c, [reader read]);
}

- (void)testUnreadTooFar {
    [reader unread];
    PKUniChar a = 'a';
    TDEquals(a, [reader read]);

    [reader unread];
    [reader unread];
    [reader unread];
    [reader unread];
    PKUniChar a2 = 'a';
    TDEquals(a2, [reader read]);
}

@end
