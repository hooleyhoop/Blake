/*
	SKTLine.h
	Part of the Sketch Sample Code
*/
#import <SketchGraph/SKTGraphic.h>


@interface SKTLine : SKTGraphic {

    // YES if the line's ending is to the right or below, respectively, it's beginning, NO otherwise. Because we reuse SKTGraphic's "bounds" property, we have to keep track of the corners of the bounds at which the line begins and ends. A more natural thing to do would be to just record two points, but then we'd be wasting an NSRect's worth of ivar space per instance, and have to override more SKTGraphic methods to boot. This of course raises the question of why SKTGraphic has a bounds property when it's not readily applicable to every conceivable subclass. Perhaps in the future it won't, but right now in Sketch it's the handy thing to do for four out of five subclasses.
    BOOL _pointsRight;
    BOOL _pointsDown;
}

/* This class is KVC and KVO compliant for these keys:

"beginPoint" and "endPoint" (NSPoint-containing NSValues; read-only) - The two points that define the line segment.

In Sketch "beginPoint" and "endPoint" are two more of the properties that SKTDocument observes so it can register undo actions when they change.

Notice that we don't guarantee KVC or KVO compliance for "pointsRight" and "pointsDown." Those aren't just private instance variables, they're private properties, concepts that no code outside of SKTLine should care about.

*/

@end