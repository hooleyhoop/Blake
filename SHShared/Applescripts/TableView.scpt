FasdUAS 1.101.10   ��   ��    k             l     ��  ��    E ?getCountOfRowsInTable("InAppTests", "Untitled", "table1Scroll")     � 	 	 ~ g e t C o u n t O f R o w s I n T a b l e ( " I n A p p T e s t s " ,   " U n t i t l e d " ,   " t a b l e 1 S c r o l l " )   
  
 l     ��  ��    E ?getSelctedRowsInTable("InAppTests", "Untitled", "table1Scroll")     �   ~ g e t S e l c t e d R o w s I n T a b l e ( " I n A p p T e s t s " ,   " U n t i t l e d " ,   " t a b l e 1 S c r o l l " )      l     ��  ��    C =selectRowInTable("InAppTests", "Untitled", "table1Scroll", 4)     �   z s e l e c t R o w I n T a b l e ( " I n A p p T e s t s " ,   " U n t i t l e d " ,   " t a b l e 1 S c r o l l " ,   4 )      l     ��������  ��  ��        l     ��  ��    Y SselectRowsInTable("InAppTests", "Untitled",  "table1Scroll", 4) -- first index is 1     �   � s e l e c t R o w s I n T a b l e ( " I n A p p T e s t s " ,   " U n t i t l e d " ,     " t a b l e 1 S c r o l l " ,   4 )   - -   f i r s t   i n d e x   i s   1      l     ��������  ��  ��        l     ��   ��     move mouse [1527, 59]      � ! ! * m o v e   m o u s e   [ 1 5 2 7 ,   5 9 ]   " # " l     �� $ %��   $ $ click mouse [1527, 59] times 2    % � & & < c l i c k   m o u s e   [ 1 5 2 7 ,   5 9 ]   t i m e s   2 #  ' ( ' l     ��������  ��  ��   (  ) * ) l     ��������  ��  ��   *  + , + i      - . - I      �� /���� &0 selectrowsintable selectRowsInTable /  0 1 0 o      ���� 0 appname appName 1  2 3 2 o      ���� 0 windowtitle windowTitle 3  4�� 4 o      ���� 0 rowindex rowIndex��  ��   . k     S 5 5  6 7 6 l     ��������  ��  ��   7  8�� 8 O     S 9 : 9 O    R ; < ; k    Q = =  > ? > r     @ A @ m    ��
�� boovtrue A 1    ��
�� 
pisf ?  B C B r     D E D e     F F l    G���� G 5    �� H��
�� 
cwin H o    ���� 0 windowtitle windowTitle
�� kfrmname��  ��   E o      ���� 0 win   C  I�� I O    Q J K J O    P L M L O   % O N O N k   , N P P  Q R Q r   , 4 S T S m   , -��
�� boovtrue T n       U V U 1   1 3��
�� 
valL V 4   - 1�� W
�� 
attr W m   / 0 X X � Y Y  A X F o c u s e d R  Z [ Z l  5 5��������  ��  ��   [  \ ] \ l  5 5�� ^ _��   ^ < 6			set mumblemumble to the value of attribute "AXRows"    _ � ` ` l 	 	 	 s e t   m u m b l e m u m b l e   t o   t h e   v a l u e   o f   a t t r i b u t e   " A X R o w s " ]  a b a l  5 5�� c d��   c C =						set value of attribute "AXSelectedRows" to mumblemumble    d � e e z 	 	 	 	 	 	 s e t   v a l u e   o f   a t t r i b u t e   " A X S e l e c t e d R o w s "   t o   m u m b l e m u m b l e b  f g f l  5 5��������  ��  ��   g  h i h l  5 5��������  ��  ��   i  j k j l  5 5�� l m��   l # 				click at row 1's position    m � n n : 	 	 	 	 c l i c k   a t   r o w   1 ' s   p o s i t i o n k  o p o l  5 5�� q r��   q $ 	click row 2 with command down    r � s s < 	 c l i c k   r o w   2   w i t h   c o m m a n d   d o w n p  t u t l  5 5��������  ��  ��   u  v w v l  5 5�� x y��   x " return count of mumblemumble    y � z z 8 r e t u r n   c o u n t   o f   m u m b l e m u m b l e w  { | { l  5 5�� } ~��   } $ Dangerous!						key down shift    ~ �   < D a n g e r o u s ! 	 	 	 	 	 	 k e y   d o w n   s h i f t |  � � � l  5 5�� � ���   � ( " set rowsToSelect to rows 1 thru 3    � � � � D   s e t   r o w s T o S e l e c t   t o   r o w s   1   t h r u   3 �  � � � l  5 5�� � ���   � $ 	set selected of row 2 to true    � � � � < 	 s e t   s e l e c t e d   o f   r o w   2   t o   t r u e �  � � � l  5 5�� � ���   � $ 	set selected of row 3 to true    � � � � < 	 s e t   s e l e c t e d   o f   r o w   3   t o   t r u e �  � � � l  5 5�� � ���   �  	pick row 1    � � � �  	 p i c k   r o w   1 �  � � � l  5 5�� � ���   �  	pick row 2    � � � �  	 p i c k   r o w   2 �  � � � l  5 5�� � ���   �  			delay 0.2    � � � �  	 	 	 d e l a y   0 . 2 �  � � � l  5 5�� � ���   � " 			click at row 1's position    � � � � 8 	 	 	 c l i c k   a t   r o w   1 ' s   p o s i t i o n �  � � � l  5 5�� � ���   � " 			click at row 2's position    � � � � 8 	 	 	 c l i c k   a t   r o w   2 ' s   p o s i t i o n �  � � � l  5 5��������  ��  ��   �  � � � l  5 5��������  ��  ��   �  � � � l  5 5�� � ���   � . (		display dialog (count of rowsToSelect)    � � � � P 	 	 d i s p l a y   d i a l o g   ( c o u n t   o f   r o w s T o S e l e c t ) �  � � � l  5 5�� � ���   � 0 *		set the selected of rowsToSelect to true    � � � � T 	 	 s e t   t h e   s e l e c t e d   o f   r o w s T o S e l e c t   t o   t r u e �  � � � l  5 5�� � ���   � / )	set the selected items 1 to rowsToSelect    � � � � R 	 s e t   t h e   s e l e c t e d   i t e m s   1   t o   r o w s T o S e l e c t �  � � � l  5 5�� � ���   � > 8	set value of attribute "AXSelectedRows" to rowsToSelect    � � � � p 	 s e t   v a l u e   o f   a t t r i b u t e   " A X S e l e c t e d R o w s "   t o   r o w s T o S e l e c t �  � � � l  5 5�� � ���   �  		key up shift    � � � �  	 	 k e y   u p   s h i f t �  � � � l  5 5��������  ��  ��   �  � � � l  5 5�� � ���   � ' !	set  selected rows value to true    � � � � B 	 s e t     s e l e c t e d   r o w s   v a l u e   t o   t r u e �  � � � l  5 5�� � ���   �  keystroke shift down    � � � � ( k e y s t r o k e   s h i f t   d o w n �  � � � l  5 5�� � ���   �  delay 1    � � � �  d e l a y   1 �  � � � l  5 5�� � ���   �  		key down shift    � � � �   	 	 k e y   d o w n   s h i f t �  � � � l  5 5�� � ���   �  click row 1    � � � �  c l i c k   r o w   1 �  � � � l  5 5�� � ���   �  	click row 3    � � � �  	 c l i c k   r o w   3 �  � � � l  5 5��������  ��  ��   �  � � � l  5 5�� � ���   � C =		key code 125 using {command down, shift down} -- down arrow    � � � � z 	 	 k e y   c o d e   1 2 5   u s i n g   { c o m m a n d   d o w n ,   s h i f t   d o w n }   - -   d o w n   a r r o w �  � � � l  5 5�� � ���   � 5 /		key code 125 using {command down, shift down}    � � � � ^ 	 	 k e y   c o d e   1 2 5   u s i n g   { c o m m a n d   d o w n ,   s h i f t   d o w n } �  � � � l  5 5��������  ��  ��   �  � � � l  5 5�� � ���   �  						mouseClick position    � � � � 2 	 	 	 	 	 	 m o u s e C l i c k   p o s i t i o n �  � � � l  5 5��������  ��  ��   �  � � � O   5 L � � � k   < K � �  �  � r   < A 1   < ?��
�� 
posn o      ���� 0 thepos thePos   I  B I��
�� .EeEeeeEHnull���   @ long o   B C���� 0 thepos thePos ����
�� 
x$$$ o   D E���� 0 thepos thePos��   	 l  J J��������  ��  ��  	 

 l  J J��������  ��  ��    l  J J��������  ��  ��    l  J J��������  ��  ��    l  J J��������  ��  ��    l  J J����   - '		click using(command down, shift down)    � N 	 	 c l i c k   u s i n g ( c o m m a n d   d o w n ,   s h i f t   d o w n ) �� l  J J����   4 .			set value of attribute "AXSelected" to true    � \ 	 	 	 s e t   v a l u e   o f   a t t r i b u t e   " A X S e l e c t e d "   t o   t r u e��   � 4   5 9��
�� 
crow m   7 8����  �  l  M M����    		tell row 2    �    	 	 t e l l   r o w   2 !"! l  M M��#$��  # 4 .			set value of attribute "AXSelected" to true   $ �%% \ 	 	 	 s e t   v a l u e   o f   a t t r i b u t e   " A X S e l e c t e d "   t o   t r u e" &'& l  M M�()�  (  
		end tell   ) �**  	 	 e n d   t e l l' +,+ l  M M�~-.�~  -  	key up shift   . �//  	 k e y   u p   s h i f t, 0�}0 l  M M�|�{�z�|  �{  �z  �}   O 4   % )�y1
�y 
tabB1 m   ' (�x�x  M 4    "�w2
�w 
scra2 m     !�v�v  K o    �u�u 0 win  ��   < 4    �t3
�t 
prcs3 o    �s�s 0 appname appName : m     44�                                                                                  sevs  alis    �  HooDisk1                   �1��H+   
�System Events.app                                               
���85G        ����  	                CoreServices    �1��      �8'7     
� 
%� 
%�  6HooDisk1:System:Library:CoreServices:System Events.app  $  S y s t e m   E v e n t s . a p p    H o o D i s k 1  -System/Library/CoreServices/System Events.app   / ��  ��   , 565 l     �r�q�p�r  �q  �p  6 787 l     �o�n�m�o  �n  �m  8 9:9 l     �l�k�j�l  �k  �j  : ;<; l     �i=>�i  =   selectRowInTable   > �?? "   s e l e c t R o w I n T a b l e< @A@ l     �h�g�f�h  �g  �f  A BCB i    DED I      �eF�d�e $0 selectrowintable selectRowInTableF GHG o      �c�c 0 appname appNameH IJI o      �b�b 0 windowtitle windowTitleJ KLK o      �a�a  0 scrollareaname scrollAreaNameL M�`M o      �_�_ 0 rowindex rowIndex�`  �d  E k     �NN OPO l     �^�]�\�^  �]  �\  P QRQ q      SS �[�Z�[ 0 returnstring returnString�Z  R TUT r     VWV m     XX �YY 
 n o E r rW o      �Y�Y 0 returnstring returnStringU Z[Z l   �X�W�V�X  �W  �V  [ \]\ l   �^_`^ O    �aba Q    �cdec l   �fghf O    �iji k    �kk lml r    non m    �U
�U boovtrueo 1    �T
�T 
pisfm p�Sp Q    �qrsq k    �tt uvu r    #wxw e    !yy l   !z�R�Qz 5    !�P{�O
�P 
cwin{ o    �N�N 0 windowtitle windowTitle
�O kfrmname�R  �Q  x o      �M�M 0 win  v |�L| l  $ �}~} O   $ ���� Q   ( ����� k   + t�� ��� r   + =��� 6  + ;��� 4 + /�K�
�K 
scra� m   - .�J�J � =  0 :��� n   1 6��� 1   4 6�I
�I 
valL� 4   1 4�H�
�H 
attr� m   2 3�� ���  A X D e s c r i p t i o n� o   7 9�G�G  0 scrollareaname scrollAreaName� o      �F�F "0 tablescrollarea tableScrollArea� ��E� l  > t���� O   > t��� Q   B s���� l  E `���� O   E `��� k   L _�� ��� r   L T��� m   L M�D
�D boovtrue� n      ��� 1   Q S�C
�C 
valL� 4   M Q�B�
�B 
attr� m   O P�� ���  A X F o c u s e d� ��A� I  U _�@��?
�@ .miscslctuiel       uiel� 4   U [�>�
�> 
crow� l  W Z��=�<� c   W Z��� o   W X�;�; 0 rowindex rowIndex� m   X Y�:
�: 
nmbr�=  �<  �?  �A  � 4   E I�9�
�9 
tabB� m   G H�8�8 �   end tell table   � ���    e n d   t e l l   t a b l e� R      �7��
�7 .ascrerr ****      � ****� o      �6�6 0 errstr errStr� �5��4
�5 
errn� o      �3�3 0 errornumber errorNumber�4  � r   h s��� b   h q��� b   h m��� m   h k�� ��� " D o e s   s c r o l l   v i e w  � o   k l�2�2  0 scrollareaname scrollAreaName� m   m p�� ��� "   c o n t a i n   a   t a b l e ?� o      �1�1 0 returnstring returnString� o   > ?�0�0 "0 tablescrollarea tableScrollArea�   end tell scroll area   � ��� *   e n d   t e l l   s c r o l l   a r e a�E  � R      �/��
�/ .ascrerr ****      � ****� o      �.�. 0 errstr errStr� �-��,
�- 
errn� o      �+�+ 0 errornumber errorNumber�,  � r   | ���� b   | ���� m   | �� ��� : C a n t   f i n d   t h a t   s c r o l l   a r e a   -  � o    ��*�*  0 scrollareaname scrollAreaName� o      �)�) 0 returnstring returnString� o   $ %�(�( 0 win  ~   end tell win    ���    e n d   t e l l   w i n�L  r R      �'��
�' .ascrerr ****      � ****� o      �&�& 0 errstr errStr� �%��$
�% 
errn� o      �#�# 0 errornumber errorNumber�$  s r   � ���� b   � ���� m   � ��� ��� 0 C a n t   f i n d   t h a t   w i n d o w   -  � o   � ��"�" 0 windowtitle windowTitle� o      �!�! 0 returnstring returnString�S  j 4    � �
�  
prcs� o    �� 0 appname appNameg   end tell appname   h ��� "   e n d   t e l l   a p p n a m ed R      ���
� .ascrerr ****      � ****� o      �� 0 errstr errStr� ���
� 
errn� o      �� 0 errornumber errorNumber�  e r   � ���� b   � ���� m   � ��� ��� * C a n t   f i n d   t h a t   A p p   -  � o   � ��� 0 appname appName� o      �� 0 returnstring returnStringb m    ���                                                                                  sevs  alis    �  HooDisk1                   �1��H+   
�System Events.app                                               
���85G        ����  	                CoreServices    �1��      �8'7     
� 
%� 
%�  6HooDisk1:System:Library:CoreServices:System Events.app  $  S y s t e m   E v e n t s . a p p    H o o D i s k 1  -System/Library/CoreServices/System Events.app   / ��  _   end tell system events   ` ��� .   e n d   t e l l   s y s t e m   e v e n t s] ��� l  � �����  �  �  � ��� L   � ��� o   � ��� 0 returnstring returnString� ��� l  � �����  �  �  �  C ��� l     ����  �  �  � ��� i    ��� I      ���� 0 indexofitem indexOfItem� ��� o      �
�
 0 theitem2 theItem2� ��	� o      �� 0 thelist2 theList2�	  �  � k     %�� ��� Y     "������ Z   ����� =   ��� n    ��� 4    ��
� 
cobj� o    �� 0 i  � o    �� 0 thelist2 theList2� o    � �  0 theitem2 theItem2� L    �� o    ���� 0 i  �  �  � 0 i  � m    ���� � I   	�� ��
�� .corecnte****       ****  o    ���� 0 thelist2 theList2��  �  � �� L   # % m   # $��������  �  l     ��������  ��  ��    l     ��������  ��  ��    l     ��������  ��  ��   	
	 l     ����     getSelctedRowsInTable    � ,   g e t S e l c t e d R o w s I n T a b l e
  l     ��������  ��  ��    i     I      ������ .0 getselctedrowsintable getSelctedRowsInTable  o      ���� 0 appname appName  o      ���� 0 windowtitle windowTitle �� o      ����  0 scrollareaname scrollAreaName��  ��   k     �  l     ��������  ��  ��    q       ������ 0 returnstring returnString��    !  r     "#" m     $$ �%% 
 n o E r r# o      ���� 0 returnstring returnString! &'& O    �()( Q    �*+,* l   �-./- O    �010 k    �22 343 r    565 m    ��
�� boovtrue6 1    ��
�� 
pisf4 7��7 Q    �89:8 k    �;; <=< r    #>?> e    !@@ l   !A����A 5    !��B��
�� 
cwinB o    ���� 0 windowtitle windowTitle
�� kfrmname��  ��  ? o      ���� 0 win  = C��C l  $ �DEFD O   $ �GHG Q   ( �IJKI k   + �LL MNM r   + =OPO 6  + ;QRQ 4 + /��S
�� 
scraS m   - .���� R =  0 :TUT n   1 6VWV 1   4 6��
�� 
valLW 4   1 4��X
�� 
attrX m   2 3YY �ZZ  A X D e s c r i p t i o nU o   7 9����  0 scrollareaname scrollAreaNameP o      ���� "0 tablescrollarea tableScrollAreaN [��[ l  > �\]^\ O   > �_`_ l  B �abca Q   B �defd k   E �gg hih r   E Njkj I  E L��l��
�� .corecnte****       ****l l  E Hm����m 2   E H��
�� 
tabB��  ��  ��  k o      ���� 0 
tablecount 
tableCounti non l  O O��������  ��  ��  o pqp r   O Ursr l  O St����t 4 O S��u
�� 
tabBu m   Q R���� ��  ��  s o      ���� 0 thetable theTableq v��v l  V �wxyw O   V �z{z k   Z �|| }~} r   Z b� m   Z [��
�� boovtrue� n      ��� 1   _ a��
�� 
valL� 4   [ _���
�� 
attr� m   ] ^�� ���  A X F o c u s e d~ ��� r   c h��� 2   c f��
�� 
crow� o      ���� 0 allrows allRows� ��� r   i m��� J   i k����  � o      ���� 0 indexeslist indexesList� ��� l  n n������  � M G woohoo ! set cabage to ((every row whose selected is true)'s position)   � ��� �   w o o h o o   !   s e t   c a b a g e   t o   ( ( e v e r y   r o w   w h o s e   s e l e c t e d   i s   t r u e ) ' s   p o s i t i o n )� ��� r   n |��� l  n z������ l  n z������ 6  n z��� 2   n q��
�� 
crow� =  r y��� 1   s u��
�� 
selE� m   v x��
�� boovtrue��  ��  ��  ��  � o      ���� 0 selectedrows selectedRows� ��� l  } }��������  ��  ��  � ��� Y   } ��������� k   � ��� ��� r   � ���� n   � ���� l  � ������� 4   � ����
�� 
cobj� o   � ����� 0 i  ��  ��  � o   � ����� 0 selectedrows selectedRows� o      ���� 0 thisitem thisItem� ��� r   � ���� n  � ���� I   � �������� 0 indexofitem indexOfItem� ��� o   � ����� 0 thisitem thisItem� ���� o   � ����� 0 allrows allRows��  ��  �  f   � �� o      ���� 0 theindex theIndex� ���� r   � ���� o   � ����� 0 theindex theIndex� l     ������ n      ���  ;   � �� o   � ����� 0 indexeslist indexesList��  ��  ��  �� 0 i  � m   � ����� � I  � ������
�� .corecnte****       ****� o   � ����� 0 selectedrows selectedRows��  ��  � ��� l  � ���������  ��  ��  � ��� L   � ��� o   � ����� 0 indexeslist indexesList� ���� l  � ���������  ��  ��  ��  { o   V W���� 0 thetable theTablex   end tell table   y ���    e n d   t e l l   t a b l e��  e R      ����
�� .ascrerr ****      � ****� o      ���� 0 errstr errStr� �����
�� 
errn� o      ���� 0 errornumber errorNumber��  f r   � ���� b   � ���� b   � ���� m   � ��� ��� " D o e s   s c r o l l   v i e w  � o   � �����  0 scrollareaname scrollAreaName� m   � ��� ��� "   c o n t a i n   a   t a b l e ?� o      ���� 0 returnstring returnStringb   end tell table   c ���    e n d   t e l l   t a b l e` o   > ?���� "0 tablescrollarea tableScrollArea]   end tell scroll area   ^ ��� *   e n d   t e l l   s c r o l l   a r e a��  J R      ����
�� .ascrerr ****      � ****� o      ���� 0 errstr errStr� �����
�� 
errn� o      ���� 0 errornumber errorNumber��  K r   � ���� b   � ���� m   � ��� ��� : C a n t   f i n d   t h a t   s c r o l l   a r e a   -  � o   � ���  0 scrollareaname scrollAreaName� o      �~�~ 0 returnstring returnStringH o   $ %�}�} 0 win  E   end tell window   F ���     e n d   t e l l   w i n d o w��  9 R      �|��
�| .ascrerr ****      � ****� o      �{�{ 0 errstr errStr� �z��y
�z 
errn� o      �x�x 0 errornumber errorNumber�y  : r   � ���� b   � ���� m   � ��� ��� 0 C a n t   f i n d   t h a t   w i n d o w   -  � o   � ��w�w 0 windowtitle windowTitle� o      �v�v 0 returnstring returnString��  1 4    �u�
�u 
prcs� o    �t�t 0 appname appName.   end tell process   / ��� "   e n d   t e l l   p r o c e s s+ R      �s��
�s .ascrerr ****      � ****� o      �r�r 0 errstr errStr� �q��p
�q 
errn� o      �o�o 0 errornumber errorNumber�p  , r   � ���� b   � ���� m   � ��� ��� * C a n t   f i n d   t h a t   A p p   -  � o   � ��n�n 0 appname appName� o      �m�m 0 returnstring returnString) m    ���                                                                                  sevs  alis    �  HooDisk1                   �1��H+   
�System Events.app                                               
���85G        ����  	                CoreServices    �1��      �8'7     
� 
%� 
%�  6HooDisk1:System:Library:CoreServices:System Events.app  $  S y s t e m   E v e n t s . a p p    H o o D i s k 1  -System/Library/CoreServices/System Events.app   / ��  ' ��� L   � ��� o   � ��l�l 0 returnstring returnString� ��k� l  � ��j�i�h�j  �i  �h  �k   ��� l     �g�f�e�g  �f  �e  � ��� l     �d�c�b�d  �c  �b  � ��� l     �a�`�_�a  �`  �_  � ��� l     �^� �^  �   getCountOfRowsInTable     � ,   g e t C o u n t O f R o w s I n T a b l e�  l     �]�\�[�]  �\  �[    i     I      �Z�Y�Z .0 getcountofrowsintable getCountOfRowsInTable 	
	 o      �X�X 0 appname appName
  o      �W�W 0 windowtitle windowTitle �V o      �U�U  0 scrollareaname scrollAreaName�V  �Y   k     �  l     �T�S�R�T  �S  �R    l     �Q�Q   N H shit - now need to do the scroll pane stuff! just do table 1 of window!    � �   s h i t   -   n o w   n e e d   t o   d o   t h e   s c r o l l   p a n e   s t u f f !   j u s t   d o   t a b l e   1   o f   w i n d o w !  q       �P�O�P 0 returnstring returnString�O    r      m      � 
 n o E r r o      �N�N 0 returnstring returnString   O    �!"! Q    �#$%# l   �&'(& O    �)*) k    �++ ,-, r    ./. m    �M
�M boovtrue/ 1    �L
�L 
pisf- 0�K0 Q    �1231 k    �44 565 r    #787 e    !99 l   !:�J�I: 5    !�H;�G
�H 
cwin; o    �F�F 0 windowtitle windowTitle
�G kfrmname�J  �I  8 o      �E�E 0 win  6 <�D< l  $ �=>?= O   $ �@A@ Q   ( �BCDB k   + sEE FGF r   + =HIH 6  + ;JKJ 4 + /�CL
�C 
scraL m   - .�B�B K =  0 :MNM n   1 6OPO 1   4 6�A
�A 
valLP 4   1 4�@Q
�@ 
attrQ m   2 3RR �SS  A X D e s c r i p t i o nN o   7 9�?�?  0 scrollareaname scrollAreaNameI o      �>�> "0 tablescrollarea tableScrollAreaG T�=T l  > sUVWU O   > sXYX l  B rZ[\Z Q   B r]^_] O   E _`a` k   L ^bb cdc r   L Tefe l  L Rg�<�;g n   L Rhih 1   P R�:
�: 
valLi 4   L P�9j
�9 
attrj m   N Okk �ll  A X R o w s�<  �;  f o      �8�8 0 mumblemumble  d m�7m r   U ^non c   U \pqp l  U Zr�6�5r I  U Z�4s�3
�4 .corecnte****       ****s o   U V�2�2 0 mumblemumble  �3  �6  �5  q m   Z [�1
�1 
nmbro o      �0�0 0 returnstring returnString�7  a 4 E I�/t
�/ 
tabBt m   G H�.�. ^ R      �-uv
�- .ascrerr ****      � ****u o      �,�, 0 errstr errStrv �+w�*
�+ 
errnw o      �)�) 0 errornumber errorNumber�*  _ r   g rxyx b   g pz{z b   g l|}| m   g j~~ � " D o e s   s c r o l l   v i e w  } o   j k�(�(  0 scrollareaname scrollAreaName{ m   l o�� ��� "   c o n t a i n   a   t a b l e ?y o      �'�' 0 returnstring returnString[   end tell table   \ ���    e n d   t e l l   t a b l eY o   > ?�&�& "0 tablescrollarea tableScrollAreaV   end tell scroll area   W ��� *   e n d   t e l l   s c r o l l   a r e a�=  C R      �%��
�% .ascrerr ****      � ****� o      �$�$ 0 errstr errStr� �#��"
�# 
errn� o      �!�! 0 errornumber errorNumber�"  D r   { ���� b   { ���� m   { ~�� ��� : C a n t   f i n d   t h a t   s c r o l l   a r e a   -  � o   ~ � �   0 scrollareaname scrollAreaName� o      �� 0 returnstring returnStringA o   $ %�� 0 win  >   end tell window   ? ���     e n d   t e l l   w i n d o w�D  2 R      ���
� .ascrerr ****      � ****� o      �� 0 errstr errStr� ���
� 
errn� o      �� 0 errornumber errorNumber�  3 r   � ���� b   � ���� m   � ��� ��� 0 C a n t   f i n d   t h a t   w i n d o w   -  � o   � ��� 0 windowtitle windowTitle� o      �� 0 returnstring returnString�K  * 4    ��
� 
prcs� o    �� 0 appname appName'   end tell process   ( ��� "   e n d   t e l l   p r o c e s s$ R      ���
� .ascrerr ****      � ****� o      �� 0 errstr errStr� ���
� 
errn� o      �� 0 errornumber errorNumber�  % r   � ���� b   � ���� m   � ��� ��� * C a n t   f i n d   t h a t   A p p   -  � o   � ��� 0 appname appName� o      �� 0 returnstring returnString" m    ���                                                                                  sevs  alis    �  HooDisk1                   �1��H+   
�System Events.app                                               
���85G        ����  	                CoreServices    �1��      �8'7     
� 
%� 
%�  6HooDisk1:System:Library:CoreServices:System Events.app  $  S y s t e m   E v e n t s . a p p    H o o D i s k 1  -System/Library/CoreServices/System Events.app   / ��    ��� L   � ��� o   � ��� 0 returnstring returnString� ��� l  � ���
�	�  �
  �	  �   ��� l     ����  �  �  � ��� l     ����  �  �  �       ��������  � � ���������  &0 selectrowsintable selectRowsInTable�� $0 selectrowintable selectRowInTable�� 0 indexofitem indexOfItem�� .0 getselctedrowsintable getSelctedRowsInTable�� .0 getcountofrowsintable getCountOfRowsInTable� �� .���������� &0 selectrowsintable selectRowsInTable�� ����� �  �������� 0 appname appName�� 0 windowtitle windowTitle�� 0 rowindex rowIndex��  � ������������ 0 appname appName�� 0 windowtitle windowTitle�� 0 rowindex rowIndex�� 0 win  �� 0 thepos thePos� 4�������������� X����������
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
�� .EeEeeeEHnull���   @ long�� T� P*�/ He*�,FO*��0EE�O� 4*�k/ ,*�k/ $e*��/�,FO*�l/ *�,E�O��l OPUOPUUUUU� ��E���������� $0 selectrowintable selectRowInTable�� ����� �  ���������� 0 appname appName�� 0 windowtitle windowTitle��  0 scrollareaname scrollAreaName�� 0 rowindex rowIndex��  � 	�������������������� 0 appname appName�� 0 windowtitle windowTitle��  0 scrollareaname scrollAreaName�� 0 rowindex rowIndex�� 0 returnstring returnString�� 0 win  �� "0 tablescrollarea tableScrollArea�� 0 errstr errStr�� 0 errornumber errorNumber� X����������������������������������
�� 
prcs
�� 
pisf
�� 
cwin
�� kfrmname
�� 
scra�  
�� 
attr
�� 
valL
�� 
tabB
�� 
crow
�� 
nmbr
�� .miscslctuiel       uiel�� 0 errstr errStr� ������
�� 
errn�� 0 errornumber errorNumber��  �� ��E�O� � �*�/ �e*�,FO n*��0EE�O� ] N*�k/�[��/�,\Z�81E�O� 3  *�k/ e*��/�,FO*���&/j UW X  a �%a %E�UW X  a �%E�UW X  a �%E�UW X  a �%E�UO�OP� ������������� 0 indexofitem indexOfItem�� ����� �  ������ 0 theitem2 theItem2�� 0 thelist2 theList2��  � �������� 0 theitem2 theItem2�� 0 thelist2 theList2�� 0 i  � ����
�� .corecnte****       ****
�� 
cobj�� & !k�j  kh ��/�  �Y h[OY��Oi� ������������ .0 getselctedrowsintable getSelctedRowsInTable�� ����� �  �������� 0 appname appName�� 0 windowtitle windowTitle��  0 scrollareaname scrollAreaName��  � ���������������������������������� 0 appname appName�� 0 windowtitle windowTitle��  0 scrollareaname scrollAreaName�� 0 returnstring returnString�� 0 win  �� "0 tablescrollarea tableScrollArea�� 0 
tablecount 
tableCount�� 0 thetable theTable�� 0 allrows allRows�� 0 indexeslist indexesList�� 0 selectedrows selectedRows�� 0 i  �� 0 thisitem thisItem�� 0 theindex theIndex�� 0 errstr errStr�� 0 errornumber errorNumber� $��������������Y�����������������������
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
crow
�� 
selE
�� 
cobj�� 0 indexofitem indexOfItem�� 0 errstr errStr� ������
�� 
errn�� 0 errornumber errorNumber��  �� ��E�O� � �*�/ �e*�,FO �*��0EE�O� � �*�k/�[��/�,\Z�81E�O� � m*�-j E�O*�k/E�O� Te*��/�,FO*�-E�OjvE�O*�-�[�,\Ze81E�O )k�j kh �a �/E�O)��l+ E�O��6F[OY��O�OPUW X  a �%a %E�UW X  a �%E�UW X  a �%E�UW X  a �%E�UO�OP� ������������ .0 getcountofrowsintable getCountOfRowsInTable�� ����� �  �������� 0 appname appName�� 0 windowtitle windowTitle��  0 scrollareaname scrollAreaName��  � 	������������~�}�|�� 0 appname appName�� 0 windowtitle windowTitle��  0 scrollareaname scrollAreaName�� 0 returnstring returnString�� 0 win  � "0 tablescrollarea tableScrollArea�~ 0 mumblemumble  �} 0 errstr errStr�| 0 errornumber errorNumber� ��{�z�y�x�w��vR�u�tk�s�r�q�~����
�{ 
prcs
�z 
pisf
�y 
cwin
�x kfrmname
�w 
scra
�v 
attr
�u 
valL
�t 
tabB
�s .corecnte****       ****
�r 
nmbr�q 0 errstr errStr� �p�o�n
�p 
errn�o 0 errornumber errorNumber�n  �� ��E�O� � �*�/ �e*�,FO m*��0EE�O� \ M*�k/�[��/�,\Z�81E�O� 2 *�k/ *��/�,E�O�j �&E�UW X  a �%a %E�UW X  a �%E�UW X  a �%E�UW X  a �%E�UO�OPascr  ��ޭ