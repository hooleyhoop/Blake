FasdUAS 1.101.10   ��   ��    k             l     ��  ��    5 /getCountOfRowsInTable("InAppTests", "Untitled")     � 	 	 ^ g e t C o u n t O f R o w s I n T a b l e ( " I n A p p T e s t s " ,   " U n t i t l e d " )   
  
 l         I     �� ���� &0 selectrowsintable selectRowsInTable      m       �    I n A p p T e s t s      m       �    U n t i t l e d   ��  m    ���� ��  ��      first index is 1     �   "   f i r s t   i n d e x   i s   1      l     ��������  ��  ��        l     ��  ��     move mouse [1527, 59]     �     * m o v e   m o u s e   [ 1 5 2 7 ,   5 9 ]   ! " ! l     �� # $��   # $ click mouse [1527, 59] times 2    $ � % % < c l i c k   m o u s e   [ 1 5 2 7 ,   5 9 ]   t i m e s   2 "  & ' & i      ( ) ( I      �� *���� &0 selectrowsintable selectRowsInTable *  + , + o      ���� 0 appname appName ,  - . - o      ���� 0 windowtitle windowTitle .  /�� / o      ���� 0 rowindex rowIndex��  ��   ) k     S 0 0  1 2 1 l     ��������  ��  ��   2  3�� 3 O     S 4 5 4 O    R 6 7 6 k    Q 8 8  9 : 9 r     ; < ; m    ��
�� boovtrue < 1    ��
�� 
pisf :  = > = r     ? @ ? e     A A l    B���� B 5    �� C��
�� 
cwin C o    ���� 0 windowtitle windowTitle
�� kfrmname��  ��   @ o      ���� 0 win   >  D�� D O    Q E F E O    P G H G O   % O I J I k   , N K K  L M L r   , 4 N O N m   , -��
�� boovtrue O n       P Q P 1   1 3��
�� 
valL Q 4   - 1�� R
�� 
attr R m   / 0 S S � T T  A X F o c u s e d M  U V U l  5 5��������  ��  ��   V  W X W l  5 5�� Y Z��   Y < 6			set mumblemumble to the value of attribute "AXRows"    Z � [ [ l 	 	 	 s e t   m u m b l e m u m b l e   t o   t h e   v a l u e   o f   a t t r i b u t e   " A X R o w s " X  \ ] \ l  5 5�� ^ _��   ^ C =						set value of attribute "AXSelectedRows" to mumblemumble    _ � ` ` z 	 	 	 	 	 	 s e t   v a l u e   o f   a t t r i b u t e   " A X S e l e c t e d R o w s "   t o   m u m b l e m u m b l e ]  a b a l  5 5��������  ��  ��   b  c d c l  5 5��������  ��  ��   d  e f e l  5 5�� g h��   g # 				click at row 1's position    h � i i : 	 	 	 	 c l i c k   a t   r o w   1 ' s   p o s i t i o n f  j k j l  5 5�� l m��   l $ 	click row 2 with command down    m � n n < 	 c l i c k   r o w   2   w i t h   c o m m a n d   d o w n k  o p o l  5 5��������  ��  ��   p  q r q l  5 5�� s t��   s " return count of mumblemumble    t � u u 8 r e t u r n   c o u n t   o f   m u m b l e m u m b l e r  v w v l  5 5�� x y��   x $ Dangerous!						key down shift    y � z z < D a n g e r o u s ! 	 	 	 	 	 	 k e y   d o w n   s h i f t w  { | { l  5 5�� } ~��   } ( " set rowsToSelect to rows 1 thru 3    ~ �   D   s e t   r o w s T o S e l e c t   t o   r o w s   1   t h r u   3 |  � � � l  5 5�� � ���   � $ 	set selected of row 2 to true    � � � � < 	 s e t   s e l e c t e d   o f   r o w   2   t o   t r u e �  � � � l  5 5�� � ���   � $ 	set selected of row 3 to true    � � � � < 	 s e t   s e l e c t e d   o f   r o w   3   t o   t r u e �  � � � l  5 5�� � ���   �  	pick row 1    � � � �  	 p i c k   r o w   1 �  � � � l  5 5�� � ���   �  	pick row 2    � � � �  	 p i c k   r o w   2 �  � � � l  5 5�� � ���   �  			delay 0.2    � � � �  	 	 	 d e l a y   0 . 2 �  � � � l  5 5�� � ���   � " 			click at row 1's position    � � � � 8 	 	 	 c l i c k   a t   r o w   1 ' s   p o s i t i o n �  � � � l  5 5�� � ���   � " 			click at row 2's position    � � � � 8 	 	 	 c l i c k   a t   r o w   2 ' s   p o s i t i o n �  � � � l  5 5��������  ��  ��   �  � � � l  5 5��������  ��  ��   �  � � � l  5 5�� � ���   � . (		display dialog (count of rowsToSelect)    � � � � P 	 	 d i s p l a y   d i a l o g   ( c o u n t   o f   r o w s T o S e l e c t ) �  � � � l  5 5�� � ���   � 0 *		set the selected of rowsToSelect to true    � � � � T 	 	 s e t   t h e   s e l e c t e d   o f   r o w s T o S e l e c t   t o   t r u e �  � � � l  5 5�� � ���   � / )	set the selected items 1 to rowsToSelect    � � � � R 	 s e t   t h e   s e l e c t e d   i t e m s   1   t o   r o w s T o S e l e c t �  � � � l  5 5�� � ���   � > 8	set value of attribute "AXSelectedRows" to rowsToSelect    � � � � p 	 s e t   v a l u e   o f   a t t r i b u t e   " A X S e l e c t e d R o w s "   t o   r o w s T o S e l e c t �  � � � l  5 5�� � ���   �  		key up shift    � � � �  	 	 k e y   u p   s h i f t �  � � � l  5 5��������  ��  ��   �  � � � l  5 5�� � ���   � ' !	set  selected rows value to true    � � � � B 	 s e t     s e l e c t e d   r o w s   v a l u e   t o   t r u e �  � � � l  5 5�� � ���   �  keystroke shift down    � � � � ( k e y s t r o k e   s h i f t   d o w n �  � � � l  5 5�� � ���   �  delay 1    � � � �  d e l a y   1 �  � � � l  5 5�� � ���   �  		key down shift    � � � �   	 	 k e y   d o w n   s h i f t �  � � � l  5 5�� � ���   �  click row 1    � � � �  c l i c k   r o w   1 �  � � � l  5 5�� � ���   �  	click row 3    � � � �  	 c l i c k   r o w   3 �  � � � l  5 5��������  ��  ��   �  � � � l  5 5�� � ���   � C =		key code 125 using {command down, shift down} -- down arrow    � � � � z 	 	 k e y   c o d e   1 2 5   u s i n g   { c o m m a n d   d o w n ,   s h i f t   d o w n }   - -   d o w n   a r r o w �  � � � l  5 5�� � ���   � 5 /		key code 125 using {command down, shift down}    � � � � ^ 	 	 k e y   c o d e   1 2 5   u s i n g   { c o m m a n d   d o w n ,   s h i f t   d o w n } �  � � � l  5 5��������  ��  ��   �  � � � l  5 5�� � ���   �  						mouseClick position    � � � � 2 	 	 	 	 	 	 m o u s e C l i c k   p o s i t i o n �  � � � l  5 5��������  ��  ��   �  � � � O   5 L � � � k   < K � �  � � � r   < A � � � 1   < ?��
�� 
posn � o      ���� 0 thepos thePos �  � � � I  B I�� 
�� .EeEeeeEHnull���   @ long  o   B C���� 0 thepos thePos ����
�� 
x$$$ o   D E���� 0 thepos thePos��   �  l  J J��������  ��  ��    l  J J��������  ��  ��    l  J J��������  ��  ��   	
	 l  J J��������  ��  ��  
  l  J J��������  ��  ��    l  J J����   - '		click using(command down, shift down)    � N 	 	 c l i c k   u s i n g ( c o m m a n d   d o w n ,   s h i f t   d o w n ) �� l  J J����   4 .			set value of attribute "AXSelected" to true    � \ 	 	 	 s e t   v a l u e   o f   a t t r i b u t e   " A X S e l e c t e d "   t o   t r u e��   � 4   5 9��
�� 
crow m   7 8����  �  l  M M����    		tell row 2    �  	 	 t e l l   r o w   2  l  M M����   4 .			set value of attribute "AXSelected" to true    �   \ 	 	 	 s e t   v a l u e   o f   a t t r i b u t e   " A X S e l e c t e d "   t o   t r u e !"! l  M M��#$��  #  
		end tell   $ �%%  	 	 e n d   t e l l" &'& l  M M��()��  (  	key up shift   ) �**  	 k e y   u p   s h i f t' +��+ l  M M��������  ��  ��  ��   J 4   % )��,
�� 
tabB, m   ' (����  H 4    "�-
� 
scra- m     !�~�~  F o    �}�} 0 win  ��   7 4    �|.
�| 
prcs. o    �{�{ 0 appname appName 5 m     //�                                                                                  sevs  alis    v  Snow                       �1��H+    ,System Events.app                                               +��85G        ����  	                CoreServices    �1��      �8'7      ,   �   �  2Snow:System:Library:CoreServices:System Events.app  $  S y s t e m   E v e n t s . a p p  
  S n o w  -System/Library/CoreServices/System Events.app   / ��  ��   ' 010 l     �z�y�x�z  �y  �x  1 232 i    454 I      �w6�v�w $0 selectrowintable selectRowInTable6 787 o      �u�u 0 appname appName8 9:9 o      �t�t 0 windowtitle windowTitle: ;�s; o      �r�r 0 rowindex rowIndex�s  �v  5 k     B<< =>= l     �q�p�o�q  �p  �o  > ?�n? O     B@A@ O    ABCB k    @DD EFE r    GHG m    �m
�m boovtrueH 1    �l
�l 
pisfF IJI r    KLK e    MM l   N�k�jN 5    �iO�h
�i 
cwinO o    �g�g 0 windowtitle windowTitle
�h kfrmname�k  �j  L o      �f�f 0 win  J P�eP O    @QRQ O    ?STS O   % >UVU k   , =WW XYX r   , 4Z[Z m   , -�d
�d boovtrue[ n      \]\ 1   1 3�c
�c 
valL] 4   - 1�b^
�b 
attr^ m   / 0__ �``  A X F o c u s e dY a�aa I  5 =�`b�_
�` .miscslctuiel       uielb 4   5 9�^c
�^ 
crowc o   7 8�]�] 0 rowindex rowIndex�_  �a  V 4   % )�\d
�\ 
tabBd m   ' (�[�[ T 4    "�Ze
�Z 
scrae m     !�Y�Y R o    �X�X 0 win  �e  C 4    �Wf
�W 
prcsf o    �V�V 0 appname appNameA m     gg�                                                                                  sevs  alis    v  Snow                       �1��H+    ,System Events.app                                               +��85G        ����  	                CoreServices    �1��      �8'7      ,   �   �  2Snow:System:Library:CoreServices:System Events.app  $  S y s t e m   E v e n t s . a p p  
  S n o w  -System/Library/CoreServices/System Events.app   / ��  �n  3 hih l     �U�T�S�U  �T  �S  i j�Rj i    klk I      �Qm�P�Q .0 getcountofrowsintable getCountOfRowsInTablem non o      �O�O 0 appname appNameo p�Np o      �M�M 0 windowtitle windowTitle�N  �P  l k     @qq rsr l     �L�K�J�L  �K  �J  s t�It O     @uvu O    ?wxw k    >yy z{z r    |}| m    �H
�H boovtrue} 1    �G
�G 
pisf{ ~~ r    ��� e    �� l   ��F�E� 5    �D��C
�D 
cwin� o    �B�B 0 windowtitle windowTitle
�C kfrmname�F  �E  � o      �A�A 0 win   ��@� O    >��� O    =��� O   % <��� k   , ;�� ��� r   , 4��� l  , 2��?�>� n   , 2��� 1   0 2�=
�= 
valL� 4   , 0�<�
�< 
attr� m   . /�� ���  A X R o w s�?  �>  � o      �;�; 0 mumblemumble  � ��:� L   5 ;�� I  5 :�9��8
�9 .corecnte****       ****� o   5 6�7�7 0 mumblemumble  �8  �:  � 4   % )�6�
�6 
tabB� m   ' (�5�5 � 4    "�4�
�4 
scra� m     !�3�3 � o    �2�2 0 win  �@  x 4    �1�
�1 
prcs� o    �0�0 0 appname appNamev m     ���                                                                                  sevs  alis    v  Snow                       �1��H+    ,System Events.app                                               +��85G        ����  	                CoreServices    �1��      �8'7      ,   �   �  2Snow:System:Library:CoreServices:System Events.app  $  S y s t e m   E v e n t s . a p p  
  S n o w  -System/Library/CoreServices/System Events.app   / ��  �I  �R       �/������/  � �.�-�,�+�. &0 selectrowsintable selectRowsInTable�- $0 selectrowintable selectRowInTable�, .0 getcountofrowsintable getCountOfRowsInTable
�+ .aevtoappnull  �   � ****� �* )�)�(���'�* &0 selectrowsintable selectRowsInTable�) �&��& �  �%�$�#�% 0 appname appName�$ 0 windowtitle windowTitle�# 0 rowindex rowIndex�(  � �"�!� ���" 0 appname appName�! 0 windowtitle windowTitle�  0 rowindex rowIndex� 0 win  � 0 thepos thePos� /������� S�����
� 
prcs
� 
pisf
� 
cwin
� kfrmname
� 
scra
� 
tabB
� 
attr
� 
valL
� 
crow
� 
posn
� 
x$$$
� .EeEeeeEHnull���   @ long�' T� P*�/ He*�,FO*��0EE�O� 4*�k/ ,*�k/ $e*��/�,FO*�l/ *�,E�O��l OPUOPUUUUU� �5������ $0 selectrowintable selectRowInTable� ��� �  ���
� 0 appname appName� 0 windowtitle windowTitle�
 0 rowindex rowIndex�  � �	����	 0 appname appName� 0 windowtitle windowTitle� 0 rowindex rowIndex� 0 win  � g������ ��_������
� 
prcs
� 
pisf
� 
cwin
� kfrmname
� 
scra
�  
tabB
�� 
attr
�� 
valL
�� 
crow
�� .miscslctuiel       uiel� C� ?*�/ 7e*�,FO*��0EE�O� #*�k/ *�k/ e*��/�,FO*�/j UUUUU� ��l���������� .0 getcountofrowsintable getCountOfRowsInTable�� ����� �  ������ 0 appname appName�� 0 windowtitle windowTitle��  � ���������� 0 appname appName�� 0 windowtitle windowTitle�� 0 win  �� 0 mumblemumble  � ��������������������
�� 
prcs
�� 
pisf
�� 
cwin
�� kfrmname
�� 
scra
�� 
tabB
�� 
attr
�� 
valL
�� .corecnte****       ****�� A� =*�/ 5e*�,FO*��0EE�O� !*�k/ *�k/ *��/�,E�O�j 
UUUUU� �����������
�� .aevtoappnull  �   � ****� k     ��  
����  ��  ��  �  �   ������ �� &0 selectrowsintable selectRowsInTable�� 	*���m+ ascr  ��ޭ