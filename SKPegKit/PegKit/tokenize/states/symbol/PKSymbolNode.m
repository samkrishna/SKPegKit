//
//  PKSymbolNode.m
//  SKPegKit
//
//  Created by Sam Krishna on 3/26/22.
//

#import "PKSymbolNode.h"

@interface PKSymbolNode ()
@property (nonatomic, readwrite, strong) NSString *ancestry;
@property (nonatomic, readwrite, strong) PKSymbolNode *parent;
@property (nonatomic, readwrite, strong) NSMutableDictionary *children;
@property (nonatomic, readwrite, strong) NSString *string;

@property (nonatomic, readwrite, assign) PKUniChar character;
@end

@implementation PKSymbolNode

- (instancetype)initWithParent:(PKSymbolNode *)p character:(PKUniChar)c {
    if (!(self = [super init])) { return nil; }

    self.parent = p;
    self.character = c;
    self.children = [NSMutableDictionary dictionary];
    self.string = [NSString stringWithFormat:@"%C", (unichar)self.character];
    [self determineAncestry];

    return self;
}

- (void)determineAncestry {
    if (PKEOF == self.parent.character) {
        self.ancestry = self.string;
    }
    else {
        NSMutableString *result = [NSMutableString string];
        PKSymbolNode *n = self;
        while (PKEOF != n.character) {
            [result insertString:n.string atIndex:0];
            n = n.parent;
        }

        self.ancestry = result; // optimization
    }
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<PKSymbolNode %@>", self.ancestry];
}

@end
