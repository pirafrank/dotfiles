function gitignore --description 'fetch gitignore templates from toptal.com'
    curl -sLw "\n" https://www.toptal.com/developers/gitignore/api/$argv
end
