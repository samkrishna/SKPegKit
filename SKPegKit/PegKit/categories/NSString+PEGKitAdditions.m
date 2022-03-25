//
//  NSString+PEGKitAdditions.m
//  SKPegKit
//
//  Created by Sam Krishna on 3/24/22.
//

#import "NSString+PEGKitAdditions.h"

@implementation NSString (PEGKitAdditions)

- (NSString *)stringByTrimmingQuotes {
    NSUInteger len = self.length;
    if (len < 2) {
        return self;
    }

    NSRange r = NSMakeRange(0, len);
    unichar c = [self characterAtIndex:0];

    if (!isalnum(c)) {
        unichar quoteChar = c;
        r.location = 1;
        r.length -= 1;

        c = [self characterAtIndex:(len - 1)];
        if (c == quoteChar) {
            r.length -= 1;
        }

        return [self substringWithRange:r];
    }

    return self;
}

@end
