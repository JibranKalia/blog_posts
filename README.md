# README

Ruby Version: 2.6.3

Note:
- Intentionally didn't make it concurrent. In Ruby (MRI) this is difficult because of the global interpreter lock which leads to concurrent calls not providing much of a performance boost. Especially with caching implemented.
- I differ in the sorting with the provided solution for the following keys: `likes popularity` as there is not secondary sort parameter.

Errors found in the solution:

`https://hatchways.io/api/assessment/solution/posts?tags=tech&direction=test` should return an error but it does not.

`https://hatchways.io/api/assessment/solution/posts?` error message does not match instructions.
