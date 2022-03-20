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

    Programminglanguage: string;
    Ratings: string;
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
    ProgramData: TArray<TProgramData>;
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
  lbl_Mar2022.Caption := format('%d', [ProgramData[AIndex].Mar2022]);
  lbl_Mar2021.Caption := format('%d', [ProgramData[AIndex].Mar2021]);

  lbl_Ratings.Caption := format('%s%%', [ProgramData[AIndex].Ratings]);
  lbl_Change.Caption := format('%s%%', [ProgramData[AIndex].ChangePercent]);
  lbl_ProgramingName.Caption := ProgramData[AIndex].Programminglanguage;
  vimg_ProgramIcon.imageindex := ProgramData[AIndex].Key;

  if (ProgramData[AIndex].Change = 'down') then
    vimgChange.ImageIndex := 0
  else if (ProgramData[AIndex].Change = 'downdown') then
    vimgChange.ImageIndex := 1
  else if (ProgramData[AIndex].Change = 'up') then
    vimgChange.ImageIndex := 2
  else if (ProgramData[AIndex].Change = 'upup') then
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
  L := TStringList.Create;
  try
    TIOBE.loadfromfile('../../TIOBE.txt');
    //TIOBE.LoadfromFile(ExtractFilePath(ParamStr(0))+'data/TIOBE.txt');

    SetLength(ProgramData, 20);

    for i := 0 to Pred(Length(ProgramData)) do // 20-1
    begin
      Split('|', TIOBE.Strings[i], L);

      ProgramData[i].Key := i;

      ProgramData[i].Mar2022 := StrToInt(L.Strings[0]);
      ProgramData[i].Mar2021 := StrToInt(L.Strings[1]);
      ProgramData[i].Change := L.Strings[2];

      ProgramData[i].Programminglanguage := L.Strings[3];
      ProgramData[i].Ratings := L.Strings[4];
      ProgramData[i].ChangePercent := L.Strings[5];

    end;

  finally
    TIOBE.free;
    L.free;
  end;

  ControlList1.Enabled := False;
  ControlList1.ItemCount := Length(ProgramData);
  ControlList1.Enabled := True;
end;

end.
