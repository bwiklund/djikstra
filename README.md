djikstra's city
====

![sample](https://raw.github.com/bwiklund/djikstra/master/source/images/sample.png)

A javascript demo that uses Djikstra's algorithm to build a network of roads over terrain.

The map is filled with perlin noise, where low values (dark) have a lower travel cost, and vice versa. Two random points are chosen, and the cheapest route is found between them. 

That route also "beats down a path", and makes the nodes along the path cheaper. The process is repeated, and major roads develop.

Setup:
```
bundle install
```

Run:
```
middleman server
```
