
import sys

def pb(x, b):
    s = ''
    for _ in range(b):
        s += str(x % 2)
        x //= 2
    return s[::-1]

def toi(a):
    x = 0;
    print('>', a);
    for i in range(len(a)):
        x = x * 2 + int(a[i])
    return x

cc = -1

name = sys.argv[1]

with open(name + '.code', 'r') as fin:
    with open(name + '.data', 'w') as f:
        for l in fin:
            cc = cc + 1;
            a = l.split(' ')
            for i in range(1, len(a)):
                a[i] = a[i][0:-1]
            print(a)
            o = ''
            if a[0] == "ADDI":
                o += pb(int(a[3]), 12)
                o += pb(int(a[2][1:]), 5)
                o += pb(0b000, 3)
                o += pb(int(a[1][1:]), 5)
                o += pb(0b0010011, 7)
            elif a[0] == "ORI":
                o += pb(eval(a[3]), 12)
                o += pb(eval(a[2][1:]), 5)
                o += pb(0b110, 3)
                o += pb(eval(a[1][1:]), 5)
                o += pb(0b0010011, 7)
            elif a[0] == "JAL":
                print("a[2] = ", a[2])
                if (int(a[2]) >= 0):
                    o += pb(int(a[2])//2, 11)
                    o += pb(0, 9)
                    o += pb(int(a[1][1:]), 5)
                    o += pb(0b1101111, 7)
                else:
                    o += pb(-int(a[2])//2, 11)
                    oo = ''
                    for ii in range(11):
                        oo += '1' if o[ii] == '0' else '0';
                    o = str(bin(toi(oo)+1))[2:]
                    o += ('1'*9)
                    o += pb(int(a[1][1:]), 5)
                    o += pb(0b1101111, 7)
            elif a[0] == "JALR":
                if (int(a[3]) >= 0):
                    o += pb(int(a[3]), 12)
                    o += pb(int(a[2][1:]), 5)
                    o += pb(0b000, 3)
                    o += pb(int(a[1][1:]), 5)
                    o += pb(0b1100111, 7)
                else:
                    o += pb(-int(a[3]), 12)
                    oo = ''
                    for ii in range(12):
                        oo += '1' if o[ii] == '0' else '0';
                    o = str(bin(toi(oo)+1))[2:]
                    o += pb(int(a[2][1:]), 5)
                    o += pb(0b000, 3)
                    o += pb(int(a[1][1:]), 5)
                    o += pb(0b1100111, 7)
            elif a[0] == "LB":
                if (int(a[2]) >= 0):
                    o += pb(int(a[2]), 12)
                    o += pb(int(a[3][1:]), 5)
                    o += pb(0b000, 3)
                    o += pb(int(a[1][1:]), 5)
                    o += pb(0b0000011, 7)
            elif a[0] == "LW":
                if (int(a[2]) >= 0):
                    o += pb(int(a[2]), 12)
                    o += pb(int(a[3][1:]), 5)
                    o += pb(0b010, 3)
                    o += pb(int(a[1][1:]), 5)
                    o += pb(0b0000011, 7)
            elif a[0] == "LH":
                if (int(a[2]) >= 0):
                    o += pb(int(a[2]), 12)
                    o += pb(int(a[3][1:]), 5)
                    o += pb(0b001, 3)
                    o += pb(int(a[1][1:]), 5)
                    o += pb(0b0000011, 7)
            elif a[0] == "SB":
                if (int(a[2]) >= 0):
                    o += pb(int(a[2])>>5, 7)
                    o += pb(int(a[1][1:]), 5)
                    o += pb(int(a[3][1:]), 5)
                    o += pb(0b000, 3)
                    o += pb(int(a[2])&31, 5)
                    o += pb(0b0100011, 7)
            elif a[0] == "SW":
                if (int(a[2]) >= 0):
                    o += pb(int(a[2])>>5, 7)
                    o += pb(int(a[1][1:]), 5)
                    o += pb(int(a[3][1:]), 5)
                    o += pb(0b010, 3)
                    o += pb(int(a[2])&31, 5)
                    o += pb(0b0100011, 7)
            elif a[0] == "SH":
                if (int(a[2]) >= 0):
                    o += pb(int(a[2])>>5, 7)
                    o += pb(int(a[1][1:]), 5)
                    o += pb(int(a[3][1:]), 5)
                    o += pb(0b001, 3)
                    o += pb(int(a[2])&31, 5)
                    o += pb(0b0100011, 7)
            elif a[0] == "BLT":
                if (int(a[3]) >= 0):
                    o += pb(0, 7)
                    o += pb(int(a[2][1:]), 5)
                    o += pb(int(a[1][1:]), 5)
                    o += pb(0b100, 3)
                    o += pb(int(a[3]), 5)
                    o += pb(0b1100011, 7)
            elif a[0] == "BGE":
                if (int(a[3]) >= 0):
                    o += pb(0, 7)
                    o += pb(int(a[2][1:]), 5)
                    o += pb(int(a[1][1:]), 5)
                    o += pb(0b101, 3)
                    o += pb(int(a[3]), 5)
                    o += pb(0b1100011, 7)
            elif a[0] == "LUI":
                o += pb(int(a[2]), 20)
                o += pb(int(a[1][1:]), 5)
                o += pb(0b0110111, 7)
            print(len(o), o, str(hex(toi(o)))[2:])
            o = o[::-1]
            # print('32\'h' + str(hex(cc*4))[2:], ': rn_o <= 32\'h' + str(hex(toi(o)))[2:] + ';', file=f)
            for i in range(4):
                print(o[i*8:i*8+8][::-1], file=f)
