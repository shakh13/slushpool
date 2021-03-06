unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,
  IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL,
  IdServerIOHandler, Json, Math, FMX.Effects;

type
  TForm1 = class(TForm)
    http: TIdHTTP;
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
    infoLabel: TLabel;
    flow: TFlowLayout;
    StyleBook1: TStyleBook;
    Timer1: TTimer;
    shadowEffect: TShadowEffect;
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const api_key = 'MUdJO6I0LkaUGI7m';

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.Timer1Timer(Sender: TObject);
var
  json: TJsonObject;
  ja: TJsonArray;
  btc: TJsonObject;
  username: String;

  hashrate: double;
  hr: string;

  confirmed, unconfirmed: String;
  i: integer;

  workerLabel: TLabel;
  cv: String;
  she: TShadowEffect;
begin
  try
  json := TJsonObject.Create;
  http.Request.CustomHeaders.Text := 'SlushPool-Auth-Token: ' + api_key;
  json := TJsonObject.ParseJSONValue(http.Get('https://slushpool.com/accounts/profile/json/btc/'), false, true) as TJsonObject;

  btc := TJsonObject.ParseJSONValue(json.GetValue('btc').ToString, false, true) as TJsonObject;

  username := json.GetValue('username').ToString.Remove(0, 1);
  username := username.Remove(username.Length - 1);

  hr := btc.GetValue('hash_rate_scoring').ToString;
  hr := hr.Remove(hr.IndexOf('.'));
  hashrate := Math.RoundTo(strToFloat(hr) / 1000, -2);

  confirmed := btc.GetValue('confirmed_reward').ToString.Remove(0, 1);
  confirmed := 'Confirmed: ' + confirmed.Remove(confirmed.Length - 1) + ' BTC';;

  unconfirmed := btc.GetValue('unconfirmed_reward').ToString.Remove(0, 1);
  unconfirmed := 'Unconfirmed: ' + unconfirmed.Remove(unconfirmed.Length - 1) + ' BTC';;


  infoLabel.Text := username + ': ' +floatToStr(hashrate) + ' TH' + #13 + unconfirmed + #13 + confirmed;


  http.Request.CustomHeaders.Text := 'SlushPool-Auth-Token: ' + api_key;
  json := TJsonObject.ParseJSONValue(http.Get('https://slushpool.com/accounts/workers/json/btc/'), false, true) as TJsonObject;

  json := TJsonObject.ParseJSONValue(json.GetValue('btc').ToString, false, true) as TJsonObject;
  json := json.FindValue('workers').AsType<TJsonObject>;

  flow.DeleteChildren;
  height := 58 + round(json.Count * 17);
  top := round(Screen.Height - height - 40);
  left := round(screen.Width - width);

  with json.GetEnumerator do
    while MoveNext do
      begin
        workerLabel := TLabel.Create(flow);
        workerLabel.Parent := flow;
        workerLabel.Width := flow.Width;
        workerLabel.TextAlign := TTextAlign.Center;
        cv := (Current.JsonValue as TJsonObject).Values['hash_rate_scoring'].Value;
        cv := cv.Remove(cv.IndexOf('.'));
        workerLabel.Text := Current.JsonString.Value.Remove(0, Current.JsonString.Value.IndexOf('.') + 1) + ': '
          + floatToStr(Math.RoundTo(cv.ToDouble / 1000, -2)) + ' TH '
          + (Current.JsonValue as TJsonObject).Values['state'].Value;

        she := TShadowEffect.Create(form1);
        she.Parent := workerLabel;
        she.Direction := 45;
        she.Distance := 2;
        she.Enabled := true;
        she.Opacity := 0.8;
        she.Softness := 0.1;
      end;
  except
    on e: exception do
      begin

      end;
  end;
  //infoLabel.Text := json.GetValue('username').ToString;
end;

end.
