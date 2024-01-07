#!/bin/bash

usage() {
    echo "Usage: $0 [-n|--name <environment_name>] [-p|--packages <package1 package2 ...>] [-r|--requirements <requirements_file>]"
    exit 1
}

while [[ $# -gt 0 ]]; do
    key="$1"

    case $key in
        -n|--name)
            ENV_NAME="$2"
            shift
            shift
            ;;
        -p|--packages)
            PACKAGES="$2"
            shift
            shift
            ;;
        -r|--requirements)
            REQUIREMENTS_FILE="$2"
            shift
            shift
            ;;
        *)
            # Unknown option
            usage
            ;;
    esac
done

if [ -z "$ENV_NAME" ]; then
    read -p "Enter the environment name (or press Enter for the default 'myenv'): " ENV_NAME
fi

if [ -z "$ENV_NAME" ]; then
    ENV_NAME="myenv"
fi

if [ -z "$PACKAGES" ]; then
    read -p "Enter packages to install (or press Enter for no additional packages): " PACKAGES
fi

if [ -z "$REQUIREMENTS_FILE" ]; then
    read -p "Enter the path to requirements.txt file (or press Enter for no file): " REQUIREMENTS_FILE
fi

# Update the system
sudo apt update
sudo apt upgrade -y

wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh
bash miniconda.sh -b -p $HOME/miniconda
rm miniconda.sh

export PATH="$HOME/miniconda/bin:$PATH"

# Initialize Conda
conda init

exec $SHELL

conda create --name "$ENV_NAME"

conda activate "$ENV_NAME"

if [ -n "$PACKAGES" ]; then
    conda install $PACKAGES
fi

if [ -n "$REQUIREMENTS_FILE" ]; then
    conda install --file "$REQUIREMENTS_FILE"
fi

echo "Script completed. You can now activate your Conda environment with 'conda activate $ENV_NAME'."

