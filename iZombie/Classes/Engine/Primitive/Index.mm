//
//  Index.mm
//  Goftware
//
//  Created by Muhammed Safiul Azam on 11/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Index.h"

Index IndexMake(NSInteger column, NSInteger row) 
{
	Index index;
	index.column = column;
	index.row = row;
	
	return index;
}

Index IndexClone(Index index)
{
	return IndexMake(index.column, index.row);
}
