# Tarantool EE Live Migrations

Playground for testing out Tarantool EE online DDL migrations.

Toolchain:
```
Tarantool Enterprise 3.0.0-0-gf58f7d82a-r23-gc64
Target: Linux-x86_64-RelWithDebInfo
Build options: cmake . -DCMAKE_INSTALL_PREFIX=/home/centos/release/sdk/tarantool/static-build/tarantool-prefix -DENABLE_BACKTRACE=TRUE
Compiler: GNU-9.3.1
C_FLAGS: -fexceptions -funwind-tables -fasynchronous-unwind-tables -static-libstdc++ -fno-common -msse2  -fmacro-prefix-map=/home/centos/release/sdk/tarantool=. -std=c11 -Wall -Wextra -Wno-gnu-alignof-expression -fno-gnu89-inline -Wno-cast-function-type -O2 -g -DNDEBUG -ggdb -O2 
CXX_FLAGS: -fexceptions -funwind-tables -fasynchronous-unwind-tables -static-libstdc++ -fno-common -msse2  -fmacro-prefix-map=/home/centos/release/sdk/tarantool=. -std=c++11 -Wall -Wextra -Wno-invalid-offsetof -Wno-gnu-alignof-expression -Wno-cast-function-type -O2 -g -DNDEBUG -ggdb -O2 
```

Startup:
```bash
tt run --name storage-a-001 --config tarantool.yaml
```

Run migration (with post-run cleanup):
```bash
tt run migrations/0x_<something>.lua
```
Use a separate ternimal to execute code on the `storage-a-001` server.
The numbers are just means to structure the code, they do not bear any meaning
like in tarantool/migrations.

If something went wrong:
- stop the server,
- `rm -rf ./var/lib/storage-a-001/*`,
- start the server anew.
