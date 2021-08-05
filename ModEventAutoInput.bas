Attribute VB_Name = "ModEventAutoInput"
Option Explicit

'�P��o�^���Ȃ���P��̎������͂��s�����߂̃C�x���g�v���V�[�W��
'�C�x���g�v���V�[�W���̓R�s�[���Ďg��

Const TextFileName$ = "�P��o�^.txt" '����������������������������������������������

Sub �Z���̒l�ύX���ɓo�^�P��o�͂ƒP��o�^() 'Worksheet_Change�v���V�[�W���ɒ��g�R�s�[
'�Z���̒l�ύX���ɓo�^�P��o�͂ƒP��o�^

    Dim InputCell As Range, OutputCell As Range '���͏o�̓Z��
    Set InputCell = ���̓Z���͈͎擾
    Set OutputCell = �o�̓Z���͈͎擾
    
    If VarType(Target.Value) >= vbArray Then Exit Sub
    
    If Not Intersect(InputCell, Target) Is Nothing Then
        Application.EnableEvents = False
        Call ���͒l����֘A���o��(Target, Target.Offset(0, 1)) '����������������������������������������������
        Application.EnableEvents = True
    ElseIf Not Intersect(OutputCell, Target) Is Nothing Then
        Call �֘A���o�^(Target.Offset(0, -1).Value, Target.Value)
    End If

End Sub

Function ���̓Z���͈͎擾()
    
    Set ���̓Z���͈͎擾 = Range("B3:B1000") '����������������������������������������������

End Function

Function �o�̓Z���͈͎擾()
    
    Set �o�̓Z���͈͎擾 = Range("C3:C1000") '����������������������������������������������

End Function

Sub ���͒l����֘A���o��(TargetCell As Range)
    
    Dim InputValue$
    InputValue = TargetCell.Value
        
    If InputValue = "" Then
        TargetCell.Offset(0, 1) = ""
        Exit Sub
    End If
        
    Dim TextList
    TextList = InputText(ThisWorkbook.Path & "\" & TextFileName, ",")
    
    Dim KanrenStr$ '�֘A���
    Dim I%, J%, K%, M%, N% '�����グ�p(Integer�^)
    
    If UBound(TextList, 1) = 1 Then
        '�������Ȃ�
    Else
        For I = 2 To UBound(TextList, 1)
            If InputValue = TextList(I, 1) Then
                KanrenStr = TextList(I, 2)
                Exit For
            End If
        Next I
        
        TargetCell.Offset(0, 1).Value = KanrenStr
        
    End If
    
End Sub

Sub �֘A���o�^(InputStr$, KanrenStr$)

    If KanrenStr = "" Or InputStr = "" Then Exit Sub
    
    Dim TextList
    TextList = InputText(ThisWorkbook.Path & "\" & TextFileName, ",")
    
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
    
    Call OutputText(ThisWorkbook.Path, TextFileName, OutputList, ",")
    
End Sub
