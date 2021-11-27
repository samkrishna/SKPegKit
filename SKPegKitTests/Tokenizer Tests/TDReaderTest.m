#import "TDTestScaffold.h"

@interface TDReaderTest : XCTestCase {
    PKReader *reader;
    NSString *string;
}

@end

@implementation TDReaderTest

- (void)setUp {
    string = @"abcdefghijklmnopqrstuvwxyz";
    reader = [[PKReader alloc] initWithString:string];
}

- (void)tearDown {
    string = nil;
    reader = nil;
}

- (void)testReadCharsMatch {
    TDNotNil(reader);
    NSUInteger len = string.length;
    PKUniChar c;

    for (NSUInteger i = 0; i < len; i++) {
        c = [string characterAtIndex:i];
        TDEquals(c, [reader read]);
    }
}

- (void)testReadTooFar {
    NSUInteger len = string.length;
    for (NSUInteger i = 0; i < len; i++) {
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
