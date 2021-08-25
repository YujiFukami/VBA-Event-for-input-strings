Attribute VB_Name = "ModEventAutoInput"
Option Explicit

'�P��o�^���Ȃ���P��̎������͂��s�����߂̃C�x���g�v���V�[�W��
'ModFile�ƈꏏ�Ɏg������

Const TextFileName$ = "�P��o�^.txt" '����������������������������������������������

Private Function ���̓Z���͈͎擾()
    
    Set ���̓Z���͈͎擾 = Sheet1.Range("B3:B50") '����������������������������������������������

End Function

Private Function �o�̓Z���͈͎擾()
    
    Set �o�̓Z���͈͎擾 = Sheet1.Range("C3:C50") '����������������������������������������������

End Function

Sub �Z���̒l�ύX���ɓo�^�P��o�͂ƒP��o�^(ByVal Target As Range) 'Worksheet_Change�v���V�[�W���Ŏ��s
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

