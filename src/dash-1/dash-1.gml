{
globalvar draw,dash,wave;

draw=object_add();
object_event_add(draw,ev_create,0,'
{
    room_speed=60;
    instance_create(room_width div 2,room_height div 2,dash);
    display_mouse_set(room_width div 2,room_height div 2);
}
');

object_event_add(draw,ev_draw,0,'
{
    with wave event_user(10);
    with dash event_user(10);
}
');

object_event_add(draw,ev_keypress,vk_enter,'
{
    with wave instance_destroy();
}
');

dash=object_add();
object_event_add(dash,ev_create,0,'
{
    a=1/256;
    r=7;
    rr=110;
    t=1;
    w=1;
    xx=0;
    yy=0;
}
');

object_event_add(dash,ev_step,ev_step_normal,'
{
    xx=(mouse_x-x)*a;
    yy=(mouse_y-y)*a;
    hspeed+=xx;
    vspeed+=yy;
    if mouse_check_button(mb_right) speed*=0.98;
    if mouse_check_button(mb_left) speed*=1.02;
    t=1-t;
    if w or t then instance_create(x,y,wave);
}

');

object_event_add(dash,ev_other,ev_user10,'
{
    draw_set_color(make_color_hsv(dash.speed/32*255,255,255));
    draw_circle(x,y,6,false);
    draw_set_color(c_white)
    draw_arrow(x,y,x+hspeed*r,y+vspeed*r,10);
    draw_arrow(x,y,x+xx*rr,y+yy*rr,10);
}
');

object_event_add(dash,ev_keypress,vk_space,'
{
    w=1-w;
}

');

wave=object_add();
object_event_add(wave,ev_create,0,'
{
    r=0;
    m=256;
    s=0.5;
    a=dash.speed/32*255;
}
');

object_event_add(wave,ev_step,ev_step_normal,'
{
    r+=s;
    if r>m then instance_destroy();
}
');

object_event_add(wave,ev_other,ev_user10,'
{
    c=255-r/m*255;
    draw_set_color(make_color_hsv(a,255,c));
    draw_circle(x,y,r,true);
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
