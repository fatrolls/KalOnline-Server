unit Quaternions;

interface

uses
  Math, Dialogs, SysUtils;


type
  TAxel = ( aX,aY,aZ );

  //Not used yet.. for future "Back to Euler" or something
  TEuler = class
  private
    pX:extended;
    pY:extended;
    pZ:extended;
  public
    property X:extended read pX write pX;
    property Y:extended read pY write pY;
    property Z:extended read pZ write pZ;
  end;

  TQuaternion = class
  private
    pX:extended;
    pY:extended;
    pZ:extended;
    pW:extended;
  public
    property X:extended read pX write pX;
    property Y:extended read pY write pY;
    property Z:extended read pZ write pZ;
    property W:extended read pW write pW;
    procedure FillWithDegree(Axel:TAxel;Degrees:extended);
    procedure Add(Q2:TQuaternion);
    //function BreakDown:TEuler;
  end;

implementation

procedure TQuaternion.FillWithDegree(Axel:TAxel;Degrees:extended);
begin
  Degrees:=Degrees/2;
  Case Axel of
    aX: Begin
          Self.W:=Cos(DegToRad(Degrees));
          Self.X:=1*Sin(DegToRad(Degrees));
          Self.Y:=0*Sin(DegToRad(Degrees));
          Self.Z:=0*Sin(DegToRad(Degrees));
        end;
    aY: Begin
          Self.W:=Cos(DegToRad(Degrees));
          Self.X:=0*Sin(DegToRad(Degrees));
          Self.Y:=1*Sin(DegToRad(Degrees));
          Self.Z:=0*Sin(DegToRad(Degrees));
        end;
    aZ: Begin
          Self.W:=Cos(DegToRad(Degrees));
          Self.X:=0*Sin(DegToRad(Degrees));
          Self.Y:=0*Sin(DegToRad(Degrees));
          Self.Z:=1*Sin(DegToRad(Degrees));
        end;
  end;
end;

procedure TQuaternion.Add(Q2:TQuaternion);
var
  Q1:TQuaternion;
begin
  //Setting Q1 with same values as current Quaternion
  Q1:=Self;

  //Multiplying it as _Varis_ explained (thank u sir)
  Self.W:=(Q1.W*Q2.W)-(Q1.X*Q2.X)-(Q1.Y*Q2.Y)-(Q1.Z*Q2.Z);
  Self.X:=(Q1.W*Q2.X)+(Q1.X*Q2.W)+(Q1.Y*Q2.Z)-(Q1.Z*Q2.Y);
  Self.Y:=(Q1.W*Q2.Y)-(Q1.X*Q2.Z)+(Q1.Y*Q2.W)+(Q1.Z*Q2.X);
  Self.Z:=(Q1.W*Q2.Z)+(Q1.X*Q2.Y)-(Q1.Y*Q2.X)+(Q1.Z*Q2.W);
end;

end.
