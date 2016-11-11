# ---- language-env DON'T MODIFY THIS LINE!
# ログインシェルではない bash の起動時に実行される。
# ----- 基本的な設定 -----
# XIM サーバーの名前を定義する
# (XIM は、language-env だけで使うシェル変数です)
PAGER=less
export PAGER
# ファイルを作るとき、どんな属性で作るか。man umask 参照
umask 022

bindkey -e

export LS_COLORS='di=01;37;40:'
autoload colors
colors
PROMPT="%n:%~%%"
RPROMPT="[%m %D{%k:%M %m/%d}]"
export PATH="/opt/local/bin:/opt/local/sbin:$HOME/.local/bin:$HOME/root/bin:/usr/local/bin:/usr/bin:/bin:/usr/bin/X11:/usr/games:$PATH"
export LC_ALL=ja_JP.UTF-8
export LANG=ja_JP.UTF-8
export LANGUAGE=ja
export LESSCHARSET=utf-8
export CPPREF_DOCROOT=$HOME/root/share/perl/5.10.0/auto/share/dist/cppref
export DISPLAY=:0.0
#export XMODIFIERS=@im=uim
#alias standby='sudo apm -s'
#
export EDITOR="vim"
export SVN_EDITOR="vim"

alias ls='ls -v -F -G'
alias time=/usr/bin/time
alias vi='vim'
alias cl='sbcl --noinform'

alias rhino='java org.mozilla.javascript.tools.shell.Main'

#export PERL5LIB=/opt/local/lib/perl5/vendor_perl:/opt/local/lib/perl5/vendor_perl/5.8.8:/opt/local/lib/perl5/vendor_perl/5.8.8/darwin-2level:/opt/local/lib/perl5/site_perl:/opt/local/lib/perl5/site_perl/5.8.8:/opt/local/lib/perl5/site_perl/5.8.8/darwin-2level:/opt/local/lib/perl5/5.8.8/darwin-2level:/opt/local/lib/perl5/5.8.8:/home/masa/perl/lib/perl5/site_perl:/home/masa/perl/lib/perl5/site_perl/5.8.6/darwin-thread-multi-2level:$PERL5LIB

#export PERL5LIB=/home/masa/perl/lib/perl5/site_perl:/home/masa/perl/lib/perl5/site_perl/5.8.6/darwin-thread-multi-2level:/sw/lib/perl5/5.8.6:$PERL5LIB
export MANPATH=$HOME/root/share/man:/opt/local/share/man:$MANPATH
export RUBYLIB=$HOME/build/bin
export PYTHONSTARTUP=$HOME/.pythonrc.py
export PYTHONPATH="$HOME/root/lib/python2.6/site-packages:$PYTHONPATH"
alias ssh-shnya="ssh shnya.jp"
alias cabocha-utf8="cat | nkf -e | cabocha -f1 | nkf -w "
alias chasen-utf8="cat | nkf -e | chasen | nkf -w "
alias updateports="sudo port selfupdate; sudo port outdated"
alias portupgrade="sudo port upgrade installed"
alias w3m='w3m -B'
alias l='ls -v -F -G'
alias c='cd'
#for screen
#function preexec () {
#      echo -ne "\ek${1%% *}\e\\"
#}
alias screen='screen -U -D -RR'
alias tcp_scaling='$HOME/.tcp_scaling'
alias aptitude='sudo aptitude'
alias shutdown='sudo shutdown -h now'
alias reboot='sudo reboot'
alias whois='jwhois'

make_p () {
  local t s;
  t="$1"; shift;

  [ -f $t ] || return 0;

  for s
  do
    [ $s -nt $t ] && return 0;
  done;

  return 1;
}

cache_hosts_file="$HOME/.cache_hosts"
known_hosts_file="$HOME/.ssh/known_hosts"

print_cache_hosts () {
  if [ -f $known_hosts_file ]; 
  then
    awk '{ if (split($1, a, ",") > 1) for (i in a) { if (a[i] ~ /^[a-z]/) print a[i] } else print $1 }' $known_hosts_file;
  fi
}

update_cache_hosts () {
  print_cache_hosts | sort -u > $cache_hosts_file;
}

make_p $cache_hosts_file $known_hosts_file && update_cache_hosts

_cache_hosts=( $(< $cache_hosts_file ) );

limitargs=(cputime filesize datasize stacksize coredumpsize
    resident maxproc descripters)
# limit(1), unlimit(1)の補完候補

zstyle ':completion:*' use-cache true
compctl -c man jman which # コマンド名を補完候補に
compctl -l '' nice exec screen # cmd arg1 arg2 ... 型の補完
compctl -E printenv setenv
compctl -v -E vared unset # シェル変数、環境変数
compctl -g '*.tex' + tex jtex ptex latex jlatex platex
compctl -g '*.dvi' xdvi dviselect dvips dvi2ps
compctl -g '/var/db/pkg/*(:t)' pkg_info pkg_delete
# /var/db/pkg 下のファイルの basename を補完候補に
compctl -k limitargs limit unlimit
# limit と unlimit の補完候補は $limitargs
compctl -k hosts  slogin telnet ftp ncftp ping nslookup traceroute xhost
compctl -f -k hosts rsh ssh
compctl -f -x 's[http://]' -k hosts -k urls -- w3m netscape
compctl -f -x 's[-P]' -k printers -- lpr lpq lprm prn
compctl -x 's[-]' -k signals -- kill
compctl -x 's[if=] , s[of=]' -f -- dd edd
compctl -v -x 's[DISPLAY=]' -k hosts -S ':0' -- export
# export の引数は変数(-v)だが、 DISPLAY= で始まっていると
# ホスト名で補完して、末尾に :0 を付ける
function _folders () { reply=(`folders -recurse -fast`) }
compctl -x 's[+]' -K _folders -- folders folder scan packf
# 補完時にシェルコマンドを呼出す例
HISTFILE=$HOME/.zsh-history           # 履歴をファイルに保存する
HISTSIZE=100000                       # メモリ内の履歴の数
SAVEHIST=100000                       # 保存される履歴の数
setopt extended_history               # 履歴ファイルに時刻を記録
function history-all { history -E 1 } # 全履歴の一覧を出力する


alias tree='tree -C'
#alias free='free -mt' #alias df='df -H' #alias ps='ps -H'
#alias ping='ping -c4'
alias -g L='| less'
alias -g H='| head'
alias -g T='| tail'
alias -g G='| grep -i'
alias -g W='| wc'
alias -g S='| sed'
alias -g A='| awk'
autoload -U compinit; compinit -d ~/.zcompdump
zstyle ':completion:*' group-name ''
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:descriptions' format '%d' 
zstyle ':completion:*:options' verbose yes
zstyle ':completion:*:values' verbose yes
zstyle ':completion:*:options' prefix-needed yes
zstyle ':completion:*:default' menu select=1
zstyle ':completion:*' matcher-list '' \
'm:{a-z}={A-Z}' 'l:|=* r:|[.,_-]=* r:|=* m:{a-z}={A-Z}' 
setopt \
auto_list \
auto_param_slash \
list_packed \
completeinword  \
printeightbit \
auto_menu \
auto_cd \
auto_name_dirs \
auto_remove_slash \
extended_history \
hist_ignore_dups \
hist_ignore_space \
prompt_subst \
auto_pushd \
pushd_ignore_dups \
rm_star_silent \
sun_keyboard_hack \
extended_glob \
list_types no_beep \
always_last_prompt \
cdable_vars \
sh_word_split \
auto_param_keys \
all_export \
correct \
notify \
pushdsilent \
complete_aliases \
promptcr \
print_eight_bit \
noautoremoveslash

autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^p" history-beginning-search-backward-end
bindkey "^n" history-beginning-search-forward-end
bindkey "\\ep" history-beginning-search-backward-end
bindkey "\\en" history-beginning-search-forward-end

autoload zed
autoload predict-on

#alias backup="lftp -u masa -e \"mirror -Rv -x '^\..*' --delete --only-newer  /home/masa/ /lagrange ; close; quit;\" 192.168.3.131"

if [ $TERM = "screen" ]; then
echo -n -e "\ek$(hostname)\e\\"
fi

if [ -e $HOME/.local/bin/virtualenvwrapper.sh ]; then
source $HOME/.local/bin/virtualenvwrapper.sh
fi

alias chrome="google-chrome"
