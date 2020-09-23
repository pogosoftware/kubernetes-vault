#!/bin/bash -eux

wget --quiet https://github.com/roboll/helmfile/releases/download/v0.130.0/helmfile_linux_amd64
mv helmfile_linux_amd64 /usr/local/bin/helmfile
chmod +x /usr/local/bin/helmfile
