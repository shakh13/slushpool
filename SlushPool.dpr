program SlushPool;

uses
  System.StartUpCopy, WinApi.Windows,
  FMX.Platform.Win,
  FMX.Forms,
  Unit1 in 'Unit1.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  showWindow(ApplicationHWND, sw_hide);
  Application.CreateForm(TForm1, Form1);

  Application.Run;
end.
