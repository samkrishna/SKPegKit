//
//  PKTypes.h
//  SKPegKit
//
//  Created by Sam Krishna on 3/24/22.
//

#ifndef PKTypes_h
#define PKTypes_h

// a UTF-16 code unit. signed so that it may include -1 (EOF) as well
typedef int32_t PKUniChar;
#define PKEOF (PKUniChar)-1

#endif /* PKTypes_h */
