
        //          GMLcurves v 1.1
        // 
        //         
        // Автор: Клименко Алексей,
        //    МГУ им. М.В. Ломоносова в Ташкенте.
        //       Группа М1-12.
        // 
        // Как запустить:
        //      Создайте пустую игру на Game Maker и вставьте весь этот текст
        //      в "код инициализации" новой комнаты (room Creation code).

{

// Объекты
globalvar draw,ball,tang;



        // ВЕРШИНА

ball=object_add();


// Код создания вершины
object_event_add(ball,ev_create,0,'

{

    // Предыдущая и следующая вершины
    prev=noone;
    next=noone;
    
    // Отображаемый радиус вершины
    r=8;
    // Цвет покоя
    c1=c_blue;
    // Цвет при перетаскивании
    c2=c_red;
    
    // Флаги перетаскивания
    press=false;
    release=false;
    
    // Создание своей касательной
    dir=instance_create(x,y,tang);
    // Указатель на себя
    dir.vert=id;
    
    // Рисовать перед всем остальным
    depth=-10;
    
}

');


// Код при удалении вершин
object_event_add(ball,ev_destroy,0,'

{
    // При удалении вершины также удаляем её касательную
    with(dir) instance_destroy();
    
}

');


// Это выполняется для каждой вершины в каждом шаге
object_event_add(ball,ev_step,ev_step_normal,'

{
    // Следование за мышью при перетаскивании
    if(press)
    {
        // Сохранение прошлой позиции
        px=x;
        py=y;
        release=true;
        
        // Перемещение
        x=mouse_x;
        y=mouse_y;
    }
    else if(release)
    {
        // После отпускания возвращаем на шаг назад
        x=px;
        y=py;
        release=false;
    }
    
}

');


// Рисование вершин в каждом шаге
object_event_add(ball,ev_draw,0,'

{
    // Если опция видимости вершин включена
    if(draw.vert)
    {
        if(press)
        {
            // Цвет при перетаскивании
            draw_set_color(c2);
        }
        else
        {
            // Цвет в покое
            draw_set_color(c1);
        }
        
        // Рисуем кружок на каждой вершине
        draw_circle(x,y,r,0);
    }
    
}

');



        // КАСАТЕЛЬНАЯ

tang=object_add();


// Код при создании касательных
object_event_add(tang,ev_create,0,'

{
    
    // Базовая вершина
    vert=noone;
    
    // Вектор касательной
    tx=0;
    ty=0;
    
    // Радиус метки
    r=5;
    
    // Цвета кружочка и линии
    c1=c_lime;
    c2=c_white;
    
    // Флаги перетаскивания
    press=false;
    release=false;
    
    // Флаг ручного определения касательной
    custom=false;
    
    // Рисовать позади всего остального
    depth=10;
    
}

');


// Код шага каждой касательной
object_event_add(tang,ev_step,ev_step_normal,'

{
    // Следование за мышью при перетаскивании
    if (press)
    {
        // Сохранение прошлого вектора
        px=tx;
        py=ty;
        release=true;
        
        // Перемещение
        tx=mouse_x-vert.x;
        ty=mouse_y-vert.y;
    }
    else if (release)
    {
        // После отпускания возвращаем на шаг назад
        tx=px;
        ty=py;
        release=false;
    }
    
    // Вычисление настоящих координат по базовой вершине и своему вектору
    x=vert.x+tx;
    y=vert.y+ty;
    
}

');


// Рисование каждой касательной
object_event_add(tang,ev_draw,0,'

{
    // Если опция видимости касательных включена
    if (draw.dir)
    {
        // Кружок, закрашенный или нет в зависимости от custom
        draw_set_color(c1);
        draw_circle(x,y,r,!custom);
        
        if (draw.base)
        {
            // Линия от вершины, если рисуется и вся ломаная
            draw_set_color(c2);
            draw_line(vert.x,vert.y,x,y);
        }
    }
    
}

');



        // КРИВАЯ

draw=object_add();


// Код инициализации
object_event_add(draw,ev_create,0,'

{

    // Скорость перерисовки
    room_speed=15;

    // Указатели на крайние вершины, изначально пусты
    first=noone;
    last=noone;
    tlast=noone;
    
    // Перетаскиваемая вершина
    press=noone;
    // Последняя тронутая вершина для удаления по правому щелчку
    action=noone;
    
    // Максимальное количество вершин
    limit=20;
    
    // Настройки отображения: ломаная, вершины, касательные и точки
    base=true;
    vert=true;
    dir=false;
    dash=true;
    
    // Текущий тип кривой
    curve=1;
    
    // Доступное количество кривых
    mcurve=5;
    
    // Маска для отлавливания пересечений, чтобы вставлять вершины в середине ломаной
    tmp=sprite_create_from_screen(0,0,16,16,0,0,8,8);
    sprite_collision_mask(tmp,0,1,0,0,0,0,2,0);
    sprite_index=tmp;
    
    // Расчёт факториала!
    factn=50;
    fact[factn]=0;
    fact[0]=1;
    // В массив
    for( i=1; i<factn; i+=1 )
    {
        fact[i]=fact[i-1]*i;
    }
    
}

');


// Основной цикл программы
object_event_add(draw,ev_step,ev_step_normal,'

{

    // Обработка взаимодействия с пользователем
    
    if (mouse_wheel_up() || keyboard_check_pressed(vk_right) || keyboard_check_pressed(vk_up))
    {
        // Переход к следующему типу кривой
        curve+=1;
        // Циклично
        if (curve>mcurve) curve=1;
        // Сбрасываем касательные
        with(tang) custom=false;
    }
    
    if (mouse_wheel_down() || keyboard_check_pressed(vk_left) || keyboard_check_pressed(vk_down))
    {
        // Возврат к предыдущей кривой
        curve-=1;
        // Тоже цикличный
        if (curve<1) curve=mcurve;
        // Также сбрасываем касательные
        with(tang) custom=false;

    }
    
    // Переключатель видимости ломаной
    if (keyboard_check_pressed(vk_control)&&(!keyboard_check_pressed(vk_alt))) base=!base;
    // Видимость вершин
    if (keyboard_check_pressed(vk_shift)) vert=!vert;
    // Касательных
    if (keyboard_check_pressed(vk_alt)) dir=!dir;
    
    if (keyboard_check_pressed(vk_space))
    {
        // Удаление всех вершин
        with(ball) instance_destroy();
        first=noone;
        last=noone;
    }
    
    // Отображение кривой точками или линиями
    if (keyboard_check_pressed(vk_enter)) dash=!dash;
    
    // Закрытие программы
    if (keyboard_check_pressed(vk_escape)) game_end();
    
    // Щелчок левой кнопкой мышки
    if (mouse_check_button_pressed(mb_left))
    {
        // Сбрасываем выделенную, если вдруг есть
        if (press!=noone)
        {
            press.press=false;
            press=noone;
        }
    
        // Проверка на касательных
        with(tang)
        {
            // Если кликнули кружок
            if (point_distance(x,y,mouse_x,mouse_y)<r)
            {
                // Пометить ручную остановку касательной
                custom=true;
                // Запоминаем нажатую
                press=true;
                other.press=id;
                break;
            }
        }
        
        // Если на касательных не сработало
        if (press==noone)
        {
            // Проверка вершин
            with(ball)
            {
                // Кликнули кружочек
                if (point_distance(x,y,mouse_x,mouse_y)<r)
                {
                    // Вершина последней манипуляции
                    other.action=id;
                    // Запоминаем нажатую
                    press=true;
                    other.press=id;
                    break;
                }
            }
        }
            
        // Если и на вершинах не сработало
        if (press==noone)
        {
            // Перемещаем маску сравнения в позицию мыши
            x=mouse_x;
            y=mouse_y;
            // По всем вершинам
            with(ball)
            {
                // Кроме последней, проверяем пересечения
                if (next!=noone)
                if (collision_line(x,y,next.x,next.y,draw,true,false)>0)
                {
                    // Создаём новую вершину
                    new=instance_create(mouse_x,mouse_y,ball);
                    
                    // Аккуратно цепляем её в список вершин
                    new.next=next;
                    new.prev=id;
                    next.prev=new;
                    next=new;
                    
                    // Пусть будет выделенной
                    new.press=true;
                    other.press=new;
                    break;
                }
            }
        }
        
        // Если даже на пересечении с ломаной не сработало
        if (press==noone)
        {
            // Просто добавляем новую вершину
            new=instance_create(mouse_x,mouse_y,ball);
            // Отмечаем как последнюю тронутую
            action=new;
            
            // Осторожно вносим в список вершин
            
            new.prev=last;
            if (first==noone)
            {
                first=new;
                last=new;
            }
            last.next=new;
            last=new;
            new.next=noone;
     
            // Она становится выделенной
            new.press=true;
            press=new;
        }
        
        // Когда вершин стало слишком много
        if (instance_number(ball)>limit)
        {
            // Удаляем первую
            tmp=first;
            tmp.next.prev=noone;
            first=tmp.next;
            with(tmp) instance_destroy();
        }
    }
    
    // Отпускание левой кнопки мыши
    if ((mouse_check_button_released(mb_left)) && (press!=noone))
    {
        // Сброс выделенной вершины или касательной
        press.press=false;
        press=noone;
    }
    
    // Щелчок правой кнопкой мышки
    if ((mouse_check_button_pressed(mb_right)) && (first!=noone))
    {
        tmp=true;
        // По касательным
        with (tang)
        {
            // Если кликнут кружочек, который был однажды выделен
            if ((point_distance(x,y,mouse_x,mouse_y)<r) && custom)
            {
                // Сбрасываем флаг ручной установки этой касательной
                custom=false;
                other.tmp=false;
                break;
            }
        }
        
        // Если щёлкнули не касательную
        if (tmp)
        {
            // Поискать ту, которую кликнули
            with(ball)
            {
                if(point_distance(x,y,mouse_x,mouse_y)<r)
                {
                    // Отметить её как последнюю тронутую
                    other.action=id;
                    tmp=false;
                    break;
                }
            }
            
            if(tmp)
            {
                // Тогда может есть последняя тронутая
                if (instance_exists(action))
                {
                    if (last==first)
                    {
                        // Когда единственная, то удалить всех
                        with(first) instance_destroy();
                        first=noone;
                        last=noone;
                    }
                    else
                    {
                        if (action==last)
                        {
                            // Когда последняя, удалить с конца
                            action.prev.next=noone;
                            last=action.prev;
                        }
                        else
                        {
                            if (action==first)
                            {
                                // Когда первая, удалить с начала
                                action.next.prev=noone;
                                first=action.next;
                            }
                            else
                            {
                                // И когда в середине
                                action.prev.next=action.next;
                                action.next.prev=action.prev;
                            }
                        }
                        
                        // Удалить наконец
                        with(action) instance_destroy();
                        
                    }
                }
            }
        }
    }
    
}

');


// Цикл рисования
object_event_add(draw,ev_draw,0,'

{

    // Основное вырисовывание кривых на экране

    // Количество вершин
    num=instance_number(ball);
    if (num<2) exit;
    
    // Номер последней вершины
    n=num-1;
    
    // Их координаты
    px[num]=0;
    py[num]=0;
    
    // Доля каждой вершины в длине от всей ломаной
    pz[num]=0;
    
    // Ссылки на объекты касательных
    pt[num]=noone;

    // Явно задаём для первой вершины
    px[0]=first.x;
    py[0]=first.y;
    pz[0]=0;
    pt[0]=first.dir;
    
    // Цикл по всем с расчетом
    i=1;
    dst=0;
    // Минимальное расстояние между двумя соседними
    eps=0.001;
    obj=first.next;
    while (obj!=noone)
    {
        // Накапливаем длину
        dst+=sqrt(sqr(px[i]-px[i-1])+sqr(py[i]-py[i-1]));
        px[i]=obj.x;
        py[i]=obj.y;
        // Не может совпадать с предыдущей
        if(dst-pz[i-1]<eps)dst+=eps;
        pz[i]=dst;
        pt[i]=obj.dir;
        // Обработка всех кроме первой
        i+=1;
        obj=obj.next;
    }
    
    // Переопределение для последней вершины явно
    px[n]=last.x;
    py[n]=last.y;
    pz[n]=1;
    pt[n]=last.dir;
    
    // Делим накопленную длину на общий путь, получая долю
    for( i=1; i<n; i+=1 ) pz[i]/=dst;
    
    // Если опция рисования ломаной включена
    if (base)
    {
        draw_set_color(c_white);
        // Просто набором длинных отрезков
        for( i=1; i<=n; i+=1 ) draw_line_width(px[i-1],py[i-1],px[i],py[i],1);
    }
    
    // Массивы вывода получившихся точек
    rx[0]=0;
    ry[0]=0;
    // Их размер, количество рассчитанных точек
    m=0;
    
    // Выбор в зависимости от текущего типа кривой
    switch(curve){

    
    
    case 1:
    
            // КРИВАЯ СЛЕДОВАНИЯ
    
    // Храним две точки: одна движется вдоль по ломаной с постоянной скоростью,
    // а другая следует за ней с некоторой плавностью.
    // Это значит, что за шаг она перемещается не сразу в её координаты,
    // а на определённую долю от них, поэтому она не может надолго догнать её.
    // Но и сильно отстать она тоже не может, потому что чем больше становится расстояние,
    // тем сильнее по абсолютной величине она притягивается.
    // 
    // Чтобы уравнять вид кривой в зависимости от направления прохождения,
    // весь пусть просчитывается два раза, в ту и другую сторону.
    // Потом ищется среднее арифметическое каждой точки.
    // 
    // Кривая не касается ни одной вершины ломаной, включая концевые, но
    // её можно продолжить до них прямым отрезком с каждого конца.

    // Цвет
    color=c_lime;
    // Скорость убегающей точки
    step=4;
    // Плавность по умолчанию догоняющей
    slow=60;
    
    // Обход касательных, они задают глобальную плавность
    t=noone;
    with(tang)
    {
        // Найдена изменённая пользователем
        if (custom)
        {
            // Плавность численно равна длине касательной
            other.slow=sqrt(sqr(tx)+sqr(ty));
            other.t=id;
            // Выйти из цикла, чтобы корректно обрабатывать изменения других
            if (other.tlast!=id) break;
        }
    }
    tlast=t;
    // Плавность не может быть меньше единицы
    if (slow<1) slow=1;
    
    if (t==noone)
    {
        // Ни одна касательная не изменена пользователем
        with(tang)
        {
            // Установить диагональное направление по умолчанию
            tx=other.slow*cos(pi/4);
            ty=-other.slow*cos(pi/4);
        }
    }
    else
    {
        // Плавность задал пользователь
        with(tang)
        {
            // Заставить все касательные иметь одну и ту же форму
            tx=other.t.tx;
            ty=other.t.ty;
            custom=false;
        }
        t.custom=true;
    }
    
    // Цикл на два прохода в обе стороны
    for( b=0; b<=1; b+=1 )
    {
        if (b==0)
        {
            // Первый проход из начала в конец
            Sx=px[0];
            Sy=py[0];
            s=1;
            i=0;
        }
        else
        {
            // Второй проход с конца в начало
            Sx=px[n];
            Sy=py[n];
            s=-1;
            i=n;
            // Запоминаем реальное количество точек
            M=m;
        }
        
        // Изначально обе точки находятся в первой вершине
        Ax=Sx;
        Ay=Sy;
        
        // Цикл по вершинам
        for (j=0; j<=n ;j+=1)
        {
            // Следующая вершина, к которой направляется первая точка
            Tx=px[i];
            Ty=py[i];
            
            // Вычисление направления к ней
            Dd=degtorad(point_direction(Sx,Sy,Tx,Ty));
            // Умножение на скорость
            Dx=cos(Dd)*step;
            Dy=sin(Dd)*step;
            
            // Начальное расстояние до цели
            Dt=sqrt(sqr(Sx-Tx)+sqr(Sy-Ty));
            Dc=Dt;
            
            // Цикл выполняется, пока точка не настигнет и обгонит очередную вершину
            while (Dt<=Dc)
            {
                // Шаг вперёд
                Sx+=Dx;
                Sy-=Dy;
                
                // Плавное следование для второй точки
                Ax+=(Sx-Ax)/slow;
                Ay+=(Sy-Ay)/slow;
                
                // Запись в массив результата
                rx[m]=Ax;
                ry[m]=Ay;
                m+=1;
                
                // Сравнение прошлого и нового расстояний до цели
                Dc=Dt;
                Dt=sqrt(sqr(Sx-Tx)+sqr(Sy-Ty));
            }
            
            // После обгона вершины корректироваться на неё
            Sx=Tx;
            Sy=Ty;
            
            // Инкремент или декремент, в зависимости от направления обхода
            i+=s;
        }
        
        if (b==0)
        {
            // Последняя для первого прохода
            rx[m]=px[n];
            ry[m]=py[n];
        }
        else
        {
            // И для второго прохода
            rx[m]=px[0];
            ry[m]=py[0];
        }
        m+=1;
    }
 
    m-=1;
    // Среднее арифметическое по двум обходам
    for( i=0; i<M; i+=1 )
    {
        rx[i]=(rx[i]+rx[m-i])/2;
        ry[i]=(ry[i]+ry[m-i])/2;
    }
    // Сообщаем размер массива
    m=M; 
    break;
    
    
    
    case 2:
    
            // КРИВАЯ БЕЗЬЕ
    
    // Использованы полиномы Бернштейна и веса точек.
    //   
    // Формула базиса Бернштейна применена в явном виде,
    // факториалы чисел рассчитаны заранее в массив.
    // 
    // Длины касательных в каждой вершине задают её вес.

    // Цвет
    color=c_aqua;
    
    // Множитель длины касательной
    M=64;
    for(i=0;i<=n;i+=1)
    {
        if(pt[i].custom)
        {
            // Запоминаем вес вершины, если установлен пользователем
            W[i]=(pt[i].tx-pt[i].ty*3)/M;
        }
        else
        {
            // Сбрасываем касательную, если вес по умолчанию
            pt[i].tx=M;
            pt[i].ty=0;
            W[i]=1;
        }
    }
    
    // Количество рассчитываемых точек для всей кривой
    step=50+10*n;
    for( j=0; j<=step; j+=1)
    {
        // Долевая параметризация
        t=j/step;
        rx[m]=0;
        ry[m]=0;
        
        // Накапливаемая сумма для весов
        sum=0;
        for( i=0; i<=n; i+=1)
        {
            // Формула Бернштейна
            B=((fact[n]/(fact[i]*fact[n-i]))*power(t,i)*power(1-t,n-i))*W[i];
            sum+=B;
            // Суммирование по всем вершинам
            rx[m]+=px[i]*B;
            ry[m]+=py[i]*B;
        }
        // Финальное деление на найдённую сумму
        rx[m]/=sum;
        ry[m]/=sum;
        m+=1;
    }
    break;
    
    
    
    case 3:
    
            // ПОЛИНОМ ЛАГРАНЖА
    
    // Ведётся прямой расчет по формуле со всеми вершинами,
    // касательные не используются.
     
    // Цвет
    color=c_fuchsia;
    
    with(tang)
    {
        // Сброс всех касательных
        tx=16;
        ty=-16;
    }
    
    // Количество точек все кривой
    step=30+15*n;
    for( k=0; k<=step; k+=1 )
    {
        // Параметризация
        t=k/step;
        rx[m]=0;
        ry[m]=0;
        
        // Цикл суммирования
        for( i=0; i<=n; i+=1 )
        {
            L=1;
            // Цикл перемножения
            for( j=0; j<=n; j+=1 )  
            {
                if(j=i)continue;
                // Формула Лагранжа
                L*=(t-pz[j])/(pz[i]-pz[j]);
            }
            // Умножение на координаты вершин
            rx[m]+=L*px[i];
            ry[m]+=L*py[i];
        }
        m+=1;
    }
    break;
    
    
    
    case 4:
    
            // СОСТАВНОЙ СПЛАЙН БЕЗЬЕ
    
    // Проходит через все вершины, потому что составляется из
    // участков кривых Безье, имеющих в каждой вершине общие касательные.
    // 
    // Каждая кубическая Безье строится на четырёх точках:
    // две базовые вершины и две их касательные.
    // 
    // Расчёт начальных касательных следующий:
    // во внутренних вершинах касательная параллельна секущей соседних вершин,
    // а её длина равняется трети длины этой секущей.
    // На концевых вершинах касательная направлена в точку, находящуюся на продолжении
    // ближайшей касательной  следующей вершины, если длину той продолжить на треть;
    // но длина вычисляемой касательной считается равной двум третям от расстояния
    // до рассчитанной точки.
    
    // Цвет
    color=c_yellow;
    draw_set_color(color);
    
    // Первая и последняя точки
    rx[0]=px[0];
    ry[0]=py[0];
    px[n+1]=px[n];
    py[n+1]=py[n];

    // Количество точек на одном участке кривой
    step=60;         
    for(i=1;i<=n;i+=1)
    {
        // Предыдущая
        X0=px[i-1];
        Y0=py[i-1];
        // Текущая
        X=px[i];
        Y=py[i];
        // Следующая
        X3=px[i+1];
        Y3=py[i+1];
        
        // Центр секущей
        TX=(X3+X0)/2;
        TY=(Y3+Y0)/2;
        
        // Концы касательных
        X1=X+(X0-TX)/3;
        X2=X+(X3-TX)/3;
        Y1=Y+(Y0-TY)/3;
        Y2=Y+(Y3-TY)/3;
        
        if (i==n)
        {
            // Отдельно для последней точки
            X1=((XP-X0)/2*3+X0-X)*2/3+X;
            Y1=((YP-Y0)/2*3+Y0-Y)*2/3+Y;
        }
        if (i==1)
        {
            // И для первой
            XP=((X1-X)/2*3+X-X0)*2/3+X0;
            YP=((Y1-Y)/2*3+Y-Y0)*2/3+Y0;
        }
        
        if (i<n)
        {
            // Отображение касательных
            if (pt[i].custom)
            {
                // Пользовательские данные
                X1=X-pt[i].tx;
                Y1=Y-pt[i].ty;
            }
            else
            {
                // Автоматическая настройка
                pt[i].tx=-X1+X;
                pt[i].ty=-Y1+Y;
            }
        }
        else
        {
            // Касательная первой вершины рисуется особо
            if (pt[i].custom)
            {
                // От пользователя
                X1=X+pt[i].tx;
                Y1=Y+pt[i].ty;
            }
            else
            {
                // Автоматически
                pt[i].tx=X1-X;
                pt[i].ty=Y1-Y;
            }
        }
            
        if(pt[i-1].custom)
        {
            // И для предыдущей касательной
            XP=X0+pt[i-1].tx;
            YP=Y0+pt[i-1].ty;
        }
        else
        {
            // Всё аналогично
            pt[i-1].tx=XP-X0;
            pt[i-1].ty=YP-Y0;
        }
        
        if(dir)
        {
            // Прорисовка касательных
            draw_line(X1,Y1,X,Y);
            draw_line(X0,Y0,XP,YP);
        }
        
        // Главный цикл участка
        for( j=0; j<=step; j+=1)
        {
            t=j/step;
            // Расчёт полинома
            T=1-t;
            T0=T*T*T;
            T1=3*T*T*t;
            T2=3*T*t*t;
            T3=t*t*t;
            // Вычисление новой точки
            rx[m]=X0*T0+XP*T1+X1*T2+X*T3;
            ry[m]=Y0*T0+YP*T1+Y1*T2+Y*T3;
            m+=1;
        }
        
        // Следующая касательная становится предыдущей
        XP=X2;
        YP=Y2;
    }
    break;
    
    
    
    case 5:
    
            // СПЛАЙН ЭРМИТА
    
    // Касательные вычисляются по одной формуле из учебника,
    // которая не требует равномерного распределения точек.
    //     
    // В концевых точках касательные по умолчанию не заданы.

    // Цвет   
    color=c_red;
    draw_set_color(color);
   
    // Немного расширяем исходный массив вершин
    px[n+1]=px[n];
    px[n+2]=px[n+1];
    py[n+1]=py[n];
    py[n+2]=py[n+1];

    if (!pt[n].custom)
    {
        // Сброс последней, если не определена
        pt[n].tx=0;
        pt[n].ty=0;
    }
    else
    {
        // Считывание, если используется
        Lqx1=pt[n].tx*2;
        Lqy1=pt[n].ty*2;
    }
   
    // Конечные не заданы
    qx2=0;
    qy2=0;
    
    // Количество точек на каждом участке
    step=60;
    for( i=0; i<n; i+=1 )
    {
        // Циклическое сохранение касательных
        qx1=qx2;
        qy1=qy2;
        qx0=0;
        qy0=0;
  
        // Расстояние между вершинами
        s1=sqrt((sqr(px[i+1]-px[i])+sqr(py[i+1]-py[i])));
        
        if (i>0)
        {
            // Первую вершину считаем отдельно
            s0=sqrt((sqr(px[i]-px[i-1])+sqr(py[i]-py[i-1])));
            s3=s0+s1;
            if (s3!=0)
            {
                qx0=(s1*(px[i]-px[i-1])+s0*(px[i+1]-px[i]))/s3;
                qy0=(s1*(py[i]-py[i-1])+s0*(py[i+1]-py[i]))/s3;
            }
        }

        // Другая касательная
        s2=sqrt((sqr(px[i+2]-px[i+1])+sqr(py[i+2]-py[i+1])));
        s4=s1+s2;
        if(s4!=0)
        {
            qx1=(s2*(px[i+1]-px[i])+s1*(px[i+2]-px[i+1]))/s4;
            qy1=(s2*(py[i+1]-py[i])+s1*(py[i+2]-py[i+1]))/s4;
        }

        
        if (!pt[i].custom)
        {
            // Переопределение пользователем
            pt[i].tx=qx0/2;
            pt[i].ty=qy0/2;
        }
        else
        {
            // Или вывод автоматического расчёта
            qx0=pt[i].tx*2;
            qy0=pt[i].ty*2;
        }
        
        // То же для второй касательной
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
        
        // Рисование со сдвигом наполовину
        if (dir)
        {
            draw_line(px[i]-qx0/2,py[i]-qy0/2,px[i]+qx0/2,py[i]+qy0/2);
            draw_line(px[i+1]-qx1/2,py[i+1]-qy1/2,px[i+1]+qx1/2,py[i+1]+qy1/2);
        }
         
        // Цикл подсчёта полинома
        for( j=0; j<=step; j+=1 )
        {
            // Местный параметр
            w=j/step;
            //Степени  
            w2=w*w;
            w3=w2*w;
            
            // Кубические м
            A0=1-3*w2+2*w3;
            A1=3*w2-2*w3;
            B0=w-2*w2+w3;
            B1=-w2+w3;
            
            // Расчёт точек
            rx[m]=A0*px[i]+A1*px[i+1]+B0*qx0+B1*qx1;
            ry[m]=A0*py[i]+A1*py[i+1]+B0*qy0+B1*qy1;
            m+=1;
        }
    }
    break; 
       
    }
    
    
    // Рисование найденной кривой
    draw_set_color(color);
    
    if (dash)
    {
        // Либо линиями
        for( i=1; i<m; i+=1 ) draw_line_width(rx[i-1],ry[i-1],rx[i],ry[i],3);
    }
    else
    {
        //Либо кружками
        for( i=0; i<m; i+=1 ) draw_circle(rx[i],ry[i],3,0);
    }
    
}

');

    // Начало программы здесь 
    r=room_add();
    
    // Подгонка размера окна под разрешение экрана
    room_set_width(r,display_get_width());
    room_set_height(r,display_get_height());
    window_set_fullscreen(true);
    window_set_cursor(cr_default);
    
    // Цвет фона
    room_set_background_color(r,c_black,1);
    
    // Добавление главного объекта
    room_instance_add(r,0,0,draw);
    room_goto(r);
    
}
