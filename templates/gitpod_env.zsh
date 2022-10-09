# loads environment variables in .gitpod.env file from the repo's root folder
[[ ! -f "$GITPOD_REPO_ROOT/.gitpod.env" ]] || { set -a; source "$GITPOD_REPO_ROOT/.gitpod.env"; set +a; }
