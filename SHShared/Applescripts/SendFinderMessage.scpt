FasdUAS 1.101.10   ��   ��    k             l     ��  ��    $  SendFinderMessage.applescript     � 	 	 <   S e n d F i n d e r M e s s a g e . a p p l e s c r i p t   
  
 l     ��  ��      InAppTests     �      I n A p p T e s t s      l     ��������  ��  ��        l     ��  ��    . (  Created by steve hooley on 07/01/2010.     �   P     C r e a t e d   b y   s t e v e   h o o l e y   o n   0 7 / 0 1 / 2 0 1 0 .      l     ��  ��    ; 5  Copyright 2010 BestBefore Ltd. All rights reserved.     �   j     C o p y r i g h t   2 0 1 0   B e s t B e f o r e   L t d .   A l l   r i g h t s   r e s e r v e d .      l     ��������  ��  ��        l     ��   ��    h b it is possible to get xcode to compile this for us in a custom build phase for better performance      � ! ! �   i t   i s   p o s s i b l e   t o   g e t   x c o d e   t o   c o m p i l e   t h i s   f o r   u s   i n   a   c u s t o m   b u i l d   p h a s e   f o r   b e t t e r   p e r f o r m a n c e   " # " l     ��������  ��  ��   #  $ % $ l     �� & '��   &  GUIScripting_status()    ' � ( ( * G U I S c r i p t i n g _ s t a t u s ( ) %  ) * ) l     �� + ,��   + H Bset menuEnabled to is_menu_enabled("Script Editor", "File", "New")    , � - - � s e t   m e n u E n a b l e d   t o   i s _ m e n u _ e n a b l e d ( " S c r i p t   E d i t o r " ,   " F i l e " ,   " N e w " ) *  . / . l     �� 0 1��   0 , &display dialog (menuEnabled as string)    1 � 2 2 L d i s p l a y   d i a l o g   ( m e n u E n a b l e d   a s   s t r i n g ) /  3 4 3 l     �� 5 6��   5  global isEnabled    6 � 7 7   g l o b a l   i s E n a b l e d 4  8 9 8 l     �� : ;��   :  set isEnabled to false    ; � < < , s e t   i s E n a b l e d   t o   f a l s e 9  = > = l     �� ? @��   ? / )tell application "InAppTests" to activate    @ � A A R t e l l   a p p l i c a t i o n   " I n A p p T e s t s "   t o   a c t i v a t e >  B C B l     �� D E��   D 2 ,menu_click({"Script Editor", "File", "New"})    E � F F X m e n u _ c l i c k ( { " S c r i p t   E d i t o r " ,   " F i l e " ,   " N e w " } ) C  G H G l     �� I J��   I   display dialog (isEnabled)    J � K K 4 d i s p l a y   d i a l o g   ( i s E n a b l e d ) H  L M L l     ��������  ��  ��   M  N O N l     �� P Q��   P * $do_menu("InAppTests", "File", "New")    Q � R R H d o _ m e n u ( " I n A p p T e s t s " ,   " F i l e " ,   " N e w " ) O  S T S l     �� U V��   U , &do_menu("InAppTests", "File", "Close")    V � W W L d o _ m e n u ( " I n A p p T e s t s " ,   " F i l e " ,   " C l o s e " ) T  X Y X l     ��������  ��  ��   Y  Z [ Z i      \ ] \ I      �� ^���� 0 show_message   ^  _�� _ o      ���� 0 user_message  ��  ��   ] O     
 ` a ` I   	�� b��
�� .sysodlogaskr        TEXT b o    ���� 0 user_message  ��   a m      c c�                                                                                  MACS  alis    Z  Snow                       �1��H+    ,
Finder.app                                                       ��ƘY�        ����  	                CoreServices    �1��      ƘK�      ,   �   �  +Snow:System:Library:CoreServices:Finder.app    
 F i n d e r . a p p  
  S n o w  &System/Library/CoreServices/Finder.app  / ��   [  d e d l     ��������  ��  ��   e  f g f i     h i h I      �� j���� 0 
menu_click   j  k�� k o      ���� 0 mlist mList��  ��   i k     T l l  m n m q       o o �� p�� 0 appname appName p �� q�� 0 topmenu topMenu q ������ 0 r  ��   n  r s r l     ��������  ��  ��   s  t u t l     �� v w��   v   Validate our input    w � x x &   V a l i d a t e   o u r   i n p u t u  y z y Z     { |���� { A      } ~ } n      �  1    ��
�� 
leng � o     ���� 0 mlist mList ~ m    ����  | R    �� ���
�� .ascrerr ****      � **** � m   
  � � � � � 8 M e n u   l i s t   i s   n o t   l o n g   e n o u g h��  ��  ��   z  � � � l   ��������  ��  ��   �  � � � l   �� � ���   � ; 5 Set these variables for clarity and brevity later on    � � � � j   S e t   t h e s e   v a r i a b l e s   f o r   c l a r i t y   a n d   b r e v i t y   l a t e r   o n �  � � � r    + � � � l    ����� � n     � � � 7  �� � �
�� 
cobj � m    ����  � m    ����  � o    ���� 0 mlist mList��  ��   � J       � �  � � � o      ���� 0 appname appName �  ��� � o      ���� 0 topmenu topMenu��   �  � � � r   , ; � � � l  , 9 ����� � n   , 9 � � � 7 - 9�� � �
�� 
cobj � m   1 3����  � l  4 8 ����� � n  4 8 � � � 1   6 8��
�� 
leng � o   4 6���� 0 mlist mList��  ��   � o   , -���� 0 mlist mList��  ��   � o      ���� 0 r   �  � � � l  < <��������  ��  ��   �  � � � l  < <�� � ���   � A ; This overly-long line calls the menu_recurse function with    � � � � v   T h i s   o v e r l y - l o n g   l i n e   c a l l s   t h e   m e n u _ r e c u r s e   f u n c t i o n   w i t h �  � � � l  < <�� � ���   � > 8 two arguments: r, and a reference to the top-level menu    � � � � p   t w o   a r g u m e n t s :   r ,   a n d   a   r e f e r e n c e   t o   t h e   t o p - l e v e l   m e n u �  ��� � O  < T � � � n  @ S � � � I   A S�� ����� 0 menu_click_recurse   �  � � � o   A B���� 0 r   �  ��� � l  B O ����� � n  B O � � � l  L O ����� � 4   L O�� �
�� 
menE � o   M N���� 0 topmenu topMenu��  ��   � n  B L � � � l  I L ����� � 4   I L�� �
�� 
mbri � o   J K���� 0 topmenu topMenu��  ��   � n  B I � � � l 	 F I ����� � l  F I ����� � 4   F I�� �
�� 
mbar � m   G H���� ��  ��  ��  ��   � l  B F ����� � 4   B F�� �
�� 
prcs � o   D E���� 0 appname appName��  ��  ��  ��  ��  ��   �  f   @ A � m   < = � ��                                                                                  sevs  alis    v  Snow                       �1��H+    ,System Events.app                                               +��85G        ����  	                CoreServices    �1��      �8'7      ,   �   �  2Snow:System:Library:CoreServices:System Events.app  $  S y s t e m   E v e n t s . a p p  
  S n o w  -System/Library/CoreServices/System Events.app   / ��  ��   g  � � � l     ��������  ��  ��   �  � � � i     � � � I      �� ����� 0 menu_click_recurse   �  � � � o      ���� 0 mlist mList �  ��� � o      ���� 0 parentobject parentObject��  ��   � k     J � �  � � � q       � � �� ��� 0 f   � ������ 0 r  ��   �  � � � l     ��������  ��  ��   �  � � � l     �� � ���   � , & `f` = first item, `r` = rest of items    � � � � L   ` f `   =   f i r s t   i t e m ,   ` r `   =   r e s t   o f   i t e m s �  � � � r      � � � n      � � � 4    � �
� 
cobj � m    �~�~  � o     �}�} 0 mlist mList � o      �|�| 0 f   �  � � � Z   " � ��{�z � ?     � � � n   
 � � � 1    
�y
�y 
leng � o    �x�x 0 mlist mList � m   
 �w�w  � r     � � � l    ��v�u � n     � � � 7  �t � �
�t 
cobj � m    �s�s  � l    ��r�q � n    � � � 1    �p
�p 
leng � o    �o�o 0 mlist mList�r  �q   � o    �n�n 0 mlist mList�v  �u   � o      �m�m 0 r  �{  �z   �  � � � l  # #�l�k�j�l  �k  �j   �  � � � l  # #�i � ��i   � < 6 either actually click the menu item, or recurse again    � � � � l   e i t h e r   a c t u a l l y   c l i c k   t h e   m e n u   i t e m ,   o r   r e c u r s e   a g a i n �  �h  O   # J Z   ' I�g =  ' , n  ' *	 1   ( *�f
�f 
leng	 o   ' (�e�e 0 mlist mList m   * +�d�d  k   / 9

  l  / /�c�c   A ;	set isEnabled to get enabled of parentObject's menu item f    � v 	 s e t   i s E n a b l e d   t o   g e t   e n a b l e d   o f   p a r e n t O b j e c t ' s   m e n u   i t e m   f  I  / 7�b�a
�b .prcsclicuiel    ��� uiel n  / 3 4   0 3�`
�` 
menI o   1 2�_�_ 0 f   o   / 0�^�^ 0 parentobject parentObject�a   �] l  8 8�\�\    		delay 10    �  	 d e l a y   1 0�]  �g   n  < I I   = I�[�Z�[ 0 menu_click_recurse    o   = >�Y�Y 0 r   �X l  > E �W�V  n  > E!"! l  B E#�U�T# 4   B E�S$
�S 
menE$ o   C D�R�R 0 f  �U  �T  " n  > B%&% l  ? B'�Q�P' 4   ? B�O(
�O 
menI( o   @ A�N�N 0 f  �Q  �P  & o   > ?�M�M 0 parentobject parentObject�W  �V  �X  �Z    f   < = m   # $))�                                                                                  sevs  alis    v  Snow                       �1��H+    ,System Events.app                                               +��85G        ����  	                CoreServices    �1��      �8'7      ,   �   �  2Snow:System:Library:CoreServices:System Events.app  $  S y s t e m   E v e n t s . a p p  
  S n o w  -System/Library/CoreServices/System Events.app   / ��  �h   � *+* l     �L�K�J�L  �K  �J  + ,-, i    ./. I      �I0�H�I 0 is_menu_enabled  0 121 o      �G�G 0 app_name  2 343 o      �F�F 0 	menu_name  4 5�E5 o      �D�D 0 	menu_item  �E  �H  / k    �66 787 l     �C�B�A�C  �B  �A  8 9:9 r     ;<; m     == �>>  F a i l e d< o      �@�@ 0 returnstring returnString: ?@? Q   �ABCA k   �DD EFE l   �?�>�=�?  �>  �=  F GHG l   �<IJ�<  I &  set appToTest to "Script Editor"   J �KK @ s e t   a p p T o T e s t   t o   " S c r i p t   E d i t o r "H LML r    
NON o    �;�; 0 app_name  O o      �:�: 0 	apptotest 	appToTestM PQP I   �9R�8
�9 .miscactvnull��� ��� nullR 4    �7S
�7 
cappS o    �6�6 0 	apptotest 	appToTest�8  Q TUT O   !VWV I    �5�4�3
�5 .miscactvnull��� ��� null�4  �3  W 4    �2X
�2 
cappX o    �1�1 0 	apptotest 	appToTestU YZY l  " "�0�/�.�0  �/  �.  Z [\[ p   " "]] �-�,�- 0 position  �,  \ ^_^ l  " "�+�*�)�+  �*  �)  _ `a` l  "8bcdb O   "8efe k   &7gg hih Z   &.jk�(lj 1   & *�'
�' 
uienk O   -&mnm k   4%oo pqp r   4 9rsr m   4 5�&
�& boovtrues 1   5 8�%
�% 
pisfq tut l  : :�$�#�"�$  �#  �"  u vwv l  : :�!xy�!  x + % insert GUI Scripting statements here   y �zz J   i n s e r t   G U I   S c r i p t i n g   s t a t e m e n t s   h e r ew {|{ l  : :� ���   �  �  | }~} l  : :���     select menu bar   � ���     s e l e c t   m e n u   b a r~ ��� U   : q��� Q   A l���� k   D Z�� ��� O  D Q��� I  K P���
� .miscactvnull��� ��� null�  �  � 4   D H��
� 
capp� o   F G�� 0 	apptotest 	appToTest� ��� r   R X��� l  R V���� 4   R V��
� 
mbar� m   T U�� �  �  � o      �� 0 
themenubar 
theMenuBar� ���  S   Y Z�  � R      ���
� .ascrerr ****      � ****� o      �� 0 error_message  �  � O  b l��� I  f k���
� .ascrcmnt****      � ****� m   f g�� ��� " c a n t   g e t   m e n u   b a r�  � m   b c���                                                                                  MACS  alis    Z  Snow                       �1��H+    ,
Finder.app                                                       ��ƘY�        ����  	                CoreServices    �1��      ƘK�      ,   �   �  +Snow:System:Library:CoreServices:Finder.app    
 F i n d e r . a p p  
  S n o w  &System/Library/CoreServices/Finder.app  / ��  � m   = >�� 
� ��� l  r r����  �  		click theMenuBar   � ��� $ 	 	 c l i c k   t h e M e n u B a r� ��� I  r z�
��	
�
 .prcsclicuiel    ��� uiel� 4   r v��
� 
cwin� m   t u�� �	  � ��� I  { ����
� .prcskprsnull���    utxt� o   { ~�
� 
ret �  � ��� l  � �����  �  �  � ��� O   �#��� k   �"�� ��� r   � ���� 4   � �� �
�  
mbri� m   � ��� ���  F i l e� o      ���� 0 bra  � ��� U   � ���� k   � ��� ��� I  � ������
�� .prcsclicuiel    ��� uiel� o   � ����� 0 bra  ��  � ��� I  � ������
�� .sysodelanull��� ��� nmbr� m   � ����� ��  � ��� I  � ������
�� .prcskprsnull���    utxt� o   � ���
�� 
ret ��  � ��� I  � ������
�� .prcsclicuiel    ��� uiel� o   � ����� 0 bra  ��  � ��� I  � ������
�� .sysodelanull��� ��� nmbr� m   � ����� ��  � ���� l  � ���������  ��  ��  ��  � m   � ����� � ��� I  � ������
�� .prcskprsnull���    utxt� o   � ���
�� 
ret ��  � ��� l  � ���������  ��  ��  � ��� r   � ���� 1   � ���
�� 
posn� J      �� ��� o      ���� 0 	xposition 	xPosition� ���� o      ���� 0 	yposition 	yPosition��  � ��� l  � ���������  ��  ��  � ��� r   � ���� 1   � ���
�� 
ptsz� J      �� ��� o      ���� 0 xsize xSize� ���� o      ���� 0 ysize ySize��  � ��� r   ���� l  � ������ n   � ��� 4   � ���
�� 
menE� m   � ����� � o   � ����� 0 bra  ��  ��  � o      ���� 0 theinnermenu theInnerMenu� ��� O   ��� k  �� ��� r  ��� l ������ 4  ���
�� 
menI� m  �� ���  N e w��  ��  � o      ����  0 thedesireditem theDesiredItem� ���� O  ��� r  ��� e  �� 1  ��
�� 
enaB� o      ���� .0 thedesireditemenabled theDesiredItemEnabled� o  ����  0 thedesireditem theDesiredItem��  � o  ���� 0 theinnermenu theInnerMenu� ��� l !!��������  ��  ��  �  ��  l !!����   , &	 press menu item   "File" of menu bar    � L 	   p r e s s   m e n u   i t e m       " F i l e "   o f   m e n u   b a r��  � o   � ����� 0 
themenubar 
theMenuBar�  l $$����   : 4	set menuBarChildren to the every item of menu bar 1    � h 	 s e t   m e n u B a r C h i l d r e n   t o   t h e   e v e r y   i t e m   o f   m e n u   b a r   1 	
	 l $$����   8 2		set whatInTheWorld to the first item of menu bar    � d 	 	 s e t   w h a t I n T h e W o r l d   t o   t h e   f i r s t   i t e m   o f   m e n u   b a r
  l $$����   + %		return the whatInTheWorld as string    � J 	 	 r e t u r n   t h e   w h a t I n T h e W o r l d   a s   s t r i n g  l $$����   7 1set aMenuItem to menu bar item "File" of menu bar    � b s e t   a M e n u I t e m   t o   m e n u   b a r   i t e m   " F i l e "   o f   m e n u   b a r �� l $$����   H B		set menuname to get name of menu item "New" of menu of aMenuItem    � � 	 	 s e t   m e n u n a m e   t o   g e t   n a m e   o f   m e n u   i t e m   " N e w "   o f   m e n u   o f   a M e n u I t e m��  n 4   - 1��
�� 
pcap o   / 0���� 0 	apptotest 	appToTest�(  l I ).������
�� .sysobeepnull��� ��� long��  ��  i  l //�� ��   * $	display dialog (position as string)     �!! H 	 d i s p l a y   d i a l o g   ( p o s i t i o n   a s   s t r i n g ) "#" l //��������  ��  ��  # $%$ l //��&'��  & F @	click at {xPosition + (xSize div 2), yPosition + (ySize div 2)}   ' �(( � 	 c l i c k   a t   { x P o s i t i o n   +   ( x S i z e   d i v   2 ) ,   y P o s i t i o n   +   ( y S i z e   d i v   2 ) }% )*) l //��������  ��  ��  * +,+ L  /5-- c  /4./. o  /0���� .0 thedesireditemenabled theDesiredItemEnabled/ m  03��
�� 
TEXT, 0��0 l 66��������  ��  ��  ��  f m   " #11�                                                                                  sevs  alis    v  Snow                       �1��H+    ,System Events.app                                               +��85G        ����  	                CoreServices    �1��      �8'7      ,   �   �  2Snow:System:Library:CoreServices:System Events.app  $  S y s t e m   E v e n t s . a p p  
  S n o w  -System/Library/CoreServices/System Events.app   / ��  c   end tell system events?   d �22 0   e n d   t e l l   s y s t e m   e v e n t s ?a 343 l 99��������  ��  ��  4 565 l 99��78��  7 0 * bring the target application to the front   8 �99 T   b r i n g   t h e   t a r g e t   a p p l i c a t i o n   t o   t h e   f r o n t6 :;: O  9F<=< I @E������
�� .miscactvnull��� ��� null��  ��  = 4  9=��>
�� 
capp> o  ;<���� 0 app_name  ; ?@? O  G�ABA O  K�CDC k  T�EE FGF r  TYHIH m  TU��
�� boovtrueI 1  UX��
�� 
pisfG JKJ l ZZ��������  ��  ��  K LML r  Z_NON 1  Z]��
�� 
pisfO o      ���� 0 amifront amIFrontM PQP Z  `nRS����R = `cTUT o  `a���� 0 amifront amIFrontU m  ab��
�� boovfalsS L  fjVV m  fiWW �XX < w a n k e r   -   a p p   i s n t   a t   t h e   f r o n t��  ��  Q YZY l oo��[\��  [ . (	tell menu bar 0 to click menu menu_name   \ �]] P 	 t e l l   m e n u   b a r   0   t o   c l i c k   m e n u   m e n u _ n a m eZ ^_^ r  o�`a` e  o�bb n  o�cdc 1  ����
�� 
pnamd n  o�efe 4  ���g
�� 
menIg m  ��hh �ii  N e wf n  ojkj 4  z��l
�� 
menEl m  }~����  k n  ozmnm 4  sz��o
�� 
mbrio m  vypp �qq  F i l en 4  os��r
�� 
mbarr m  qr���� a o      ���� 0 menuname  _ sts L  ��uu c  ��vwv o  ������ 0 menuname  w m  ����
�� 
TEXTt xyx l ����z{��  z ) #		set mainMenuBar to the menu bar 0   { �|| F 	 	 s e t   m a i n M e n u B a r   t o   t h e   m e n u   b a r   0y }~} l �������   3 -		return the (count of mainMenuBar) as string   � ��� Z 	 	 r e t u r n   t h e   ( c o u n t   o f   m a i n M e n u B a r )   a s   s t r i n g~ ��� l ��������  � 8 2		set theMenu to the menu menu_name of mainMenuBar   � ��� d 	 	 s e t   t h e M e n u   t o   t h e   m e n u   m e n u _ n a m e   o f   m a i n M e n u B a r� ��� l ��������  � = 7		set theMenuItem to the menu item menu_item of theMenu   � ��� n 	 	 s e t   t h e M e n u I t e m   t o   t h e   m e n u   i t e m   m e n u _ i t e m   o f   t h e M e n u� ��� l ��������  � 5 /		set isEnabled to the AXEnabled of theMenuItem   � ��� ^ 	 	 s e t   i s E n a b l e d   t o   t h e   A X E n a b l e d   o f   t h e M e n u I t e m� ��� l ��������  �  		keystroke return   � ��� $ 	 	 k e y s t r o k e   r e t u r n� ��� l ����������  ��  ��  � ���� l ��������  � % 		set returnString to isEnabled   � ��� > 	 	 s e t   r e t u r n S t r i n g   t o   i s E n a b l e d��  D 4  KQ���
�� 
prcs� o  OP���� 0 app_name  B m  GH���                                                                                  sevs  alis    v  Snow                       �1��H+    ,System Events.app                                               +��85G        ����  	                CoreServices    �1��      �8'7      ,   �   �  2Snow:System:Library:CoreServices:System Events.app  $  S y s t e m   E v e n t s . a p p  
  S n o w  -System/Library/CoreServices/System Events.app   / ��  @ ��� L  ���� m  ���~
�~ boovfals�  B R      �}��|
�} .ascrerr ****      � ****� o      �{�{ 0 error_message  �|  C r  ����� c  ����� o  ���z�z 0 error_message  � m  ���y
�y 
TEXT� o      �x�x 0 returnstring returnString@ ��w� L  ���� o  ���v�v 0 returnstring returnString�w  - ��� l     �u�t�s�u  �t  �s  � ��� l     �r���r  � Y S Selecting a Menu Item - A sub-routine for selecting a menu item in an application:   � ��� �   S e l e c t i n g   a   M e n u   I t e m   -   A   s u b - r o u t i n e   f o r   s e l e c t i n g   a   m e n u   i t e m   i n   a n   a p p l i c a t i o n :� ��� i    ��� I      �q��p�q 0 do_menu  � ��� o      �o�o 0 app_name  � ��� o      �n�n 0 	menu_name  � ��m� o      �l�l 0 	menu_item  �m  �p  � Q     K���� k    A�� ��� l   �k���k  � 0 * bring the target application to the front   � ��� T   b r i n g   t h e   t a r g e t   a p p l i c a t i o n   t o   t h e   f r o n t� ��� O    ��� I  
 �j�i�h
�j .miscactvnull��� ��� null�i  �h  � 4    �g�
�g 
capp� o    �f�f 0 app_name  � ��� O    >��� O    =��� O    <��� O   # ;��� O   * :��� I  1 9�e��d
�e .prcsclicuiel    ��� uiel� 4   1 5�c�
�c 
menI� o   3 4�b�b 0 	menu_item  �d  � 4   * .�a�
�a 
menE� o   , -�`�` 0 	menu_name  � 4   # '�_�
�_ 
mbri� o   % &�^�^ 0 	menu_name  � 4     �]�
�] 
mbar� m    �\�\ � 4    �[�
�[ 
prcs� o    �Z�Z 0 app_name  � m    ���                                                                                  sevs  alis    v  Snow                       �1��H+    ,System Events.app                                               +��85G        ����  	                CoreServices    �1��      �8'7      ,   �   �  2Snow:System:Library:CoreServices:System Events.app  $  S y s t e m   E v e n t s . a p p  
  S n o w  -System/Library/CoreServices/System Events.app   / ��  � ��Y� L   ? A�� m   ? @�X
�X boovtrue�Y  � R      �W��V
�W .ascrerr ****      � ****� o      �U�U 0 error_message  �V  � L   I K�� m   I J�T
�T boovfals� ��� l     �S�R�Q�S  �R  �Q  � ��P� i    ��� I      �O�N�M�O *0 guiscripting_status GUIScripting_status�N  �M  � k     =�� ��� l     �L���L  � 3 - check to see if assistive devices is enabled   � ��� Z   c h e c k   t o   s e e   i f   a s s i s t i v e   d e v i c e s   i s   e n a b l e d� ��� O     
��� r    	��� 1    �K
�K 
uien� o      �J�J 0 
ui_enabled 
UI_enabled� m     ���                                                                                  sevs  alis    v  Snow                       �1��H+    ,System Events.app                                               +��85G        ����  	                CoreServices    �1��      �8'7      ,   �   �  2Snow:System:Library:CoreServices:System Events.app  $  S y s t e m   E v e n t s . a p p  
  S n o w  -System/Library/CoreServices/System Events.app   / ��  � ��I� Z    =���H�G� =   ��� o    �F�F 0 
ui_enabled 
UI_enabled� m    �E
�E boovfals� O    9��� k    8�� ��� I   �D�C�B
�D .miscactvnull��� ��� null�C  �B  � ��� r    $��� 5     �A��@
�A 
xppb� m    �� ��� H c o m . a p p l e . p r e f e r e n c e . u n i v e r s a l a c c e s s
�@ kfrmID  � 1     #�?
�? 
xpcp�  �>  I  % 8�=
�= .sysodlogaskr        TEXT b   % , b   % * b   % ( m   % &		 �

 � T h i s   s c r i p t   u t i l i z e s   t h e   b u i l t - i n   G r a p h i c   U s e r   I n t e r f a c e   S c r i p t i n g   a r c h i t e c t u r e   o f   M a c   O S   x   w h i c h   i s   c u r r e n t l y   d i s a b l e d . o   & '�<
�< 
ret  o   ( )�;
�; 
ret  m   * + � Y o u   c a n   a c t i v a t e   G U I   S c r i p t i n g   b y   s e l e c t i n g   t h e   c h e c k b o x   " E n a b l e   a c c e s s   f o r   a s s i s t i v e   d e v i c e s "   i n   t h e   U n i v e r s a l   A c c e s s   p r e f e r e n c e   p a n e . �:
�: 
disp m   - .�9�9  �8
�8 
btns J   / 2 �7 m   / 0 �  C a n c e l�7   �6�5
�6 
dflt m   3 4�4�4 �5  �>  � m    �                                                                                  sprf  alis    d  Snow                       �1��H+    4System Preferences.app                                          +��kv        ����  	                Applications    �1��      �kh      4  (Snow:Applications:System Preferences.app  .  S y s t e m   P r e f e r e n c e s . a p p  
  S n o w  #Applications/System Preferences.app   / ��  �H  �G  �I  �P       �3�3   �2�1�0�/�.�-�2 0 show_message  �1 0 
menu_click  �0 0 menu_click_recurse  �/ 0 is_menu_enabled  �. 0 do_menu  �- *0 guiscripting_status GUIScripting_status �, ]�+�*�)�, 0 show_message  �+ �( �(    �'�' 0 user_message  �*   �&�& 0 user_message    c�%
�% .sysodlogaskr        TEXT�) � �j U �$ i�#�"!"�!�$ 0 
menu_click  �# � #�  #  �� 0 mlist mList�"  ! ����� 0 mlist mList� 0 appname appName� 0 topmenu topMenu� 0 r  " 	� �� ������
� 
leng
� 
cobj
� 
prcs
� 
mbar
� 
mbri
� 
menE� 0 menu_click_recurse  �! U��,m 	)j�Y hO�[�\[Zk\Zl2E[�k/E�Z[�l/E�ZO�[�\[Zm\Z��,2E�O� )�*�/�k/�/�/l+ U � ���$%�� 0 menu_click_recurse  � �&� &  ��� 0 mlist mList� 0 parentobject parentObject�  $ ���
�	� 0 mlist mList� 0 parentobject parentObject�
 0 f  �	 0 r  % ��)����
� 
cobj
� 
leng
� 
menI
� .prcsclicuiel    ��� uiel
� 
menE� 0 menu_click_recurse  � K��k/E�O��,k �[�\[Zl\Z��,2E�Y hO� $��,k  ��/j OPY )���/�/l+ U �/�� '(��� 0 is_menu_enabled  � ��)�� )  �������� 0 app_name  �� 0 	menu_name  �� 0 	menu_item  �   ' ������������������������������������ 0 app_name  �� 0 	menu_name  �� 0 	menu_item  �� 0 returnstring returnString�� 0 	apptotest 	appToTest�� 0 
themenubar 
theMenuBar�� 0 error_message  �� 0 bra  �� 0 	xposition 	xPosition�� 0 	yposition 	yPosition�� 0 xsize xSize�� 0 ysize ySize�� 0 theinnermenu theInnerMenu��  0 thedesireditem theDesiredItem�� .0 thedesireditemenabled theDesiredItemEnabled�� 0 amifront amIFront�� 0 menuname  ( #=����1��������������������������������������������������Wph��
�� 
capp
�� .miscactvnull��� ��� null
�� 
uien
�� 
pcap
�� 
pisf�� 

�� 
mbar�� 0 error_message  ��  
�� .ascrcmnt****      � ****
�� 
cwin
�� .prcsclicuiel    ��� uiel
�� 
ret 
�� .prcskprsnull���    utxt
�� 
mbri
�� .sysodelanull��� ��� nmbr
�� 
posn
�� 
cobj
�� 
ptsz
�� 
menE
�� 
menI
�� 
enaB
�� .sysobeepnull��� ��� long
�� 
TEXT
�� 
prcs
�� 
pnam����E�O��E�O*�/j O*�/ *j UO�*�,E �*�/ �e*�,FO 6�kh *�/ *j UO*�k/E�OW X 	 
� �j U[OY��O*�k/j O_ j O� �*a a /E�O ,kkh�j Omj O_ j O�j Omj OP[OY��O_ j O*a ,E[a k/E�Z[a l/E�ZO*a ,E[a k/E�Z[a l/E�ZO�a k/E�O� *a a /E�O� 
*a ,EE�UUOPUOPUY *j O�a &OPUO*�/ *j UO� R*a �/ He*�,FO*�,E�O�f  	a Y hO*�k/a a  /a j/a a !/a ",EE^ O] a &OPUUOfW X 	 
�a &E�O� �������*+���� 0 do_menu  �� ��,�� ,  �������� 0 app_name  �� 0 	menu_name  �� 0 	menu_item  ��  * ���������� 0 app_name  �� 0 	menu_name  �� 0 	menu_item  �� 0 error_message  + ���������������������
�� 
capp
�� .miscactvnull��� ��� null
�� 
prcs
�� 
mbar
�� 
mbri
�� 
menE
�� 
menI
�� .prcsclicuiel    ��� uiel�� 0 error_message  ��  �� L C*�/ *j UO� **�/ "*�k/ *�/ *�/ 
*�/j UUUUUOeW 	X 	 
f �������-.���� *0 guiscripting_status GUIScripting_status��  ��  - ���� 0 
ui_enabled 
UI_enabled. ������������	������������
�� 
uien
�� .miscactvnull��� ��� null
�� 
xppb
�� kfrmID  
�� 
xpcp
�� 
ret 
�� 
disp
�� 
btns
�� 
dflt�� 
�� .sysodlogaskr        TEXT�� >� *�,E�UO�f  -� %*j O*���0*�,FO��%�%�%�k��kv�k� UY hascr  ��ޭ