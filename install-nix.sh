command -v sudo >/dev/null 2>&1 || { echo "Not found 'sudo' command"; exit; }

if command -v nix >/dev/null 2>&1; then
    echo "nix exists"
else
    sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --no-daemon
    echo "nix not found"
fi

