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
  TProgramData = record
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
    lbl_ProgramingName: TLabel;
    vimg_ProgramIcon: TVirtualImage;
    ControlListButton1: TControlListButton;
    ControlListButton2: TControlListButton;
    ImageCollection1: TImageCollection;
    vimgChange: TVirtualImage;
    ImageCollection2: TImageCollection;
    Label5: TLabel;
    Label6: TLabel;
    lbl_Mar2022: TLabel;
    lbl_Mar2021: TLabel;
    Label3: TLabel;
    lbl_Ratings: TLabel;
    lbl_Change: TLabel;
    Label9: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure ControlList1BeforeDrawItem(AIndex: Integer; ACanvas: TCanvas;
      ARect: TRect; AState: TOwnerDrawState);
  private
    { Private declarations }
    CovidData: TArray<TProgramData>;
    procedure Init;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
{ TForm1 }

procedure TForm1.ControlList1BeforeDrawItem(AIndex: Integer; ACanvas: TCanvas;
  ARect: TRect; AState: TOwnerDrawState);
begin

  lbl_Mar2022.Caption := format('%d', [CovidData[AIndex].Mar2022]);
  lbl_Mar2021.Caption := format('%d', [CovidData[AIndex].Mar2021]);

  lbl_Ratings.Caption := format('%s%%', [CovidData[AIndex].Ratings]);
  lbl_Change.Caption := format('%s%%', [CovidData[AIndex].ChangePercent]);
  lbl_ProgramingName.Caption := CovidData[AIndex].Programminlanguage;
  vimg_ProgramIcon.ImageIndex := CovidData[AIndex].Key;
  if (CovidData[AIndex].Change = 'down') then
    vimgChange.ImageIndex := 0
  else if (CovidData[AIndex].Change = 'downdown') then
    vimgChange.ImageIndex := 1
  else if (CovidData[AIndex].Change = 'up') then
    vimgChange.ImageIndex := 2
  else if (CovidData[AIndex].Change = 'upup') then
    vimgChange.ImageIndex := 3
  else
    vimgChange.ImageIndex := -1;
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  Init;
end;

procedure Split(Delimiter: Char; Str: string; ListOfStrings: TStrings);
begin
  ListOfStrings.Clear;
  ListOfStrings.Delimiter := Delimiter;
  ListOfStrings.StrictDelimiter := True;
  ListOfStrings.DelimitedText := Str;
end;

procedure TForm1.Init;
var
  TIOBE: TStrings;
  L: TStrings;
  i: Byte;
begin
  TIOBE := TStringList.Create;

  try
    TIOBE.LoadFromFile('../../TIOBE.txt');
    //TIOBE.LoadFromFile(extractfilepath(ParamStr(0)) + 'data\TIOBE.txt');

    SetLength(CovidData, 20);

    L := TStringList.Create;
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
  ControlList1.ItemCount := Length(CovidData);
  ControlList1.Enabled := True;
end;

end.
