Attribute VB_Name = "ModEventAutoInput"
Option Explicit

'EventAutoInput	���ꏊ�FFukamiAddins3.ModEventAutoInput
'���̓Z���͈͎擾	���ꏊ�FFukamiAddins3.ModEventAutoInput
'�o�̓Z���͈͎擾	���ꏊ�FFukamiAddins3.ModEventAutoInput
'���͒l����֘A���o��	���ꏊ�FFukamiAddins3.ModEventAutoInput
'InputText	���ꏊ�FFukamiAddins3.ModFile
'InputTextShiftJIS	���ꏊ�FFukamiAddins3.ModFile
'GetRowCountTextFile	���ꏊ�FFukamiAddins3.ModFile
'InputTextUTF8	���ꏊ�FFukamiAddins3.ModFile
'fncGetCharset	���ꏊ�FFukamiAddins3.ModFile
'�֘A���o�^	���ꏊ�FFukamiAddins3.ModEventAutoInput
'OutputText	���ꏊ�FFukamiAddins3.ModFile
'Lib���͔z��������p�ɕϊ�	���ꏊ�FFukamiAddins3.ModFile


'------------------------------


'�P��o�^���Ȃ���P��̎������͂��s�����߂̃C�x���g�v���V�[�W��
'ModFile�ƈꏏ�Ɏg������

Const TextFileName$ = "RegistStrings.txt" '����������������������������������������������

'------------------------------

'------------------------------


Sub EventAutoInput(ByVal Target As Range) 'Worksheet_Change�v���V�[�W���Ŏ��s
'�Z���̒l�ύX���ɓo�^�P��o�͂ƒP��o�^

    If VarType(Target.Value) >= vbArray Then
        '�ύX�Z���������̏ꍇ��1�Ԗڂ̃Z�������ΏۂƂ���B
        Set Target = Target(1)
    End If
    
    If Not Intersect(���̓Z���͈͎擾, Target) Is Nothing Then
        '�ύX�����Z�������̓Z���͈͂̏ꍇ
        Application.EnableEvents = False '�֘A���o�͌�̃C�x���g�������~
        Call ���͒l����֘A���o��(Target)
        Application.EnableEvents = True
    ElseIf Not Intersect(�o�̓Z���͈͎擾, Target) Is Nothing Then
        '�ύX�����Z�����o�̓Z���͈͂̏ꍇ
        Call �֘A���o�^(Target.Offset(0, -1).Value, Target.Value)
    End If
    
End Sub

Private Function ���̓Z���͈͎擾()
    
    Set ���̓Z���͈͎擾 = Sheet1.Range("B3:B50") '����������������������������������������������

End Function

Private Function �o�̓Z���͈͎擾()
    
    Set �o�̓Z���͈͎擾 = Sheet1.Range("C3:C50") '����������������������������������������������

End Function

Private Sub ���͒l����֘A���o��(TargetCell As Range)
    
    Dim InputValue$
    InputValue = TargetCell.Value
        
     '���͔͈͂Əo�͔͈͂���I�t�Z�b�g�ʌv�Z
    Dim InputStartCell As Range, OutputStartCell As Range
    Dim OffsetRow&, OffsetCol&
    Set InputStartCell = ���̓Z���͈͎擾(1)
    Set OutputStartCell = �o�̓Z���͈͎擾(1)
    OffsetRow = OutputStartCell.Row - InputStartCell.Row
    OffsetCol = OutputStartCell.Column - InputStartCell.Column
    
    If InputValue = "" Then
        TargetCell.Offset(OffsetRow, OffsetCol) = ""
        Exit Sub
    End If
    
    '�o�^�ς݂̊֘A�����e�L�X�g�t�@�C������ǂݍ���
    Dim TextList
    TextList = InputText(ThisWorkbook.Path & "\" & TextFileName, Chr(9))
    
    Dim KanrenStr$ '�֘A���
    Dim I%, J%, K%, M%, N% '�����グ�p(Integer�^)
    

    '�֘A���o��
    If UBound(TextList, 1) = 1 Then
        '�o�^�����P�ꂪ����Ȃ��ꍇ�͉������Ȃ�
    Else
        For I = 2 To UBound(TextList, 1)
            If InputValue = TextList(I, 1) Then
                KanrenStr = TextList(I, 2)
                Exit For
            End If
        Next I
        
        TargetCell.Offset(OffsetRow, OffsetCol).Value = KanrenStr
        
    End If
    
End Sub

Private Function InputText(FilePath$, Optional KugiriMoji$ = "")
'�e�L�X�g�t�@�C����ǂݍ���Ŕz��ŕԂ�
'�����R�[�h�͎����I�ɔ��肵�ēǍ��`����ύX����
'20210721

'FilePath�E�E�E�e�L�X�g�t�@�C���̃t���p�X
'KugiriMoji�E�E�E�e�L�X�g�t�@�C����ǂݍ���ŋ�؂蕶���ŋ�؂��Ĕz��ŏo�͂���ꍇ�̋�؂蕶��

    '�e�L�X�g�t�@�C���̑��݊m�F
    If Dir(FilePath, vbDirectory) = "" Then
        MsgBox ("�u" & FilePath & "�v" & vbLf & _
               "�̑��݂��m�F�ł��܂���B" & vbLf & _
               "�������I�����܂��B")
        End
    End If
    
    '�e�L�X�g�t�@�C���̕����R�[�h���擾
    Dim strCode
    strCode = fncGetCharset(FilePath)
    If strCode = "UTF-8 BOM" Or strCode = "UTF-8" Then
        strCode = "UTF-8"
    ElseIf strCode = "UTF-16 LE BOM" Or strCode = "UTF-16 BE BOM" Then
        strCode = "UTF-16LE"
    Else
        strCode = Empty
    End If
    
    '�e�L�X�g�t�@�C���Ǎ�
    Dim Output
    Dim RowCount&
    Dim I&, J&, K&, M&, N& '�����グ�p(Long�^)
    Dim FileNo%, Buffer$
    
    If IsEmpty(strCode) = False Then 'UTF8�ł̏ꍇ����������������������������������
   
        Output = InputTextUTF8(FilePath, KugiriMoji)
    
    Else 'Shift-JIS�ł̏ꍇ����������������������������������
        
        Output = InputTextShiftJIS(FilePath, KugiriMoji)
     
    End If

    InputText = Output
    
End Function

Private Function InputTextShiftJIS(FilePath$, Optional KugiriMoji$ = "")
'�e�L�X�g�t�@�C����ǂݍ��� ShiftJIS�`����p
'20210721

'FilePath�E�E�E�e�L�X�g�t�@�C���̃t���p�X
'KugiriMoji�E�E�E�e�L�X�g�t�@�C����ǂݍ���ŋ�؂蕶���ŋ�؂��Ĕz��ŏo�͂���ꍇ�̋�؂蕶��
    
    Dim I&, J&, K&, M&, N& '�����グ�p(Long�^)
    Dim FileNo%, Buffer$, SplitBuffer
    Dim Output1, Output2
    ' FreeFile�l�̎擾(�ȍ~���̒l�œ��o�͂���)
    FileNo = FreeFile
    
    N = GetRowCountTextFile(FilePath)
    ReDim Output1(1 To N)
    ' �w��t�@�C����OPEN(���̓��[�h)
    Open FilePath For Input As #FileNo
            
    ' �t�@�C����EOF(End of File)�܂ŌJ��Ԃ�
    I = 0
    M = 0
    Do Until EOF(FileNo)
        Line Input #FileNo, Buffer
        I = I + 1
        Output1(I) = Buffer '1���Ǎ���
        
        If KugiriMoji <> "" Then '�����ŋ�؂�ꍇ�͋�؂�����v�Z
            '��؂蕶���ɂ���؂���̍ő�l����ɍX�V���Ă���
            M = WorksheetFunction.Max(M, UBound(Split(Buffer, KugiriMoji)) + 1)
        End If
    Loop
    
    Close #FileNo
    
    '��؂蕶���̏���
    If KugiriMoji = "" Then
        '��؂蕶���Ȃ�
        Output2 = Output1
    Else
        ReDim Output2(1 To N, 1 To M)
        For I = 1 To N
            Buffer = Output1(I)
            SplitBuffer = Split(Buffer, KugiriMoji)
            For J = 0 To UBound(SplitBuffer)
                Output2(I, J + 1) = SplitBuffer(J)
            Next J
        Next I
    End If
    
    InputTextShiftJIS = Output2

End Function

Private Function GetRowCountTextFile(FilePath$)
'�e�L�X�g�t�@�C���ACSV�t�@�C���̍s�����擾����
'20210720

    '�t�@�C���̑��݊m�F
    If Dir(FilePath, vbDirectory) = "" Then
        MsgBox ("�u" & FilePath & "�v������܂���" & vbLf & _
                "�I�����܂�")
        End
    End If
    
    Dim Output&
    With CreateObject("Scripting.FileSystemObject")
        Output = .OpenTextFile(FilePath, 8).Line
    End With
    
    GetRowCountTextFile = Output
    
End Function

Private Function InputTextUTF8(FilePath$, Optional KugiriMoji$ = "")
'�e�L�X�g�t�@�C����ǂݍ��� UTF8�`����p
'20210721

'FilePath�E�E�E�e�L�X�g�t�@�C���̃t���p�X
'KugiriMoji�E�E�E�e�L�X�g�t�@�C����ǂݍ���ŋ�؂蕶���ŋ�؂��Ĕz��ŏo�͂���ꍇ�̋�؂蕶��

    Dim I&, J&, K&, M&, N& '�����グ�p(Long�^)
    Dim Buffer$, SplitBuffer
    Dim Output1, Output2
    
    N = GetRowCountTextFile(FilePath)
    ReDim Output1(1 To N)
    
    With CreateObject("ADODB.Stream")
        .Charset = "UTF-8"
        .Type = 2 ' �t�@�C���̃^�C�v(1:�o�C�i�� 2:�e�L�X�g)
        .Open
        .LineSeparator = 10 '���s�R�[�h
        .LoadFromFile (FilePath)
        
        For I = 1 To N
            Buffer = .ReadText(-2)
            Output1(I) = Buffer
            If KugiriMoji <> "" Then '�����ŋ�؂�ꍇ�͋�؂�����v�Z
                '��؂蕶���ɂ���؂���̍ő�l����ɍX�V���Ă���
                M = WorksheetFunction.Max(M, UBound(Split(Buffer, KugiriMoji)) + 1)
            End If
        Next I
        .Close
    End With
    
    '��؂蕶���̏���
    If KugiriMoji = "" Then
        '��؂蕶���Ȃ�
        Output2 = Output1
    Else
        ReDim Output2(1 To N, 1 To M)
        For I = 1 To N
            Buffer = Output1(I)
            SplitBuffer = Split(Buffer, KugiriMoji)
            For J = 0 To UBound(SplitBuffer)
                Output2(I, J + 1) = SplitBuffer(J)
            Next J
        Next I
    End If
    
    InputTextUTF8 = Output2
    
End Function

Private Function fncGetCharset(FileName As String) As String
'20200909�ǉ�
'�e�L�X�g�t�@�C���̕����R�[�h��Ԃ�
'�Q�lhttps://popozure.info/20190515/14201

    Dim I                   As Long
    
    Dim hdlFile             As Long
    Dim lngFileLen          As Long
    
    Dim bytFile()           As Byte
    Dim b1                  As Byte
    Dim b2                  As Byte
    Dim b3                  As Byte
    Dim b4                  As Byte
    
    Dim lngSJIS             As Long
    Dim lngUTF8             As Long
    Dim lngEUC              As Long
    
    On Error Resume Next
    
    '�t�@�C���ǂݍ���
    lngFileLen = FileLen(FileName)
    ReDim bytFile(lngFileLen)
    If (Err.Number <> 0) Then
        Exit Function
    End If
    
    hdlFile = FreeFile()
    Open FileName For Binary As #hdlFile
    Get #hdlFile, , bytFile
    Close #hdlFile
    If (Err.Number <> 0) Then
        Exit Function
    End If
    
    'BOM�ɂ�锻�f
    If (bytFile(0) = &HEF And bytFile(1) = &HBB And bytFile(2) = &HBF) Then
        fncGetCharset = "UTF-8 BOM"
        Exit Function
    ElseIf (bytFile(0) = &HFF And bytFile(1) = &HFE) Then
        fncGetCharset = "UTF-16 LE BOM"
        Exit Function
    ElseIf (bytFile(0) = &HFE And bytFile(1) = &HFF) Then
        fncGetCharset = "UTF-16 BE BOM"
        Exit Function
    End If
    
    'BINARY
    For I = 0 To lngFileLen - 1
        b1 = bytFile(I)
        If (b1 >= &H0 And b1 <= &H8) Or (b1 >= &HA And b1 <= &H9) Or (b1 >= &HB And b1 <= &HC) Or (b1 >= &HE And b1 <= &H19) Or (b1 >= &H1C And b1 <= &H1F) Or (b1 = &H7F) Then
            fncGetCharset = "BINARY"
            Exit Function
        End If
    Next I
           
    'SJIS
    For I = 0 To lngFileLen - 1
        b1 = bytFile(I)
        If (b1 = &H9) Or (b1 = &HA) Or (b1 = &HD) Or (b1 >= &H20 And b1 <= &H7E) Or (b1 >= &HB0 And b1 <= &HDF) Then
            lngSJIS = lngSJIS + 1
        Else
            If (I < lngFileLen - 2) Then
                b2 = bytFile(I + 1)
                If ((b1 >= &H81 And b1 <= &H9F) Or (b1 >= &HE0 And b1 <= &HFC)) And _
                   ((b2 >= &H40 And b2 <= &H7E) Or (b2 >= &H80 And b2 <= &HFC)) Then
                   lngSJIS = lngSJIS + 2
                   I = I + 1
                End If
            End If
        End If
    Next I
           
    'UTF-8
    For I = 0 To lngFileLen - 1
        b1 = bytFile(I)
        If (b1 = &H9) Or (b1 = &HA) Or (b1 = &HD) Or (b1 >= &H20 And b1 <= &H7E) Then
            lngUTF8 = lngUTF8 + 1
        Else
            If (I < lngFileLen - 2) Then
                b2 = bytFile(I + 1)
                If (b1 >= &HC2 And b1 <= &HDF) And (b2 >= &H80 And b2 <= &HBF) Then
                   lngUTF8 = lngUTF8 + 2
                   I = I + 1
                Else
                    If (I < lngFileLen - 3) Then
                        b3 = bytFile(I + 2)
                        If (b1 >= &HE0 And b1 <= &HEF) And (b2 >= &H80 And b2 <= &HBF) And (b3 >= &H80 And b3 <= &HBF) Then
                            lngUTF8 = lngUTF8 + 3
                            I = I + 2
                        Else
                            If (I < lngFileLen - 4) Then
                                b4 = bytFile(I + 3)
                                If (b1 >= &HF0 And b1 <= &HF7) And (b2 >= &H80 And b2 <= &HBF) And (b3 >= &H80 And b3 <= &HBF) And (b4 >= &H80 And b3 <= &HBF) Then
                                    lngUTF8 = lngUTF8 + 4
                                    I = I + 3
                                End If
                            End If
                        End If
                    End If
                End If
            End If
        End If
    Next I

    'EUC-JP
    For I = 0 To lngFileLen - 1
        b1 = bytFile(I)
        If (b1 = &H7) Or (b1 = 10) Or (b1 = 13) Or (b1 >= &H20 And b1 <= &H7E) Then
            lngEUC = lngEUC + 1
        Else
            If (I < lngFileLen - 2) Then
                b2 = bytFile(I + 1)
                If ((b1 >= &HA1 And b1 <= &HFE) And _
                   (b2 >= &HA1 And b2 <= &HFE)) Or _
                   ((b1 = &H8E) And (b2 >= &HA1 And b2 <= &HDF)) Then
                   lngEUC = lngEUC + 2
                   I = I + 1
                End If
            End If
        End If
    Next I
           
    '�����R�[�h�o�����ʂɂ�锻�f
    If (lngSJIS <= lngUTF8) And (lngEUC <= lngUTF8) Then
        fncGetCharset = "UTF-8"
        Exit Function
    End If
    If (lngUTF8 <= lngSJIS) And (lngEUC <= lngSJIS) Then
        fncGetCharset = "Shift_JIS"
        Exit Function
    End If
    If (lngUTF8 <= lngEUC) And (lngSJIS <= lngEUC) Then
        fncGetCharset = "EUC-JP"
        Exit Function
    End If
    fncGetCharset = ""
    
End Function

Private Sub �֘A���o�^(InputStr$, KanrenStr$)
    
    '�󔒂͓o�^���Ȃ�
    If KanrenStr = "" Or InputStr = "" Then Exit Sub
    
    Dim TextList
    TextList = InputText(ThisWorkbook.Path & "\" & TextFileName, Chr(9))
    
    Dim I%, J%, K%, M%, N% '�����グ�p(Integer�^)
    Dim OutputList
    Dim TorokuzumiNaraTrue As Boolean
    Dim TorokuZumiNum%
    If UBound(TextList, 1) = 1 Then
        '�ŏ�����o�^
        ReDim OutputList(1 To 2, 1 To 2)
        OutputList(1, 1) = "����"
        OutputList(1, 2) = "�֘A���"
        OutputList(2, 1) = InputStr
        OutputList(2, 2) = KanrenStr
        
    Else
        TorokuzumiNaraTrue = False
        For I = 2 To UBound(TextList, 1)
            '���ɓo�^�ς݂ł��邩�m�F
            If InputStr = TextList(I, 1) Then
                TorokuzumiNaraTrue = True
                TorokuZumiNum = I
                Exit For
            End If
        Next I
        
        If TorokuzumiNaraTrue Then
            OutputList = TextList
            
            If OutputList(TorokuZumiNum, 2) = KanrenStr Then
                '�o�^�ς݂������Ȃ̂ŉ������Ȃ�
                Exit Sub
            End If
            
            OutputList(TorokuZumiNum, 2) = KanrenStr '�o�^���ύX
        Else
            N = UBound(TextList, 1)
            ReDim OutputList(1 To N + 1, 1 To 2)
            For J = 1 To N
                OutputList(J, 1) = TextList(J, 1)
                OutputList(J, 2) = TextList(J, 2)
            Next J
            
            OutputList(N + 1, 1) = InputStr
            OutputList(N + 1, 2) = KanrenStr
        End If
                
    End If
    
    '�ҏW��̃e�L�X�g�f�[�^���o��
    Call OutputText(ThisWorkbook.Path, TextFileName, OutputList, Chr(9))
    
End Sub

Private Sub OutputText(FolderPath$, FileName$, ByVal OutputHairetu, Optional KugiriMoji$ = ",")
'�w��z���txt�ŏo�͂���
'20210721
   
'FolderPath�E�E�E�o�͐�̃t�H���_�p�X
'FileName�E�E�E�o�͂���t�@�C�����i�g���q�͂���j
'OutputHairetu�E�E�E�o�͂���z��
'KugiriMoji�E�E�E������Ԃ̋�؂蕶��

    Dim I%, J%, K%, M%, N% '�����グ�p(Integer�^)
    
    '1�����z���2�����z��ɕϊ�
    OutputHairetu = Lib���͔z��������p�ɕϊ�(OutputHairetu)
    
    N = UBound(OutputHairetu, 1)
    M = UBound(OutputHairetu, 2)
    Dim fp
    
    ' FreeFile�l�̎擾(�ȍ~���̒l�œ��o�͂���)
    fp = FreeFile
    ' �w��t�@�C����OPEN(�o�̓��[�h)
    Open FolderPath & "\" & FileName For Output As #fp
    ' �ŏI�s�܂ŌJ��Ԃ�
    
    For I = 1 To N
        For J = 1 To M - 1
            ' ���R�[�h���o��
            Print #fp, OutputHairetu(I, J) & KugiriMoji;
        Next J
        
        If I < N Then
            Print #fp, OutputHairetu(I, M)
        Else
            Print #fp, OutputHairetu(I, M);
        End If
    Next I
    ' �w��t�@�C����CLOSE
    Close fp

End Sub

Private Function Lib���͔z��������p�ɕϊ�(InputHairetu)
'���͂����z��������p�ɕϊ�����
'1�����z��2�����z��
'���l��������2�����z��(1,1)
'�v�f�̊J�n�ԍ���1�ɂ���
'20210721

    Dim Output
    Dim I%, J%, K%, M%, N% '�����グ�p(Integer�^)
    Dim Base1%, Base2%
    If IsArray(InputHairetu) = False Then
        '�z��łȂ��ꍇ(���l��������)
        ReDim Output(1 To 1, 1 To 1)
        Output(1, 1) = InputHairetu
    Else
        On Error Resume Next
        M = UBound(InputHairetu, 2)
        On Error GoTo 0
        If M = 0 Then
            '1�����z��
            Output = WorksheetFunction.Transpose(InputHairetu)
        Else
            '2�����z��
            Base1 = LBound(InputHairetu, 1)
            Base2 = LBound(InputHairetu, 2)
            
            If Base1 <> 1 Or Base2 <> 1 Then
                N = UBound(InputHairetu, 1)
                If N = Base1 Then
                    '(1,M)�z��
                    ReDim Output(1 To 1, 1 To M - Base2 + 1)
                    For I = 1 To M - Base2 + 1
                        Output(1, I) = InputHairetu(Base1, Base2 + I - 1)
                    Next I
                Else
                    Output = WorksheetFunction.Transpose(InputHairetu)
                    Output = WorksheetFunction.Transpose(Output)
                End If
            Else
                Output = InputHairetu
            End If
        End If
    End If
    
    Lib���͔z��������p�ɕϊ� = Output
    
End Function


