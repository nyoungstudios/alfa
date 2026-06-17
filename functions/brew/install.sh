#!/bin/bash

is_macos_admin_user() {
  local user_name="$1"

  if id -Gn "$user_name" 2>/dev/null | tr ' ' '\n' | grep -qx 'admin'; then
    return 0
  fi

  if command -v dseditgroup >/dev/null 2>&1 &&
    dseditgroup -o checkmember -m "$user_name" admin 2>/dev/null | grep -qi 'yes'; then
    return 0
  fi

  if command -v dsmemberutil >/dev/null 2>&1 &&
    dsmemberutil checkmembership -U "$user_name" -G admin 2>/dev/null | grep -qi 'is a member'; then
    return 0
  fi

  return 1
}

install_brew() {
  local target_user="${ALFA_USER:-${SUDO_USER:-${USER:-$(id -un 2>/dev/null || true)}}}"

  if [ "$(uname -s)" = 'Darwin'; then
    if ! is_macos_admin_user "$target_user"; then
      echo "Need sudo access on macOS (e.g. the user ${target_user} needs to be an Administrator)!"
      return 1
    fi

    if ! sudo -n -v >/dev/null 2>&1; then
      echo 'Checking for `sudo` access (which may request your password)...'
      if ! sudo -v; then
        echo "Need sudo access on macOS (e.g. the user ${target_user} needs to be an Administrator)!"
        return 1
      fi
    fi
  fi

  # Installs homebrew
  NONINTERACTIVE=1 /bin/bash -c "$(curl_or_wget -s https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}
