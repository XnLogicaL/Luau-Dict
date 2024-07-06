# Custom Lua Dicts
A custom [heavily optimized](BENCHMARKS.md) class for dictionaries with full intellisense support written in luau.

My problem with luau's dictionaries is that they lack capability compared to arrays.
You cannot use the "#" operator on dicts, cannot index using numbers, it's just overall lackluster.

I've managed to create a promisingly optimized dictionary class that can potentially rival the luau dictionaries.
It includes many great features that the luau dictionaries don't, such as the usage of the length operator,
unions with other dicts, inverse unions (I forgor the word for it) with other dicts, an easy way to gather it's keys and values seperately.

And those are just the beginning...
