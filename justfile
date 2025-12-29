alias f := fetch

gen:
    python gen.py

fetch pkg="":
    @cd templates && just select-sources "{{ pkg }}" | xargs -0 -I {} ./nivv "{}"

[private]
select-sources pkg="":
    #!/usr/bin/env bash
    set -euo pipefail

    if [ -z "{{ pkg }}" ]; then
        grep -oP '(?<=^\[)[^].]+(?=.*\]$)' ./templates/config.toml | fzf -m --print0
    else
        echo "{{ pkg }}"
    fi
