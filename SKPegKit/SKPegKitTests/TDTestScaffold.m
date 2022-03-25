//
//  TDTestScaffold.m
//  SKPegKitTests
//
//  Created by Sam Krishna on 3/25/22.
//

#import "TDTestScaffold.h"

NSString *TDAssembly(NSString *s) {
#if !DEBUG
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(.+?\\])[^,\\]].*" options:NSRegularExpressionDotMatchesLineSeparators error:nil];
    s = [regex stringByReplacingMatchesInString:s options:0 range:NSMakeRange(0, [s length]) withTemplate:@"$1"];
#endif
    return s;
}
