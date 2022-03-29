//
//  PKReader.m
//  SKPegKit
//
//  Created by Sam Krishna on 3/25/22.
//

#import "PKReader.h"

@interface PKReader ()
@property (nonatomic, readwrite, assign) NSUInteger offset;
@property (nonatomic, readwrite, assign) NSUInteger length;
@end

@implementation PKReader

- (instancetype)init {
    return [self initWithString:nil];
}

- (instancetype)initWithString:(NSString *)s {
    if (!(self = [super init])) { return nil; }
    self.string = s;
    return self;
}

- (instancetype)initWithStream:(NSInputStream *)s {
    if (!(self = [super init])) { return nil; }
    self.stream = s;
    return self;
}

- (void)setString:(NSString *)s {
    TDConditionAssert(!self.stream);

    if (_string != s) {
        _string = s;
        self.length = s.length;
    }

    self.offset = 0;
}

- (void)setStream:(NSInputStream *)s {
    TDConditionAssert(!self.string);

    if (_stream != s) {
        _stream = s;
        self.length = NSNotFound;
    }

    self.offset = 0;
}

- (PKUniChar)read {
    PKUniChar result = PKEOF;

    if (self.string) {
        if (self.length && self.offset < self.length) {
            result = [self.string characterAtIndex:self.offset++];
        }
    }
    else {
        NSUInteger maxLen = 1; // 2 for wide char?
        uint8_t c;
        if ([self.stream read:&c maxLength:maxLen]) {
            result = (PKUniChar)c;
        }
    }

    return result;
}

- (void)unread {
    self.offset = (0 == _offset) ? 0 : (_offset - 1);
}

- (void)unread:(NSUInteger)count {
    for (NSUInteger i = 0; i < count; i++) {
        [self unread];
    }
}

@end
