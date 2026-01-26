function rec --description 'thin wrapper around asciinema for easier terminal recording'
    # A thin wrapper around asciinema for easier terminal sessions recording,
    # with default conversion to gif for sharing, e.g. embed them in markdown files.
    # Not meant to be a substitute or to wrap all functions of asciinema binary.
    #
    # Requires asciinema and agg to be installed.
    #
    # author: @pirafrank

    # Default values
    set -l format ''
    set -l filename (date '+%Y-%m-%d_%H%M%S')
    set -l convert_to_gif 'false'

    # Parse options
    set -l options (fish_opt -s h -l help)
    set options $options (fish_opt -s v -l version)
    set options $options (fish_opt -s f -l format --required-val)

    argparse $options -- $argv
    or return

    if set -q _flag_h
        echo "Usage: rec [OPTIONS] [FILENAME]"
        echo "Options:"
        echo "  -h, --help          Show help"
        echo "  -v, --version       Show version"
        echo "  -f, --format FORMAT Specify format [possible values: asciicast-v3, asciicast-v2, raw, txt, gif]"
        return 0
    end

    if set -q _flag_v
        echo "Version 0.1.1"
        return 0
    end

    if set -q _flag_f
        set format $_flag_f
    end

    # Get filename argument if provided
    if test (count $argv) -gt 0
        set filename $argv[1]
    end

    # prepare
    mkdir -p "$HOME/asciinema"

    # check if asciinema is installed
    if not type -q asciinema
        echo "asciinema is not installed. Please install it before running this script."
        return 2
    end

    # check params, if gif record as asciicast and convert later
    if test "$format" = 'gif'; or test -z "$format"
        # default to v2 because agg is compatible only with v2
        set format "asciicast-v2"
        set convert_to_gif 'true'
    end

    # record
    set -l extension (string replace -r '-.*' '' $format | string replace 'ascii' '')
    asciinema rec -f "$format" "$HOME/asciinema/$filename.$extension"

    if test $status -ne 0
        return $status
    end

    set -l msg "asciinema recording saved to $HOME/asciinema/$filename.$extension"

    # if gif output format is wanted, convert screencast
    if test "$convert_to_gif" = 'false'
        # we're done here. quitting.
        printf '\n%s\n' "$msg."
        return 0
    end

    # check if agg is installed
    if not type -q agg
        echo "agg is not installed. Please install to convert recording to gif."
        return 3
    end

    # convert to gif
    agg --theme monokai "$HOME/asciinema/$filename.$extension" "$HOME/asciinema/$filename.gif"

    if test $status -eq 0
        printf '\n%s\n' "$msg and converted to gif ($HOME/asciinema/$filename.gif)."
    else
        return $status
    end
end
