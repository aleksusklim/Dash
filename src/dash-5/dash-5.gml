{

globalvar draw,vert;

draw=object_add();

object_event_add(draw,ev_create,0,'

mn=64;
mx=room_width;

edge=noone;
move=noone;
movex=0;
movey=0;

pl=4;
mousep=3;
mousex=0;
mousey=0;

timerd=0;
timerr=0;
timerl=0;
timerll=0;
timerrr=0;
two=false;
three=false;

globalvar mouse_x_,mouse_y_;
mouse_x_=mouse_x;
mouse_y_=mouse_y;

back=background_create_color(0,0,0);
backz=background_duplicate(back);
backn=false;
');


object_event_add(draw,ev_step,ev_step_normal,'

var a,b,c,p,x1,x2,y1,y2,x0,y0;

if timerd>0 timerd-=1 else timerr=0;
if timerl>0 timerl-=1;
if timerrr>0 timerrr-=1;
if timerll>0 timerll-=1;

if edge!=noone{
f=true;with vert{if point_distance(x,y,mouse_x_,mouse_y_)<rr{other.f=false;
if other.edge!=id{
ff=true;for(i=0;i<edges;i+=1){
if edge[i]=other.edge{
other.edge=id;
ff=false;break;}}if ff{
with other.edge{
mass[edges]=0;yes[edges]=0;no[edges]=0;
edge[edges]=other.id;
edges+=1;}
edge[edges]=other.edge;
mass[edges]=0;yes[edges]=0;no[edges]=0;
edges+=1;
other.edge=id;
}}
break;}}if f{
}}else{if mouse_check_button(mb_right)&&(not mouse_check_button(mb_left)){
timerr+=1;timerd=1;if timerr>20{
x0=mouse_x_;y0=mouse_y_;
with vert{
if(point_distance(x,y,mouse_x_,mouse_y_)<r){
while(edges>0){
with(edge[0]){
for(i=0;i<edges;i+=1){
if(edge[i]=other.id){
edges-=1;
edge[i]=edge[edges];
edge[edges]=noone;
break;
}}}
edges-=1;
edge[0]=edge[edges];
edge[edges]=noone;}
instance_destroy();
}else{
x1=x;y1=y;
for(i=0;i<edges;i+=1){
x2=edge[i].x;y2=edge[i].y;
if((((x1<x0)&&(x0<x2))||((x2<x0)&&(x0<x1)))&&(((y1<y0)&&(y0<y2))||((y2<y0)&&(y0<y1)))){
a=y2-y1;b=x2-x1;c=b*y1-a*x1;
if abs(a*x0-b*y0+c)/sqrt(a*a+b*b)<re{
edges-=1;obj=edge[i];
edge[i]=edge[edges];edge[edges]=noone;
with obj{for(i=0;i<edges;i+=1){
if edge[i]=other.id{
edges-=1;obj=edge[edges];
edge[i]=edge[edges];edge[edges]=noone;
break}}}
break;
}}}}}}}}

if move!=noone{
movex=move.x;
movey=move.y;
move.x+=(mouse_x_-move.x)/pl;
move.y+=(mouse_y_-move.y)/pl;
}


if not mouse_check_button(mb_right){
edge=noone;
}
if not mouse_check_button(mb_left){
if move!=noone{
move.x=movex;
move.y=movey;}
move=noone;
}

if mouse_check_button_pressed(mb_left){
y2=true;
if mouse_check_button(mb_right){if backn {background_assign(back,backz);backn=false;y2=false};}
if y2{if timerl>0{
if mouse_check_button(mb_right){
with vert instance_destroy();
move=noone;
edge=noone;
}else{
other.obj=noone;
with vert{if point_distance(x,y,mouse_x_,mouse_y_)<r{
if edges=0{
with vert{if id=other.id continue;
edge[edges]=other.id;
mass[edges]=0;yes[edges]=0;no[edges]=0;
edges+=1;
with(other.id){
edge[edges]=other.id;
mass[edges]=0;yes[edges]=0;no[edges]=0;
edges+=1;}}
}else{
if other.obj=noone{
other.obj=id;
}else{
obj=other.obj;
for(i=0;i<edges;i+=1){j=-1;
e=edge[i];j=-1;
for(t=0;t<e.edges;t+=1)if e.edge[t]=id j=t;
if(e=obj){
e.edges-=1;
e.edge[j]=e.edge[e.edges];
e.edge[e.edges]=noone;
}else{
e.edge[j]=obj;
obj.edge[obj.edges]=e;
obj.mass[obj.edges]=0;obj.yes[obj.edges]=0;obj.no[obj.edges]=0;
obj.edges+=1;
with(obj){
for(i=0;i<edges;i+=1){
for(j=i+1;j<edges;j+=1){
if(edge[i]=edge[j]){
edges-=1;
edge[i]=edge[edges];
edge[edges]=noone;
i=edges;j=edges;
}}}}
with(e){
for(i=0;i<edges;i+=1){
for(j=i+1;j<edges;j+=1){
if(edge[i]=edge[j]){
edges-=1;
edge[i]=edge[edges];
edge[edges]=noone;
i=edges;j=edges;
}}}}}}
instance_destroy();
}}}}}}else{f=true;with vert{if point_distance(x,y,mouse_x_,mouse_y_)<rr{other.f=false;
other.move=id;
other.timerl=10;
break;}}if f{
move=instance_create(mouse_x_,mouse_y_,vert);
x0=mouse_x_;
y0=mouse_y_;
with(vert){
x1=x;y1=y;
for(i=0;i<edges;i+=1){
x2=edge[i].x;y2=edge[i].y;
if((((x1<x0)&&(x0<x2))||((x2<x0)&&(x0<x1)))&&(((y1<y0)&&(y0<y2))||((y2<y0)&&(y0<y1)))){
a=y2-y1;b=x2-x1;c=b*y1-a*x1;
if abs(a*x0-b*y0+c)/sqrt(a*a+b*b)<re{
obj=edge[i];
edge[i]=draw.move;
with draw.move{
edge[edges]=other.obj;
mass[edges]=0;no[edges]=0;
yes[edges]=false;
edges+=1;
edge[edges]=other.id;
mass[edges]=0;no[edges]=0;
yes[edges]=false;
edges+=1;}
with obj{for(i=0;i<edges;i+=1){
if edge[i]=other.id{
edge[i]=draw.move;
break}}}
break;
}}}}}}}}

if mouse_check_button_pressed(mb_right){
if mouse_check_button(mb_left){
if move!=noone{
event_user(0);
draw_set_color(0);two=true;
with(vert)for(i=0;i<edges;i+=1){if(no[i]!=yes[i])other.two=false;no[i]=yes[i];draw_circle(x,y,r,0)}
screen_refresh();
if not three {two=false;three=true;}
if two then three=false;
rw=room_width;rh=room_height;
if two s=16 else s=8;ss=40;s2=s div 2;
var arr;arr[rw div s,rh div s]=0;b=0;a=(rw div s)*(rh div s);c=0;
for(i=0;i<rw;i+=s)for(j=0;j<rh;j+=s)arr[i div s,j div s]=b;
x0=move.x;y0=move.y;
draw_clear_alpha(c_black,0);
draw_set_color(c_white);
while(c<a){b+=1;x1=-1;
for(i=0;i<rw;i+=s)for(j=0;j<rh;j+=s){
move.x=i+s2;move.y=j+s2;
event_user(0);bad=false;
if arr[i div s,j div s]=0{
with(vert){for(i=0;i<edges;i+=1)if(no[i]!=yes[i]){other.bad=true;break}if(other.bad)break}
if not bad{c+=1;
arr[i div s,j div s]=b;
if two draw_set_color(make_color_hsv(b*ss-ss,255,255))
draw_rectangle(i,j,i+s,j+s,false);
}else{x1=i;y1=j;}}}
if not two then break;
if x1>=0{
move.x=x1+s2;move.y=y1+s2;
event_user(0);
with(vert)for(i=0;i<edges;i+=1)no[i]=yes[i];
}else break;}
draw_set_color(c_black);
draw_rectangle(0,0,rw-1,rh-1,1);
background_assign(back,background_create_from_screen(0,0,rw,rh,1,0));
backn=true;
move.x=x0;
move.y=y0;}
}else{
if other.timerll>0{
x0=mouse_x_;
y0=mouse_y_;
with vert{
x1=x;y1=y;
for(i=0;i<edges;i+=1){
x2=edge[i].x;y2=edge[i].y;
if((((x1<x0)&&(x0<x2))||((x2<x0)&&(x0<x1)))&&(((y1<y0)&&(y0<y2))||((y2<y0)&&(y0<y1)))){
a=y2-y1;b=x2-x1;c=b*y1-a*x1;
if abs(a*x0-b*y0+c)/sqrt(a*a+b*b)<re{
edges-=1;obj=edge[i];
edge[i]=edge[edges];edge[edges]=noone;
with obj{for(i=0;i<edges;i+=1){
if edge[i]=other.id{
edges-=1;obj=edge[edges];
edge[i]=edge[edges];edge[edges]=noone;
break}}}
break;
}}}
}}else other.timerll=10;

f=true;with vert{if point_distance(x,y,mouse_x_,mouse_y_)<rr{other.f=false;
if other.timerrr>0{
while(edges>0){
with(edge[0]){
for(i=0;i<edges;i+=1){
if(edge[i]=other.id){
edges-=1;
edge[i]=edge[edges];
edge[edges]=noone;
break;
}}}
edges-=1;
edge[0]=edge[edges];
edge[edges]=noone;}
instance_destroy();
}else{
other.timerrr=10;
other.edge=id;
}
break;}}}}

mouse_x_=mouse_x;
mouse_y_=mouse_y;
');


object_event_add(draw,ev_other,ev_user0,'
var m,v,e,a,s,i,v,j,k,t;

with vert{
use=true;
for(i=0;i<edges;i+=1){
m=point_distance(x,y,edge[i].x,edge[i].y);
mass[i]=m;
yes[i]=false;
}}

s=0;a[s]=noone;t=1000;

while true do begin 
m=99999;v=noone;with vert{
for(i=0;i<edges;i+=1){
if use if mass[i]<m{
m=mass[i];v=id;k=i}}}
if v=noone{
with vert{
for(i=0;i<edges;i+=1)if yes[i]{e=edge[i];
for(j=0;j<e.edges;j+=1)if e.edge[j]=id{e.yes[j]=true;break}
}}
exit;}
v.use=false;
v.edge[k].use=false;
v.yes[k]=true;
a[s]=v;s+=1;
a[s]=v.edge[k];s+=1;

while true do begin if t<0 then begin show_message("LOOP") game_end() exit end else t=t-1;
m=99999;v=noone;
for(j=0;j<s;j+=1){with a[j]{
for(i=0;i<edges;i+=1){
if mass[i]<m if edge[i].use{
m=mass[i];v=id;k=i;}}}}
if v=noone break;
v.edge[k].use=false;
v.yes[k]=true;
a[s]=v.edge[k];s+=1;
end;end;
');

object_event_add(draw,ev_draw,0,'

event_user(0);
with vert event_user(0);
with vert event_user(1);
with vert event_user(2);

mousex+=(mouse_x-mousex)/mousep;
mousey+=(mouse_y-mousey)/mousep;
if edge!=noone{
draw_set_color(c_white);
draw_line(mousex,mousey,edge.x,edge.y);
}
draw_background_ext(back,0,0,1,1,0,c_white,0.4);

');


vert=object_add();

object_event_add(vert,ev_create,0,'

r=8;
rr=r*4/3;
re=4;

c=c_white;
d=8;
pl=6;

edges=0;
edge[edges]=noone;
mass[edges]=0;
yes[edges]=false;
no[edges]=false;
dr=0;

');

object_event_add(vert,ev_step,ev_step_normal,'

dr+=(r-dr)/pl;

');

object_event_add(vert,ev_other,ev_user0,'

var v;
for(i=0;i<edges;i+=1){
v=(mass[i]-draw.mn)/draw.mx*255;
draw_set_color(make_color_hsv(v,255,255));
if not yes[i] draw_line(x,y,edge[i].x,edge[i].y);}

');

object_event_add(vert,ev_other,ev_user1,'

var v;
for(i=0;i<edges;i+=1){
v=(mass[i]-draw.mn)/draw.mx*255;
draw_set_color(make_color_hsv(v,255,255));
if yes[i] draw_line_width(x,y,edge[i].x,edge[i].y,d)}

');

object_event_add(vert,ev_other,ev_user2,'

draw_set_color(c);
draw_circle(x,y,dr,false);

');


object_event_add(vert,ev_draw,0,'

');


r=room_add();
room_set_width(r,display_get_width());
room_set_height(r,display_get_height());
window_set_fullscreen(true);
window_set_cursor(cr_default);
room_set_background_color(r,c_black,1);
room_instance_add(r,-32,-32,draw);
room_goto(r);

}

