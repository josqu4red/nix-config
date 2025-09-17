## facts\.config

General shared config



*Type:*
attribute set



*Default:*
` { } `

*Declared by:*
 - [nix-config/modules/nixos/options\.nix](https://github.com/josqu4red/nix-config/tree/main/modules/nixos/options.nix)



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



## facts\.dns



DNS settings



*Type:*
submodule



*Default:*
` null `

*Declared by:*
 - [nix-config/modules/nixos/options\.nix](https://github.com/josqu4red/nix-config/tree/main/modules/nixos/options.nix)



## facts\.dns\.internalDomain



Internal domain name



*Type:*
string



*Default:*
` null `

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



## facts\.hosts\.\<name>\.aliases



Host aliases



*Type:*
list of string



*Default:*
` [ ] `

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



## facts\.hosts\.\<name>\.netIf



Host main network interface



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



## facts\.networks



Network settings



*Type:*
attribute set of (submodule)



*Default:*
` null `

*Declared by:*
 - [nix-config/modules/nixos/options\.nix](https://github.com/josqu4red/nix-config/tree/main/modules/nixos/options.nix)



## facts\.networks\.\<name>\.dhcp



Dynamic prefix



*Type:*
submodule



*Default:*
` null `

*Declared by:*
 - [nix-config/modules/nixos/options\.nix](https://github.com/josqu4red/nix-config/tree/main/modules/nixos/options.nix)



## facts\.networks\.\<name>\.dhcp\.address



Prefix address



*Type:*
string

*Declared by:*
 - [nix-config/modules/nixos/options\.nix](https://github.com/josqu4red/nix-config/tree/main/modules/nixos/options.nix)



## facts\.networks\.\<name>\.dhcp\.length



Prefix length



*Type:*
signed integer

*Declared by:*
 - [nix-config/modules/nixos/options\.nix](https://github.com/josqu4red/nix-config/tree/main/modules/nixos/options.nix)



## facts\.networks\.\<name>\.gateway



Default gateway



*Type:*
string



*Default:*
` null `

*Declared by:*
 - [nix-config/modules/nixos/options\.nix](https://github.com/josqu4red/nix-config/tree/main/modules/nixos/options.nix)



## facts\.networks\.\<name>\.prefix



Network prefix



*Type:*
submodule



*Default:*
` null `

*Declared by:*
 - [nix-config/modules/nixos/options\.nix](https://github.com/josqu4red/nix-config/tree/main/modules/nixos/options.nix)



## facts\.networks\.\<name>\.prefix\.address



Prefix address



*Type:*
string

*Declared by:*
 - [nix-config/modules/nixos/options\.nix](https://github.com/josqu4red/nix-config/tree/main/modules/nixos/options.nix)



## facts\.networks\.\<name>\.prefix\.length



Prefix length



*Type:*
signed integer

*Declared by:*
 - [nix-config/modules/nixos/options\.nix](https://github.com/josqu4red/nix-config/tree/main/modules/nixos/options.nix)



## facts\.networks\.\<name>\.vlan



VLAN ID



*Type:*
signed integer



*Default:*
` null `

*Declared by:*
 - [nix-config/modules/nixos/options\.nix](https://github.com/josqu4red/nix-config/tree/main/modules/nixos/options.nix)



## settings\.userShell



Default user shell



*Type:*
package



*Default:*
` <derivation bash-interactive-5.2p37> `



*Example:*
` <derivation zsh-5.9> `

*Declared by:*
 - [nix-config/modules/nixos/options\.nix](https://github.com/josqu4red/nix-config/tree/main/modules/nixos/options.nix)


