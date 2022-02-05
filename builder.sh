set -e

# create and activate venv
$virtualenv/bin/virtualenv $out
export PATH=$coreutils/bin
. $out/bin/activate

# TODO: This is a bit ugly and there's probably some env var for pip to do it differently?
# We don't want to deep copy octavia and f5pd, so we make symlink dirs
# This is so that pip can write its .eggs directory
$coreutils/bin/mkdir -p $out/octavia
$findutils/bin/find $octavia/ -mindepth 1 -maxdepth 1 -exec ln -s {} $out/octavia/ \;
$coreutils/bin/mkdir -p $out/f5pd
$findutils/bin/find $f5pd/ -mindepth 1 -maxdepth 1 -exec ln -s {} $out/f5pd/ \;

# install requirements with upper-constraints
set -x
$out/bin/pip install -c $upperconstraints -e $out/octavia/
$out/bin/pip install -c $upperconstraints -e $out/f5pd/
set +x

# TODO: octavia-db-manage stuff

# Activation subshell
# Let bash source the activation script and then call itself with the new env
# FIXME: Bash behaves weird, C-a a doesn't work for example
echo "$bash/bin/bash -c '. $out/bin/activate;exec $bash/bin/bash'" > $out/bin/activate.sh
$coreutils/bin/chmod +x $out/bin/activate.sh
