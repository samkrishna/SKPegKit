//
//  PKReader.h
//  SKPegKit
//
//  Created by Sam Krishna on 3/25/22.
//

@import Foundation;
#import "PKTypes.h"

@interface PKReader : NSObject

@property (nonatomic, readonly, assign) NSUInteger offset;
@property (nonatomic, readwrite, strong) NSString *string;
@property (nonatomic, readwrite, strong) NSInputStream *stream;

- (instancetype)initWithString:(NSString *)s;
- (instancetype)initWithStream:(NSInputStream *)s;

- (PKUniChar)read;

- (void)unread;
- (void)unread:(NSUInteger)count;

@end

