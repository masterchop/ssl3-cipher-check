#!/bin/bash
#####################################################################################
#
# ssl3_cipher_check.sh - Determine which SSL 3.0 ciphers, if any, are supported by
#                        a targeted server.
#
# Author  - Lamar Spells (lamar.spells@gmail.com)
# Blog    - http://foxtrot7security.blogspot.com
# Twitter - lspells
#
# Copyright (c) 2014, Lamar Spells
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without modification,
# are permitted provided that the following conditions are met:
#
#   - Redistributions of source code must retain the above copyright notice, this
#     list of conditions and the following disclaimer.
#   - Redistributions in binary form must reproduce the above copyright notice,
#     this list of conditions and the following disclaimer in the documentation
#     and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
# IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
# INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
# BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
# LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
# OF THE POSSIBILITY OF SUCH DAMAGE.
#
#####################################################################################

if [ $# -lt 1 ] ; then
   echo "USAGE: `basename $0` <ip> [port]"
   exit 1
fi

if [ $# -eq 1 ] ; then
  SERVER=${1}:443
else
  SERVER=${1}:${2}
fi
DELAY=1

echo "Testing $SERVER for support of SSL3.0 ..."

result=`echo -n | openssl s_client -connect $SERVER -ssl3 2>&1`
if [[ "$result" =~ "New, TLSv1/SSLv3, Cipher is" ]] ; then
  echo "YES - SSL 3.0 support detected on $SERVER"
  exit 1
else
  if [[ "$result" =~ ":error:" ]] ; then
    error=`echo -n $result | cut -d':' -f6`
    echo NO SSL 3.0 support detected on $SERVER \($error\)
    exit 0
  else
    echo "ERROR:  UNKNOWN RESPONSE: $result"
    exit 255
  fi
fi

