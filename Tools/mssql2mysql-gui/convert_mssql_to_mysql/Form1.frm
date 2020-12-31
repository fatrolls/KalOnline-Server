VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   10935
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   11310
   LinkTopic       =   "Form1"
   ScaleHeight     =   10935
   ScaleWidth      =   11310
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox maxreccounter 
      Enabled         =   0   'False
      Height          =   285
      Left            =   1320
      TabIndex        =   25
      Top             =   4200
      Width           =   2295
   End
   Begin VB.TextBox reccounter 
      Enabled         =   0   'False
      Height          =   285
      Left            =   1320
      TabIndex        =   23
      Top             =   4560
      Width           =   2295
   End
   Begin VB.ComboBox Combo1 
      Height          =   315
      ItemData        =   "Form1.frx":0000
      Left            =   1320
      List            =   "Form1.frx":000A
      Style           =   2  'Dropdown List
      TabIndex        =   21
      Top             =   3720
      Width           =   2295
   End
   Begin VB.Timer Timer1 
      Enabled         =   0   'False
      Interval        =   1000
      Left            =   3120
      Top             =   3240
   End
   Begin VB.CheckBox dropdb 
      Height          =   255
      Left            =   1440
      TabIndex        =   17
      Top             =   3360
      Value           =   1  'Checked
      Width           =   495
   End
   Begin VB.TextBox dbname 
      Height          =   285
      Left            =   1320
      TabIndex        =   15
      Top             =   2880
      Width           =   2295
   End
   Begin VB.TextBox mysqlpass 
      Height          =   285
      Left            =   1320
      TabIndex        =   14
      Top             =   2160
      Width           =   2295
   End
   Begin VB.TextBox mysqllogin 
      Height          =   285
      Left            =   1320
      TabIndex        =   12
      Top             =   1800
      Width           =   2295
   End
   Begin VB.TextBox mysqlhost 
      Height          =   285
      Left            =   1320
      TabIndex        =   10
      Top             =   1440
      Width           =   2295
   End
   Begin VB.TextBox mssqlpass 
      Height          =   285
      Left            =   1320
      TabIndex        =   8
      Top             =   840
      Width           =   2295
   End
   Begin VB.TextBox mssqllogin 
      Height          =   285
      Left            =   1320
      TabIndex        =   6
      Top             =   480
      Width           =   2295
   End
   Begin VB.TextBox mssqlhost 
      Height          =   285
      Left            =   1320
      TabIndex        =   4
      Top             =   120
      Width           =   2295
   End
   Begin VB.TextBox Text1 
      Height          =   10935
      Left            =   3720
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   2
      Top             =   0
      Width           =   7575
   End
   Begin VB.CommandButton Command2 
      Caption         =   "&Quit"
      Height          =   2175
      Left            =   0
      TabIndex        =   1
      Top             =   8760
      Width           =   3615
   End
   Begin VB.CommandButton Command1 
      Caption         =   "&Start Conversion"
      Height          =   2055
      Left            =   0
      TabIndex        =   0
      Top             =   6600
      Width           =   3615
   End
   Begin VB.Label lbltabletime 
      Caption         =   "0:0:0"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   735
      Left            =   1560
      TabIndex        =   28
      Top             =   5040
      Width           =   2055
   End
   Begin VB.Label Label13 
      Caption         =   "Table Time Remain"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   495
      Left            =   120
      TabIndex        =   27
      Top             =   5040
      Width           =   1575
   End
   Begin VB.Label Label12 
      Caption         =   "Drop Database"
      Height          =   255
      Left            =   120
      TabIndex        =   26
      Top             =   3360
      Width           =   1455
   End
   Begin VB.Label Label11 
      Caption         =   "Record Count"
      Height          =   375
      Left            =   240
      TabIndex        =   24
      Top             =   4200
      Width           =   1695
   End
   Begin VB.Label Label10 
      Caption         =   "Current Count"
      Height          =   375
      Left            =   240
      TabIndex        =   22
      Top             =   4560
      Width           =   1695
   End
   Begin VB.Label Label9 
      Caption         =   "Verbosity"
      Height          =   375
      Left            =   120
      TabIndex        =   20
      Top             =   3720
      Width           =   1575
   End
   Begin VB.Label Label8 
      Caption         =   "Time Elapsed"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   495
      Left            =   120
      TabIndex        =   19
      Top             =   5880
      Width           =   1095
   End
   Begin VB.Label timeuse 
      Caption         =   "0:0:0"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   12
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   495
      Left            =   1560
      TabIndex        =   18
      Top             =   5880
      Width           =   2055
   End
   Begin VB.Label Label7 
      Caption         =   "DB Name"
      Height          =   255
      Left            =   120
      TabIndex        =   16
      Top             =   2880
      Width           =   1455
   End
   Begin VB.Label Label6 
      Caption         =   "MySQL Pass"
      Height          =   255
      Left            =   120
      TabIndex        =   13
      Top             =   2160
      Width           =   1455
   End
   Begin VB.Label Label5 
      Caption         =   "MySQL Login"
      Height          =   255
      Left            =   120
      TabIndex        =   11
      Top             =   1800
      Width           =   1455
   End
   Begin VB.Label Label4 
      Caption         =   "MySQL Server"
      Height          =   255
      Left            =   120
      TabIndex        =   9
      Top             =   1440
      Width           =   1455
   End
   Begin VB.Label Label3 
      Caption         =   "M$ SQL Pass"
      Height          =   255
      Left            =   120
      TabIndex        =   7
      Top             =   840
      Width           =   1455
   End
   Begin VB.Label Label2 
      Caption         =   "M$ SQL Login"
      Height          =   255
      Left            =   120
      TabIndex        =   5
      Top             =   480
      Width           =   1455
   End
   Begin VB.Label Label1 
      Caption         =   "M$ SQL Server"
      Height          =   255
      Left            =   120
      TabIndex        =   3
      Top             =   120
      Width           =   1455
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
' this program converts Microsoft SQL Server databases to MySQL databases

' (c) 2001 Michael Kofler
'     http://www.kofler.cc/mysql
'     mssql2mysql@kofler.cc

' LICENSE: GPL (Gnu Public License)
' VERSION: 0.06 (Apr. 8 2002)
'
' HISTORY:
' 0.01 (Jan. 18 2001): initial version
' 0.02 (June 23 2001): better handling of decimal numbers
'   by <dave.whitla@ocean.net.au>
' 0.03 (August 7 2001): compatibility with Office 97
'   by <DaveMeaker@angelshade.com>
'   (uncomment Replace function at the end of the script!)
' 0.04 (September 30 2001): slightly faster (ideas by
'    janivar@acos.no)
' 0.05 (April 8 2002): compatible with MyODBC 3.51
'    (set variable MyODBCVersion accordingly!)
'    thanks to Silvio Iaccarino
' 0.06 (August 22, 2002): Added GUI and output status code by Lee Leahu

' USEAGE:
' 1) copy this code into a new VBA 6 module
'    (i.e. start Excel 2000 or Word 2000 or another
'     program with VBA editor, hit Alt+F11, execute
'     Insert|Module, insert code)
'    OR copy code into an empty form of a new VB6 project
'
' 2) change the constants at the beginning of the code,
' 3) hit F5 and execute Main()
'    the program now connects to Microsoft SQL Server
'    and converts the database; the resulting SQL commands
'    are either saved in an ASCII file or executed immediately

' FUNCTION:
' converts both schema (tables and indices) and
' data (numbers, strings, dates etc.)
' handles table and column names which are not legal in MySQL (see MySQLName())

' LIMITATIONS:
' no foreign keys            (not yet supported by MySQL)
' no SPs, no triggers        (not yet supported by MySQL)
' no views                   (not yet supported by MySQL)
' no user defined data types (not yet supported by MySQL)
' AUTO_INCREMENTs: MySQL does not support tables with more
'   than one AUTO_INCREMENT column; the AUTO_INCREMENT column
'   must also be a key column; the converter does not check this,
'   so use MSSQL to add an index to the AUTO_INCREMENT column
'   before starting the conversion
' no privileges/access infos (the idea of logins/users in M$ SQL Server
'     is incompatible with user/group/database/table/column
'     privileges of MySQL)
' cannot handle ADO type adFileTime yet
' GUIDs not tested
' fairly slow and no visible feedback during conversion process
'   for example, it takes 80 seconds to convert Northwind (2.8 MB data)
'   with M$SQL running on PII 350 (CPU=0) and this script running in
'   Excel 2000 on PII 400 (CPU=100); unfortunately, compiling the program
'   with VB6 does not make it any faster
'   tip: test with MAX_RECORDS = 10 first to see if it works for you at all

' DATA:
' Unicode string can be converted either to ANSI strings or to BLOBs
' (Unicode --> BLOB is untested, though)

' INTERNALS:
' method:   read database schema using DMO
'           read data using a ADO recordset

' NECESSARY LIBRARIES:
'   ADODB  (tested with 2.5, should also run with all versions >=2.1)
'   MyODBC (testet with 2.50.36 and 3.51)
'   SQLDMO (tested with the version provided by M$ SQL Server 7 / MSDE 1)
'   SCRIPTING


Option Explicit

Option Compare Text

' -------------- change these constants before use!

                                  'M$ SQL Server
Const MSSQL_SECURE_LOGIN = False   'login type (True for NT security)

Const OUTPUT_TO_FILE = 0          '1 --> write file;
                                  '0 --> connect to MySQL, execute SQL commands directly
                                  
                                  'output file (only needed if OUTPUT_TO_FILE=1)
Const OUTPUT_FILENAME = "c:\export.sql"

 
Const MyODBCVersion = "MySQL"     'for MyODBC 2.51.*; if you use MyODBC 3.51*, use
                                  'this setting instead: "MySQL ODBC 3.51 Driver"

Const NEW_DB_NAME = ""            'name of new MySQL database ("" if same as M$SQL db name)
                                  'conversion options
Const UNICODE_TO_BLOB = False      'unicode --> BLOBs (True) or ASCII (False)
Public DROP_DATABASE As String         'begin with DROP dbname?
Const MAX_RECORDS = 0             'max. nr of records per table (0 for all records, n for testing purposes)


 Public MSSQL_LOGIN_NAME As String
 Public MSSQL_PASSWORD As String
 Public MSSQL_HOST As String
 Public MSSQL_DB_NAME As String
 Public MYSQL_USER_NAME As String
 Public MYSQL_PASSWORD As String
 Public MYSQL_HOST As String

' ----------------------------- don't change below here (unless you know what you are doing)

Const SQLDMOIndex_DRIPrimaryKey = 2048
Const SQLDMOIndex_Unique = 2
Const adEmpty = 0
Const adTinyInt = 16
Const adSmallInt = 2
Const adInteger = 3
Const adBigInt = 20
Const adUnsignedTinyInt = 17
Const adUnsignedSmallInt = 18
Const adUnsignedInt = 19
Const adUnsignedBigInt = 21
Const adSingle = 4
Const adDouble = 5
Const adCurrency = 6
Const adDecimal = 14
Const adNumeric = 131
Const adBoolean = 11
Const adError = 10
Const adUserDefined = 132
Const adVariant = 12
Const adIDispatch = 9
Const adIUnknown = 13
Const adGUID = 72
Const adDate = 7
Const adDBDate = 133
Const adDBTime = 134
Const adDBTimeStamp = 135
Const adBSTR = 8
Const adChar = 129
Const adVarChar = 200
Const adLongVarChar = 201
Const adWChar = 130
Const adVarWChar = 202
Const adLongVarWChar = 203
Const adBinary = 128
Const adVarBinary = 204
Const adLongVarBinary = 205
Const adChapter = 136
Const adFileTime = 64
Const adPropVariant = 138
Const adVarNumeric = 139
Const adArray = &H2000

Public timesecs As Integer
Public timemins As Integer
Public timehours As Integer


Public dmoApplic 'As New SQLDMO.Application  'SQLDMO Application object
Public dmoSrv    'As New SQLDMO.SQLServer    'SQLDMO Server object
Public mssqlConn 'As New Connection          'ADO Connection to M$ SQL Server
Public mysqlConn 'As New Connection          'ADO Connection to MySQL
Public fso       'As Scripting.FileSystemObject
Public fileout   'AS FSO.TextStream

Public Sub Main()
 
Timer1.Enabled = True

 
If dropdb.Value = 1 Then
    DROP_DATABASE = True
Else
    DROP_DATABASE = False
End If


timesecs = 0
timemins = 0
timehours = 0

 
 MSSQL_LOGIN_NAME = mssqllogin.Text 'login name (for NT security use "" here)
 MSSQL_PASSWORD = mssqlpass.Text         'password   (for NT security use "" here)
 MSSQL_HOST = mssqlhost.Text       'if localhost: use "(local)"
 MSSQL_DB_NAME = dbname.Text  'database name
                                 'connect to MySQL (only needed if OUTPUT_TO_FILE=0)
 MYSQL_USER_NAME = mysqllogin.Text     'login name
 MYSQL_PASSWORD = mysqlpass.Text    'password
 MYSQL_HOST = mysqlhost.Text    'if localhost: use "localhost"
  
  
  Set dmoApplic = CreateObject("SQLDMO.Application")
  Set dmoSrv = CreateObject("SQLDMO.SQLServer")
  Set mssqlConn = CreateObject("ADODB.Connection")
  Set mysqlConn = CreateObject("ADODB.Connection")
  Set fso = CreateObject("Scripting.FileSystemObject")
  
  
  
  mssqllogin.Enabled = False
  mssqlpass.Enabled = False
  mssqlhost.Enabled = False
  mysqlhost.Enabled = False
  mysqlpass.Enabled = False
  mysqllogin.Enabled = False
  
  Combo1.Enabled = False
  
  reccounter.Enabled = False
  maxreccounter.Enabled = False
  
  
  dbname.Enabled = False
  dropdb.Enabled = False
    
  Text1.Text = Text1.Text & "connecting to database...." & vbCrLf
  Text1.SelStart = Len(Text1.Text)
  DoEvents
  ConnectToDatabases
  Text1.Text = Text1.Text & "converting database...." & vbCrLf
  Text1.SelStart = Len(Text1.Text)
  DoEvents
  ConvertDatabase
  Text1.Text = Text1.Text & "done" & vbCrLf
  Text1.SelStart = Len(Text1.Text)
  DoEvents
  
  Timer1.Enabled = False
  
End Sub

' connect to M$ SQL Server and MySQL
Private Sub ConnectToDatabases()
  dmoSrv.LoginTimeout = 10
  On Error Resume Next
  
  ' DMO connection to M$ SQL Server
  If MSSQL_SECURE_LOGIN Then
    dmoSrv.LoginSecure = True
    dmoSrv.Connect MSSQL_HOST
  Else
    dmoSrv.LoginSecure = False
    dmoSrv.Connect MSSQL_HOST, MSSQL_LOGIN_NAME, MSSQL_PASSWORD
  End If
  If Err Then
    MsgBox "Sorry, cannot connect to M$ SQL Server. " & _
      "Please edit the MSSQL constats at the beginning " & _
      "of the code." & vbCrLf & vbCrLf & Error
    End
  End If
  
  ' ADO connection to M$ SQL Server
  Dim tmpCStr$
  tmpCStr = _
    "Provider=SQLOLEDB;" & _
    "Data Source=" & MSSQL_HOST & ";" & _
    "Initial Catalog=" & MSSQL_DB_NAME & ";"
  If MSSQL_SECURE_LOGIN Then
    tmpCStr = tmpCStr & "Integrated Security=SSPI"
  Else
    tmpCStr = tmpCStr & _
      "User ID=" & MSSQL_LOGIN_NAME & ";" & _
      "Password=" & MSSQL_PASSWORD
  End If
  mssqlConn.ConnectionString = tmpCStr
  mssqlConn.open
  If Err Then
    MsgBox "Sorry, cannot connect to M$ SQL Server. " & _
      "Please edit the MSSQL constats at the beginning " & _
      "of the code." & vbCrLf & vbCrLf & Error
    End
  End If
  
  ' ADO connection to MySQL or open output file
  If (OUTPUT_TO_FILE = 0) Then
    mysqlConn.ConnectionString = _
      "Provider=MSDASQL;" & _
      "Driver=" & MyODBCVersion & ";" & _
      "Server=" & MYSQL_HOST & ";" & _
      "UID=" & MYSQL_USER_NAME & ";" & _
      "PWD=" & MYSQL_PASSWORD
    mysqlConn.open
    If Err Then
      MsgBox "Sorry, cannot connect to MySQL. " & _
        "Please edit the MYSQL constats at the beginning " & _
        "of the code." & vbCrLf & vbCrLf & Error
      End
    End If
  Else
    Set fileout = fso.CreateTextFile(OUTPUT_FILENAME)
  End If
End Sub

Private Sub ConvertDatabase()
  ' copy database schema
  Dim dmoDB 'As SQLDMO.Database
  Set dmoDB = dmoSrv.Databases(MSSQL_DB_NAME)
  Text1.Text = Text1.Text & "dbdefinition....." & dmoDB.Name & "..." & vbCrLf
  Text1.SelStart = Len(Text1.Text)
  DoEvents
  DBDefinition dmoDB
  ' copy data
  Text1.Text = Text1.Text & "copydb......" & dmoDB.Name & "..." & vbCrLf
  Text1.SelStart = Len(Text1.Text)
  DoEvents
  CopyDB dmoDB
End Sub

' build SQL code to define one column
' ColDefinition$(col As SQLDMO.Column)
Function ColDefinition$(col)
  Dim cdef$
  cdef = MySQLName(col.Name) & " " & DataType(col)
  If col.Default <> "" Then
    cdef = cdef & " DEFAULT " & col.Default
  End If
  If col.AllowNulls Then
    cdef = cdef & " NULL"
  Else
    cdef = cdef & " NOT NULL"
  End If
  If col.Identity Then
    cdef = cdef & " AUTO_INCREMENT"
  End If
  ColDefinition = cdef
  
    If Combo1.Text >= 2 Then
      Text1.Text = Text1.Text & "col_definition....." & col.Name & "..." & vbCrLf
        Text1.SelStart = Len(Text1.Text)
    DoEvents
    End If
    
End Function

' datatype transition M$ SQL Server --> MySQL
' DataType$(col As SQLDMO.Column)
Function DataType$(col)
  Dim oldtype$, length&, precision&, scal&
  Dim newtype$
  
  oldtype = col.PhysicalDatatype
  length = col.length
  precision = col.NumericPrecision
  scal = col.NumericScale
  If LCase(oldtype) = "money" Then
    precision = 19
    scal = 4
  ElseIf LCase(oldtype) = "smallmoney" Then
    precision = 10
    scal = 4
  End If
  
  Select Case LCase(oldtype)
  
  ' integers
  Case "bit", "tinyint"
    newtype = "TINYINT"
  Case "smallint"
    newtype = "SMALLINT"
  Case "int"
    newtype = "INT"
  
  ' floating points
  Case "float"
    newtype = "DOUBLE"
  Case "real"
    newtype = "FLOAT"
  Case "decimal", "numeric", "money", "smallmoney"
    newtype = "DECIMAL(" & precision & ", " & scal & ")"
  
  ' strings
  Case "char"
    If length < 255 Then
      newtype = "CHAR(" & length & ")"
    Else
      newtype = "TEXT"
    End If
  Case "varchar"
    If length < 255 Then
      newtype = "VARCHAR(" & length & ")"
    Else
      newtype = "TEXT"
    End If
  Case "text"
    newtype = "LONGTEXT"
    
  ' unicode strings
  Case "nchar"
    If UNICODE_TO_BLOB Then
      newtype = "BLOB"
    Else
      If length <= 255 Then
        newtype = "CHAR(" & length & ")"
      Else
        newtype = "TEXT"
      End If
    End If
  Case "nvarchar"
    If UNICODE_TO_BLOB Then
      newtype = "BLOB"
    Else
      If length <= 255 Then
        newtype = "VARCHAR(" & length & ")"
      Else
        newtype = "TEXT"
      End If
    End If
  
  Case "ntext"
    If UNICODE_TO_BLOB Then
      newtype = "LONGBLOB"
    Else
      newtype = "LONGTEXT"
    End If
    
  ' date/time
  Case "datetime", "smalldatetime"
    newtype = "DATETIME"
  Case "timestamp"
    newtype = "TIMESTAMP"
    
  ' binary and other
  Case "uniqueidentifier"
    newtype = "TINYBLOB"
  Case "binary", "varbinary"
    newtype = "BLOB"
  Case "image"
    newtype = "LONGBLOB"
  
  Case Else
    Stop
  End Select
  
  DataType = newtype
  
  
End Function

' IndexDefinition$(tbl As SQLDMO.Table, idx As SQLDMO.Index)
Function IndexDefinition$(tbl, idx)
  Dim i&
  Dim tmp$
  Dim col 'As SQLDMO.Column
  ' don't deal with system indices (used i.e. to ensure ref. integr.)
  If Left$(idx.Name, 1) = "_" Then Exit Function
  ' index type (very incomplete !!!)
  If idx.Type And SQLDMOIndex_DRIPrimaryKey Then
    tmp = tmp & "PRIMARY KEY"
  ElseIf idx.Type And SQLDMOIndex_Unique Then
    tmp = tmp & "UNIQUE " & MySQLName(idx.Name)
  Else
    tmp = tmp & "INDEX " & MySQLName(idx.Name)
  End If
  ' index columns
  tmp = tmp & "("
  
    Text1.Text = Text1.Text & vbCrLf
      Text1.SelStart = Len(Text1.Text)
DoEvents
  
  For i = 1 To idx.ListIndexedColumns.Count
    Set col = idx.ListIndexedColumns(i)
    tmp = tmp & MySQLName(col.Name)
    ' specify index length
    If (col.PhysicalDatatype = "nchar" Or col.PhysicalDatatype = "nvarchar" Or col.PhysicalDatatype = "ntext") And UNICODE_TO_BLOB = True Then
      ' 2 byte per unicode char!
      tmp = tmp & "(" & IIf(col.length * 2 < 255, col.length * 2, 255) & ")"
    ElseIf Right$(DataType(col), 4) = "BLOB" Or Right$(DataType(col), 4) = "TEXT" Then
      tmp = tmp & "(" & IIf(col.length < 255, col.length, 255) & ")"
    End If
    ' seperate, if more than one index column
    If i < idx.ListIndexedColumns.Count Then tmp = tmp & ","
    
    Text1.Text = Text1.Text & "."
      Text1.SelStart = Len(Text1.Text)
DoEvents

  Next
  
    Text1.Text = Text1.Text & vbCrLf
      Text1.SelStart = Len(Text1.Text)
DoEvents
    
  tmp = tmp & ")"
  IndexDefinition = tmp
  
  Text1.Text = Text1.Text & "index_definition....." & idx.Name & "..." & vbCrLf
    Text1.SelStart = Len(Text1.Text)
DoEvents
  
End Function

' build SQL code to define one table
' TableDefinition$(tbl As SQLDMO.Table)
Function TableDefinition$(tbl)
  Dim i&
  Dim tmp$, ixdef$
  ' table
  tmp = "CREATE TABLE " & _
        NewDBName(tbl.Parent) & "." & MySQLName(tbl.Name) & vbCrLf & "("
  For i = 1 To tbl.Columns.Count
    tmp = tmp & ColDefinition(tbl.Columns(i))
    If i < tbl.Columns.Count Then
      tmp = tmp & ", " & vbCrLf
    End If
  Next
  ' indices
    
    Text1.Text = Text1.Text & vbCrLf
      Text1.SelStart = Len(Text1.Text)
DoEvents
    
  For i = 1 To tbl.Indexes.Count
    ixdef = IndexDefinition(tbl, tbl.Indexes(i))
    If ixdef <> "" Then
      tmp = tmp & ", " & vbCrLf & ixdef
    End If
    
        Text1.Text = Text1.Text & "."
      Text1.SelStart = Len(Text1.Text)
DoEvents
    
  Next
  
      Text1.Text = Text1.Text & vbCrLf
      Text1.SelStart = Len(Text1.Text)
DoEvents
    
  tmp = tmp & ")"
  TableDefinition = tmp
  
  Text1.Text = Text1.Text & "table_definition....." & tbl.Name & "..." & vbCrLf
   Text1.SelStart = Len(Text1.Text)
DoEvents
 
End Function

' build SQL code to define database (all tables)
' DBDefinition(db As SQLDMO.Database)
Sub DBDefinition(db)
  Dim i&
  Dim sql, dbname$
  dbname = NewDBName(db)
  If DROP_DATABASE Then
    sql = "DROP DATABASE IF EXISTS " & dbname
    ExecuteSQL sql
  End If
  sql = "CREATE DATABASE " & dbname
  ExecuteSQL sql
  Text1.Text = Text1.Text & vbCrLf
    Text1.SelStart = Len(Text1.Text)
DoEvents
  For i = 1 To db.Tables.Count
    If Not db.Tables(i).SystemObject Then
      sql = TableDefinition(db.Tables(i))
      ExecuteSQL sql
    End If
    Text1.Text = Text1.Text & "."
      Text1.SelStart = Len(Text1.Text)
DoEvents
  Next
  Text1.Text = Text1.Text & vbCrLf
    Text1.SelStart = Len(Text1.Text)
DoEvents
  
  Text1.Text = Text1.Text & "db_definition_func....." & db.Name & "..." & vbCrLf
    Text1.SelStart = Len(Text1.Text)
DoEvents
  
End Sub

' copy content of all M$ SQL Server tables to new MySQL database
' CopyDB(msdb As SQLDMO.Database)
Sub CopyDB(msdb)
  Dim i&
  Dim tmp$
  ExecuteSQL "USE " & NewDBName(msdb)
      Text1.Text = Text1.Text & vbCrLf
      Text1.SelStart = Len(Text1.Text)
        DoEvents
  For i = 1 To msdb.Tables.Count
    If Not msdb.Tables(i).SystemObject Then
      CopyTable msdb.Tables(i)
    End If
        Text1.Text = Text1.Text & "."
      Text1.SelStart = Len(Text1.Text)
DoEvents
  Next
      Text1.Text = Text1.Text & vbCrLf
      Text1.SelStart = Len(Text1.Text)
DoEvents
  
  Text1.Text = Text1.Text & "copy_db_func....." & msdb.Name & "..." & vbCrLf
    Text1.SelStart = Len(Text1.Text)
DoEvents
  
End Sub

' copy content of one table from M$ SQL Server to MySQL
' CopyTable(mstable As SQLDMO.Table)
Sub CopyTable(mstable)
    Dim reversal As Boolean
    reversal = False
    Dim reversalcount As Long
   Dim firstfield As String
   
   
  Dim rec ' As Recordset
  Dim rec2
  Dim sqlInsert$, sqlValues$
  Dim i&, recordCounter&
  Set rec = CreateObject("ADODB.Recordset")
  rec.open "SELECT * FROM [" & mstable.Name & "]", mssqlConn

    firstfield = rec.fields(0).Name
    
    Set rec2 = CreateObject("adodb.recordset")
    rec2.open "select count(" & firstfield & ") as counter from [" & mstable.Name & "]", mssqlConn
    
    maxreccounter = rec2.fields(0)

  ' build beginning statement of SQL INSERT command
  ' for example: INSERT INTO tablename (column1, column2)
  sqlInsert = "INSERT INTO " & MySQLName(mstable.Name) & " ("
  For i = 0 To rec.fields.Count - 1
    sqlInsert = sqlInsert & MySQLName(rec.fields(i).Name)
    If i <> rec.fields.Count - 1 Then
      sqlInsert = sqlInsert & ", "
    End If
  Next
  sqlInsert = sqlInsert & ") "
  ' for each recordset in M$SS table: build sql statement
      Text1.Text = Text1.Text & mstable.Name & vbCrLf
    Text1.SelStart = Len(Text1.Text)
       
DoEvents
  Do While Not rec.EOF
    sqlValues = ""
    For i = 0 To rec.fields.Count - 1
      sqlValues = sqlValues & DataValue(rec.fields(i))
      If i <> rec.fields.Count - 1 Then
        sqlValues = sqlValues & ", "
      End If
    Next
    ExecuteSQL sqlInsert & " VALUES(" & sqlValues & ")"
    rec.MoveNext
    ' counter
    recordCounter = recordCounter + 1
    If MAX_RECORDS <> 0 Then
      If recordCounter >= MAX_RECORDS Then Exit Do
    End If
        
      reversalcount = reversalcount + 1
      
        reccounter.Text = reversalcount
        
DoEvents
  Loop


  Text1.Text = Text1.Text & vbCrLf & "copy_table....." & mstable.Name & "..." & vbCrLf
    Text1.SelStart = Len(Text1.Text)
DoEvents
  
End Sub

' data transition M$ SQL Server --> MySQL
' DataValue$(fld As ADO.Field)
Function DataValue$(fld)
  If IsNull(fld.Value) Then
    DataValue = "NULL"
  Else

    Select Case fld.Type
    
    ' integer numbers
    Case adBigInt, adInteger, adSmallInt, adTinyInt, adUnsignedBigInt, adUnsignedInt, adUnsignedSmallInt, adUnsignedTinyInt
      DataValue = fld.Value
    
    ' decimal numbers
    Case adCurrency, adDecimal, adDouble, adNumeric, adSingle, adVarNumeric
      DataValue = Str(fld.Value)
      If Not InStr(DataValue, ".") > 0 Then
        DataValue = DataValue & ".0"
      End If
      
    ' boolean
    Case adBoolean
      DataValue = IIf(fld.Value, -1, 0)
      
    ' date, time
    Case adDate, adDBDate, adDBTime
      DataValue = Format(fld.Value, "'yyyy-mm-dd Hh:Nn:Ss'")
    Case adDBTimeStamp
      DataValue = Format(fld.Value, "yyyymmddHhNnSs")
    Case adFileTime
      ' todo
      Beep
      Stop
      
    ' ANSI strings
    Case adBSTR, adChar, adLongVarChar, adVarChar
      DataValue = "'" & Quote(fld.Value) & "'"
    
    ' UNICODE strings
    Case adLongVarWChar, adVarWChar, adWChar
      If UNICODE_TO_BLOB = True Then
        DataValue = HexCodeStr(fld.Value)
      Else
        ' we hope the string only contains ANSI characters ...
        DataValue = "'" & Quote(fld.Value) & "'"
      End If
    
    ' binary and other
    Case adGUID
      DataValue = HexCode(fld.Value)
    Case adLongVarBinary, adVarBinary
      DataValue = HexCode(fld.Value)
    
    End Select
  End If
  
End Function

' converts a Byte-array into a hex string
' HexCode$(bytedata() As Byte)
Function HexCode(bytedata)
  Dim i&
  Dim tmp$
  tmp = ""
  For i = LBound(bytedata) To UBound(bytedata)
    If bytedata(i) <= 15 Then
      tmp = tmp + "0" + Hex(bytedata(i))
    Else
      tmp = tmp + Hex(bytedata(i))
    End If
  Next
  HexCode = "0x" + tmp
End Function

' converts a String into a hex string
' HexCode$(bytedata() As Byte)
Function HexCodeStr(bytedata)
  Dim i&, b&
  Dim tmp$
  tmp = ""
  For i = 1 To LenB(bytedata)
    b = AscB(MidB(bytedata, i, 1))
    If b <= 15 Then
      tmp = tmp + "0" + Hex(b)
    Else
      tmp = tmp + Hex(b)
    End If
  Next
  HexCodeStr = "0x" + tmp
End Function

' returns name of new database
' NewDBName$(db As SQLDMO.Database)
Function NewDBName$(db)
  If NEW_DB_NAME = "" Then
    NewDBName = db.Name
  Else
    NewDBName = NEW_DB_NAME
  End If
End Function

' quote ' " and \; replace chr(0) by \0
Function Quote(tmp)
  tmp = Replace(tmp, "\", "\\")
  tmp = Replace(tmp, """", "\""")
  tmp = Replace(tmp, "'", "\'")
  Quote = Replace(tmp, Chr(0), "\0")
End Function

' to translate MSSQL names to legal MySQL names
' replace blank, -, ( and ) by '_'
Function MySQLName(tmp)
  tmp = Replace(tmp, " ", "_")
  tmp = Replace(tmp, "-", "_")
  tmp = Replace(tmp, "(", "_")
  MySQLName = Replace(tmp, ")", "_")
End Function

' either execute SQL command or write it into file
Function ExecuteSQL(sql)
    Dim clickval
    Dim errordata
    
  If OUTPUT_TO_FILE Then
    fileout.WriteLine sql & ";"
    If Left$(sql, 6) <> "INSERT" Then
      fileout.WriteLine
    End If
  Else
  
    On Error Resume Next
    
    mysqlConn.Execute sql
    
    While Err.Number <> 0
        errordata = Err.Description & vbCrLf & vbCrLf & sql
        clickval = MsgBox(errordata, vbOKCancel)
        If clickval = 2 Then End
    Wend
  End If
End Function



Private Sub Command1_Click()
    Main
    
End Sub

Private Sub Command2_Click()
    End
    
End Sub

' this event procedures starts the converter if it is run as a VB6 programm
Private Sub Form_Load()
    Combo1.Text = 1
    
  'Main
  'End
End Sub



' uncomment the following lines if you are using Office 97,
' which does not have the Replace function include; please
' note that this Replace function is much slower than the
' built-in version in Office 2000/VB6
'
' to replace all occurrences of a string within a string
' Function Replace(tmp, fromStr, toStr)
'     Dim leftOff&
'     Dim pos&
'     leftOff = 1
'     Do While InStr$(leftOff, tmp, fromStr) > 0
'         pos = InStr$(leftOff, tmp, fromStr)
'         tmp = Left$(tmp, pos - 1) + toStr + Mid$(tmp, pos + Len(fromStr), Len(tmp))
'         leftOff = pos + Len(fromStr) + 1
'     Loop
'     Replace = tmp
' End Function



Private Sub Timer1_Timer()
    
    Dim recleft
    Static lastrecs
    Dim timeleft
    
    Dim secsleft
    Dim minsleft
    Dim hoursleft
    
    If lastrecs = "" Then lastrecs = 0
    
    secsleft = 0
    minsleft = 0
    hoursleft = 0
    
    timesecs = timesecs + 1

    If timesecs = 60 Then
        timesecs = 0
        timemins = timemins + 1
    End If
    
    If timemins = 60 Then
        timemins = 0
        timehours = timehours + 1
    End If
    
    timeuse.Caption = timehours & ":" & timemins & ":" & timesecs
    
    If maxreccounter.Text <> "" And reccounter.Text <> "" Then
        recleft = maxreccounter.Text - reccounter.Text

        lastrecs = reccounter.Text - lastrecs
        
        timeleft = recleft / lastrecs
        
        secsleft = timeleft Mod 60
        timeleft = timeleft - secsleft
        
        timeleft = timeleft / 60
        minsleft = timeleft Mod 60
        timeleft = timeleft - minsleft
        
        hoursleft = timeleft Mod 60
     
        If secsleft >= 0 And minsleft >= 0 And hoursleft >= 0 Then
            lbltabletime.Caption = hoursleft & ":" & minsleft & ":" & secsleft
        End If
     
     End If
          
    
    lastrecs = reccounter.Text
        
End Sub
