//
//  TDWriter.m
//  SKPegKit
//
//  Created by Sam Krishna on 3/24/22.
//

#import "TDWriter.h"
#import "TDTemplateEngine.h"

@implementation TDWriter

+ (instancetype)writerWithOutputStream:(NSOutputStream *)output {
    return [[self alloc] initWithOutputStream:output];
}

- (instancetype)initWithOutputStream:(NSOutputStream *)output {
    if (!(self = [super init])) { return nil; }
    self.output = output;
    return self;
}

- (void)appendObject:(id)obj {
    NSString *str = nil;
    if ([obj isKindOfClass:[NSString class]]) {
        str = obj;
    }
    else if ([obj respondsToSelector:@selector(stringValue)]) {
        str = [obj stringValue];
    }
    else {
        str = [obj description];
    }

    [self appendString:str];
}

- (void)appendString:(NSString *)str {
    TDAssert(self.output);
    TDAssert(str);

    NSUInteger len = [str lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    if (len) {
        const uint8_t *zstr = (const uint8_t *)str.UTF8String;
        NSUInteger remaining = len;
        do {
            NSInteger trim = remaining - len;
            if (trim > 0) {
                zstr += trim;
            }
            NSInteger written = [self.output write:zstr maxLength:len];
            if (written == -1) {
                [NSException raise:TDTemplateEngineErrorDomain format:@"Error while writing template output string"];
            }
            remaining -= written;
        } while (remaining > 0);
    }
}

- (void)appendFormat:(NSString *)fmt, ... NS_FORMAT_FUNCTION(1, 2) {
    va_list vargs;
    va_start(vargs, fmt);
    NSString *str = [[NSString alloc] initWithFormat:fmt arguments:vargs];
    [self appendString:str];
    va_end(vargs);
}

@end
