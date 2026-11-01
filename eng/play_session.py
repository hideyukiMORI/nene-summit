#!/usr/bin/env python3
"""PTY で nene-summit を起動し、画面が出てから q で終了することを見る。

リサイズと終了後の termios 復元は見ていない。TERM-001 の全体ではない。
"""

import os
import pty
import select
import sys
import time


def main() -> int:
    binary = sys.argv[1] if len(sys.argv) > 1 else ".build/debug/nene-summit"
    if not os.path.isfile(binary):
        print(f"play: {binary} が無い", file=sys.stderr)
        return 1
    pid, master = pty.fork()
    if pid == 0:
        os.execv(binary, [binary])
        return 1
    return watch(pid, master)


def watch(pid: int, master: int) -> int:
    deadline = time.monotonic() + 5
    seen = False
    sent = False
    status: int | None = None
    while time.monotonic() < deadline:
        status = reap(pid, status)
        if status is not None and sent:
            break
        readable, _, _ = select.select([master], [], [], 0.1)
        if master in readable:
            chunk = read_some(master)
            if chunk is None:
                break
            if chunk and not sent:
                seen = True
                os.write(master, b"q")
                sent = True
    drain(master)
    status = reap(pid, status, blocking=True)
    os.close(master)
    code = os.waitstatus_to_exitcode(status if status is not None else 1)
    if not seen:
        print("play: 画面が出る前に終わった", file=sys.stderr)
        return 1
    if code != 0:
        print(f"play: 終了コード {code}", file=sys.stderr)
        return 1
    print("play: 起動して q で終了コード 0")
    return 0


def read_some(master: int) -> bytes | None:
    try:
        return os.read(master, 4096)
    except OSError:
        return None


def drain(master: int) -> None:
    while True:
        readable, _, _ = select.select([master], [], [], 0.1)
        if master not in readable:
            return
        chunk = read_some(master)
        if not chunk:
            return


def reap(pid: int, status: int | None, blocking: bool = False) -> int | None:
    if status is not None:
        return status
    flags = 0 if blocking else os.WNOHANG
    done, found = os.waitpid(pid, flags)
    if done == 0:
        return None
    return found


if __name__ == "__main__":
    sys.exit(main())
