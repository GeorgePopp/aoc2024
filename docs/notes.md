# Day 01
Hard part in Day 1 was remembering how to parse IO with Julia. Once I had it as a vector, the `.` operator made it easy to apply things elementwise.

# Day 02
Used a brute force approach for the second part. This allowed me to reuse my code from part 1, but probably wasn't optimal.

# Day 03
First regex day! Regex does make this quite boring as it becomes less of a programming logic puzzle and more of a regex tricks puzzle.

For the second part, I used regex to split the string. In hindsight I could have just used regex to capture the middle.

# Day 04
My solution used CatesianCoordinates to search for the correct strings. It isn't a very elegant solution but it works. Becuase of this, I actually found the second part easier.

A fancier solution would have involved flipping / rotating / reflecting the array, but wasn't worth the headaches.

# Day 05

For part 1 I was tempted to break the loop once an error was found for speed. 

For part 2 I wrote some functions to change values inplace `correct_with_rule!()` and `correct_order!()`, I'm quite happy with these as they don't do any stack allocations so are reasonably fast - the heap variables may even get compiled away.

# Day 06

# Day 07

My solution was a very Julian solution. In Julia `+()` is a function like any other. In OOP languages such as Python, `123 + 456` is actually `123.__add__(456)`. I could just loop over a vector of functions `[+, *]` and use these in my loop as a function. e.g.

```
for f in [+, *]
    res = f(1,1)
    println(res)
end
```
would print 2 and 1.

Then for part 2 I was just able to add a new function to concat the integers and add it to the loop.

# Day 10

This one was quite fun. Found the second part much easier an in fact accidentally solved that one first before realising I was double counting.

# Day 11

