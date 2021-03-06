#!/bin/bash -eu
# Copyright 2018 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
################################################################################

./boot.sh && ./configure && make -j$(nproc)

for file in $SRC/*target.c; do
	b=$(basename $file _target.c)
	$CC $CFLAGS -c $file -I . -I lib/ -I include/ \
    -o $OUT/${b}_target.o
	$CXX $CXXFLAGS $OUT/${b}_target.o ./lib/.libs/libopenvswitch.a \
	-lz -lssl -lcrypto -latomic -lFuzzingEngine \
	-o $OUT/${b}_fuzzer
done
cp $SRC/*.dict $SRC/*.options $OUT/
wget -O $OUT/json.dict https://raw.githubusercontent.com/rc0r/afl-fuzz/master/dictionaries/json.dict
