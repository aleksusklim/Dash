{
globalvar draw,ball;

ball=object_add();
draw=object_add();
object_event_add(draw,ev_create,0,'
{
    room_speed=15;

    first=noone;
    last=noone;
    
    lim=9999;
    base=1;
    dash=1;
    
    type=1;
    maxtype=14;
}
');

object_event_add(draw,ev_step,ev_step_normal,'
{
    if(mouse_check_button_pressed(mb_left)){
    with(instance_create(mouse_x,mouse_y,ball)){
    next=noone;
    prev=other.last;
    if other.last!=noone then other.last.next=id;
    other.last=id;
    if other.first==noone then other.first=id;}
    if(instance_number(ball)>lim){
    f=first;f.next.prev=noone;
    first=f.next;with f instance_destroy();}}
    if(mouse_wheel_up())or(keyboard_check_pressed(vk_right))or(keyboard_check_pressed(vk_up)){
    type+=1;if(type>maxtype)type=maxtype;}
    if(mouse_wheel_down())or(keyboard_check_pressed(vk_left))or(keyboard_check_pressed(vk_down)){
    type-=1;if(type<1)type=1;}
    if(keyboard_check_pressed(vk_control))or(keyboard_check_pressed(vk_shift))or(mouse_check_button_pressed(mb_middle))dash=1-dash;
    if(mouse_check_button_pressed(mb_right))base=1-base;
    if(keyboard_check_pressed(vk_space)or(keyboard_check_pressed(vk_enter))){
    if(keyboard_check_pressed(vk_space))lim=9999 else lim=25;
    with ball instance_destroy();
    first=noone;last=noone;}
}
');

object_event_add(draw,ev_draw,0,'
{
    if(first==noone)exit;
    
    r=1;
    
    if(base){
    draw_set_color(c_white);
    obj=first;
    xx=obj.x;
    yy=obj.y;
    while(obj!=noone){
    draw_line_width(xx,yy,obj.x,obj.y,r);
    xx=obj.x;
    yy=obj.y;
    obj=obj.next;}}
    
    ss=4;
    r=2;
    
    for(ii=1;ii<=maxtype;ii+=1){
    if dash then ii=type;
    draw_set_color(make_color_hsv(255/(maxtype+1)*(ii-1),255,255));
    aa=ii*10;
    
    obj=first;
    tx=obj.x;
    ty=obj.y;
    ax=tx;px=tx;
    ay=ty;py=ty;
    while(obj!=noone){
    tx=obj.x;
    ty=obj.y;
    pd=degtorad(point_direction(px,py,tx,ty));
    cd=cos(pd)*ss;
    sd=sin(pd)*ss;
    ps=point_distance(px,py,tx,ty);
    pl=ps;
    while(pl<=ps){
    xx=ax;yy=ay;
    px+=cd;
    py-=sd;
    ax+=(px-ax)/aa;
    ay+=(py-ay)/aa;
    draw_line_width(xx,yy,ax,ay,r);
    ps=pl;
    pl=point_distance(px,py,tx,ty);
    }
    px=tx;
    py=ty;
    obj=obj.next;}
    
    if dash then break}
}
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
