# PS_SnowFlakes

## An xmas snowflake animation class experiment :-)

What should have been a short script to bring a more christmassy feeling to my desktop turned out to be the perfect playground for my first implementation of a powershell class.

## Snowflakes.ps1

Contains a snowflake-class and uses the individual flake methods to animate the flakes one by one. This keeps the code simple, but slows down quickly when the number of snowflakes rises.

## Snowflakes_BackBuffered.ps1

Uses the same class, but instead of relying on the output-methods of the individuall flakes it just uses their re-positioning method writes the flakes to a predefined string / char-array which is sent to the console in one big blow.<br>
That way the slowest part, the console output, though already using the fast `[console]::Write()` method, is reduced to the absolute minimum. High refresh times (`-Refreshms`) and `-FlakeCount` can be realized that way with a less noticable slowdown.


Happy coding and merry christmas!<br>
Max