// The MIT License (MIT)
//
// Copyright (c) 2014 Todd Ditchendorf
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

//
//  PKReader.m
//  SKPegKit
//
//  Created by Sam Krishna on 11/27/21.
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

- (instancetype)initWithString:(NSString  *)s {
    if (!(self = [super init])) { return nil; }

    self.string = s;

    return self;
}

- (instancetype)initWithStream:(NSInputStream *)s {
    if (!(self = [super init])) { return nil; }

    self.stream = s;

    return self;
}

- (NSString *)debugDescription {
    NSString *buff = [NSString stringWithFormat:@"%@^%@", [_string substringToIndex:_offset], [_string substringFromIndex:_offset]];
    return [NSString stringWithFormat:@"<%@ %p `%@`>", [self class], self, buff];
}

- (void)setString:(NSString *)s {
    NSAssert(!_stream, @"");

    if (_string != s) {
        _string = [s copy];
        self.length = _string.length;
    }

    // reset cursor
    self.offset = 0;
}

- (void)setStream:(NSInputStream *)s {
    NSAssert(!_string, @"");

    if (_stream != s) {
        _stream = s;
        _length = NSNotFound;
    }

    // reset cursor
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
    self.offset = (0 == _offset) ? 0 : _offset - 1;
}

@end
