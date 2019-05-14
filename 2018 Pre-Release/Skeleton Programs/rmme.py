def BinaryEncode(Message):
    Bytes = []
    Current = 128
    Count = 0
    for Character in Message:
        print('considering Character \'' + Character + '\'')
        print('Count is', Count)
        print('Current is', Current)
        print('Bytes is', Bytes)
        if Current == 0.5:
            Bytes.append(int(Count))
            Count = 0
            Current = 128
        if Character == '=':
            Count += Current
        Current = Current / 2
    if Count != 0:
        Bytes.append(int(Count))
    return bytes(Bytes) # base10 -> base2 values

string_to_convert = '=       ==       '

print('converting', string_to_convert, 'to binary object')
print('=============')

print(BinaryEncode(string_to_convert))
