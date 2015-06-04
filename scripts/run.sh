find . -mtime 0 | grep .tar.gz | while read line; do
    tar -xf $line -C /var/log/node/6/2015/05/../../tmp/${original_string/Suzi/$string_to_replace_Suzi_with}
done