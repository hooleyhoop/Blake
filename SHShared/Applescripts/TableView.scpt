FasdUAS 1.101.10   ��   ��    k             l     ��  ��    E ?getCountOfRowsInTable("InAppTests", "Untitled", "table1Scroll")     � 	 	 ~ g e t C o u n t O f R o w s I n T a b l e ( " I n A p p T e s t s " ,   " U n t i t l e d " ,   " t a b l e 1 S c r o l l " )   
  
 l     ��  ��    H BselectRowsInTable("InAppTests", "Untitled", 4) -- first index is 1     �   � s e l e c t R o w s I n T a b l e ( " I n A p p T e s t s " ,   " U n t i t l e d " ,   4 )   - -   f i r s t   i n d e x   i s   1      l     ��������  ��  ��        l     ��  ��     move mouse [1527, 59]     �   * m o v e   m o u s e   [ 1 5 2 7 ,   5 9 ]      l     ��  ��    $ click mouse [1527, 59] times 2     �   < c l i c k   m o u s e   [ 1 5 2 7 ,   5 9 ]   t i m e s   2      i         I      �� ���� &0 selectrowsintable selectRowsInTable     !   o      ���� 0 appname appName !  " # " o      ���� 0 windowtitle windowTitle #  $�� $ o      ���� 0 rowindex rowIndex��  ��    k     S % %  & ' & l     ��������  ��  ��   '  (�� ( O     S ) * ) O    R + , + k    Q - -  . / . r     0 1 0 m    ��
�� boovtrue 1 1    ��
�� 
pisf /  2 3 2 r     4 5 4 e     6 6 l    7���� 7 5    �� 8��
�� 
cwin 8 o    ���� 0 windowtitle windowTitle
�� kfrmname��  ��   5 o      ���� 0 win   3  9�� 9 O    Q : ; : O    P < = < O   % O > ? > k   , N @ @  A B A r   , 4 C D C m   , -��
�� boovtrue D n       E F E 1   1 3��
�� 
valL F 4   - 1�� G
�� 
attr G m   / 0 H H � I I  A X F o c u s e d B  J K J l  5 5��������  ��  ��   K  L M L l  5 5�� N O��   N < 6			set mumblemumble to the value of attribute "AXRows"    O � P P l 	 	 	 s e t   m u m b l e m u m b l e   t o   t h e   v a l u e   o f   a t t r i b u t e   " A X R o w s " M  Q R Q l  5 5�� S T��   S C =						set value of attribute "AXSelectedRows" to mumblemumble    T � U U z 	 	 	 	 	 	 s e t   v a l u e   o f   a t t r i b u t e   " A X S e l e c t e d R o w s "   t o   m u m b l e m u m b l e R  V W V l  5 5��������  ��  ��   W  X Y X l  5 5��������  ��  ��   Y  Z [ Z l  5 5�� \ ]��   \ # 				click at row 1's position    ] � ^ ^ : 	 	 	 	 c l i c k   a t   r o w   1 ' s   p o s i t i o n [  _ ` _ l  5 5�� a b��   a $ 	click row 2 with command down    b � c c < 	 c l i c k   r o w   2   w i t h   c o m m a n d   d o w n `  d e d l  5 5��������  ��  ��   e  f g f l  5 5�� h i��   h " return count of mumblemumble    i � j j 8 r e t u r n   c o u n t   o f   m u m b l e m u m b l e g  k l k l  5 5�� m n��   m $ Dangerous!						key down shift    n � o o < D a n g e r o u s ! 	 	 	 	 	 	 k e y   d o w n   s h i f t l  p q p l  5 5�� r s��   r ( " set rowsToSelect to rows 1 thru 3    s � t t D   s e t   r o w s T o S e l e c t   t o   r o w s   1   t h r u   3 q  u v u l  5 5�� w x��   w $ 	set selected of row 2 to true    x � y y < 	 s e t   s e l e c t e d   o f   r o w   2   t o   t r u e v  z { z l  5 5�� | }��   | $ 	set selected of row 3 to true    } � ~ ~ < 	 s e t   s e l e c t e d   o f   r o w   3   t o   t r u e {   �  l  5 5�� � ���   �  	pick row 1    � � � �  	 p i c k   r o w   1 �  � � � l  5 5�� � ���   �  	pick row 2    � � � �  	 p i c k   r o w   2 �  � � � l  5 5�� � ���   �  			delay 0.2    � � � �  	 	 	 d e l a y   0 . 2 �  � � � l  5 5�� � ���   � " 			click at row 1's position    � � � � 8 	 	 	 c l i c k   a t   r o w   1 ' s   p o s i t i o n �  � � � l  5 5�� � ���   � " 			click at row 2's position    � � � � 8 	 	 	 c l i c k   a t   r o w   2 ' s   p o s i t i o n �  � � � l  5 5��������  ��  ��   �  � � � l  5 5��������  ��  ��   �  � � � l  5 5�� � ���   � . (		display dialog (count of rowsToSelect)    � � � � P 	 	 d i s p l a y   d i a l o g   ( c o u n t   o f   r o w s T o S e l e c t ) �  � � � l  5 5�� � ���   � 0 *		set the selected of rowsToSelect to true    � � � � T 	 	 s e t   t h e   s e l e c t e d   o f   r o w s T o S e l e c t   t o   t r u e �  � � � l  5 5�� � ���   � / )	set the selected items 1 to rowsToSelect    � � � � R 	 s e t   t h e   s e l e c t e d   i t e m s   1   t o   r o w s T o S e l e c t �  � � � l  5 5�� � ���   � > 8	set value of attribute "AXSelectedRows" to rowsToSelect    � � � � p 	 s e t   v a l u e   o f   a t t r i b u t e   " A X S e l e c t e d R o w s "   t o   r o w s T o S e l e c t �  � � � l  5 5�� � ���   �  		key up shift    � � � �  	 	 k e y   u p   s h i f t �  � � � l  5 5��������  ��  ��   �  � � � l  5 5�� � ���   � ' !	set  selected rows value to true    � � � � B 	 s e t     s e l e c t e d   r o w s   v a l u e   t o   t r u e �  � � � l  5 5�� � ���   �  keystroke shift down    � � � � ( k e y s t r o k e   s h i f t   d o w n �  � � � l  5 5�� � ���   �  delay 1    � � � �  d e l a y   1 �  � � � l  5 5�� � ���   �  		key down shift    � � � �   	 	 k e y   d o w n   s h i f t �  � � � l  5 5�� � ���   �  click row 1    � � � �  c l i c k   r o w   1 �  � � � l  5 5�� � ���   �  	click row 3    � � � �  	 c l i c k   r o w   3 �  � � � l  5 5��������  ��  ��   �  � � � l  5 5�� � ���   � C =		key code 125 using {command down, shift down} -- down arrow    � � � � z 	 	 k e y   c o d e   1 2 5   u s i n g   { c o m m a n d   d o w n ,   s h i f t   d o w n }   - -   d o w n   a r r o w �  � � � l  5 5�� � ���   � 5 /		key code 125 using {command down, shift down}    � � � � ^ 	 	 k e y   c o d e   1 2 5   u s i n g   { c o m m a n d   d o w n ,   s h i f t   d o w n } �  � � � l  5 5��������  ��  ��   �  � � � l  5 5�� � ���   �  						mouseClick position    � � � � 2 	 	 	 	 	 	 m o u s e C l i c k   p o s i t i o n �  � � � l  5 5��������  ��  ��   �  � � � O   5 L � � � k   < K � �  � � � r   < A � � � 1   < ?��
�� 
posn � o      ���� 0 thepos thePos �  � � � I  B I�� � �
�� .EeEeeeEHnull���   @ long � o   B C���� 0 thepos thePos � �� ���
�� 
x$$$ � o   D E���� 0 thepos thePos��   �  � � � l  J J��������  ��  ��   �  � � � l  J J��������  ��  ��   �  � � � l  J J��������  ��  ��   �  � � � l  J J��������  ��  ��   �    l  J J��������  ��  ��    l  J J����   - '		click using(command down, shift down)    � N 	 	 c l i c k   u s i n g ( c o m m a n d   d o w n ,   s h i f t   d o w n ) �� l  J J��	��   4 .			set value of attribute "AXSelected" to true   	 �

 \ 	 	 	 s e t   v a l u e   o f   a t t r i b u t e   " A X S e l e c t e d "   t o   t r u e��   � 4   5 9��
�� 
crow m   7 8����  �  l  M M����    		tell row 2    �  	 	 t e l l   r o w   2  l  M M����   4 .			set value of attribute "AXSelected" to true    � \ 	 	 	 s e t   v a l u e   o f   a t t r i b u t e   " A X S e l e c t e d "   t o   t r u e  l  M M����    
		end tell    �  	 	 e n d   t e l l  l  M M����    	key up shift    �  	 k e y   u p   s h i f t  ��  l  M M��������  ��  ��  ��   ? 4   % )��!
�� 
tabB! m   ' (����  = 4    "��"
�� 
scra" m     !����  ; o    ���� 0 win  ��   , 4    �#
� 
prcs# o    �~�~ 0 appname appName * m     $$�                                                                                  sevs  alis    �  HooDisk1                   �1��H+   
�System Events.app                                               
���85G        ����  	                CoreServices    �1��      �8'7     
� 
%� 
%�  6HooDisk1:System:Library:CoreServices:System Events.app  $  S y s t e m   E v e n t s . a p p    H o o D i s k 1  -System/Library/CoreServices/System Events.app   / ��  ��    %&% l     �}�|�{�}  �|  �{  & '(' i    )*) I      �z+�y�z $0 selectrowintable selectRowInTable+ ,-, o      �x�x 0 appname appName- ./. o      �w�w 0 windowtitle windowTitle/ 0�v0 o      �u�u 0 rowindex rowIndex�v  �y  * k     B11 232 l     �t�s�r�t  �s  �r  3 4�q4 O     B565 O    A787 k    @99 :;: r    <=< m    �p
�p boovtrue= 1    �o
�o 
pisf; >?> r    @A@ e    BB l   C�n�mC 5    �lD�k
�l 
cwinD o    �j�j 0 windowtitle windowTitle
�k kfrmname�n  �m  A o      �i�i 0 win  ? E�hE O    @FGF O    ?HIH O   % >JKJ k   , =LL MNM r   , 4OPO m   , -�g
�g boovtrueP n      QRQ 1   1 3�f
�f 
valLR 4   - 1�eS
�e 
attrS m   / 0TT �UU  A X F o c u s e dN V�dV I  5 =�cW�b
�c .miscslctuiel       uielW 4   5 9�aX
�a 
crowX o   7 8�`�` 0 rowindex rowIndex�b  �d  K 4   % )�_Y
�_ 
tabBY m   ' (�^�^ I 4    "�]Z
�] 
scraZ m     !�\�\ G o    �[�[ 0 win  �h  8 4    �Z[
�Z 
prcs[ o    �Y�Y 0 appname appName6 m     \\�                                                                                  sevs  alis    �  HooDisk1                   �1��H+   
�System Events.app                                               
���85G        ����  	                CoreServices    �1��      �8'7     
� 
%� 
%�  6HooDisk1:System:Library:CoreServices:System Events.app  $  S y s t e m   E v e n t s . a p p    H o o D i s k 1  -System/Library/CoreServices/System Events.app   / ��  �q  ( ]^] l     �X�W�V�X  �W  �V  ^ _`_ l     �U�T�S�U  �T  �S  ` aba l     �Rcd�R  c   getCountOfRowsInTable   d �ee ,   g e t C o u n t O f R o w s I n T a b l eb fgf l     �Q�P�O�Q  �P  �O  g hih i    jkj I      �Nl�M�N .0 getcountofrowsintable getCountOfRowsInTablel mnm o      �L�L 0 appname appNamen opo o      �K�K 0 windowtitle windowTitlep q�Jq o      �I�I  0 scrollareaname scrollAreaName�J  �M  k k     �rr sts l     �H�G�F�H  �G  �F  t uvu q      ww �E�D�E 0 returnstring returnString�D  v xyx r     z{z m     || �}} 
 n o E r r{ o      �C�C 0 returnstring returnStringy ~~ O    ���� Q    ����� l   ����� O    ���� k    ��� ��� r    ��� m    �B
�B boovtrue� 1    �A
�A 
pisf� ��@� Q    ����� k    ��� ��� r    #��� e    !�� l   !��?�>� 5    !�=��<
�= 
cwin� o    �;�; 0 windowtitle windowTitle
�< kfrmname�?  �>  � o      �:�: 0 win  � ��9� l  $ ����� O   $ ���� Q   ( ����� k   + s�� ��� r   + =��� 6  + ;��� 4 + /�8�
�8 
scra� m   - .�7�7 � =  0 :��� n   1 6��� 1   4 6�6
�6 
valL� 4   1 4�5�
�5 
attr� m   2 3�� ���  A X D e s c r i p t i o n� o   7 9�4�4  0 scrollareaname scrollAreaName� o      �3�3 "0 tablescrollarea tableScrollArea� ��2� l  > s���� O   > s��� l  B r���� Q   B r���� O   E _��� k   L ^�� ��� r   L T��� l  L R��1�0� n   L R��� 1   P R�/
�/ 
valL� 4   L P�.�
�. 
attr� m   N O�� ���  A X R o w s�1  �0  � o      �-�- 0 mumblemumble  � ��,� r   U ^��� c   U \��� l  U Z��+�*� I  U Z�)��(
�) .corecnte****       ****� o   U V�'�' 0 mumblemumble  �(  �+  �*  � m   Z [�&
�& 
nmbr� o      �%�% 0 returnstring returnString�,  � 4 E I�$�
�$ 
tabB� m   G H�#�# � R      �"��
�" .ascrerr ****      � ****� o      �!�! 0 errstr errStr� � ��
�  
errn� o      �� 0 errornumber errorNumber�  � r   g r��� b   g p��� b   g l��� m   g j�� ��� " D o e s   s c r o l l   v i e w  � o   j k��  0 scrollareaname scrollAreaName� m   l o�� ��� "   c o n t a i n   a   t a b l e ?� o      �� 0 returnstring returnString�   end tell table   � ���    e n d   t e l l   t a b l e� o   > ?�� "0 tablescrollarea tableScrollArea�   end tell scroll area   � ��� *   e n d   t e l l   s c r o l l   a r e a�2  � R      ���
� .ascrerr ****      � ****� o      �� 0 errstr errStr� ���
� 
errn� o      �� 0 errornumber errorNumber�  � r   { ���� b   { ���� m   { ~�� ��� : C a n t   f i n d   t h a t   s c r o l l   a r e a   -  � o   ~ ��  0 scrollareaname scrollAreaName� o      �� 0 returnstring returnString� o   $ %�� 0 win  �   end tell window   � ���     e n d   t e l l   w i n d o w�9  � R      ���
� .ascrerr ****      � ****� o      �� 0 errstr errStr� ���
� 
errn� o      �� 0 errornumber errorNumber�  � r   � ���� b   � ���� m   � ��� ��� 0 C a n t   f i n d   t h a t   w i n d o w   -  � o   � ��� 0 windowtitle windowTitle� o      �� 0 returnstring returnString�@  � 4    ��
� 
prcs� o    �
�
 0 appname appName�   end tell process   � ��� "   e n d   t e l l   p r o c e s s� R      �	��
�	 .ascrerr ****      � ****� o      �� 0 errstr errStr� ���
� 
errn� o      �� 0 errornumber errorNumber�  � r   � ���� b   � ���� m   � ��� �   * C a n t   f i n d   t h a t   A p p   -  � o   � ��� 0 appname appName� o      �� 0 returnstring returnString� m    �                                                                                  sevs  alis    �  HooDisk1                   �1��H+   
�System Events.app                                               
���85G        ����  	                CoreServices    �1��      �8'7     
� 
%� 
%�  6HooDisk1:System:Library:CoreServices:System Events.app  $  S y s t e m   E v e n t s . a p p    H o o D i s k 1  -System/Library/CoreServices/System Events.app   / ��    L   � � o   � ��� 0 returnstring returnString � l  � �� �����   ��  ��  �  i  l     ��������  ��  ��   �� l     ��������  ��  ��  ��       ��	
��  	 �������� &0 selectrowsintable selectRowsInTable�� $0 selectrowintable selectRowInTable�� .0 getcountofrowsintable getCountOfRowsInTable
 �� �������� &0 selectrowsintable selectRowsInTable�� ����   �������� 0 appname appName�� 0 windowtitle windowTitle�� 0 rowindex rowIndex��   ������������ 0 appname appName�� 0 windowtitle windowTitle�� 0 rowindex rowIndex�� 0 win  �� 0 thepos thePos $�������������� H����������
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
�� 
crow
�� 
posn
�� 
x$$$
�� .EeEeeeEHnull���   @ long�� T� P*�/ He*�,FO*��0EE�O� 4*�k/ ,*�k/ $e*��/�,FO*�l/ *�,E�O��l OPUOPUUUUU ��*�������� $0 selectrowintable selectRowInTable�� ����   �������� 0 appname appName�� 0 windowtitle windowTitle�� 0 rowindex rowIndex��   ���������� 0 appname appName�� 0 windowtitle windowTitle�� 0 rowindex rowIndex�� 0 win   \��������������T������
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
�� 
crow
�� .miscslctuiel       uiel�� C� ?*�/ 7e*�,FO*��0EE�O� #*�k/ *�k/ e*��/�,FO*�/j UUUUU ��k�������� .0 getcountofrowsintable getCountOfRowsInTable�� ����   �������� 0 appname appName�� 0 windowtitle windowTitle��  0 scrollareaname scrollAreaName��   	�������������������� 0 appname appName�� 0 windowtitle windowTitle��  0 scrollareaname scrollAreaName�� 0 returnstring returnString�� 0 win  �� "0 tablescrollarea tableScrollArea�� 0 mumblemumble  �� 0 errstr errStr�� 0 errornumber errorNumber |�����������������������������
�� 
prcs
�� 
pisf
�� 
cwin
�� kfrmname
�� 
scra  
�� 
attr
�� 
valL
�� 
tabB
�� .corecnte****       ****
�� 
nmbr�� 0 errstr errStr ������
�� 
errn�� 0 errornumber errorNumber��  �� ��E�O� � �*�/ �e*�,FO m*��0EE�O� \ M*�k/�[��/�,\Z�81E�O� 2 *�k/ *��/�,E�O�j �&E�UW X  a �%a %E�UW X  a �%E�UW X  a �%E�UW X  a �%E�UO�OPascr  ��ޭ