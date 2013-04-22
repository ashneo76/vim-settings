# ~/.bashrc: executed by bash(1) for non-login shells.

export PS1='\h:\w\$ '
umask 022

# You may uncomment the following lines if you want `ls' to be colorized:
export LS_OPTIONS='--color=auto'

alias sshweb='ssh neo@ashishshah.net -p 443'

alias df='df -h'
alias du='du -h'

alias ifconfig='sudo ifconfig'
alias ping='sudo ping'

export PS1='\[\033[0m\][\[\033[33m\]${SHLVL}\[\033[0m\]|\[\033[34m\]\u\[\033[0m\]@\[\033[32m\]\h\[\033[0m\]|\[\033[36m\]\w\[\033[0m\]]\[\033[0m\] '
#export PS1="[\[\033[32m\]\w]\[\033[0m\]\n\[\033[1;36m\]\u\[\033[1;33m\]-> \[\033[0m\]"

if [ "$N900" ]; then
	if [ "$PS1" ]; then
	mkdir -p -m 0700 /dev/cgroup/cpu/user/$$ > /dev/null 2>&1
	echo $$ > /dev/cgroup/cpu/user/$$/tasks
	echo "1" > /dev/cgroup/cpu/user/$$/notify_on_release
	fi
	cd /home/user/MyDocs
	eval "`gdircolors`"

	alias ls='gls $LS_OPTIONS'
	alias ll='gls $LS_OPTIONS -l'
	alias la='gls $LS_OPTIONS -lAXh'
	#
	# Some more alias to avoid making mistakes:
	alias rm='rm -i'
	alias cp='cp -i'
	alias mv='mv -i'

	alias aa='sudo apt-get autoremove'
	alias ai='sudo apt-get install'
	alias au='sudo apt-get update && sudo apt-get upgrade'
	alias ac='apt-cache search'
	alias aud='sudo apt-get update'
	alias aug='sudo apt-get upgrade'
	alias ar='sudo apt-get remove'
	alias di='sudo dpkg -i'
fi

export EDITOR=vim
