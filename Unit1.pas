unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MySQL,
  FireDAC.Phys.MySQLDef, FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.Client, Data.DB,
  FireDAC.Comp.DataSet, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    FDConnection1: TFDConnection;
    FDQuery1: TFDQuery;
    tsRead: TFDTransaction;
    tsWrite: TFDTransaction;
    Button1: TButton;
    Button2: TButton;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FDQuery1UpdateError(ASender: TDataSet; AException: EFDException;
      ARow: TFDDatSRow; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
    FErrorMsg: string;
  public
    { Public declarations }
    property ErrorMsg: String read FErrorMsg write FErrorMsg;
  end;

const
  DBMS_NAME = 'your_dbms_name';
  DBMS_USR = 'your_db_username';
  DBMS_PWD = 'your_db_password';

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  err: integer;
begin
  if FDQuery1.Active then
  begin
    FDQuery1.CheckBrowseMode;
    if FDQuery1.ChangeCount > 0 then
    begin
      err := FDQuery1.applyupdates(0);
      if err = 0 then
      begin
        try
          tsWrite.Commit;
        Except
          on e: exception do
          begin
            Showmessage(format('Error type:%s', ['Commit' + #10#13,
              e.Message]));
            tsWrite.Rollback;
          end;
        end;
      end
      else
      begin
        Showmessage(format('Error type: %sMessage: %s',
          ['Applyupdates' + #10#13, ErrorMsg]));
        FDQuery1.CancelUpdates;
      end;
    end;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  if FDQuery1.State in [dsInsert, dsEdit] then
    if FDQuery1.ChangeCount > 0 then
      FDQuery1.CancelUpdates;
end;

procedure TForm1.FDQuery1UpdateError(ASender: TDataSet;
  AException: EFDException; ARow: TFDDatSRow; ARequest: TFDUpdateRequest;
  var AAction: TFDErrorAction);
begin
  ErrorMsg := AException.Message;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FDConnection1.Params.Clear;
  FDConnection1.Params.Values['User_Name'] := DBMS_USR;
  FDConnection1.Params.Values['Password'] := DBMS_PWD;
  FDConnection1.Params.Values['Database'] := DBMS_NAME;
  FDConnection1.Params.Values['DriverID'] := 'MySql';
  FDConnection1.TxOptions.AutoStart := false;
  FDConnection1.TxOptions.AutoStop := false;
  FDConnection1.Connected := true;

  tsWrite.Connection := FDConnection1;
  FDConnection1.UpdateOptions.LockWait := false;
  tsWrite.Options.ReadOnly := false;
  tsWrite.Options.Isolation := xiReadCommitted;

  tsRead.Connection := FDConnection1;
  tsRead.Options.ReadOnly := true;
  tsRead.Options.Isolation := xiReadCommitted;

  FDQuery1.Transaction := tsRead;
  FDQuery1.UpdateTransaction := tsWrite;
  FDQuery1.Active := true;
end;

end.
