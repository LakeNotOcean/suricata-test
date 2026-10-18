import sys

# z85 (ZeroMQ Base-85) кодек — аналог zmq.utils.z85, без внешних зависимостей
# Использование: z85.py decode <код...> | encode <строка...> | decode-file <файл>

ALPHABET = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ.-:+=^!/*?&<>()[]{}@%$#"


def z85_encode(data):
    out = ""
    for i in range(0, len(data), 4):
        v = int.from_bytes(data[i:i + 4], "big")
        chars = ""
        for _ in range(5):
            chars = ALPHABET[v % 85] + chars
            v //= 85
        out += chars
    return out


def z85_decode(text):
    out = b""
    for i in range(0, len(text), 5):
        v = 0
        for ch in text[i:i + 5]:
            v = v * 85 + ALPHABET.index(ch)
        out += v.to_bytes(4, "big")
    return out


if len(sys.argv) < 3:
    sys.exit("Использование: z85.py decode <код...> | encode <строка...> | decode-file <файл>")

cmd, args = sys.argv[1], sys.argv[2:]
if cmd == "decode":
    for a in args:
        print(a, "->", z85_decode(a).decode(errors="replace"))
elif cmd == "encode":
    for a in args:
        b = a.encode()
        b += b"\x00" * (-len(b) % 4)
        print(a, "->", z85_encode(b))
elif cmd == "decode-file":
    for line in open(args[0]):
        line = line.strip()
        if not line:
            continue
        try:
            print(line, "->", z85_decode(line).decode("ascii"))
        except Exception:
            print(line, "-> (не z85)")
else:
    sys.exit(f"Неизвестная команда: {cmd}")
