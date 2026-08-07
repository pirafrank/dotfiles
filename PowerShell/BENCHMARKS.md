# PowerShell startup benchmarks

This benchmark separates PowerShell's own startup cost from the cost of loading
the user profile. It follows the PowerShell team's recommendation to repeat
each measurement 100 times, then compare the averages.

Run these commands from this directory in PowerShell 7 (`pwsh`). Close other
PowerShell-heavy applications first, and keep the shell, working directory, and
environment the same for both measurements.

## Compare `-NoProfile` with the default profile

The first command measures the PowerShell baseline. The second measures the
same startup with the default profile enabled. The reported profile overhead is
the difference between the two averages.

```powershell
$iterations = 100

$noProfile = 0
1..$iterations | ForEach-Object {
    $percent = [int](($_ / $iterations) * 100)
    Write-Progress -Activity 'Measuring pwsh startup' -Status "NoProfile run $_ of $iterations" -PercentComplete $percent
    $noProfile += (Measure-Command {
        pwsh -NoLogo -NoProfile -NonInteractive -Command 'exit'
    }).TotalMilliseconds
}
Write-Progress -Activity 'Measuring pwsh startup' -Completed
$noProfileAverage = $noProfile / $iterations

$profile = 0
1..$iterations | ForEach-Object {
    $percent = [int](($_ / $iterations) * 100)
    Write-Progress -Activity 'Measuring pwsh startup' -Status "Profile run $_ of $iterations" -PercentComplete $percent
    $profile += (Measure-Command {
        pwsh -NoLogo -NonInteractive -Command 'exit'
    }).TotalMilliseconds
}
Write-Progress -Activity 'Measuring pwsh startup' -Completed
$profileAverage = $profile / $iterations

[pscustomobject]@{
    NoProfileAverageMs = [math]::Round($noProfileAverage, 2)
    ProfileAverageMs   = [math]::Round($profileAverage, 2)
    ProfileOverheadMs  = [math]::Round($profileAverage - $noProfileAverage, 2)
}
```

`-NonInteractive` prevents prompts from affecting the result. `-Command 'exit'`
ensures both processes do the same minimum amount of work after startup.

For a less noisy run, execute the whole block at least three times and compare
the averages rather than relying on a single run. The first run may also be
affected by module and file-system caches.

### Reading the results

- `NoProfileAverageMs` is the host/runtime baseline.
- `ProfileAverageMs` is baseline plus profile loading.
- `ProfileOverheadMs` is the estimated cost of this profile.
- Use the PSProfiler output to find hotspots, then re-run the startup benchmark
  after each meaningful change.

The PowerShell optimization article cited among References specifically uses a
100-iteration loop to reduce the effect of machine variance. It also cautions
that micro-optimizing a profile may trade readability for very small gains;
deferring interactive-only work is usually more meaningful.

### Current results

As of today commit ([424cb9a07c0e](https://github.com/pirafrank/dotfiles/commit/424cb9a07c0e)):

```txt

NoProfileAverageMs ProfileAverageMs ProfileOverheadMs
------------------ ---------------- -----------------
            334,60           996,15            661,55

```

## Profile the Profile.ps1 script

### Requirements

Install PSProfiler first:

```powershell
Install-Module PSProfiler -RequiredVersion 1.0.5.0 -Scope CurrentUser
```

PSProfiler provides `Measure-Script`, which reports the statements that consume
the most execution time inside a script.

### Profile with PSProfiler

This profiles the profile script itself, rather than a new `pwsh` process. It
helps identify hot statements such as module imports, command discovery, path
operations, and loops.

```powershell
$profilePath = (Resolve-Path .\Profile.ps1).Path

Import-Module PSProfiler -RequiredVersion 1.0.5.0
Measure-Script {
    . $profilePath
}
```

To profile the profile in a fresh process, which avoids any modules already
loaded in the current shell:

```powershell
$profilePath = (Resolve-Path .\Profile.ps1).Path

pwsh -NoLogo -NoProfile -Command @"
Import-Module PSProfiler -RequiredVersion 1.0.5.0
Measure-Script {
    . '$profilePath'
}
"@
```

Run this several times and focus optimization work on consistently expensive
statements. A profiler run adds measurement overhead, so use the startup
benchmark above for the actual user-visible cost.

## References

- [Optimizing your `$Profile`](https://devblogs.microsoft.com/powershell/optimizing-your-profile/)
- [PSProfiler 1.0.5.0 on PowerShell Gallery](https://www.powershellgallery.com/packages/PSProfiler/1.0.5.0)
- [PSProfiler usage and source](https://github.com/IISResetMe/PSProfiler)
