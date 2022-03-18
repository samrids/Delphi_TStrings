unit Unit2;

{
  Delphi: How to get data from TStrings
  This demo show you, How to get the data from TStrings then Split
  and show you how to work with TControlList
  Data source: https://www.tiobe.com/tiobe-index/:
}
interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.BaseImageCollection,
  Vcl.ImageCollection, Vcl.ControlList, Vcl.VirtualImage, Vcl.StdCtrls;

type
  TCovidData = record
    Key: Byte;

    Mar2022: Byte;
    Mar2021: Byte;
    Change: String;

    Programminlanguage: string;
    Ratings: String;
    ChangePercent: String;
  end;

  TForm1 = class(TForm)
    ControlList1: TControlList;
    Label1: TLabel;
    VirtualImage1: TVirtualImage;
    ControlListButton1: TControlListButton;
    ControlListButton2: TControlListButton;
    ImageCollection1: TImageCollection;
    VirtualImage2: TVirtualImage;
    ImageCollection2: TImageCollection;
    Label5: TLabel;
    Label6: TLabel;
    Label2: TLabel;
    Label7: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure ControlList1BeforeDrawItem(AIndex: Integer; ACanvas: TCanvas;
      ARect: TRect; AState: TOwnerDrawState);
  private
    { Private declarations }
    CovidData: TArray<TCovidData>;
    procedure Init;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses System.JSON;
{ TForm1 }

procedure TForm1.ControlList1BeforeDrawItem(AIndex: Integer; ACanvas: TCanvas;
  ARect: TRect; AState: TOwnerDrawState);
begin

  Label2.Caption := format('%d', [CovidData[AIndex].Mar2022]);
  Label7.Caption := format('%d', [CovidData[AIndex].Mar2021]);

  Label4.Caption := format('%s%%', [CovidData[AIndex].Ratings]);
  Label8.Caption := format('%s%%', [CovidData[AIndex].ChangePercent]);
  Label1.Caption := CovidData[AIndex].Programminlanguage;
  VirtualImage1.ImageIndex := CovidData[AIndex].Key;
  if (CovidData[AIndex].Change = 'down') then
    VirtualImage2.ImageIndex := 0
  else if (CovidData[AIndex].Change = 'downdown') then
    VirtualImage2.ImageIndex := 1
  else if (CovidData[AIndex].Change = 'up') then
    VirtualImage2.ImageIndex := 2
  else if (CovidData[AIndex].Change = 'upup') then
    VirtualImage2.ImageIndex := 3
  else
    VirtualImage2.ImageIndex := -1;
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  Init;
end;

procedure Split(Delimiter: Char; Str: string; ListOfStrings: TStrings);
begin
  ListOfStrings.Clear;
  ListOfStrings.Delimiter := Delimiter;
  ListOfStrings.StrictDelimiter := True; // Requires D2006 or newer.
  ListOfStrings.DelimitedText := Str;
end;

procedure TForm1.Init;
var
  TIOBE: TStrings;
  L: TStrings;
  i: Byte;
begin
  TIOBE := tstringlist.Create;

  try
    TIOBE.Add('1|3|up|Python|14.26|+3.95');
    TIOBE.Add('2|1|down|C|13.06|-2.27');
    TIOBE.Add('3|2|down|Java|11.19|+0.74');
    TIOBE.Add('4|4|-|C++|8.66|+2.14');
    TIOBE.Add('5|5|-|C#|5.92|+0.95');
    TIOBE.Add('6|6|-|Visual Basic|5.77|+0.91');
    TIOBE.Add('7|7|-|JavaScript|2.09|-0.03');
    TIOBE.Add('8|8|-|PHP|1.92|-0.15');
    TIOBE.Add('9|9|-|Assembly languageb|1.90|-0.07');
    TIOBE.Add('10|10|-|SQL|1.85|-0.02');
    TIOBE.Add('11|13|up|R|1.37|+0.12');
    TIOBE.Add('12|14|up|Delphi/Object|1.12|-0.07|');
    TIOBE.Add('13|11|down|Go|0.98|-0.33');
    TIOBE.Add('14|19|upup|Swift|0.90|-0.05');
    TIOBE.Add('15|18|up|MATLAB|0.80|-0.23');
    TIOBE.Add('16|16|-|Ruby|0.66|-0.52');
    TIOBE.Add('17|12|downdown|Classic Visual|0.60|-0.66');
    TIOBE.Add('18|20|up|Objective-C|0.59|-0.31');
    TIOBE.Add('19|17|down|Perl|0.57|-0.58');
    TIOBE.Add('20|38|upup|Lua|0.56|+0.23');

    SetLength(CovidData, 20);

    L := tstringlist.Create;
    for i := 0 to 19 do
    begin
      Split('|', TIOBE.Strings[i], L);

      CovidData[i].Key := i;

      CovidData[i].Mar2022 := StrToInt(L.Strings[0]);
      CovidData[i].Mar2021 := StrToInt(L.Strings[1]);
      CovidData[i].Change := L.Strings[2];

      CovidData[i].Programminlanguage := L.Strings[3];
      CovidData[i].Ratings := (L.Strings[4]);
      CovidData[i].ChangePercent := (L.Strings[5]);

    end;

  finally
    TIOBE.free;
  end;

  ControlList1.Enabled := False;
  ControlList1.ItemCount := 20;
  ControlList1.Enabled := True;
end;

end.
