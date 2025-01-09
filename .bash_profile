# Add `~/bin` to the `$PATH`
export PATH="$HOME/bin:$PATH";

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{path,bash_prompt,exports,aliases,functions,extra}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

# Append to the Bash history file, rather than overwriting it
shopt -s histappend;

# Autocorrect typos in path names when using `cd`
shopt -s cdspell;

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
	shopt -s "$option" 2> /dev/null;
done;

# Add tab completion for many Bash commands
if which brew &> /dev/null && [ -r "$(brew --prefix)/etc/profile.d/bash_completion.sh" ]; then
	# Ensure existing Homebrew v1 completions continue to work
	source "$(brew --prefix)/etc/profile.d/bash_completion.sh";
elif [ -f /etc/bash_completion ]; then
	source /etc/bash_completion;
fi;

# Enable tab completion for `g` by marking it as an alias for `git`
if type _git &> /dev/null; then
	complete -o default -o nospace -F _git g;
fi;

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;

# Add tab completion for `defaults read|write NSGlobalDomain`
# You could just use `-g` instead, but I like being explicit
complete -W "NSGlobalDomain" defaults;

# Add `killall` tab completion for common apps
complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal Twitter" killall;

#shell
export PS1="\W$ "
export BASH_SILENCE_DEPRECATION_WARNING=1
export SHELL=/bin/bash

#docker
export DOCKER_DEFAULT_PLATFORM=linux/amd64

#ccache
export PATH=":/opt/homebrew/opt/ccache/libexec:$PATH"
export CC="ccache gcc"
export CXX="ccache g++"

#python
# unlink /usr/local/bin/python
# ln -s $(which python3) /usr/local/bin/python

#git
GIT_AUTHOR_NAME="Robert Nagy"
GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
git config --global user.name "$GIT_AUTHOR_NAME"
GIT_AUTHOR_EMAIL="ronagy@icloud.com"
GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
git config --global user.email "$GIT_AUTHOR_EMAIL"

#brew
eval "$(/opt/homebrew/bin/brew shellenv)"

#curl
export PATH="/opt/homebrew/opt/curl/bin:$PATH"

#nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

#bmux
bt_vpn () {
  which sshuttle >/dev/null || {
    echo "sshuttle must be installed!"
    echo "use an apropriate package manager to install it:"
    echo " apt-get | brew install sshuttle...or so..."
    return 1;
  }
  echo "# Note: this helper only works with remote linux hosts that has the \"ip\" command installed."
  echo "# Select a subnet you wish to connect to:"
  sshuttle -vr ${1%.bmux}.bmux $(
    select net in $(ssh ${1%.bmux}.bmux ip r | grep -Ev "docker|default" | cut -d" " -f1) ;
      do echo $net; break ; done
  );
}

export PATH="/opt/homebrew/opt/util-linux/bin:$PATH"
export PATH="/opt/homebrew/opt/util-linux/sbin:$PATH"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
