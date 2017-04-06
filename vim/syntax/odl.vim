" Vim syntax file for OpenDaylight Log Files
" Language:     log4j apache karaf
" Version:      1
" Last Change:  2017 April 4
" Maintainer:   Michael Doyle

if version < 600
    syntax clear
elseif exists("b:current_syntax")
    finish
endif

set iskeyword+=-

syn case match

syn keyword karafError ERROR
syn keyword karafWarn WARN
syn keyword karafInfo INFO
syn keyword karafDebug DEBUG TRACE

syn keyword netconfOperation contained edit-config lock copy-config unlock commit create-subscription
syn keyword netconfOperation contained delete discard-changes get get-config kill-session validate
syn keyword netconfDatastore contained running candidate startup

syn keyword RPC contained rpc rpc-reply
syn keyword RPCError contained rpc-error
syn keyword RPCResponse contained ok

"Timestamp
syn match numbers contained '\d'
syn match date contained '\d\d\d\d-\d\d-\d\d'
syn match time contained '\d\d:\d\d:\d\d' contains=numbers

" rpc-reply xmlns="urn:ietf:params:xml:ns:netconf:base:1.0" message-id="m-24">
syn match messageNumber contained 'm-\d\+'
syn region xmlNameSpace contained start='xmlns.\{-}="'hs=e+1 end='"'he=e-1

"RemoteDevice{sin-DEMO-hub-1}
syn region remoteDeviceID contained matchgroup=remoteDeviceIDOutside start='RemoteDevice{' end='}'

"▷⋅⋅⋅at java.lang.Thread.run(Thread.java:745)[:1.8.0_121]
syn match javaLineNumber contained '\d\+'
syn region javaFunction contained start='('hs=s+1 end=')'he=s-1 contains=javaLineNumber
syn region stackTrace start="[\t]at"hs=s+3 end="$" oneline contains=javaFunction

" ONE(Time-stamp) | TWO(Log-type) | THREE | FOUR(module) | FIVE | SIX(message)
" 2017-03-03 17:44:33,861 | INFO  | d]-nio2-thread-8 | ClientUserAuthServiceNew | 30 - org.apache.sshd.core - 0.14.0 | Received SSH_MSG_USERAUTH_SUCCESS
syntax match LogRegion1 "^\d\{4\}\(.\{-}|\)"he=e-1 nextgroup=LogRegion2 contains=date,time
syntax match LogRegion2 "\(.\{-}|\)"he=e-1 contained nextgroup=LogRegion3 contains=karafError,karafWarn,karafInfo,karafDebug
syntax match LogRegion3 "\(.\{-}|\)"he=e-1 contained nextgroup=LogRegion4 "conceal
syntax match LogRegion4 "\(.\{-}|\)"he=e-1 contained nextgroup=LogRegion5
syntax match LogRegion5 "\(.\{-}|\)"he=e-1 contained nextgroup=LogRegion6 "conceal
syntax match LogRegion6 "\(.\{-}$\)" contained contains=messageNumber,xml,remoteDeviceID

syn region xmlStart matchgroup=xmlStartOut start="<[^/]\{-}" end=">" oneline containedin=LogRegion6 contains=RPC,RPCError,RPCResponse,messageNumber,netconfOperation,netconfDatastore,xmlNameSpace
syn region xmlEnd matchgroup=xmlEndOut start="</" end=">" oneline contains=RPC,RPCError,RPCResponse,netconfOperation,netconfDatastore
syn region netconfErrorMsg start="<error-message>" end="<\/error-message>"

" Highlighting Definitions for LOG Type
hi def link karafError ErrorMsg
hi def link karafWarn WarningMsg
hi def link karafInfo MoreMsg
hi def link karafDebug Label

" Highlight Definitions for Java Stack Trace
hi def link stackTrace comment
hi def link javaFunction Function
hi def link javaLineNumber LineNr

" Highlighting Definitions for the 6 Log Regions
hi def link LogRegion1 Statement
hi def link numbers Normal
hi def link date Statement
hi def link time Statement

hi def link LogRegion2 Identifier

hi def link LogRegion3 NonText

hi def link LogRegion4 Function

hi def link LogRegion5 NonText

hi def link LogRegion6 Normal
hi def link messageNumber Number
hi def link remoteDeviceID Identifier
hi def link remoteDeviceIDOutside Normal
hi def link xmlStartOut Type
hi def link xmlStart Type
hi def link xmlEndOut Tag
hi def link xmlEnd Tag
hi def link xmlNameSpace String
hi def link RPC Identifier
hi def link RPCResponse Identifier
hi def link RPCError Error
hi def link netconfOperation Special
hi def link netconfDatastore Identifier
hi def link netconfErrorMsg ErrorMsg

let b:current_syntax = "odl"
