program project1;
{ Skeleton Program for the AQA AS Summer 2018 examination
  this code should be used in conjunction with the Preliminary Material
  written by the AQA AS Programmer Team


   Version Number : 1.6
      }
{$APPTYPE CONSOLE}

uses
  SysUtils,
  StrUtils;

Const
  SPACE : Char = ' ';
  EOL : Char = '#';
  EMPTYSTRING : String = '';

Procedure ReportError(s : string);
begin
  writeln(Format('%0:-6s', ['*']), s, Format('%0:6s', ['*']));
end;

Function StripLeadingSpaces(Transmission : String) : String;
var
  TransmissionLength : Integer;
  FirstSignal : Char;
begin
  TransmissionLength := length(Transmission);
  if TransmissionLength > 0 then
    begin
      FirstSignal := Transmission[1];
      while (FirstSignal = SPACE) and (TransmissionLength > 0) do
        begin
          TransmissionLength := TransmissionLength - 1;
          Transmission := RightStr(Transmission, TransmissionLength);
          if TransmissionLength > 0 then
            FirstSignal := Transmission[1]
        end;
    end;
  if TransmissionLength = 0 then
    ReportError('No signal received');
  StripLeadingSpaces := Transmission;
end;

Function StripTrailingSpaces(Transmission : String) : String;
var
  LastChar : Integer;
begin
  LastChar := length(Transmission);
  while Transmission[LastChar] = SPACE do
    begin
      LastChar := LastChar - 1;
      Transmission := LeftStr(Transmission, LastChar);
    end;
  StripTrailingSpaces := Transmission
end;

Function GetTransmission() : String;
var
  FileName : String;
  FileHandle : Textfile;
  Transmission : String;
begin
  write('Enter file name: ');
  readln(FileName);
  try
    assign(FileHandle,FileName);
    reset(FileHandle);
    readln(FileHandle, Transmission);
    close(FileHandle);
    Transmission := StripLeadingSpaces(Transmission);
    if length(Transmission) > 0 then
      begin
        Transmission := StripTrailingSpaces(Transmission);
        Transmission := Transmission + EOL;
      end;
  except
    on E: exception do
      begin
        ReportError('No transmission found');
        Transmission := EMPTYSTRING;
      end;
  end ;
  GetTransmission := Transmission;
end;

Function GetNextSymbol(var i : Integer; Transmission : String) : String;
var
  Signal : Char;
  Symbol : String;
  SymbolLength : Integer;
begin
  if Transmission[i] = EOL then
    begin
      writeln;
      writeln('End of transmission');
      Symbol := EMPTYSTRING;
    end
  else
    begin
      SymbolLength := 0;
      Signal := Transmission[i];
      while (not(Signal = SPACE)) and (not(Signal = EOL)) do
        begin
          inc(i);
          Signal := Transmission [i];
          inc(SymbolLength);
        end;
      if SymbolLength = 1 then
        Symbol := '.'
      else if SymbolLength = 3 then
        Symbol := '-'
      else if SymbolLength = 0 then
        Symbol := SPACE
      else
        begin
          ReportError('Non-standard symbol received');
          Symbol := EMPTYSTRING;
        end;
    end;
    GetNextSymbol := Symbol;
end;

Function GetNextLetter(var i : Integer; Transmission : String): String;
var
  LetterEnd : Boolean;
  Symbol : String;
  SymbolString : String;
begin
  SymbolString := EMPTYSTRING;
  LetterEnd := False;
  while not(LetterEnd) do
    begin
      Symbol := GetNextSymbol(i, Transmission);
      if Symbol = SPACE then
        begin
          LetterEnd := True;
          i := i + 4;
        end
      else if Transmission[i] = EOL then
        LetterEnd := True
      else if (Transmission[i + 1] = SPACE) and (Transmission[i + 2] = SPACE) then
        begin
          LetterEnd := True;
          i := i + 3;
        end
      else
        i := i + 1;
      SymbolString := SymbolString + Symbol;
    end;
  GetNextLetter := SymbolString;
end;

Function Decode(CodedLetter : String; Dash : Array of Integer; Letter : Array of Char; Dot : Array of Integer) : String;
var
  CodedLetterLength, Pointer : Integer;
  Symbol : Char;
  i : Integer;
begin
  CodedLetterLength := length(CodedLetter);
  Pointer := 0;
  for i := 1 to CodedLetterLength do
    begin
      Symbol := CodedLetter[i];
      if Symbol = SPACE then
        Result := SPACE
      else
        begin
          if Symbol = '-' then
            Pointer := Dash[Pointer]
          else
            Pointer := Dot[Pointer];
          Result := Letter[Pointer];
        end;
    end;
  Decode := Result;
end;

Procedure ReceiveMorseCode(Dash : Array of Integer; Letter : Array of Char; Dot : Array of Integer);
var
  PlainText, MorseCodeString, Transmission , CodedLetter, PlainTextLetter : String;
  LastChar, i : Integer;
begin
  PlainText := EMPTYSTRING;
  MorseCodeString := EMPTYSTRING;
  Transmission := GetTransmission();
  LastChar := length(Transmission);
  i := 1;
  while i < LastChar do
    begin
      CodedLetter := GetNextLetter(i, Transmission);
      MorseCodeString := MorseCodeString + SPACE + CodedLetter;
      PlainTextLetter := Decode(CodedLetter, Dash, Letter, Dot);
      PlainText := PlainText + PlainTextLetter;
    end;
  writeln(MorseCodeString);
  writeln(PlainText);
end;

Procedure SendMorseCode(MorseCode : Array of String);
var
  PlainText, MorseCodeString, CodedLetter : String;
  PlainTextLength, i, Index : Integer;
  PlainTextLetter : Char;
begin
  write('Enter your message (uppercase letters and spaces only): ');
  readln(PlainText);
  PlainTextLength := length(PlainText);
  MorseCodeString := EMPTYSTRING;
  for i := 1 to PlainTextLength do
    begin
      PlainTextLetter := PlainText[i];
      if PlainTextLetter = SPACE then
        Index := 0
      else
        Index := ord(PlainTextLetter) - ord('A') + 1;
      CodedLetter := MorseCode[Index];
      MorseCodeString := MorseCodeString + CodedLetter + SPACE;
    end;
  writeln(MorseCodeString);
end;

Procedure DisplayMenu();
begin
  writeln;
  writeln('Main Menu');
  writeln('=========');
  writeln('R - Receive Morse code');
  writeln('S - Send Morse code');
  writeln('X - Exit program');
  writeln;
end;

Function GetMenuOption() : String;
var
  MenuOption : String;
begin
  MenuOption := EMPTYSTRING;
  while length(MenuOption) <> 1 do
    begin
      write('Enter your choice: ');
      readln(MenuOption);
    end;
  GetMenuOption := MenuOption;
end;

Procedure SendReceiveMessages();
const
  Dash: array[0..26] of Integer = (20,23,0,0,24,1,0,17,0,21,0,25,0,15,11,0,0,0,0,22,13,0,0,10,0,0,0);
  Dot : array[0..26] of Integer = (5,18,0,0,2,9,0,26,0,19,0,3,0,7,4,0,0,0,12,8,14,6,0,16,0,0,0);
  Letter : array[0..26] of Char= (' ','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z');
  MorseCode : array[0..26] of String= (' ','.-','-...','-.-.','-..','.','..-.','--.','....','..','.---','-.-','.-..','--','-.','---','.--.','--.-','.-.','...','-','..-','...-','.--','-..-','-.--','--..');
var
  ProgramEnd : Boolean;
  MenuOption : String;
begin
  ProgramEnd := False;
  while not(ProgramEnd) do
    begin
      DisplayMenu();
      MenuOption := GetMenuOption();
      if MenuOption = 'R' then
        ReceiveMorseCode(Dash, Letter, Dot)
      else if MenuOption = 'S' then
        SendMorseCode(MorseCode)
      else if MenuOption = 'X' then
        ProgramEnd := True;
    end;
end;


begin
  SendReceiveMessages();
  ReadLn;
end.


