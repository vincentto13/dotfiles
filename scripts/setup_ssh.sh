#!/bin/bash

add_ssh_key() {
    # Path to the authorized_keys file
    authorized_keys_path="$HOME/.ssh/authorized_keys"

    # Check if the authorized_keys file exists, if not, create it
    [ -f "$authorized_keys_path" ] || touch "$authorized_keys_path"

    # Read the new key from the provided file
    new_key=$(cat "$1")

    # Check if the new key already exists
    if ! grep -q "$new_key" "$authorized_keys_path"; then
        echo "$new_key" >> "$authorized_keys_path"
        echo "SSH key added successfully."
    else
        echo "SSH key already exists."
    fi
}

add_ssh_key "$HOME/.dotfiles/keys/id_rsa.pub"
