function fix_java --description 'extract Java version from pom.xml and set it via jenv'
    # this function is POSIX sh compliant (converted to fish)

    if not type -q jenv
        echo "jenv is not installed. Quitting."
        return 1
    end

    if test -f pom.xml
        set -l java_version (grep -iE 'java(.?*)vers' pom.xml | grep -oE '[0-9]+')
        jenv local $java_version
        printf "jenv: Java version %s set\n\n" $java_version
        java -version
    else
        echo "No pom.xml file to extract Java version from"
        return 1
    end
end
