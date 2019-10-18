{

globalvar control,ball,wall,prize,s_ball,s_wall;

s_ball=sprite_create_from_screen(0,0,16,16,0,0,8,8);
sprite_collision_mask(s_ball,0,1,0,0,0,0,2,0);

s_wall=sprite_create_from_screen(0,0,32,32,0,0,16,16);
sprite_collision_mask(s_ball,0,1,0,0,0,0,2,0);

control=object_add();
object_set_sprite(control,-1);
object_set_depth(control,0);

object_event_add(control,ev_create,0,'
with all r=0;
room_speed=45;
shade=1;
c_dkblue=make_color_rgb(0,0,127);
al=true;r=0;
rw=room_width;rw1=rw-1;
rh=room_height;rh1=rh-1;
m=0;
rx[m]=0;
ry[m]=0;
rz[m]=0;
origx=100;
origy=100;
rr=4;
rb=c_yellow;
bad=false;
dirt=true;
event_user(1);
event_perform(ev_keypress,vk_space);
');

object_event_add(control,ev_step,ev_step_end,'
if dirt event_user(0);
');

object_event_add(control,ev_mouse,ev_global_left_press,'
with(all)if point_distance(x,y,mouse_x,mouse_y)<=r then exit;
al=false;
');

object_event_add(control,ev_other,ev_user0,'
if(instance_number(ball)<3)exit;
eps=0.001;
obj=first;
mx[0]=obj.x;
my[0]=obj.y;
mz[0]=0;
n=1;
d=0;
obj=obj.next;
while(obj!=last){
mx[n]=obj.x;
my[n]=obj.y;
d+=point_distance(mx[n],my[n],mx[n-1],my[n-1]);
mz[n]=d;
if(d-mz[n-1]<eps)mz[n]=eps;
n+=1;
obj=obj.next;}
n-=1;
event_user(3);
event_user(2);
if(fail){event_user(1);
bad=true;}
if(win){
rc=c_white;
screen_redraw();
sleep(2000);
event_user(1);}
');

object_event_add(control,ev_other,ev_user1,'
rc=c_lime;
with ball instance_destroy();
last=noone;
first=instance_create(origx,origy,ball);
last=first;
ball.imm=false;
');

object_event_add(control,ev_other,ev_user2,'
with prize yes=true;
with wall no=false;
fail=false;win=false;
for(i=0;i<m;i+=1){
xx=rx[i];yy=ry[i];
if(xx<0)or(xx>rw)or(yy<0)or(yy>rh)or(collision_point(xx,yy,wall,true,0)){
fail=true;with(collision_point(xx,yy,wall,true,0))no=true;exit;}
with collision_point(xx,yy,prize,true,0) yes=false;}
with prize if yes exit;
win=true;
');

object_event_add(control,ev_other,ev_user3,'
mz[0]=0;for(i=1;i<n;i+=1)mz[i]/=d;mz[n]=1;
m=0;
step=30+15*n;
for(k=0;k<=step;k+=1){
t=k/step;
rx[m]=0;
ry[m]=0;
for(i=0;i<=n;i+=1){L=1;
for(j=0;j<=n;j+=1){if(j=i)continue;
L*=(t-mz[j])/(mz[i]-mz[j]);}
rx[m]+=L*mx[i];
ry[m]+=L*my[i];}
m+=1;}
');

object_event_add(control,ev_draw,0,'
if bad draw_set_color(rb)
else draw_set_color(rc);
for(i=0;i<m;i+=1)
if shade then draw_circle_color(rx[i],ry[i],rr,draw_get_color(),0,0)
else draw_circle(rx[i],ry[i],rr,0);
if shade for(i=1;i<m;i+=1)draw_line(rx[i],ry[i],rx[i-1],ry[i-1]);
if shade draw_set_color(c_dkblue)
else draw_set_color(c_yellow);
draw_rectangle(0,0,rw1,rh1,1);
if al then exit;
draw_set_color(c_white);
if instance_number(ball)>1 {
with ball if not first then draw_circle(x,y,r,1)}
else with ball draw_circle(x,y,r,1)
');

object_event_add(control,ev_keypress,vk_enter,'
bad=false;
event_user(1);
for(i=1;i<=Mn;i+=1)instance_create(Mx[i],My[i],ball);
instance_create(-32,-32,ball);
');

object_event_add(control,ev_keypress,vk_shift,'
shade=not shade;
');

object_event_add(control,ev_keypress,vk_space,'
bad=false;
ctrl=keyboard_check(vk_control);
x1=128;
x2=room_width-x1;
y1=128;
y2=room_height-y1;
mcnt=50;
while true {
with prize instance_destroy();
with wall instance_destroy();
P=irandom_range(3,10);
W=irandom_range(6,20);
T=irandom_range(3,8);
n=T-1;cnt=0;
while true {
d=0;wrong=false;
mx[0]=random_range(x1,x2);
my[0]=random_range(y1,y2);
for(i=1;i<T;i+=1){
mx[i]=random_range(x1,x2);
my[i]=random_range(y1,y2);
d+=point_distance(mx[i-1],my[i-1],mx[i],my[i]);
mz[i]=d;}
event_user(3);event_user(2);
if ctrl{screen_redraw();sleep(100);}
cnt+=1;if(cnt>mcnt){wrong=true;break}
if fail continue;break;}
if wrong continue;
cnt=0;
while true {
with wall instance_destroy();
for(i=0;i<W;i+=1)instance_create(irandom(rw),irandom(rh),wall);
event_user(2);
if ctrl{screen_redraw();sleep(100);}
cnt+=1;if(cnt>mcnt){wrong=true;break}
if fail continue;break;}
if wrong continue;
cnt=0;
with prize instance_destroy();
instance_create(rx[m-5],ry[m-5],prize);
while instance_number(prize)<P {
i=irandom_range(10,m-1);
instance_create(rx[i],ry[i],prize);
if ctrl{screen_redraw();sleep(100);}
cnt+=1;if(cnt>mcnt){wrong=true;break}}
if wrong continue;break}
first.x=mx[0];
first.y=my[0];
origx=mx[0];
origy=my[0];
for(i=0;i<=n;i+=1){
Mx[i]=mx[i];
My[i]=my[i];}
Mn=n;
event_user(1);
m=0;
');

ball=object_add();
object_set_sprite(ball,s_ball);
object_set_depth(ball,10);

object_event_add(ball,ev_create,0,'
if instance_number(ball)>10 instance_destroy();
first=(instance_number(ball)==1);
r=sprite_width div 2;
c1=c_blue;
c2=c_red;
press=false;
release=false;
nx=x;
ny=y;
imm=false;
next=noone;
prev=control.last;
control.last=id;
if(prev!=noone)prev.next=id;
p=6;
');

object_event_add(ball,ev_step,ev_step_normal,'
if press{
nx=x;
ny=y;
x+=(mouse_x-x)/p;
y+=(mouse_y-y)/p;
control.dirt=true;
}if release{
x=nx;
y=ny;
release=false;
control.dirt=true;
}
');

object_event_add(ball,ev_mouse,ev_left_press,'
if (imm)and(instance_number(ball)>1) exit;
if control.last=id {
if not(collision_point(x,y,ball,true,true)){
b=instance_create(mouse_x,mouse_y,ball);
b.press=true;
if instance_number(ball)=2{
control.first.imm=true;}
if instance_number(ball)=3 control.bad=false;
}}else press=true;
');

object_event_add(ball,ev_mouse,ev_global_left_release,'
control.al=true;
if press{
if (instance_number(ball)=2)and place_meeting(x,y,ball)with control event_user(1);
press=false;
release=true;}
');

object_event_add(ball,ev_draw,0,'
if imm exit;
if control.last=id draw_set_color(c2)
else draw_set_color(c1)
if control.shade then draw_circle_color(x,y,r,draw_get_color(),0,0)
else draw_circle(x,y,r,0);
');

wall=object_add();
object_set_sprite(wall,s_wall);
object_set_depth(wall,100);

object_event_add(wall,ev_create,0,'
r=sprite_width div 2;
c1=c_fuchsia;
c2=c_maroon;
no=false;
while place_meeting(x,y,wall)or place_meeting(x,y,prize) {
x=random_range(control.x1,control.x2);
y=random_range(control.y1,control.y2);}
');

object_event_add(wall,ev_draw,0,'
if no draw_set_color(c2)
else draw_set_color(c1);
if control.shade then draw_circle_color(x,y,r,draw_get_color(),0,0)
else draw_circle(x,y,r,0);
');

prize=object_add();
object_set_sprite(prize,s_wall);
object_set_depth(prize,50);

object_event_add(prize,ev_create,0,'
r=sprite_width div 2;
c1=c_aqua;
c2=c_green
yes=true;
if place_meeting(x,y,prize)or(place_meeting(x,y,wall)) instance_destroy();
');

object_event_add(prize,ev_draw,0,'
if yes draw_set_color(c1)
else draw_set_color(c2);
if control.shade then draw_circle_color(x,y,r,draw_get_color(),0,0)
else draw_circle(x,y,r,0);
');

r=room_add();
room_set_width(r,display_get_width());
room_set_height(r,display_get_height());
window_set_fullscreen(true);
window_set_cursor(cr_default);
room_set_background_color(r,c_black,1);
room_instance_add(r,-32,-32,control);
room_goto(r);

}