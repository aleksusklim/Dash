
        //          GMLcurves v 1.1
        // 
        //         
        // �����: �������� �������,
        //    ��� ��. �.�. ���������� � ��������.
        //       ������ �1-12.
        // 
        // ��� ���������:
        //      �������� ������ ���� �� Game Maker � �������� ���� ���� �����
        //      � "��� �������������" ����� ������� (room Creation code).

{

// �������
globalvar draw,ball,tang;



        // �������

ball=object_add();


// ��� �������� �������
object_event_add(ball,ev_create,0,'

{

    // ���������� � ��������� �������
    prev=noone;
    next=noone;
    
    // ������������ ������ �������
    r=8;
    // ���� �����
    c1=c_blue;
    // ���� ��� ��������������
    c2=c_red;
    
    // ����� ��������������
    press=false;
    release=false;
    
    // �������� ����� �����������
    dir=instance_create(x,y,tang);
    // ��������� �� ����
    dir.vert=id;
    
    // �������� ����� ���� ���������
    depth=-10;
    
}

');


// ��� ��� �������� ������
object_event_add(ball,ev_destroy,0,'

{
    // ��� �������� ������� ����� ������� � �����������
    with(dir) instance_destroy();
    
}

');


// ��� ����������� ��� ������ ������� � ������ ����
object_event_add(ball,ev_step,ev_step_normal,'

{
    // ���������� �� ����� ��� ��������������
    if(press)
    {
        // ���������� ������� �������
        px=x;
        py=y;
        release=true;
        
        // �����������
        x=mouse_x;
        y=mouse_y;
    }
    else if(release)
    {
        // ����� ���������� ���������� �� ��� �����
        x=px;
        y=py;
        release=false;
    }
    
}

');


// ��������� ������ � ������ ����
object_event_add(ball,ev_draw,0,'

{
    // ���� ����� ��������� ������ ��������
    if(draw.vert)
    {
        if(press)
        {
            // ���� ��� ��������������
            draw_set_color(c2);
        }
        else
        {
            // ���� � �����
            draw_set_color(c1);
        }
        
        // ������ ������ �� ������ �������
        draw_circle(x,y,r,0);
    }
    
}

');



        // �����������

tang=object_add();


// ��� ��� �������� �����������
object_event_add(tang,ev_create,0,'

{
    
    // ������� �������
    vert=noone;
    
    // ������ �����������
    tx=0;
    ty=0;
    
    // ������ �����
    r=5;
    
    // ����� �������� � �����
    c1=c_lime;
    c2=c_white;
    
    // ����� ��������������
    press=false;
    release=false;
    
    // ���� ������� ����������� �����������
    custom=false;
    
    // �������� ������ ����� ����������
    depth=10;
    
}

');


// ��� ���� ������ �����������
object_event_add(tang,ev_step,ev_step_normal,'

{
    // ���������� �� ����� ��� ��������������
    if (press)
    {
        // ���������� �������� �������
        px=tx;
        py=ty;
        release=true;
        
        // �����������
        tx=mouse_x-vert.x;
        ty=mouse_y-vert.y;
    }
    else if (release)
    {
        // ����� ���������� ���������� �� ��� �����
        tx=px;
        ty=py;
        release=false;
    }
    
    // ���������� ��������� ��������� �� ������� ������� � ������ �������
    x=vert.x+tx;
    y=vert.y+ty;
    
}

');


// ��������� ������ �����������
object_event_add(tang,ev_draw,0,'

{
    // ���� ����� ��������� ����������� ��������
    if (draw.dir)
    {
        // ������, ����������� ��� ��� � ����������� �� custom
        draw_set_color(c1);
        draw_circle(x,y,r,!custom);
        
        if (draw.base)
        {
            // ����� �� �������, ���� �������� � ��� �������
            draw_set_color(c2);
            draw_line(vert.x,vert.y,x,y);
        }
    }
    
}

');



        // ������

draw=object_add();


// ��� �������������
object_event_add(draw,ev_create,0,'

{

    // �������� �����������
    room_speed=15;

    // ��������� �� ������� �������, ���������� �����
    first=noone;
    last=noone;
    tlast=noone;
    
    // ��������������� �������
    press=noone;
    // ��������� �������� ������� ��� �������� �� ������� ������
    action=noone;
    
    // ������������ ���������� ������
    limit=20;
    
    // ��������� �����������: �������, �������, ����������� � �����
    base=true;
    vert=true;
    dir=false;
    dash=true;
    
    // ������� ��� ������
    curve=1;
    
    // ��������� ���������� ������
    mcurve=5;
    
    // ����� ��� ������������ �����������, ����� ��������� ������� � �������� �������
    tmp=sprite_create_from_screen(0,0,16,16,0,0,8,8);
    sprite_collision_mask(tmp,0,1,0,0,0,0,2,0);
    sprite_index=tmp;
    
    // ������ ����������!
    factn=50;
    fact[factn]=0;
    fact[0]=1;
    // � ������
    for( i=1; i<factn; i+=1 )
    {
        fact[i]=fact[i-1]*i;
    }
    
}

');


// �������� ���� ���������
object_event_add(draw,ev_step,ev_step_normal,'

{

    // ��������� �������������� � �������������
    
    if (mouse_wheel_up() || keyboard_check_pressed(vk_right) || keyboard_check_pressed(vk_up))
    {
        // ������� � ���������� ���� ������
        curve+=1;
        // ��������
        if (curve>mcurve) curve=1;
        // ���������� �����������
        with(tang) custom=false;
    }
    
    if (mouse_wheel_down() || keyboard_check_pressed(vk_left) || keyboard_check_pressed(vk_down))
    {
        // ������� � ���������� ������
        curve-=1;
        // ���� ���������
        if (curve<1) curve=mcurve;
        // ����� ���������� �����������
        with(tang) custom=false;

    }
    
    // ������������� ��������� �������
    if (keyboard_check_pressed(vk_control)&&(!keyboard_check_pressed(vk_alt))) base=!base;
    // ��������� ������
    if (keyboard_check_pressed(vk_shift)) vert=!vert;
    // �����������
    if (keyboard_check_pressed(vk_alt)) dir=!dir;
    
    if (keyboard_check_pressed(vk_space))
    {
        // �������� ���� ������
        with(ball) instance_destroy();
        first=noone;
        last=noone;
    }
    
    // ����������� ������ ������� ��� �������
    if (keyboard_check_pressed(vk_enter)) dash=!dash;
    
    // �������� ���������
    if (keyboard_check_pressed(vk_escape)) game_end();
    
    // ������ ����� ������� �����
    if (mouse_check_button_pressed(mb_left))
    {
        // ���������� ����������, ���� ����� ����
        if (press!=noone)
        {
            press.press=false;
            press=noone;
        }
    
        // �������� �� �����������
        with(tang)
        {
            // ���� �������� ������
            if (point_distance(x,y,mouse_x,mouse_y)<r)
            {
                // �������� ������ ��������� �����������
                custom=true;
                // ���������� �������
                press=true;
                other.press=id;
                break;
            }
        }
        
        // ���� �� ����������� �� ���������
        if (press==noone)
        {
            // �������� ������
            with(ball)
            {
                // �������� ��������
                if (point_distance(x,y,mouse_x,mouse_y)<r)
                {
                    // ������� ��������� �����������
                    other.action=id;
                    // ���������� �������
                    press=true;
                    other.press=id;
                    break;
                }
            }
        }
            
        // ���� � �� �������� �� ���������
        if (press==noone)
        {
            // ���������� ����� ��������� � ������� ����
            x=mouse_x;
            y=mouse_y;
            // �� ���� ��������
            with(ball)
            {
                // ����� ���������, ��������� �����������
                if (next!=noone)
                if (collision_line(x,y,next.x,next.y,draw,true,false)>0)
                {
                    // ������ ����� �������
                    new=instance_create(mouse_x,mouse_y,ball);
                    
                    // ��������� ������� � � ������ ������
                    new.next=next;
                    new.prev=id;
                    next.prev=new;
                    next=new;
                    
                    // ����� ����� ����������
                    new.press=true;
                    other.press=new;
                    break;
                }
            }
        }
        
        // ���� ���� �� ����������� � ������� �� ���������
        if (press==noone)
        {
            // ������ ��������� ����� �������
            new=instance_create(mouse_x,mouse_y,ball);
            // �������� ��� ��������� ��������
            action=new;
            
            // ��������� ������ � ������ ������
            
            new.prev=last;
            if (first==noone)
            {
                first=new;
                last=new;
            }
            last.next=new;
            last=new;
            new.next=noone;
     
            // ��� ���������� ����������
            new.press=true;
            press=new;
        }
        
        // ����� ������ ����� ������� �����
        if (instance_number(ball)>limit)
        {
            // ������� ������
            tmp=first;
            tmp.next.prev=noone;
            first=tmp.next;
            with(tmp) instance_destroy();
        }
    }
    
    // ���������� ����� ������ ����
    if ((mouse_check_button_released(mb_left)) && (press!=noone))
    {
        // ����� ���������� ������� ��� �����������
        press.press=false;
        press=noone;
    }
    
    // ������ ������ ������� �����
    if ((mouse_check_button_pressed(mb_right)) && (first!=noone))
    {
        tmp=true;
        // �� �����������
        with (tang)
        {
            // ���� ������� ��������, ������� ��� ������� �������
            if ((point_distance(x,y,mouse_x,mouse_y)<r) && custom)
            {
                // ���������� ���� ������ ��������� ���� �����������
                custom=false;
                other.tmp=false;
                break;
            }
        }
        
        // ���� �������� �� �����������
        if (tmp)
        {
            // �������� ��, ������� ��������
            with(ball)
            {
                if(point_distance(x,y,mouse_x,mouse_y)<r)
                {
                    // �������� � ��� ��������� ��������
                    other.action=id;
                    tmp=false;
                    break;
                }
            }
            
            if(tmp)
            {
                // ����� ����� ���� ��������� ��������
                if (instance_exists(action))
                {
                    if (last==first)
                    {
                        // ����� ������������, �� ������� ����
                        with(first) instance_destroy();
                        first=noone;
                        last=noone;
                    }
                    else
                    {
                        if (action==last)
                        {
                            // ����� ���������, ������� � �����
                            action.prev.next=noone;
                            last=action.prev;
                        }
                        else
                        {
                            if (action==first)
                            {
                                // ����� ������, ������� � ������
                                action.next.prev=noone;
                                first=action.next;
                            }
                            else
                            {
                                // � ����� � ��������
                                action.prev.next=action.next;
                                action.next.prev=action.prev;
                            }
                        }
                        
                        // ������� �������
                        with(action) instance_destroy();
                        
                    }
                }
            }
        }
    }
    
}

');


// ���� ���������
object_event_add(draw,ev_draw,0,'

{

    // �������� ������������� ������ �� ������

    // ���������� ������
    num=instance_number(ball);
    if (num<2) exit;
    
    // ����� ��������� �������
    n=num-1;
    
    // �� ����������
    px[num]=0;
    py[num]=0;
    
    // ���� ������ ������� � ����� �� ���� �������
    pz[num]=0;
    
    // ������ �� ������� �����������
    pt[num]=noone;

    // ���� ����� ��� ������ �������
    px[0]=first.x;
    py[0]=first.y;
    pz[0]=0;
    pt[0]=first.dir;
    
    // ���� �� ���� � ��������
    i=1;
    dst=0;
    // ����������� ���������� ����� ����� ���������
    eps=0.001;
    obj=first.next;
    while (obj!=noone)
    {
        // ����������� �����
        dst+=sqrt(sqr(px[i]-px[i-1])+sqr(py[i]-py[i-1]));
        px[i]=obj.x;
        py[i]=obj.y;
        // �� ����� ��������� � ����������
        if(dst-pz[i-1]<eps)dst+=eps;
        pz[i]=dst;
        pt[i]=obj.dir;
        // ��������� ���� ����� ������
        i+=1;
        obj=obj.next;
    }
    
    // ��������������� ��� ��������� ������� ����
    px[n]=last.x;
    py[n]=last.y;
    pz[n]=1;
    pt[n]=last.dir;
    
    // ����� ����������� ����� �� ����� ����, ������� ����
    for( i=1; i<n; i+=1 ) pz[i]/=dst;
    
    // ���� ����� ��������� ������� ��������
    if (base)
    {
        draw_set_color(c_white);
        // ������ ������� ������� ��������
        for( i=1; i<=n; i+=1 ) draw_line_width(px[i-1],py[i-1],px[i],py[i],1);
    }
    
    // ������� ������ ������������ �����
    rx[0]=0;
    ry[0]=0;
    // �� ������, ���������� ������������ �����
    m=0;
    
    // ����� � ����������� �� �������� ���� ������
    switch(curve){

    
    
    case 1:
    
            // ������ ����������
    
    // ������ ��� �����: ���� �������� ����� �� ������� � ���������� ���������,
    // � ������ ������� �� ��� � ��������� ����������.
    // ��� ������, ��� �� ��� ��� ������������ �� ����� � � ����������,
    // � �� ����������� ���� �� ���, ������� ��� �� ����� ������� ������� �.
    // �� � ������ ������� ��� ���� �� �����, ������ ��� ��� ������ ���������� ����������,
    // ��� ������� �� ���������� �������� ��� �������������.
    // 
    // ����� �������� ��� ������ � ����������� �� ����������� �����������,
    // ���� ����� �������������� ��� ����, � �� � ������ �������.
    // ����� ������ ������� �������������� ������ �����.
    // 
    // ������ �� �������� �� ����� ������� �������, ������� ��������, ��
    // � ����� ���������� �� ��� ������ �������� � ������� �����.

    // ����
    color=c_lime;
    // �������� ��������� �����
    step=4;
    // ��������� �� ��������� ����������
    slow=60;
    
    // ����� �����������, ��� ������ ���������� ���������
    t=noone;
    with(tang)
    {
        // ������� ��������� �������������
        if (custom)
        {
            // ��������� �������� ����� ����� �����������
            other.slow=sqrt(sqr(tx)+sqr(ty));
            other.t=id;
            // ����� �� �����, ����� ��������� ������������ ��������� ������
            if (other.tlast!=id) break;
        }
    }
    tlast=t;
    // ��������� �� ����� ���� ������ �������
    if (slow<1) slow=1;
    
    if (t==noone)
    {
        // �� ���� ����������� �� �������� �������������
        with(tang)
        {
            // ���������� ������������ ����������� �� ���������
            tx=other.slow*cos(pi/4);
            ty=-other.slow*cos(pi/4);
        }
    }
    else
    {
        // ��������� ����� ������������
        with(tang)
        {
            // ��������� ��� ����������� ����� ���� � �� �� �����
            tx=other.t.tx;
            ty=other.t.ty;
            custom=false;
        }
        t.custom=true;
    }
    
    // ���� �� ��� ������� � ��� �������
    for( b=0; b<=1; b+=1 )
    {
        if (b==0)
        {
            // ������ ������ �� ������ � �����
            Sx=px[0];
            Sy=py[0];
            s=1;
            i=0;
        }
        else
        {
            // ������ ������ � ����� � ������
            Sx=px[n];
            Sy=py[n];
            s=-1;
            i=n;
            // ���������� �������� ���������� �����
            M=m;
        }
        
        // ���������� ��� ����� ��������� � ������ �������
        Ax=Sx;
        Ay=Sy;
        
        // ���� �� ��������
        for (j=0; j<=n ;j+=1)
        {
            // ��������� �������, � ������� ������������ ������ �����
            Tx=px[i];
            Ty=py[i];
            
            // ���������� ����������� � ���
            Dd=degtorad(point_direction(Sx,Sy,Tx,Ty));
            // ��������� �� ��������
            Dx=cos(Dd)*step;
            Dy=sin(Dd)*step;
            
            // ��������� ���������� �� ����
            Dt=sqrt(sqr(Sx-Tx)+sqr(Sy-Ty));
            Dc=Dt;
            
            // ���� �����������, ���� ����� �� ��������� � ������� ��������� �������
            while (Dt<=Dc)
            {
                // ��� �����
                Sx+=Dx;
                Sy-=Dy;
                
                // ������� ���������� ��� ������ �����
                Ax+=(Sx-Ax)/slow;
                Ay+=(Sy-Ay)/slow;
                
                // ������ � ������ ����������
                rx[m]=Ax;
                ry[m]=Ay;
                m+=1;
                
                // ��������� �������� � ������ ���������� �� ����
                Dc=Dt;
                Dt=sqrt(sqr(Sx-Tx)+sqr(Sy-Ty));
            }
            
            // ����� ������ ������� ���������������� �� ��
            Sx=Tx;
            Sy=Ty;
            
            // ��������� ��� ���������, � ����������� �� ����������� ������
            i+=s;
        }
        
        if (b==0)
        {
            // ��������� ��� ������� �������
            rx[m]=px[n];
            ry[m]=py[n];
        }
        else
        {
            // � ��� ������� �������
            rx[m]=px[0];
            ry[m]=py[0];
        }
        m+=1;
    }
 
    m-=1;
    // ������� �������������� �� ���� �������
    for( i=0; i<M; i+=1 )
    {
        rx[i]=(rx[i]+rx[m-i])/2;
        ry[i]=(ry[i]+ry[m-i])/2;
    }
    // �������� ������ �������
    m=M; 
    break;
    
    
    
    case 2:
    
            // ������ �����
    
    // ������������ �������� ���������� � ���� �����.
    //   
    // ������� ������ ���������� ��������� � ����� ����,
    // ���������� ����� ���������� ������� � ������.
    // 
    // ����� ����������� � ������ ������� ������ � ���.

    // ����
    color=c_aqua;
    
    // ��������� ����� �����������
    M=64;
    for(i=0;i<=n;i+=1)
    {
        if(pt[i].custom)
        {
            // ���������� ��� �������, ���� ���������� �������������
            W[i]=(pt[i].tx-pt[i].ty*3)/M;
        }
        else
        {
            // ���������� �����������, ���� ��� �� ���������
            pt[i].tx=M;
            pt[i].ty=0;
            W[i]=1;
        }
    }
    
    // ���������� �������������� ����� ��� ���� ������
    step=50+10*n;
    for( j=0; j<=step; j+=1)
    {
        // ������� ��������������
        t=j/step;
        rx[m]=0;
        ry[m]=0;
        
        // ������������� ����� ��� �����
        sum=0;
        for( i=0; i<=n; i+=1)
        {
            // ������� ����������
            B=((fact[n]/(fact[i]*fact[n-i]))*power(t,i)*power(1-t,n-i))*W[i];
            sum+=B;
            // ������������ �� ���� ��������
            rx[m]+=px[i]*B;
            ry[m]+=py[i]*B;
        }
        // ��������� ������� �� �������� �����
        rx[m]/=sum;
        ry[m]/=sum;
        m+=1;
    }
    break;
    
    
    
    case 3:
    
            // ������� ��������
    
    // ������ ������ ������ �� ������� �� ����� ���������,
    // ����������� �� ������������.
     
    // ����
    color=c_fuchsia;
    
    with(tang)
    {
        // ����� ���� �����������
        tx=16;
        ty=-16;
    }
    
    // ���������� ����� ��� ������
    step=30+15*n;
    for( k=0; k<=step; k+=1 )
    {
        // ��������������
        t=k/step;
        rx[m]=0;
        ry[m]=0;
        
        // ���� ������������
        for( i=0; i<=n; i+=1 )
        {
            L=1;
            // ���� ������������
            for( j=0; j<=n; j+=1 )  
            {
                if(j=i)continue;
                // ������� ��������
                L*=(t-pz[j])/(pz[i]-pz[j]);
            }
            // ��������� �� ���������� ������
            rx[m]+=L*px[i];
            ry[m]+=L*py[i];
        }
        m+=1;
    }
    break;
    
    
    
    case 4:
    
            // ��������� ������ �����
    
    // �������� ����� ��� �������, ������ ��� ������������ ��
    // �������� ������ �����, ������� � ������ ������� ����� �����������.
    // 
    // ������ ���������� ����� �������� �� ������ ������:
    // ��� ������� ������� � ��� �� �����������.
    // 
    // ������ ��������� ����������� ���������:
    // �� ���������� �������� ����������� ����������� ������� �������� ������,
    // � � ����� ��������� ����� ����� ���� �������.
    // �� �������� �������� ����������� ���������� � �����, ����������� �� �����������
    // ��������� �����������  ��������� �������, ���� ����� ��� ���������� �� �����;
    // �� ����� ����������� ����������� ��������� ������ ���� ������ �� ����������
    // �� ������������ �����.
    
    // ����
    color=c_yellow;
    draw_set_color(color);
    
    // ������ � ��������� �����
    rx[0]=px[0];
    ry[0]=py[0];
    px[n+1]=px[n];
    py[n+1]=py[n];

    // ���������� ����� �� ����� ������� ������
    step=60;         
    for(i=1;i<=n;i+=1)
    {
        // ����������
        X0=px[i-1];
        Y0=py[i-1];
        // �������
        X=px[i];
        Y=py[i];
        // ���������
        X3=px[i+1];
        Y3=py[i+1];
        
        // ����� �������
        TX=(X3+X0)/2;
        TY=(Y3+Y0)/2;
        
        // ����� �����������
        X1=X+(X0-TX)/3;
        X2=X+(X3-TX)/3;
        Y1=Y+(Y0-TY)/3;
        Y2=Y+(Y3-TY)/3;
        
        if (i==n)
        {
            // �������� ��� ��������� �����
            X1=((XP-X0)/2*3+X0-X)*2/3+X;
            Y1=((YP-Y0)/2*3+Y0-Y)*2/3+Y;
        }
        if (i==1)
        {
            // � ��� ������
            XP=((X1-X)/2*3+X-X0)*2/3+X0;
            YP=((Y1-Y)/2*3+Y-Y0)*2/3+Y0;
        }
        
        if (i<n)
        {
            // ����������� �����������
            if (pt[i].custom)
            {
                // ���������������� ������
                X1=X-pt[i].tx;
                Y1=Y-pt[i].ty;
            }
            else
            {
                // �������������� ���������
                pt[i].tx=-X1+X;
                pt[i].ty=-Y1+Y;
            }
        }
        else
        {
            // ����������� ������ ������� �������� �����
            if (pt[i].custom)
            {
                // �� ������������
                X1=X+pt[i].tx;
                Y1=Y+pt[i].ty;
            }
            else
            {
                // �������������
                pt[i].tx=X1-X;
                pt[i].ty=Y1-Y;
            }
        }
            
        if(pt[i-1].custom)
        {
            // � ��� ���������� �����������
            XP=X0+pt[i-1].tx;
            YP=Y0+pt[i-1].ty;
        }
        else
        {
            // �� ����������
            pt[i-1].tx=XP-X0;
            pt[i-1].ty=YP-Y0;
        }
        
        if(dir)
        {
            // ���������� �����������
            draw_line(X1,Y1,X,Y);
            draw_line(X0,Y0,XP,YP);
        }
        
        // ������� ���� �������
        for( j=0; j<=step; j+=1)
        {
            t=j/step;
            // ������ ��������
            T=1-t;
            T0=T*T*T;
            T1=3*T*T*t;
            T2=3*T*t*t;
            T3=t*t*t;
            // ���������� ����� �����
            rx[m]=X0*T0+XP*T1+X1*T2+X*T3;
            ry[m]=Y0*T0+YP*T1+Y1*T2+Y*T3;
            m+=1;
        }
        
        // ��������� ����������� ���������� ����������
        XP=X2;
        YP=Y2;
    }
    break;
    
    
    
    case 5:
    
            // ������ ������
    
    // ����������� ����������� �� ����� ������� �� ��������,
    // ������� �� ������� ������������ ������������� �����.
    //     
    // � �������� ������ ����������� �� ��������� �� ������.

    // ����   
    color=c_red;
    draw_set_color(color);
   
    // ������� ��������� �������� ������ ������
    px[n+1]=px[n];
    px[n+2]=px[n+1];
    py[n+1]=py[n];
    py[n+2]=py[n+1];

    if (!pt[n].custom)
    {
        // ����� ���������, ���� �� ����������
        pt[n].tx=0;
        pt[n].ty=0;
    }
    else
    {
        // ����������, ���� ������������
        Lqx1=pt[n].tx*2;
        Lqy1=pt[n].ty*2;
    }
   
    // �������� �� ������
    qx2=0;
    qy2=0;
    
    // ���������� ����� �� ������ �������
    step=60;
    for( i=0; i<n; i+=1 )
    {
        // ����������� ���������� �����������
        qx1=qx2;
        qy1=qy2;
        qx0=0;
        qy0=0;
  
        // ���������� ����� ���������
        s1=sqrt((sqr(px[i+1]-px[i])+sqr(py[i+1]-py[i])));
        
        if (i>0)
        {
            // ������ ������� ������� ��������
            s0=sqrt((sqr(px[i]-px[i-1])+sqr(py[i]-py[i-1])));
            s3=s0+s1;
            if (s3!=0)
            {
                qx0=(s1*(px[i]-px[i-1])+s0*(px[i+1]-px[i]))/s3;
                qy0=(s1*(py[i]-py[i-1])+s0*(py[i+1]-py[i]))/s3;
            }
        }

        // ������ �����������
        s2=sqrt((sqr(px[i+2]-px[i+1])+sqr(py[i+2]-py[i+1])));
        s4=s1+s2;
        if(s4!=0)
        {
            qx1=(s2*(px[i+1]-px[i])+s1*(px[i+2]-px[i+1]))/s4;
            qy1=(s2*(py[i+1]-py[i])+s1*(py[i+2]-py[i+1]))/s4;
        }

        
        if (!pt[i].custom)
        {
            // ��������������� �������������
            pt[i].tx=qx0/2;
            pt[i].ty=qy0/2;
        }
        else
        {
            // ��� ����� ��������������� �������
            qx0=pt[i].tx*2;
            qy0=pt[i].ty*2;
        }
        
        // �� �� ��� ������ �����������
        if (!pt[i+1].custom)
        {
            pt[i+1].tx=qx1/2;
            pt[i+1].ty=qy1/2;
        }
        else
        {
            qx1=pt[i+1].tx*2;
            qy1=pt[i+1].ty*2;
        }
        
        // ��������� �� ������� ����������
        if (dir)
        {
            draw_line(px[i]-qx0/2,py[i]-qy0/2,px[i]+qx0/2,py[i]+qy0/2);
            draw_line(px[i+1]-qx1/2,py[i+1]-qy1/2,px[i+1]+qx1/2,py[i+1]+qy1/2);
        }
         
        // ���� �������� ��������
        for( j=0; j<=step; j+=1 )
        {
            // ������� ��������
            w=j/step;
            //�������  
            w2=w*w;
            w3=w2*w;
            
            // ���������� �
            A0=1-3*w2+2*w3;
            A1=3*w2-2*w3;
            B0=w-2*w2+w3;
            B1=-w2+w3;
            
            // ������ �����
            rx[m]=A0*px[i]+A1*px[i+1]+B0*qx0+B1*qx1;
            ry[m]=A0*py[i]+A1*py[i+1]+B0*qy0+B1*qy1;
            m+=1;
        }
    }
    break; 
       
    }
    
    
    // ��������� ��������� ������
    draw_set_color(color);
    
    if (dash)
    {
        // ���� �������
        for( i=1; i<m; i+=1 ) draw_line_width(rx[i-1],ry[i-1],rx[i],ry[i],3);
    }
    else
    {
        //���� ��������
        for( i=0; i<m; i+=1 ) draw_circle(rx[i],ry[i],3,0);
    }
    
}

');

    // ������ ��������� ����� 
    r=room_add();
    
    // �������� ������� ���� ��� ���������� ������
    room_set_width(r,display_get_width());
    room_set_height(r,display_get_height());
    window_set_fullscreen(true);
    window_set_cursor(cr_default);
    
    // ���� ����
    room_set_background_color(r,c_black,1);
    
    // ���������� �������� �������
    room_instance_add(r,0,0,draw);
    room_goto(r);
    
}
