param (
    [Int32]$FlakeCount = 20,
    [Int32]$Refreshms = 250
)

class SnowFlake {
    [ValidateSet('*','+','x','o')]
    [String]$Sign
    [int16] $x
    [int16] $y
    hidden [int16] $xold
    hidden [int16] $yold
    [ValidateRange(1,100)]
    [byte]  $Speed
    [ValidateRange(1,100)]
    [byte]  $Jitter

    ##### HIDDEN METHODS #####

    hidden [void] Init ([bool]$Top) {
        $this.Sign = Get-Random '*','+','x','o'
        $this.x = Get-Random -Minimum 0 -Maximum ([console]::WindowWidth - 1)
        if ($Top) {
            $this = 0
        } else {
            $this.y = Get-Random -Minimum 0 -Maximum ([console]::WindowHeight - 1)
        }
        $this.Speed = Get-Random -Minimum 10 -Maximum 100
        $this.Jitter = Get-Random -Minimum 1 -Maximum 100
    }

    hidden [void] Out ([int16]$x,[int16]$y,[bool]$Space) {
        $top = [console]::CursorTop
        $left = [console]::CursorLeft
        [console]::SetCursorPosition($x,$y)
        if ($Space) {
            [console]::Write(' ')
        } else {
            [console]::Write($this.Sign)
        }
        [console]::SetCursorPosition($left,$top)
    }

    ##### PUBLIC METHODS #####

    # Constructor: Creates a new MyClass object, with the specified name
    SnowFlake() {
        $this.Init($false)
    }

    [void] Reset() {
        $this.Init($false)
    }

    [void] ResetTop() {
        $this.Init($true)
    }

    [void] NewPosition() {

        $jit = Get-Random -Minimum -100 -Maximum 101
        if ($jit -le ($this.Jitter * -1)) {
            $sidestep = -1
        } elseif ($jit -gt ($this.Jitter * -1) -and $jit -lt $this.Jitter) {
            $sidestep = 0
        } else {
            $sidestep = 1
        }

        $mov = Get-Random -Minimum 0 -Maximum 101
        if ($mov -lt $this.Speed) {
            $downstep = 1
        } else {
            $downstep = 0
        }

        $this.xold = $this.x
        $this.yold = $this.y

        $this.x = $this.x + $sidestep
        if ($this.x -ge [console]::WindowWidth - 1) {
            $this.x = [console]::WindowWidth - 1
        } elseif ($this.x -lt 0) {
            $this.x = 0
        }

        $this.y = $this.y + $downstep
        if ($this.y -gt [console]::WindowHeight-1) {
            $this.y = 0
        }
    }

    [void] Blank([int16]$x,[int16]$y) {
        $this.Out($x,$y,$true)
    }

    [void] Paint([int16]$x,[int16]$y) {
        $this.Out($x,$y,$false)
    }

    [void] Move() {
        $this.NewPosition()                     # calculate new position
        $this.Out($this.xold,$this.yold,$true)  # erase old position
        $this.Out($this.x,$this.y,$false)     # paint new poisition
    }
}


# init flakes
$flakes = foreach ($i in 1..$FlakeCount) {
    [SnowFlake]::New()
}

try {

    # create scenery
    [console]::CursorVisible = $false
    Clear-Host
    foreach ($flake in $flakes) {
        $flake.Paint($flake.x,$flake.y)
    }

    # animate flakes
    $StopWatch = [System.Diagnostics.Stopwatch]::New()
    $StopWatch.Start()
    while ($true) {

        foreach ($flake in $flakes) {
            $flake.Move()
        }

        $Elapsed = $StopWatch.ElapsedMilliseconds
        if ($Elapsed -lt $Refreshms) {
            Start-Sleep -Milliseconds ($Refreshms - $Elapsed)
        }
        $StopWatch.Restart()
    }

} catch {
    $error[0]
} finally {
    Clear-Host
    [console]::CursorVisible = $true
}
