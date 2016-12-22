Very basic Swift wrapper around CFBinaryHeap.

I was trying to figure this out, and found https://bugs.swift.org/browse/SR-79
After a very helpful discussion with @jtbandes on twitter, I've got something that seems
to be working.

TODO:
- Verify memory correctness
- Expose more CFBinaryHeap functionality
- Investigate AnyObject requirement, can this work with structs? https://twitter.com/jtbandes/status/811252709172969472

