#!/bin/bash -e

on_chroot << EOF

function section_echo
{
    echo $1
    echo -e "\r\n\r\n--- $1 ---\n"
}

echo '>>> Set Debian frontend to Noninteractive'
echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
export DEBIAN_FRONTEND=noninteractive

cd /tmp

pip3 install --upgrade pip virtualenv setuptools setuptools-rust wheel
pip3 install --prefer-binary pyscf cython six==1.14.*

section_echo 'Setup virtualenv'
pip3 install virtualenv
virtualenv -p python3.7 rasqberry_venv
source rasqberry_venv/bin/activate

section_echo 'Install rust'
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source $HOME/.cargo/env

#section_echo 'Build retworkx'
pip install --prefer-binary retworkx

section_echo 'Install qiskit'
pip3 install --prefer-binary 'qiskit[visualization]==0.19.*'

EOF
