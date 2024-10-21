## facts\.defaults

Host defaults



*Type:*
submodule



*Default:*
` { } `

*Declared by:*
 - [nix-config/modules/nixos/options\.nix](https://github.com/josqu4red/nix-config/tree/main/modules/nixos/options.nix)



## facts\.defaults\.stateVersion



Default stateVersion



*Type:*
string



*Default:*
` "22.05" `

*Declared by:*
 - [nix-config/modules/nixos/options\.nix](https://github.com/josqu4red/nix-config/tree/main/modules/nixos/options.nix)



## facts\.defaults\.system



Default host platform



*Type:*
string



*Default:*
` "x86_64-linux" `

*Declared by:*
 - [nix-config/modules/nixos/options\.nix](https://github.com/josqu4red/nix-config/tree/main/modules/nixos/options.nix)



## facts\.defaults\.users



Default host users



*Type:*
list of string



*Default:*
` [ ] `

*Declared by:*
 - [nix-config/modules/nixos/options\.nix](https://github.com/josqu4red/nix-config/tree/main/modules/nixos/options.nix)



## facts\.homeNet



Home network settings



*Type:*
submodule



*Default:*
` null `

*Declared by:*
 - [nix-config/modules/nixos/options\.nix](https://github.com/josqu4red/nix-config/tree/main/modules/nixos/options.nix)



## facts\.homeNet\.defaultGw



Default gateway



*Type:*
string



*Default:*
` null `

*Declared by:*
 - [nix-config/modules/nixos/options\.nix](https://github.com/josqu4red/nix-config/tree/main/modules/nixos/options.nix)



## facts\.homeNet\.domain



Internal domain name



*Type:*
string



*Default:*
` null `

*Declared by:*
 - [nix-config/modules/nixos/options\.nix](https://github.com/josqu4red/nix-config/tree/main/modules/nixos/options.nix)



## facts\.homeNet\.prefix



Home prefix



*Type:*
submodule



*Default:*
` null `

*Declared by:*
 - [nix-config/modules/nixos/options\.nix](https://github.com/josqu4red/nix-config/tree/main/modules/nixos/options.nix)



## facts\.homeNet\.prefix\.address



Home prefix address



*Type:*
string

*Declared by:*
 - [nix-config/modules/nixos/options\.nix](https://github.com/josqu4red/nix-config/tree/main/modules/nixos/options.nix)



## facts\.homeNet\.prefix\.length



Home prefix length



*Type:*
signed integer



*Default:*
` 24 `

*Declared by:*
 - [nix-config/modules/nixos/options\.nix](https://github.com/josqu4red/nix-config/tree/main/modules/nixos/options.nix)



## facts\.hosts



List of hosts



*Type:*
attribute set of (submodule)



*Default:*
` { } `

*Declared by:*
 - [nix-config/modules/nixos/options\.nix](https://github.com/josqu4red/nix-config/tree/main/modules/nixos/options.nix)



## facts\.hosts\.\<name>\.ip



Host IPv4 address



*Type:*
string



*Default:*
` "" `

*Declared by:*
 - [nix-config/modules/nixos/options\.nix](https://github.com/josqu4red/nix-config/tree/main/modules/nixos/options.nix)



## facts\.hosts\.\<name>\.mac



Host MAC address



*Type:*
string



*Default:*
` "" `

*Declared by:*
 - [nix-config/modules/nixos/options\.nix](https://github.com/josqu4red/nix-config/tree/main/modules/nixos/options.nix)



## facts\.hosts\.\<name>\.stateVersion



State version



*Type:*
string



*Default:*
` "22.05" `

*Declared by:*
 - [nix-config/modules/nixos/options\.nix](https://github.com/josqu4red/nix-config/tree/main/modules/nixos/options.nix)



## facts\.hosts\.\<name>\.system



Host platform



*Type:*
string



*Default:*
` "x86_64-linux" `

*Declared by:*
 - [nix-config/modules/nixos/options\.nix](https://github.com/josqu4red/nix-config/tree/main/modules/nixos/options.nix)



## facts\.hosts\.\<name>\.users



Host users



*Type:*
list of string



*Default:*
` [ ] `

*Declared by:*
 - [nix-config/modules/nixos/options\.nix](https://github.com/josqu4red/nix-config/tree/main/modules/nixos/options.nix)



## facts\.hosts\.\<name>\.vms



Host microvms



*Type:*
list of string



*Default:*
` [ ] `

*Declared by:*
 - [nix-config/modules/nixos/options\.nix](https://github.com/josqu4red/nix-config/tree/main/modules/nixos/options.nix)



## settings\.userShell



Default user shell



*Type:*
package



*Default:*
` <derivation bash-5.2p32> `



*Example:*
` <derivation zsh-5.9> `

*Declared by:*
 - [nix-config/modules/nixos/options\.nix](https://github.com/josqu4red/nix-config/tree/main/modules/nixos/options.nix)


