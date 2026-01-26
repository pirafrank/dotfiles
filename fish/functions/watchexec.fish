function watchexec --description 'watchexec wrapper with auto-detection for different project types'

    function run_java
        if not test -f "pom.xml"
            echo "It looks like a Java project, but I can't find a pom.xml file."
            echo "Please run this script from the root of your Maven project. Only Maven projects are supported at this time."
            return 1
        else if grep -q spring-boot-starter-parent pom.xml
            echo "It looks like a Spring Boot project. Running with Maven..."
            command watchexec -r -w src -e java,properties,xml -- mvn spring-boot:run
        else
            echo "It looks like a Java project. Running with Maven..."
            command watchexec -r -w src -e java,properties,xml -- mvn compile exec:java
        end
    end

    function run_rust
        echo "It looks like a Rust project. Running with Cargo..."
        command watchexec -r -w src -e rs,toml,conf -- cargo run
    end

    function run_golang
        echo "It looks like a Go project. Running with Go..."
        command watchexec -r -w . -e go,mod -- go run .
    end

    function run_python
        set -l file "main.py"
        if not test -f "$file"
            set file (find . -maxdepth 1 -type f -name '*.py' -print -quit)
        end
        echo "It looks like a Python project. Remember watchexec wrapper does not load virtualenvs!"
        echo "Running $file file..."
        command watchexec -r -w . -e py,ini,txt -- python "$file"
    end

    function run_lua
        set -l file (find . -maxdepth 1 -type f -name '*.lua' -print -quit)
        echo "It looks like a Lua project. Running $file file..."
        command watchexec -r -w . -e lua,conf -- lua "$file"
    end

    function run_watchexec_detect
        if test -n (find . -name '*.java' -print -quit)
            run_java
        else if test -n (find . -name '*.go' -print -quit)
            run_golang
        else if test -n (find . -name '*.rs' -print -quit)
            run_rust
        else if test -n (find . -name '*.py' -print -quit)
            run_python
        else if test -n (find . -name '*.lua' -print -quit)
            run_lua
        end
    end

    # main script
    if test (count $argv) -gt 0
        # you choose
        command watchexec $argv
    else
        # start guessing
        run_watchexec_detect
    end
end
