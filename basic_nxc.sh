#!/bin/bash

# Define the hosts and users file
hosts_file="hosts.txt"
users_file="users.txt"

# Loop through each host in the hosts file
while IFS= read -r host; do
  echo "Running commands for host: $host"

  # Run nxc smb commands with different username and password combinations
  nxc smb "$host" -u '' -p '' --shares
  nxc smb "$host" -u 'null' -p '' --shares
  nxc smb "$host" -u 'guest' -p '' --shares
  nxc smb "$host" -u 'guest' -p '' --shares --rid-brute
  nxc smb "$host" -u 'guest' -p 'guest' --shares
  nxc smb "$host" -u "$users_file" -p '' --continue-on-success
  nxc smb "$host" -u "$users_file" -p "$users_file" --continue-on-success | grep [+]

  # Run lookupsid.py command with the current host
  /usr/share/doc/python3-impacket/examples/lookupsid.py anonymous@$host -no-pass

done < "$hosts_file"

# End of script
