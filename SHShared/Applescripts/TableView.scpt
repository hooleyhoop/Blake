FasdUAS 1.101.10   ��   ��    k             l     ��  ��    8 2getCountOfRowsInTable("InAppTests", "Untitled", 1)     � 	 	 d g e t C o u n t O f R o w s I n T a b l e ( " I n A p p T e s t s " ,   " U n t i t l e d " ,   1 )   
  
 l     ��  ��    E ?getSelctedRowsInTable("InAppTests", "Untitled", "table1Scroll")     �   ~ g e t S e l c t e d R o w s I n T a b l e ( " I n A p p T e s t s " ,   " U n t i t l e d " ,   " t a b l e 1 S c r o l l " )      l     ��������  ��  ��        l     ��  ��    H BselectRowsInTable("InAppTests", "Untitled", 4) -- first index is 1     �   � s e l e c t R o w s I n T a b l e ( " I n A p p T e s t s " ,   " U n t i t l e d " ,   4 )   - -   f i r s t   i n d e x   i s   1      l     ��������  ��  ��        l     ��  ��     move mouse [1527, 59]     �   * m o v e   m o u s e   [ 1 5 2 7 ,   5 9 ]      l     ��   ��    $ click mouse [1527, 59] times 2      � ! ! < c l i c k   m o u s e   [ 1 5 2 7 ,   5 9 ]   t i m e s   2   " # " i      $ % $ I      �� &���� &0 selectrowsintable selectRowsInTable &  ' ( ' o      ���� 0 appname appName (  ) * ) o      ���� 0 windowtitle windowTitle *  +�� + o      ���� 0 rowindex rowIndex��  ��   % k     S , ,  - . - l     ��������  ��  ��   .  /�� / O     S 0 1 0 O    R 2 3 2 k    Q 4 4  5 6 5 r     7 8 7 m    ��
�� boovtrue 8 1    ��
�� 
pisf 6  9 : 9 r     ; < ; e     = = l    >���� > 5    �� ?��
�� 
cwin ? o    ���� 0 windowtitle windowTitle
�� kfrmname��  ��   < o      ���� 0 win   :  @�� @ O    Q A B A O    P C D C O   % O E F E k   , N G G  H I H r   , 4 J K J m   , -��
�� boovtrue K n       L M L 1   1 3��
�� 
valL M 4   - 1�� N
�� 
attr N m   / 0 O O � P P  A X F o c u s e d I  Q R Q l  5 5��������  ��  ��   R  S T S l  5 5�� U V��   U < 6			set mumblemumble to the value of attribute "AXRows"    V � W W l 	 	 	 s e t   m u m b l e m u m b l e   t o   t h e   v a l u e   o f   a t t r i b u t e   " A X R o w s " T  X Y X l  5 5�� Z [��   Z C =						set value of attribute "AXSelectedRows" to mumblemumble    [ � \ \ z 	 	 	 	 	 	 s e t   v a l u e   o f   a t t r i b u t e   " A X S e l e c t e d R o w s "   t o   m u m b l e m u m b l e Y  ] ^ ] l  5 5��������  ��  ��   ^  _ ` _ l  5 5��������  ��  ��   `  a b a l  5 5�� c d��   c # 				click at row 1's position    d � e e : 	 	 	 	 c l i c k   a t   r o w   1 ' s   p o s i t i o n b  f g f l  5 5�� h i��   h $ 	click row 2 with command down    i � j j < 	 c l i c k   r o w   2   w i t h   c o m m a n d   d o w n g  k l k l  5 5��������  ��  ��   l  m n m l  5 5�� o p��   o " return count of mumblemumble    p � q q 8 r e t u r n   c o u n t   o f   m u m b l e m u m b l e n  r s r l  5 5�� t u��   t $ Dangerous!						key down shift    u � v v < D a n g e r o u s ! 	 	 	 	 	 	 k e y   d o w n   s h i f t s  w x w l  5 5�� y z��   y ( " set rowsToSelect to rows 1 thru 3    z � { { D   s e t   r o w s T o S e l e c t   t o   r o w s   1   t h r u   3 x  | } | l  5 5�� ~ ��   ~ $ 	set selected of row 2 to true     � � � < 	 s e t   s e l e c t e d   o f   r o w   2   t o   t r u e }  � � � l  5 5�� � ���   � $ 	set selected of row 3 to true    � � � � < 	 s e t   s e l e c t e d   o f   r o w   3   t o   t r u e �  � � � l  5 5�� � ���   �  	pick row 1    � � � �  	 p i c k   r o w   1 �  � � � l  5 5�� � ���   �  	pick row 2    � � � �  	 p i c k   r o w   2 �  � � � l  5 5�� � ���   �  			delay 0.2    � � � �  	 	 	 d e l a y   0 . 2 �  � � � l  5 5�� � ���   � " 			click at row 1's position    � � � � 8 	 	 	 c l i c k   a t   r o w   1 ' s   p o s i t i o n �  � � � l  5 5�� � ���   � " 			click at row 2's position    � � � � 8 	 	 	 c l i c k   a t   r o w   2 ' s   p o s i t i o n �  � � � l  5 5��������  ��  ��   �  � � � l  5 5��������  ��  ��   �  � � � l  5 5�� � ���   � . (		display dialog (count of rowsToSelect)    � � � � P 	 	 d i s p l a y   d i a l o g   ( c o u n t   o f   r o w s T o S e l e c t ) �  � � � l  5 5�� � ���   � 0 *		set the selected of rowsToSelect to true    � � � � T 	 	 s e t   t h e   s e l e c t e d   o f   r o w s T o S e l e c t   t o   t r u e �  � � � l  5 5�� � ���   � / )	set the selected items 1 to rowsToSelect    � � � � R 	 s e t   t h e   s e l e c t e d   i t e m s   1   t o   r o w s T o S e l e c t �  � � � l  5 5�� � ���   � > 8	set value of attribute "AXSelectedRows" to rowsToSelect    � � � � p 	 s e t   v a l u e   o f   a t t r i b u t e   " A X S e l e c t e d R o w s "   t o   r o w s T o S e l e c t �  � � � l  5 5�� � ���   �  		key up shift    � � � �  	 	 k e y   u p   s h i f t �  � � � l  5 5��������  ��  ��   �  � � � l  5 5�� � ���   � ' !	set  selected rows value to true    � � � � B 	 s e t     s e l e c t e d   r o w s   v a l u e   t o   t r u e �  � � � l  5 5�� � ���   �  keystroke shift down    � � � � ( k e y s t r o k e   s h i f t   d o w n �  � � � l  5 5�� � ���   �  delay 1    � � � �  d e l a y   1 �  � � � l  5 5�� � ���   �  		key down shift    � � � �   	 	 k e y   d o w n   s h i f t �  � � � l  5 5�� � ���   �  click row 1    � � � �  c l i c k   r o w   1 �  � � � l  5 5�� � ���   �  	click row 3    � � � �  	 c l i c k   r o w   3 �  � � � l  5 5��������  ��  ��   �  � � � l  5 5�� � ���   � C =		key code 125 using {command down, shift down} -- down arrow    � � � � z 	 	 k e y   c o d e   1 2 5   u s i n g   { c o m m a n d   d o w n ,   s h i f t   d o w n }   - -   d o w n   a r r o w �  � � � l  5 5�� � ���   � 5 /		key code 125 using {command down, shift down}    � � � � ^ 	 	 k e y   c o d e   1 2 5   u s i n g   { c o m m a n d   d o w n ,   s h i f t   d o w n } �  � � � l  5 5��������  ��  ��   �  � � � l  5 5�� � ���   �  						mouseClick position    � � � � 2 	 	 	 	 	 	 m o u s e C l i c k   p o s i t i o n �  � � � l  5 5��������  ��  ��   �  � � � O   5 L � � � k   < K � �  � � � r   < A � � � 1   < ?��
�� 
posn � o      ���� 0 thepos thePos �  � � � I  B I�� � �
�� .EeEeeeEHnull���   @ long � o   B C���� 0 thepos thePos � �� ���
�� 
x$$$ � o   D E���� 0 thepos thePos��   �  �  � l  J J��������  ��  ��     l  J J��������  ��  ��    l  J J��������  ��  ��    l  J J��������  ��  ��    l  J J��������  ��  ��   	
	 l  J J����   - '		click using(command down, shift down)    � N 	 	 c l i c k   u s i n g ( c o m m a n d   d o w n ,   s h i f t   d o w n )
 �� l  J J����   4 .			set value of attribute "AXSelected" to true    � \ 	 	 	 s e t   v a l u e   o f   a t t r i b u t e   " A X S e l e c t e d "   t o   t r u e��   � 4   5 9��
�� 
crow m   7 8����  �  l  M M����    		tell row 2    �  	 	 t e l l   r o w   2  l  M M����   4 .			set value of attribute "AXSelected" to true    � \ 	 	 	 s e t   v a l u e   o f   a t t r i b u t e   " A X S e l e c t e d "   t o   t r u e  l  M M�� ��    
		end tell     �!!  	 	 e n d   t e l l "#" l  M M��$%��  $  	key up shift   % �&&  	 k e y   u p   s h i f t# '��' l  M M��������  ��  ��  ��   F 4   % )��(
�� 
tabB( m   ' (��  D 4    "�~)
�~ 
scra) m     !�}�}  B o    �|�| 0 win  ��   3 4    �{*
�{ 
prcs* o    �z�z 0 appname appName 1 m     ++�                                                                                  sevs  alis    �  HooDisk1                   �1��H+   
�System Events.app                                               
���85G        ����  	                CoreServices    �1��      �8'7     
� 
%� 
%�  6HooDisk1:System:Library:CoreServices:System Events.app  $  S y s t e m   E v e n t s . a p p    H o o D i s k 1  -System/Library/CoreServices/System Events.app   / ��  ��   # ,-, l     �y�x�w�y  �x  �w  - ./. i    010 I      �v2�u�v $0 selectrowintable selectRowInTable2 343 o      �t�t 0 appname appName4 565 o      �s�s 0 windowtitle windowTitle6 7�r7 o      �q�q 0 rowindex rowIndex�r  �u  1 k     B88 9:9 l     �p�o�n�p  �o  �n  : ;�m; O     B<=< O    A>?> k    @@@ ABA r    CDC m    �l
�l boovtrueD 1    �k
�k 
pisfB EFE r    GHG e    II l   J�j�iJ 5    �hK�g
�h 
cwinK o    �f�f 0 windowtitle windowTitle
�g kfrmname�j  �i  H o      �e�e 0 win  F L�dL O    @MNM O    ?OPO O   % >QRQ k   , =SS TUT r   , 4VWV m   , -�c
�c boovtrueW n      XYX 1   1 3�b
�b 
valLY 4   - 1�aZ
�a 
attrZ m   / 0[[ �\\  A X F o c u s e dU ]�`] I  5 =�_^�^
�_ .miscslctuiel       uiel^ 4   5 9�]_
�] 
crow_ o   7 8�\�\ 0 rowindex rowIndex�^  �`  R 4   % )�[`
�[ 
tabB` m   ' (�Z�Z P 4    "�Ya
�Y 
scraa m     !�X�X N o    �W�W 0 win  �d  ? 4    �Vb
�V 
prcsb o    �U�U 0 appname appName= m     cc�                                                                                  sevs  alis    �  HooDisk1                   �1��H+   
�System Events.app                                               
���85G        ����  	                CoreServices    �1��      �8'7     
� 
%� 
%�  6HooDisk1:System:Library:CoreServices:System Events.app  $  S y s t e m   E v e n t s . a p p    H o o D i s k 1  -System/Library/CoreServices/System Events.app   / ��  �m  / ded l     �T�S�R�T  �S  �R  e fgf i    hih I      �Qj�P�Q 0 indexofitem indexOfItemj klk o      �O�O 0 theitem2 theItem2l m�Nm o      �M�M 0 thelist2 theList2�N  �P  i k     %nn opo Y     "q�Lrs�Kq Z   tu�J�It =   vwv n    xyx 4    �Hz
�H 
cobjz o    �G�G 0 i  y o    �F�F 0 thelist2 theList2w o    �E�E 0 theitem2 theItem2u L    {{ o    �D�D 0 i  �J  �I  �L 0 i  r m    �C�C s I   	�B|�A
�B .corecnte****       ****| o    �@�@ 0 thelist2 theList2�A  �K  p }�?} L   # %~~ m   # $�>�>���?  g � l     �=�<�;�=  �<  �;  � ��� l     �:���:  �   getSelctedRowsInTable   � ��� ,   g e t S e l c t e d R o w s I n T a b l e� ��� l     �9�8�7�9  �8  �7  � ��� i    ��� I      �6��5�6 .0 getselctedrowsintable getSelctedRowsInTable� ��� o      �4�4 0 appname appName� ��� o      �3�3 0 windowtitle windowTitle� ��2� o      �1�1  0 scrollareaname scrollAreaName�2  �5  � k     ��� ��� l     �0�/�.�0  �/  �.  � ��� q      �� �-�,�- 0 returnstring returnString�,  � ��� r     ��� m     �� ��� 
 n o E r r� o      �+�+ 0 returnstring returnString� ��� O    ���� Q    ����� l   ����� O    ���� k    ��� ��� r    ��� m    �*
�* boovtrue� 1    �)
�) 
pisf� ��(� Q    ����� k    ��� ��� r    #��� e    !�� l   !��'�&� 5    !�%��$
�% 
cwin� o    �#�# 0 windowtitle windowTitle
�$ kfrmname�'  �&  � o      �"�" 0 win  � ��!� l  $ ����� O   $ ���� Q   ( ����� k   + ��� ��� r   + =��� 6  + ;��� 4 + /� �
�  
scra� m   - .�� � =  0 :��� n   1 6��� 1   4 6�
� 
valL� 4   1 4��
� 
attr� m   2 3�� ���  A X D e s c r i p t i o n� o   7 9��  0 scrollareaname scrollAreaName� o      �� "0 tablescrollarea tableScrollArea� ��� l  > ����� O   > ���� l  B ����� Q   B ����� k   E ��� ��� r   E N��� I  E L���
� .corecnte****       ****� l  E H���� 2   E H�
� 
tabB�  �  �  � o      �� 0 
tablecount 
tableCount� ��� l  O O����  �  �  � ��� r   O U��� l  O S���� 4 O S��
� 
tabB� m   Q R�� �  �  � o      �� 0 thetable theTable� ��� l  V ����� O   V ���� k   Z ��� ��� r   Z b��� m   Z [�

�
 boovtrue� n      ��� 1   _ a�	
�	 
valL� 4   [ _��
� 
attr� m   ] ^�� ���  A X F o c u s e d� ��� r   c h   2   c f�
� 
crow o      �� 0 allrows allRows�  r   i m J   i k��   o      �� 0 indexeslist indexesList  l  n n�	�   M G woohoo ! set cabage to ((every row whose selected is true)'s position)   	 �

 �   w o o h o o   !   s e t   c a b a g e   t o   ( ( e v e r y   r o w   w h o s e   s e l e c t e d   i s   t r u e ) ' s   p o s i t i o n )  r   n | l  n z�� l  n z� �� 6  n z 2   n q��
�� 
crow =  r y 1   s u��
�� 
selE m   v x��
�� boovtrue�   ��  �  �   o      ���� 0 selectedrows selectedRows  l  } }��������  ��  ��    Y   } ����� k   � �  r   � �  n   � �!"! l  � �#����# 4   � ���$
�� 
cobj$ o   � ����� 0 i  ��  ��  " o   � ����� 0 selectedrows selectedRows  o      ���� 0 thisitem thisItem %&% r   � �'(' n  � �)*) I   � ���+���� 0 indexofitem indexOfItem+ ,-, o   � ����� 0 thisitem thisItem- .��. o   � ����� 0 allrows allRows��  ��  *  f   � �( o      ���� 0 theindex theIndex& /��/ r   � �010 o   � ����� 0 theindex theIndex1 l     2����2 n      343  ;   � �4 o   � ����� 0 indexeslist indexesList��  ��  ��  �� 0 i   m   � �����  I  � ���5��
�� .corecnte****       ****5 o   � ����� 0 selectedrows selectedRows��  ��   676 l  � ���������  ��  ��  7 898 L   � �:: o   � ����� 0 indexeslist indexesList9 ;��; l  � ���������  ��  ��  ��  � o   V W���� 0 thetable theTable�   end tell table   � �<<    e n d   t e l l   t a b l e�  � R      ��=>
�� .ascrerr ****      � ****= o      ���� 0 errstr errStr> ��?��
�� 
errn? o      ���� 0 errornumber errorNumber��  � r   � �@A@ b   � �BCB m   � �DD �EE 8 D o   w e   h a v e   a   t a b l e   a t   i n d e x  C o   � ����� 0 
tableindex 
tableIndexA o      ���� 0 returnstring returnString�   end tell table   � �FF    e n d   t e l l   t a b l e� o   > ?���� "0 tablescrollarea tableScrollArea�   end tell scroll area   � �GG *   e n d   t e l l   s c r o l l   a r e a�  � R      ��HI
�� .ascrerr ****      � ****H o      ���� 0 errstr errStrI ��J��
�� 
errnJ o      ���� 0 errornumber errorNumber��  � r   � �KLK b   � �MNM m   � �OO �PP : C a n t   f i n d   t h a t   s c r o l l   a r e a   -  N o   � �����  0 scrollareaname scrollAreaNameL o      ���� 0 returnstring returnString� o   $ %���� 0 win  �   end tell window   � �QQ     e n d   t e l l   w i n d o w�!  � R      ��RS
�� .ascrerr ****      � ****R o      ���� 0 errstr errStrS ��T��
�� 
errnT o      ���� 0 errornumber errorNumber��  � r   � �UVU b   � �WXW m   � �YY �ZZ 0 C a n t   f i n d   t h a t   w i n d o w   -  X o   � ����� 0 windowtitle windowTitleV o      ���� 0 returnstring returnString�(  � 4    ��[
�� 
prcs[ o    ���� 0 appname appName�   end tell process   � �\\ "   e n d   t e l l   p r o c e s s� R      ��]^
�� .ascrerr ****      � ****] o      ���� 0 errstr errStr^ ��_��
�� 
errn_ o      ���� 0 errornumber errorNumber��  � r   � �`a` b   � �bcb m   � �dd �ee * C a n t   f i n d   t h a t   A p p   -  c o   � ����� 0 appname appNamea o      ���� 0 returnstring returnString� m    ff�                                                                                  sevs  alis    �  HooDisk1                   �1��H+   
�System Events.app                                               
���85G        ����  	                CoreServices    �1��      �8'7     
� 
%� 
%�  6HooDisk1:System:Library:CoreServices:System Events.app  $  S y s t e m   E v e n t s . a p p    H o o D i s k 1  -System/Library/CoreServices/System Events.app   / ��  � ghg L   � �ii o   � ����� 0 returnstring returnStringh j��j l  � ���������  ��  ��  ��  � klk l     ��������  ��  ��  l mnm l     ��������  ��  ��  n opo l     ��qr��  q   getCountOfRowsInTable   r �ss ,   g e t C o u n t O f R o w s I n T a b l ep tut l     ��������  ��  ��  u vwv i    xyx I      ��z���� .0 getcountofrowsintable getCountOfRowsInTablez {|{ o      ���� 0 appname appName| }~} o      ���� 0 windowtitle windowTitle~ �� o      ����  0 scrollareaname scrollAreaName��  ��  y k     ��� ��� l     ��������  ��  ��  � ��� l     ������  � N H shit - now need to do the scroll pane stuff! just do table 1 of window!   � ��� �   s h i t   -   n o w   n e e d   t o   d o   t h e   s c r o l l   p a n e   s t u f f !   j u s t   d o   t a b l e   1   o f   w i n d o w !� ��� q      �� ������ 0 returnstring returnString��  � ��� r     ��� m     �� ��� 
 n o E r r� o      ���� 0 returnstring returnString� ��� O    ���� Q    ����� l   ����� O    ���� k    ��� ��� r    ��� m    ��
�� boovtrue� 1    ��
�� 
pisf� ���� Q    ����� k    ��� ��� r    #��� e    !�� l   !������ 5    !�����
�� 
cwin� o    ���� 0 windowtitle windowTitle
�� kfrmname��  ��  � o      ���� 0 win  � ���� l  $ ����� O   $ ���� Q   ( ����� k   + s�� ��� r   + =��� 6  + ;��� 4 + /���
�� 
scra� m   - .���� � =  0 :��� n   1 6��� 1   4 6��
�� 
valL� 4   1 4���
�� 
attr� m   2 3�� ���  A X D e s c r i p t i o n� o   7 9����  0 scrollareaname scrollAreaName� o      ���� "0 tablescrollarea tableScrollArea� ���� l  > s���� O   > s��� l  B r���� Q   B r���� O   E _��� k   L ^�� ��� r   L T��� l  L R������ n   L R��� 1   P R��
�� 
valL� 4   L P���
�� 
attr� m   N O�� ���  A X R o w s��  ��  � o      ���� 0 mumblemumble  � ���� r   U ^��� c   U \��� l  U Z������ I  U Z�����
�� .corecnte****       ****� o   U V���� 0 mumblemumble  ��  ��  ��  � m   Z [�
� 
nmbr� o      �~�~ 0 returnstring returnString��  � 4 E I�}�
�} 
tabB� m   G H�|�| � R      �{��
�{ .ascrerr ****      � ****� o      �z�z 0 errstr errStr� �y��x
�y 
errn� o      �w�w 0 errornumber errorNumber�x  � r   g r��� b   g p��� b   g l��� m   g j�� ��� " D o e s   s c r o l l   v i e w  � o   j k�v�v  0 scrollareaname scrollAreaName� m   l o�� ��� "   c o n t a i n   a   t a b l e ?� o      �u�u 0 returnstring returnString�   end tell table   � ���    e n d   t e l l   t a b l e� o   > ?�t�t "0 tablescrollarea tableScrollArea�   end tell scroll area   � ��� *   e n d   t e l l   s c r o l l   a r e a��  � R      �s��
�s .ascrerr ****      � ****� o      �r�r 0 errstr errStr� �q��p
�q 
errn� o      �o�o 0 errornumber errorNumber�p  � r   { ���� b   { ���� m   { ~�� ��� : C a n t   f i n d   t h a t   s c r o l l   a r e a   -  � o   ~ �n�n  0 scrollareaname scrollAreaName� o      �m�m 0 returnstring returnString� o   $ %�l�l 0 win  �   end tell window   � ���     e n d   t e l l   w i n d o w��  � R      �k 
�k .ascrerr ****      � ****  o      �j�j 0 errstr errStr �i�h
�i 
errn o      �g�g 0 errornumber errorNumber�h  � r   � � b   � � m   � � � 0 C a n t   f i n d   t h a t   w i n d o w   -   o   � ��f�f 0 windowtitle windowTitle o      �e�e 0 returnstring returnString��  � 4    �d	
�d 
prcs	 o    �c�c 0 appname appName�   end tell process   � �

 "   e n d   t e l l   p r o c e s s� R      �b
�b .ascrerr ****      � **** o      �a�a 0 errstr errStr �`�_
�` 
errn o      �^�^ 0 errornumber errorNumber�_  � r   � � b   � � m   � � � * C a n t   f i n d   t h a t   A p p   -   o   � ��]�] 0 appname appName o      �\�\ 0 returnstring returnString� m    �                                                                                  sevs  alis    �  HooDisk1                   �1��H+   
�System Events.app                                               
���85G        ����  	                CoreServices    �1��      �8'7     
� 
%� 
%�  6HooDisk1:System:Library:CoreServices:System Events.app  $  S y s t e m   E v e n t s . a p p    H o o D i s k 1  -System/Library/CoreServices/System Events.app   / ��  �  L   � � o   � ��[�[ 0 returnstring returnString �Z l  � ��Y�X�W�Y  �X  �W  �Z  w  l     �V�U�T�V  �U  �T   �S l     �R�Q�P�R  �Q  �P  �S       �O !�O   �N�M�L�K�J�N &0 selectrowsintable selectRowsInTable�M $0 selectrowintable selectRowInTable�L 0 indexofitem indexOfItem�K .0 getselctedrowsintable getSelctedRowsInTable�J .0 getcountofrowsintable getCountOfRowsInTable �I %�H�G"#�F�I &0 selectrowsintable selectRowsInTable�H �E$�E $  �D�C�B�D 0 appname appName�C 0 windowtitle windowTitle�B 0 rowindex rowIndex�G  " �A�@�?�>�=�A 0 appname appName�@ 0 windowtitle windowTitle�? 0 rowindex rowIndex�> 0 win  �= 0 thepos thePos# +�<�;�:�9�8�7�6 O�5�4�3�2�1
�< 
prcs
�; 
pisf
�: 
cwin
�9 kfrmname
�8 
scra
�7 
tabB
�6 
attr
�5 
valL
�4 
crow
�3 
posn
�2 
x$$$
�1 .EeEeeeEHnull���   @ long�F T� P*�/ He*�,FO*��0EE�O� 4*�k/ ,*�k/ $e*��/�,FO*�l/ *�,E�O��l OPUOPUUUUU �01�/�.%&�-�0 $0 selectrowintable selectRowInTable�/ �,'�, '  �+�*�)�+ 0 appname appName�* 0 windowtitle windowTitle�) 0 rowindex rowIndex�.  % �(�'�&�%�( 0 appname appName�' 0 windowtitle windowTitle�& 0 rowindex rowIndex�% 0 win  & c�$�#�"�!� ��[���
�$ 
prcs
�# 
pisf
�" 
cwin
�! kfrmname
�  
scra
� 
tabB
� 
attr
� 
valL
� 
crow
� .miscslctuiel       uiel�- C� ?*�/ 7e*�,FO*��0EE�O� #*�k/ *�k/ e*��/�,FO*�/j UUUUU �i��()�� 0 indexofitem indexOfItem� �*� *  ��� 0 theitem2 theItem2� 0 thelist2 theList2�  ( ���� 0 theitem2 theItem2� 0 thelist2 theList2� 0 i  ) ��
� .corecnte****       ****
� 
cobj� & !k�j  kh ��/�  �Y h[OY��Oi  ����+,�� .0 getselctedrowsintable getSelctedRowsInTable� �
-�
 -  �	���	 0 appname appName� 0 windowtitle windowTitle�  0 scrollareaname scrollAreaName�  + ������� ��������������������� 0 appname appName� 0 windowtitle windowTitle�  0 scrollareaname scrollAreaName� 0 returnstring returnString� 0 win  � "0 tablescrollarea tableScrollArea�  0 
tablecount 
tableCount�� 0 thetable theTable�� 0 allrows allRows�� 0 indexeslist indexesList�� 0 selectedrows selectedRows�� 0 i  �� 0 thisitem thisItem�� 0 theindex theIndex�� 0 errstr errStr�� 0 errornumber errorNumber�� 0 
tableindex 
tableIndex, �f����������.��������������������/DOYd
�� 
prcs
�� 
pisf
�� 
cwin
�� kfrmname
�� 
scra.  
�� 
attr
�� 
valL
�� 
tabB
�� .corecnte****       ****
�� 
crow
�� 
selE
�� 
cobj�� 0 indexofitem indexOfItem�� 0 errstr errStr/ ������
�� 
errn�� 0 errornumber errorNumber��  � ��E�O� � �*�/ �e*�,FO �*��0EE�O� � �*�k/�[��/�,\Z�81E�O� ~ m*�-j E�O*�k/E�O� Te*��/�,FO*�-E�OjvE�O*�-�[�,\Ze81E�O )k�j kh �a �/E�O)��l+ E�O��6F[OY��O�OPUW X  a ] %E�UW X  a �%E�UW X  a �%E�UW X  a �%E�UO�OP! ��y����01���� .0 getcountofrowsintable getCountOfRowsInTable�� ��2�� 2  �������� 0 appname appName�� 0 windowtitle windowTitle��  0 scrollareaname scrollAreaName��  0 	�������������������� 0 appname appName�� 0 windowtitle windowTitle��  0 scrollareaname scrollAreaName�� 0 returnstring returnString�� 0 win  �� "0 tablescrollarea tableScrollArea�� 0 mumblemumble  �� 0 errstr errStr�� 0 errornumber errorNumber1 �����������.��������������3���
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
attr
�� 
valL
�� 
tabB
�� .corecnte****       ****
�� 
nmbr�� 0 errstr errStr3 ������
�� 
errn�� 0 errornumber errorNumber��  �� ��E�O� � �*�/ �e*�,FO m*��0EE�O� \ M*�k/�[��/�,\Z�81E�O� 2 *�k/ *��/�,E�O�j �&E�UW X  a �%a %E�UW X  a �%E�UW X  a �%E�UW X  a �%E�UO�OP ascr  ��ޭ