FasdUAS 1.101.10   ��   ��    k             l     ��  ��      TEST     � 	 	 
   T E S T   
  
 l     ��  ��    1 +open_mainmenu_item("Script Editor", "File")     �   V o p e n _ m a i n m e n u _ i t e m ( " S c r i p t   E d i t o r " ,   " F i l e " )      l     ��  ��    A ;set aVar to is_menu_enabled("Script Editor", "File", "New")     �   v s e t   a V a r   t o   i s _ m e n u _ e n a b l e d ( " S c r i p t   E d i t o r " ,   " F i l e " ,   " N e w " )      l     ��  ��    % display dialog (aVar as string)     �   > d i s p l a y   d i a l o g   ( a V a r   a s   s t r i n g )      l     ��������  ��  ��        l     ��  ��    . ( open a meni such as 'File', 'View', etc     �   P   o p e n   a   m e n i   s u c h   a s   ' F i l e ' ,   ' V i e w ' ,   e t c     !   i      " # " I      �� $���� 0 open_mainmenu_item   $  % & % o      ���� 0 app_name   &  '�� ' o      ���� 0 	menu_name  ��  ��   # k      ( (  ) * ) O     + , + I   ������
�� .miscactvnull��� ��� null��  ��   , 4     �� -
�� 
capp - o    ���� 0 app_name   *  .�� . I    �� /���� 0 
menu_click   /  0�� 0 J     1 1  2 3 2 o    ���� 0 app_name   3  4�� 4 o    ���� 0 	menu_name  ��  ��  ��  ��   !  5 6 5 l     ��������  ��  ��   6  7 8 7 i     9 : 9 I      �� ;���� 0 is_menu_enabled   ;  < = < o      ���� 0 app_name   =  > ? > o      ���� 0 	menu_name   ?  @�� @ o      ���� 0 	menu_item  ��  ��   : k      A A  B C B O     D E D I   ������
�� .miscactvnull��� ��� null��  ��   E 4     �� F
�� 
capp F o    ���� 0 app_name   C  G�� G L     H H n    I J I I    �� K���� 0 	isenabled 	isEnabled K  L�� L J     M M  N O N o    ���� 0 app_name   O  P Q P o    ���� 0 	menu_name   Q  R�� R o    ���� 0 	menu_item  ��  ��  ��   J  f    ��   8  S T S l     ��������  ��  ��   T  U V U i     W X W I      �� Y���� 0 	isenabled 	isEnabled Y  Z�� Z o      ���� 0 mlist mList��  ��   X k     [ [ [  \ ] \ Z     ^ _���� ^ A      ` a ` n     b c b 1    ��
�� 
leng c o     ���� 0 mlist mList a m    ����  _ R    �� d��
�� .ascrerr ****      � **** d m   
  e e � f f 8 M e n u   l i s t   i s   n o t   l o n g   e n o u g h��  ��  ��   ]  g h g l   ��������  ��  ��   h  i j i q     k k �� l�� 0 
returnflag 
returnFlag l �� m�� 0 appname appName m �� n�� 0 topmenu topMenu n ������ 0 r  ��   j  o p o r    + q r q l    s���� s n     t u t 7  �� v w
�� 
cobj v m    ����  w m    ����  u o    ���� 0 mlist mList��  ��   r J       x x  y z y o      ���� 0 appname appName z  {�� { o      ���� 0 topmenu topMenu��   p  | } | r   , ; ~  ~ l  , 9 ����� � n   , 9 � � � 7 - 9�� � �
�� 
cobj � m   1 3����  � l  4 8 ����� � n  4 8 � � � 1   6 8��
�� 
leng � o   4 6���� 0 mlist mList��  ��   � o   , -���� 0 mlist mList��  ��    o      ���� 0 r   }  � � � O   < V � � � r   @ U � � � n  @ S � � � I   A S�� ����� 0 menu_enabled_recurse   �  � � � o   A B���� 0 r   �  ��� � n  B O � � � l  L O ����� � 4   L O�� �
�� 
menE � o   M N���� 0 topmenu topMenu��  ��   � n  B L � � � l  I L ����� � 4   I L�� �
�� 
mbri � o   J K���� 0 topmenu topMenu��  ��   � n  B I � � � l  F I ����� � 4   F I�� �
�� 
mbar � m   G H���� ��  ��   � l  B F ����� � 4   B F�� �
�� 
prcs � o   D E���� 0 appname appName��  ��  ��  ��   �  f   @ A � o      ���� 0 
returnflag 
returnFlag � m   < = � ��                                                                                  sevs   alis    �  Leopard                    ��T�H+   3��System Events.app                                               4���S        ����  	                CoreServices    ��F�      ��C     3�� 3� 3�  5Leopard:System:Library:CoreServices:System Events.app   $  S y s t e m   E v e n t s . a p p    L e o p a r d  -System/Library/CoreServices/System Events.app   / ��   �  ��� � L   W [ � � c   W Z � � � o   W X���� 0 
returnflag 
returnFlag � m   X Y��
�� 
TEXT��   V  � � � l     ��������  ��  ��   �  � � � i     � � � I      �� ����� 0 menu_enabled_recurse   �  � � � o      ���� 0 mlist mList �  ��� � o      ���� 0 parentobject parentObject��  ��   � k     L � �  � � � l     ��������  ��  ��   �  � � � q       � � �� ��� 0 f   � ������ 0 r  ��   �  � � � l     �� � ���   � , & `f` = first item, `r` = rest of items    � � � � L   ` f `   =   f i r s t   i t e m ,   ` r `   =   r e s t   o f   i t e m s �  � � � r      � � � n      � � � 4    � �
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
leng � o    �o�o 0 mlist mList�r  �q   � o    �n�n 0 mlist mList�v  �u   � o      �m�m 0 r  �{  �z   �  � � � l  # #�l � ��l   � < 6 either actually click the menu item, or recurse again    � � � � l   e i t h e r   a c t u a l l y   c l i c k   t h e   m e n u   i t e m ,   o r   r e c u r s e   a g a i n �  � � � O   # I � � � Z   ' H � ��k � � =  ' , � � � n  ' * � � � 1   ( *�j
�j 
leng � o   ' (�i�i 0 mlist mList � m   * +�h�h  � L   / 7 � � n   / 6 � � � 1   3 5�g
�g 
enaB � n  / 3 � � � 4   0 3�f �
�f 
menI � o   1 2�e�e 0 f   � o   / 0�d�d 0 parentobject parentObject�k   � L   : H � � I   : G�c ��b�c 0 menu_enabled_recurse   �  � � � o   ; <�a�a 0 r   �  ��` � l  < C ��_�^ � n  < C � � � l  @ C ��]�\ � 4   @ C�[ �
�[ 
menE � o   A B�Z�Z 0 f  �]  �\   � n  < @ � � � l  = @ ��Y�X � 4   = @�W �
�W 
menI � o   > ?�V�V 0 f  �Y  �X   � o   < =�U�U 0 parentobject parentObject�_  �^  �`  �b   � m   # $ � ��                                                                                  sevs   alis    �  Leopard                    ��T�H+   3��System Events.app                                               4���S        ����  	                CoreServices    ��F�      ��C     3�� 3� 3�  5Leopard:System:Library:CoreServices:System Events.app   $  S y s t e m   E v e n t s . a p p    L e o p a r d  -System/Library/CoreServices/System Events.app   / ��   �  ��T � L   J L � � m   J K�S
�S boovfals�T   �  � � � l     �R�Q�P�R  �Q  �P   �  �  � i     I      �O�N�O 0 
menu_click   �M o      �L�L 0 mlist mList�M  �N   k     /  q       �K	�K 0 appname appName	 �J
�J 0 topmenu topMenu
 �I�H�I 0 r  �H    l     �G�F�E�G  �F  �E    l     �D�D   ; 5 Set these variables for clarity and brevity later on    � j   S e t   t h e s e   v a r i a b l e s   f o r   c l a r i t y   a n d   b r e v i t y   l a t e r   o n  r      l    �C�B n      7  �A
�A 
cobj m    �@�@  m    
�?�?  o     �>�> 0 mlist mList�C  �B   J        o      �=�= 0 appname appName �< o      �;�; 0 topmenu topMenu�<     l   �:!"�:  ! : 4set r to (items 3 through (mList's length) of mList)   " �## h s e t   r   t o   ( i t e m s   3   t h r o u g h   ( m L i s t ' s   l e n g t h )   o f   m L i s t )  $%$ l   �9�8�7�9  �8  �7  % &'& l   �6()�6  ( A ; This overly-long line calls the menu_recurse function with   ) �** v   T h i s   o v e r l y - l o n g   l i n e   c a l l s   t h e   m e n u _ r e c u r s e   f u n c t i o n   w i t h' +,+ l   �5-.�5  - > 8 two arguments: r, and a reference to the top-level menu   . �// p   t w o   a r g u m e n t s :   r ,   a n d   a   r e f e r e n c e   t o   t h e   t o p - l e v e l   m e n u, 0�40 O   /121 n   .343 I     .�35�2�3 0 menu_click_recurse  5 6�16 n    *787 l  ' *9�0�/9 4   ' *�.:
�. 
mbri: o   ( )�-�- 0 topmenu topMenu�0  �/  8 n    ';<; l  $ '=�,�+= 4   $ '�*>
�* 
mbar> m   % &�)�) �,  �+  < l    $?�(�'? 4     $�&@
�& 
prcs@ o   " #�%�% 0 appname appName�(  �'  �1  �2  4  f     2 m    AA�                                                                                  sevs   alis    �  Leopard                    ��T�H+   3��System Events.app                                               4���S        ����  	                CoreServices    ��F�      ��C     3�� 3� 3�  5Leopard:System:Library:CoreServices:System Events.app   $  S y s t e m   E v e n t s . a p p    L e o p a r d  -System/Library/CoreServices/System Events.app   / ��  �4    BCB l     �$�#�"�$  �#  �"  C D�!D i    EFE I      � G��  0 menu_click_recurse  G H�H o      �� 0 parentobject parentObject�  �  F k     II JKJ l     �LM�  L  
local f, r   M �NN  l o c a l   f ,   rK OPO l     ����  �  �  P QRQ l     �ST�  S , & `f` = first item, `r` = rest of items   T �UU L   ` f `   =   f i r s t   i t e m ,   ` r `   =   r e s t   o f   i t e m sR VWV l     �XY�  X  set f to item 1 of mList   Y �ZZ 0 s e t   f   t o   i t e m   1   o f   m L i s tW [\[ l     �]^�  ] V P	if mList's length > 1 then set r to (items 2 through (mList's length) of mList)   ^ �__ � 	 i f   m L i s t ' s   l e n g t h   >   1   t h e n   s e t   r   t o   ( i t e m s   2   t h r o u g h   ( m L i s t ' s   l e n g t h )   o f   m L i s t )\ `a` l     ����  �  �  a bcb l     �de�  d < 6 either actually click the menu item, or recurse again   e �ff l   e i t h e r   a c t u a l l y   c l i c k   t h e   m e n u   i t e m ,   o r   r e c u r s e   a g a i nc g�g O     hih k    jj klk l   �mn�  m " 	if mList's length is 1 then   n �oo 8 	 i f   m L i s t ' s   l e n g t h   i s   1   t h e nl pqp l   �rs�  r A ;	set isEnabled to get enabled of parentObject's menu item f   s �tt v 	 s e t   i s E n a b l e d   t o   g e t   e n a b l e d   o f   p a r e n t O b j e c t ' s   m e n u   i t e m   fq uvu I   	�w�
� .prcsclicuiel    ��� uielw o    �� 0 parentobject parentObject�  v xyx l  
 
�z{�  z  		delay 10   { �||  	 d e l a y   1 0y }~} l  
 
�
��
    	else   � ��� 
 	 e l s e~ ��� l  
 
�	���	  � K E		my menu_click_recurse(r, (parentObject's (menu item f)'s (menu f)))   � ��� � 	 	 m y   m e n u _ c l i c k _ r e c u r s e ( r ,   ( p a r e n t O b j e c t ' s   ( m e n u   i t e m   f ) ' s   ( m e n u   f ) ) )� ��� l  
 
����  �  	end if   � ���  	 e n d   i f�  i m     ���                                                                                  sevs   alis    �  Leopard                    ��T�H+   3��System Events.app                                               4���S        ����  	                CoreServices    ��F�      ��C     3�� 3� 3�  5Leopard:System:Library:CoreServices:System Events.app   $  S y s t e m   E v e n t s . a p p    L e o p a r d  -System/Library/CoreServices/System Events.app   / ��  �  �!       ���������  � ������ � 0 open_mainmenu_item  � 0 is_menu_enabled  � 0 	isenabled 	isEnabled� 0 menu_enabled_recurse  � 0 
menu_click  �  0 menu_click_recurse  � �� #���������� 0 open_mainmenu_item  �� ����� �  ������ 0 app_name  �� 0 	menu_name  ��  � ������ 0 app_name  �� 0 	menu_name  � ������
�� 
capp
�� .miscactvnull��� ��� null�� 0 
menu_click  �� *�/ *j UO*��lvk+ � �� :���������� 0 is_menu_enabled  �� ����� �  �������� 0 app_name  �� 0 	menu_name  �� 0 	menu_item  ��  � �������� 0 app_name  �� 0 	menu_name  �� 0 	menu_item  � ������
�� 
capp
�� .miscactvnull��� ��� null�� 0 	isenabled 	isEnabled�� *�/ *j UO)���mvk+ � �� X���������� 0 	isenabled 	isEnabled�� ����� �  ���� 0 mlist mList��  � ������������ 0 mlist mList�� 0 
returnflag 
returnFlag�� 0 appname appName�� 0 topmenu topMenu�� 0 r  � 
�� e�� �������������
�� 
leng
�� 
cobj
�� 
prcs
�� 
mbar
�� 
mbri
�� 
menE�� 0 menu_enabled_recurse  
�� 
TEXT�� \��,m 	)j�Y hO�[�\[Zk\Zl2E[�k/E�Z[�l/E�ZO�[�\[Zm\Z��,2E�O� )�*�/�k/�/�/l+ E�UO��&� �� ����������� 0 menu_enabled_recurse  �� ����� �  ������ 0 mlist mList�� 0 parentobject parentObject��  � ���������� 0 mlist mList�� 0 parentobject parentObject�� 0 f  �� 0 r  � ���� ���������
�� 
cobj
�� 
leng
�� 
menI
�� 
enaB
�� 
menE�� 0 menu_enabled_recurse  �� M��k/E�O��,k �[�\[Zl\Z��,2E�Y hO� #��,k  ��/�,EY *���/�/l+ UOf� ������������ 0 
menu_click  �� ����� �  ���� 0 mlist mList��  � ���������� 0 mlist mList�� 0 appname appName�� 0 topmenu topMenu�� 0 r  � ��A��������
�� 
cobj
�� 
prcs
�� 
mbar
�� 
mbri�� 0 menu_click_recurse  �� 0�[�\[Zk\Zl2E[�k/E�Z[�l/E�ZO� )*�/�k/�/k+ U� ��F���������� 0 menu_click_recurse  �� ����� �  ���� 0 parentobject parentObject��  � ���� 0 parentobject parentObject� ���
�� .prcsclicuiel    ��� uiel�� � 	�j OPUascr  ��ޭ