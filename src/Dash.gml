s=window_get_caption();
window_set_caption("");
c=string_char_at(s,1);
s=string_delete(s,1,1);
D="\";

a[0]="";b[0]="";
i=0;j=0;
globalvar game,start,help,info,index,size,name,helpfile,game_directory;
game[0]="";
start[0]="";
help[0]="";
info[0]="";

d=working_directory+D;
f=file_find_first(d+"*",fa_directory);
while(f!=""){
if(f!=".")and(f!="..")and(directory_exists(d+f)){
b[i]=f;a[i]=d+f+D;i+=1;}
f=file_find_next();}
file_find_close();
m=i;
for(i=0;i<m;i+=1){
d=a[i];
f=file_find_first(d+"*.gml",0);
if file_exists(d+f) if not file_exists(d+file_find_next()){
start[j]=d+f;
game[j]=b[i];
j+=1;
}file_find_close();}

for(i=0;i<j;i+=1){
if file_exists(start[i]+".txt")info[i]=start[i]+".txt"
else{if file_exists(filename_change_ext(start[i],"")+".txt")
info[i]=filename_change_ext(start[i],"")+".txt" else info[i]="";}
if file_exists(start[i]+".rtf")help[i]=start[i]+".rtf"
else{if file_exists(filename_change_ext(start[i],"")+".rtf")
help[i]=filename_change_ext(start[i],"")+".rtf" else help[i]="";}}

size=j;index=0;if c=chr(1){
for(i=0;i<j;i+=1){
if game[i]=s{
game_directory=filename_dir(start[i]);
if help[i]!="" load_info(help[i]);
execute_file(start[i]);
o=object_add();
object_event_add(o,ev_keypress,vk_f2,"{window_set_caption(chr(2)+'"+
s+"');draw_clear(c_black);screen_refresh();game_restart();}");
object_event_add(o,ev_destroy,0,'{instance_create(x,y,object_index)}');
object_set_persistent(o,true);
instance_create(-9999,-9999,o);
exit;}}}else{if c=chr(2){
for(i=0;i<j;i+=1)if game[i]=s{
index=i;break;}}}

name[0]="Games not found!"
for(i=0;i<size;i+=1){
name[i]=filename_name(start[i]);
if info[i]!=""{s="";
t=file_text_open_read(info[i]);
while not file_text_eof(t) {
s=s+file_text_read_string(t);
file_text_readln(t);}
file_text_close(t);
info[i]=s;}}

helpfile=working_directory+"\"+filename_name(parameter_string(0));
if file_exists(helpfile+".rtf") helpfile=helpfile+".rtf"
else {if file_exists(filename_change_ext(helpfile,".rtf")) helpfile=filename_change_ext(helpfile,".rtf")
else {helpfile="";d=working_directory+"\";
f=file_find_first(d+"*.rtf",0);
if file_exists(d+f) if not file_exists(d+file_find_next()){
helpfile=d+f;
}file_find_close();

}}
if helpfile!="" then load_info(helpfile);
globalvar dash;
dash=object_add();
object_event_add(dash,ev_create,0,'
globalvar font;
s=22;M=5;
rw=room_width;
font[false]=font_add("Courier New",s,0,0,0,255);
font[true]=font_add("Courier New",s,1,0,0,255);
capt=font_add("Arial",28,1,0,0,255);
draw_set_font(font);
char[false]="  ";
char[true]=" >";
c=c_white;
ca=c_aqua;
ch=c_yellow;
cw=c_purple;
ct=c_orange;
y1=210;
y2=400;
y3=432;
xs=64;
xw=room_width-xs;
x1=128;
x2=x1+48;
ys=32;
x0=64;
cy=48;
c1=make_color_rgb(255,64,64);
c2=make_color_rgb(64,64,255);
c3=make_color_rgb(64,255,64);
t1="Dash loader v1.0";
t2="by      ";
t3="Kly_Men_COmpany!";
l1=64;
l2=rw/2;
l3=rw-l1;
u1=32;
u2=48+u1
u3=48+u2;
dir=0;
fn=0;st=0;
al="/"+string(size);
l0=l1+128;
if helpfile!="" then help0="F1 = help"
else help0="Help not found"
alm=room_speed/2;
alm2=alm/4;
help2="No help...";
help1="F3 = help!";
');

object_event_add(dash,ev_draw,0,'
draw_set_font(capt);
draw_set_halign(0);draw_set_color(c1);draw_text(l1,u1,t1);
draw_set_halign(1);draw_set_color(c2);draw_text(l2,u2,t2);
draw_set_halign(2);draw_set_color(c3);draw_text(l3,u3,t3);
if(fn==st)or(min(fn-index,index-st)<2){
st=0;fn=size;
if dir while(fn-st>M){
if(fn-2>index){fn-=1;continue;}
if(st+1<index){st+=1;continue;}
} else while(fn-st>M){
if(st+1<index){st+=1;continue;}
if(fn-2>index){fn-=1;continue;}
}}
draw_set_color(c);
draw_set_halign(2);
yy=y1;for(i=st;i<fn;i+=1){
draw_set_font(font[index==i]);
draw_text(x1,yy,string(i+1)+char[index==i]);
yy+=ys;}
draw_set_halign(0);
yy=y1;for(i=st;i<fn;i+=1){
draw_set_font(font[index==i]);
draw_text(x2,yy,string(game[i]));
yy+=ys;}
draw_set_halign(2);
draw_set_font(font[true]);
draw_set_color(ca);
if size>0
then draw_text(l0,u3,string(index+1)+al);
else draw_text(l0,u3,"0"+al);
draw_set_color(ch);
draw_text(l3,u1,help0);
draw_set_halign(0);
draw_set_font(font[true]);
draw_set_color(cw);
draw_text(xs,y2,name[index]);
draw_set_halign(2);
if help[index]!=""
then draw_text(xw,y2,help1)
else draw_text(xw,y2,help2);
draw_set_halign(1);
draw_set_font(font[false]);
draw_set_color(ct);
draw_text_ext(l2,y3,info[index],-1,xw);
');

if size>0 {
object_event_add(dash,ev_alarm,0,'
event_perform(ev_keypress,key);
alarm[0]=alm2;
');

object_event_add(dash,ev_keyrelease,vk_anykey,'
alarm[0]=0;
');

object_event_add(dash,ev_keypress,vk_up,'
index-=1;if index<0 then index=size-1;dir=0;
key=vk_up;alarm[0]=alm;
');
object_event_add(dash,ev_keypress,vk_down,'
index+=1;if index=size then index=0;dir=1;
key=vk_down;alarm[0]=alm;
');
object_event_add(dash,ev_keypress,vk_right,'
if index+M<size {index+=M;if (fn+M<size){st+=M;fn+=M}}
key=vk_right;alarm[0]=alm;
');
object_event_add(dash,ev_keypress,vk_left,'
if index-M>=0 {index-=M;if (st-M>=0){st-=M;fn-=M}}
key=vk_left;alarm[0]=alm;
');
object_event_add(dash,ev_keypress,vk_home,'
index=0;dir=1;
');
object_event_add(dash,ev_keypress,vk_end,'
index=size-1;dir=0;
');
object_event_add(dash,ev_keypress,vk_enter,'
window_set_caption(chr(1)+game[index]);
draw_clear(c_black);screen_refresh();
game_restart();
');
object_event_add(dash,ev_keypress,vk_f3,'
clipboard_set_text(help[index])

if file_exists(help[index]){
load_info(help[index]);
show_info();
if helpfile!="" then load_info(helpfile);}
');}

window_set_fullscreen(true);
window_set_cursor(cr_default);
window_set_stayontop(false);
window_set_showborder(true);
window_set_color(c_black);
window_set_showicons(true);
set_program_priority(1);
r=room_add();
room_set_width(r,800);
room_set_height(r,600);
room_set_background_color(r,c_black,1);
room_instance_add(r,0,0,dash);
room_goto(r);