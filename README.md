# README

* Ruby version

Ruby 2.6.3

Note:
- Intentionally didn't make it concurrent in ruby as this is actually a lot of work and ususally doesn't provide that much of a performance. Especially with caching implemented.
- Differ in the sorting with the solution for keys `likes popularity` as there is not secondary sort parameter

Errors found in the solution:

`https://hatchways.io/api/assessment/solution/posts?tags=tech&direction=test` should return an error but it does not.

`https://hatchways.io/api/assessment/solution/posts?` error message does not match instructions.