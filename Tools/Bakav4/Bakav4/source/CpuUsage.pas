unit CpuUsage;

interface

uses
  Windows, SysUtils, Classes, Registry;

const
  PROCESS_OBJECT_INDEX = 230; // 'Process' object
  PROCESSOR_TIME_COUNTER_INDEX = 6; // '% processor time' counter
  PERF_NO_INSTANCES = -1;

type
  PPerfDataBlock = ^TPerfDataBlock;
  TPerfDataBlock = record
    Signature: array[0..3] of WChar;
    LittleEndian: DWord;
    Version: DWord;
    Revision: DWord;
    TotalByteLength: DWord;
    HeaderLength: DWord;
    NumObjectTypes: DWord;
    DefaultObject: Longint;
    SystemTime: TSystemTime;

    // It seams that there is an error in declaration
    // of this structure in Microsoft sources
    // This field added to correct it
    Reserved: DWord;
    PerfTime: TLargeInteger;
    PerfFreq: TLargeInteger;
    PerfTime100nSec: TLargeInteger;
    SystemNameLength: DWord;
    SystemNameOffset: DWord;
  end;

  PPerfObjectType = ^TPerfObjectType;
  TPerfObjectType = record
    TotalByteLength: DWord;
    DefinitionLength: DWord;
    HeaderLength: DWord;
    ObjectNameTitleIndex: DWord;
    ObjectNameTitle: LPWSTR;
    ObjectHelpTitleIndex: DWord;
    ObjectHelpTitle: LPWSTR;
    DetailLevel: DWord;
    NumCounters: DWord;
    DefaultCounter: Longint;
    NumInstances: Longint;
    CodePage: DWord;
    PerfTime: TLargeInteger;
    PerfFreq: TLargeInteger;
  end;

  PPerfCounterDefinition = ^TPerfCounterDefinition;
  TPerfCounterDefinition = record
    ByteLength: DWord;
    CounterNameTitleIndex: DWord;
    CounterNameTitle: LPWSTR;
    CounterHelpTitleIndex: DWord;
    CounterHelpTitle: LPWSTR;
    DefaultScale: Longint;
    DetailLevel: DWord;
    CounterType: DWord;
    CounterSize: DWord;
    CounterOffset: DWord;
  end;

  PPerfInstanceDefinition = ^TPerfInstanceDefinition;
  TPerfInstanceDefinition = record
    ByteLength: DWord;
    ParentObjectTitleIndex: DWord;
    ParentObjectInstance: DWord;
    UniqueID: Longint;
    NameOffset: DWord;
    NameLength: DWord;
  end;

  PPerfCounterBlock = ^TPerfCounterBlock;
  TPerfCounterBlock = record
    ByteLength: DWord;
  end;

type
  TCpuUsage = class
  private
    pPerfdata: PPerfDataBlock;
    BufferSize: cardinal;
    m_bFirstTime: boolean;
    m_lnOldValue: TLargeInteger;
    m_OldPerfTime100nSec: TLargeInteger;
    function GetCpuUsage(pProcessName: PChar): double;
    function GetCounterValue(pPerfObj: PPerfObjectType; dwCounterIndex: DWord;
      pInstanceName: PChar): TLargeInteger; overload;
    function GetCounterValue(dwObjectIndex: DWord; dwCounterIndex: DWord;
      pInstanceName: PChar = nil): TLargeInteger; overload;
    function EnablePerformanceCounters(bEnable: boolean = true): boolean;
    procedure QueryPerformanceData(dwObjectIndex: DWord; dwCounterIndex: DWord);
    function FirstObject(PerfData: PPerfDataBlock): PPerfObjectType;
    function NextObject(PerfObj: PPerfObjectType): PPerfObjectType;
    function FirstInstance(PerfObj: PPerfObjectType): PPerfInstanceDefinition;
    function NextInstance(PerfInst: PPerfInstanceDefinition):
      PPerfInstanceDefinition;
    function FirstCounter(PerfObj: PPerfObjectType): PPerfCounterDefinition;
    function NextCounter(PerfCntr: PPerfCounterDefinition):
      PPerfCounterDefinition;

  public
    property CpuUsage[ProcessName: PChar]: double read GetCpuUsage;
    constructor Create;
    destructor Destroy; override;
  end;

implementation

function GetPlatform: string;
var
  osvi: OSVERSIONINFO;
begin
  osvi.dwOSVersionInfoSize := sizeof(OSVERSIONINFO);
  if (not GetVersionEx(osvi)) then
    Result := 'UNKNOWN';
  case osvi.dwPlatformId of
    VER_PLATFORM_WIN32_WINDOWS:
      Result := 'WIN9X';
    VER_PLATFORM_WIN32_NT:
      if (osvi.dwMajorVersion = 4) then
        Result := 'WINNT'
      else
        Result := 'WIN2K_XP';
  else
    Result := 'UNKNOWN';
  end;
end;

constructor TCpuUsage.Create;
begin
  inherited Create;
  BufferSize := $2000;
  pPerfData := AllocMem(BufferSize);
  m_bFirstTime := true;
  m_lnOldValue := 0;
  m_OldPerfTime100nSec := 0;
end;

destructor TCpuUsage.Destroy;
begin
  Freemem(pPerfdata);
  inherited Destroy;
end;

function TCpuUsage.GetCpuUsage(pProcessName: PChar): double;
var
  CpuUsage: double;
  szInstance: PChar;
  lnNewValue: TLargeInteger;
  NewPerfTime100nSec: TLargeInteger;
  dwObjectIndex: DWord;
  dwCpuUsageIndex: DWord;
  lnValueDelta: TLargeInteger;
  DeltaPerfTime100nSec: TLargeInteger;
  a: double;
begin
  a := 0;
  DeltaPerfTime100nSec := 0;
  CpuUsage := 0;
  lnNewValue := 0;
  NewPerfTime100nSec := 0;

  if (m_bFirstTime) then
    EnablePerformanceCounters;

  szInstance := pProcessName;

  dwObjectIndex := PROCESS_OBJECT_INDEX;
  dwCpuUsageIndex := PROCESSOR_TIME_COUNTER_INDEX;
  lnNewValue := GetCounterValue(dwObjectIndex, dwCpuUsageIndex, szInstance);
  NewPerfTime100nSec := pPerfData.PerfTime100nSec;

  if (m_bFirstTime) then
  begin
    m_bFirstTime := false;
    m_lnOldValue := lnNewValue;
    m_OldPerfTime100nSec := NewPerfTime100nSec;
    result := 0;
    exit;
  end;
  
  try
  lnValueDelta := lnNewValue - m_lnOldValue;
  DeltaPerfTime100nSec := NewPerfTime100nSec - m_OldPerfTime100nSec;
  m_lnOldValue := lnNewValue;
  m_OldPerfTime100nSec := NewPerfTime100nSec;
  a := lnValueDelta / DeltaPerfTime100nSec;
  except a:=0; end;
  CpuUsage := a * 100;
  if (CpuUsage < 0) then
  begin
    result := 0;
    exit;
  end
  else
    result := CpuUsage;
end;

function TCpuUsage.EnablePerformanceCounters(bEnable: boolean = true): boolean;
var
  regKey: TRegistry;
begin
  regKey := TRegistry.Create;
  regKey.RootKey := HKEY_LOCAL_MACHINE;
  if GetPlatform <> 'WIN2K_XP' then
  begin
    Result := true;
    exit;
  end;

  if not
    regKey.OpenKey('SYSTEM\\CurrentControlSet\\Services\\PerfOS\\Performance',
    true) then
  begin
    Result := false;
    exit;
  end;

  regKey.WriteBool('Disable Performance Counters', not bEnable);
  regKey.CloseKey;

  if not
    regKey.OpenKey('SYSTEM\\CurrentControlSet\\Services\\PerfProc\\Performance',
    true) then
  begin
    Result := false;
    exit;
  end;

  regKey.WriteBool('Disable Performance Counters', not bEnable);
  regKey.CloseKey;
  Result := true;
end;

function TCpuUsage.GetCounterValue(pPerfObj: PPerfObjectType; dwCounterIndex:
  DWord;
  pInstanceName: PChar): TLargeInteger;
var
  pPerfCntr: PPerfCounterDefinition;
  pPerfInst: PPerfInstanceDefinition;
  pCounterBlock: PPerfCounterBlock;
  J: cardinal;
  K: cardinal;
  bstrInstance: string;
  bstrInputInstance: PChar;
  lnValue: PLargeInteger; //Pointer auf TLargeInteger
begin
  pPerfCntr := nil;
  pPerfInst := nil;
  pCounterBlock := nil;

  // Get the first counter.

  pPerfCntr := FirstCounter(pPerfObj);

  for j := 0 to pPerfObj.NumCounters - 1 do
  begin
    if pPerfCntr.CounterNameTitleIndex = dwCounterIndex then
      break;

    // Get the next counter.

    pPerfCntr := NextCounter(pPerfCntr);
  end;

  if pPerfObj.NumInstances = PERF_NO_INSTANCES then
    pCounterBlock := PPerfCounterBlock(DWord(pPerfObj) +
      pPerfObj.DefinitionLength)

  else
  begin
    pPerfInst := FirstInstance(pPerfObj);

    // Look for instance pInstanceName
    bstrInputInstance := pInstanceName;
    for k := 0 to pPerfObj.NumInstances - 1 do
    begin
      bstrInstance := WideCharToString(PWideChar(DWord(pPerfInst) +
        pPerfInst.NameOffset));

      //Bei Gleichheit liefert StrIComp 0 zurück
      if StrIComp(PChar(bstrInstance), bstrInputInstance) = 0 then
      begin
        pCounterBlock := PPerfCounterBlock(DWord(pPerfInst) +
          pPerfInst.ByteLength);
        break;
      end;

      // Get the next instance.

      pPerfInst := NextInstance(pPerfInst);
    end;
  end;

  if assigned(pCounterBlock) then
  begin
    lnValue := nil;
    lnValue := pointer(DWord(pCounterBlock) + pPerfCntr.CounterOffset);
    Result := lnValue^;
  end
  else
    Result := 0;
end;

function TCpuUsage.GetCounterValue(dwObjectIndex: DWord; dwCounterIndex: DWord;
  pInstanceName: PChar = nil): TLargeInteger;
var
  pPerfObj: PperfObjectType;
  I: cardinal;
  lnValue: TLargeInteger;
begin
  pPerfObj := nil;
  QueryPerformanceData(dwObjectIndex, dwCounterIndex);
  lnValue := 0;
  // Get the first object type.
  pPerfObj := FirstObject(pPerfData);

  // Look for the given object index

  for i := 0 to pPerfData.NumObjectTypes - 1 do
  begin

    if (pPerfObj.ObjectNameTitleIndex = dwObjectIndex) then
    begin
      lnValue := GetCounterValue(pPerfObj, dwCounterIndex, pInstanceName);
      break;
    end;

    pPerfObj := NextObject(pPerfObj);
  end;
  Result := lnValue;
end;

procedure TCpuUsage.QueryPerformanceData(dwObjectIndex: DWord; dwCounterIndex:
  DWord);
var
  BS: cardinal;
  KeyName: PChar;
begin
  KeyName := PChar(IntToStr(DWord(dwObjectIndex)));
  BS := BufferSize;
  while RegQueryValueEx(HKEY_PERFORMANCE_DATA,
    KeyName,
    nil,
    nil,
    Pointer(pPerfdata),
    @BS) = ERROR_MORE_DATA do
  begin
    {buffer is too small}
    INC(BufferSize, $1000);
    BS := BufferSize;
    ReallocMem(pPerfdata, BufferSize);
  end;
end;

function TCpuUsage.FirstObject(PerfData: PPerfDataBlock): PPerfObjectType;
begin
  Result := PPerfObjectType(DWord(PerfData) + PerfData.HeaderLength);
end;

function TCpuUsage.NextObject(PerfObj: PPerfObjectType): PPerfObjectType;
begin
  Result := PPerfObjectType(DWord(PerfObj) + PerfObj.TotalByteLength);
end;

function TCpuUsage.FirstInstance(PerfObj: PPerfObjectType):
  PPerfInstanceDefinition;
begin
  Result := PPerfInstanceDefinition(DWord(PerfObj) + PerfObj.DefinitionLength);
end;

function TCpuUsage.NextInstance(PerfInst: PPerfInstanceDefinition):
  PPerfInstanceDefinition;
var
  PerfCntrBlk: PPerfCounterBlock;
begin
  PerfCntrBlk := PPerfCounterBlock(DWord(PerfInst) + PerfInst.ByteLength);
  Result := PPerfInstanceDefinition(DWord(PerfCntrBlk) +
    PerfCntrBlk.ByteLength);
end;

function TCpuUsage.FirstCounter(PerfObj: PPerfObjectType):
  PPerfCounterDefinition;
begin
  Result := PPerfCounterDefinition(DWord(PerfObj) + PerfObj.HeaderLength);
end;

function TCpuUsage.NextCounter(PerfCntr: PPerfCounterDefinition):
  PPerfCounterDefinition;
begin
  Result := PPerfCounterDefinition(DWord(PerfCntr) + PerfCntr.ByteLength);
end;

end.